/// @file dynamical_model_abstract_template.hpp
/// @brief Dynamical model interface
/// @author Thomas Gurriet (tgurriet@3laws.io)
/// @copyright Copyright 2023 3Laws Robotics Inc.

#ifndef THREELAWS_DYNAMICAL_MODEL_ABSTRACT_TEMPLATE_HPP
#define THREELAWS_DYNAMICAL_MODEL_ABSTRACT_TEMPLATE_HPP

#include <span>

#include <memory>
#include <vector>

/// @brief Dynamical model evaluation result
/// @details Given a dynamical model \f$ \dot{x} = f(x,u) \f$ evaluated at \f$ x
/// \in \mathbb{R}^{\text{nx}} \f$ and \f$ u \in \mathbb{R}^{\text{nu}} \f$
/// then: \f{array}{
///    \text{val} = f(x,u) \newline
///    \text{dval_dx} = \frac{\partial{f(x,u)}}{\partial{x}} \newline
///    \text{dval_du} = \frac{\partial{f(x,u)}}{\partial{u}} \newline
/// \f}
template<class Scalar>
struct DynamicalModelEvaluationResultTemplate
{
  size_t nx = 0;  ///< Number of states
  size_t nu = 0;  ///< Number of inputs

  /// @brief Value of dynamics evaluation
  /// @details In column major order, size nx*1.
  std::vector<Scalar> val;

  /// @brief Partial derivative w.r.t state
  /// @details In column major order, size nx*nx, empty if not available.
  std::vector<Scalar> dval_dx;

  /// @brief Partial derivative w.r.t input
  /// @details In column major order, size nx*nu, empty if not available.
  std::vector<Scalar> dval_du;
};

/// @brief Initialize dynamical model evaluation result
/// @details Set nx and nu to specified input values, resize val, dval_dx, and
/// dval_du accordingly.
/// @param res DynamicalModelEvaluationResultTemplate object to initialize
/// @param nx Number of states (must be strictly positive)
/// @param nu Number of inputs (must be strictly positive)
/// @param with_failsafe Whether dval_dx and dval_du must be initialized
template<class Scalar>
void init(DynamicalModelEvaluationResultTemplate<Scalar> & res,
  const size_t nx,
  const size_t nu,
  const bool with_gradient = false)
{
  res.nx = nx;
  res.nu = nu;
  res.val.assign(nx, Scalar(0.));
  if (with_gradient) {
    res.dval_dx.assign(nx * nx, Scalar(0.));
    res.dval_du.assign(nx * nu, Scalar(0.));
  }
}

/// @brief Dynamical model interface
/// @details Abstract class for a generic non-linear dynamical model of the form
/// \f$ \dot{x} = f(x,u) \f$ with \f$ x \in \mathbb{R}^{\text{nx}} \f$ and \f$ u
/// \in \mathbb{R}^{\text{nu}} \f$.
template<class Scalar>
class DynamicalModelAbstractTemplate
{
public:
  using shared_ptr = std::shared_ptr<DynamicalModelAbstractTemplate>;
  using unique_ptr = std::unique_ptr<DynamicalModelAbstractTemplate>;

  DynamicalModelAbstractTemplate()                                                       = default;
  DynamicalModelAbstractTemplate(const DynamicalModelAbstractTemplate &)                 = default;
  DynamicalModelAbstractTemplate(DynamicalModelAbstractTemplate &&) noexcept             = default;
  DynamicalModelAbstractTemplate & operator=(const DynamicalModelAbstractTemplate &)     = default;
  DynamicalModelAbstractTemplate & operator=(DynamicalModelAbstractTemplate &&) noexcept = default;
  virtual ~DynamicalModelAbstractTemplate()                                              = default;

  /// @brief Check if model evaluation result contains gradient information, false by default.
  virtual bool has_gradient() const { return false; }

  /// @brief Number of model states
  virtual size_t nx() const = 0;

  /// @brief Number of model inputs
  virtual size_t nu() const = 0;

  /// @brief Evaluate the model dynamics for a given state value x and input value u
  /// @param x State at which to evaluate the dynamics (size must match result of nx())
  /// @param u Input at which to evaluate the dynamics (size must match result of nu())
  virtual const DynamicalModelEvaluationResultTemplate<Scalar> & evaluate(
    const std::span<const Scalar> x, const std::span<const Scalar> u) = 0;

  /// @brief Get latest evaluation result
  // virtual const DynamicalModelEvaluationResultTemplate<Scalar> & get_evaluation_result() const =
  // 0;

  /// @brief Get copy of model
  // virtual unique_ptr get_copy() const = 0;
};

#endif  // THREELAWS_DYNAMICAL_MODEL_ABSTRACT_TEMPLATE_HPP
