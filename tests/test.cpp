/// @file test.cpp
/// @brief
/// @author Thomas Gurriet (tgurriet@3laws.io)
/// @copyright Copyright 2023 3Laws Robotics Inc.

#include <gtest/gtest.h>

#include <3laws/dynamical_model_abstract_template.hpp>

#include "./matplotlibcpp.hpp"

namespace plt = matplotlibcpp;

template<class Scalar>
void simulate(DynamicalModelAbstractTemplate<Scalar> & model)
{
  // Prepare some variables
  static constexpr double dt = 0.01;
  static constexpr size_t N  = 1000;
  std::vector<Scalar> u;
  u.assign(model.nu(), 0.0);

  std::vector<Scalar> t;
  t.resize(N, 0.);

  std::vector<Scalar> xHistory;
  xHistory.assign(model.nx() * N, 0.);

  // Integrate dynamical model over 10s
  for (size_t i = 0; i < N - 1; ++i) {
    const auto xCurrent = std::span<const Scalar>(xHistory.data() + i * model.nx(), model.nx());
    auto xNext          = std::span<Scalar>(xHistory.data() + (i + 1) * model.nx(), model.nx());
    const auto & res    = model.evaluate(xCurrent, u);
    t[i + 1]            = dt * static_cast<Scalar>(i + 1);
    for (size_t j = 0; j < model.nx(); ++j) { xNext[j] = xCurrent[j] + dt * res.val[j]; }
  }

  // Prepare for plotting
  std::vector<std::vector<Scalar>> xList;
  xList.resize(model.nx(), std::vector<Scalar>(N, 0.));
  for (size_t i = 0; i < model.nx(); ++i) {
    for (size_t j = 0; j < N; ++j) { xList[i][j] = xHistory[i + j * model.nx()]; }
  }

  // Plot
  plt::figure();
  for (size_t i = 0; i < model.nx(); ++i) { plt::plot(t, xList[i]); }
  plt::grid(true);
  plt::save("simulation.png");
}

// TODO: Implement a model
// struct MyModel ...

int main()
{
  MyModel model;
  simulate(model);
}
