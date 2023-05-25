Return-Path: <netdev+bounces-5220-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEF17710457
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 06:52:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D1CA1C20BB5
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 04:52:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 046D51FBE;
	Thu, 25 May 2023 04:52:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9856F199
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 04:52:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08192C433A4;
	Thu, 25 May 2023 04:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684990322;
	bh=wbuqSr/dpQZAWNfRhRWhjk92q+VPd7IY9nI6I0haJc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hiuDBew7VBo2HHdEmQ55CNhozIfR4j7iDQjfwkU4miS1db86JvKZ+VNXb/3xz0K8m
	 E08J7bukhI8hTtLI65/NR3Y9uKdkxvDIvWuTbpF3/pzsWMq7XJX0/SkFScxSS0yy2v
	 mckEp+vuLMm5t2VWiq8Bb7xe4+IR8ms+rIyQNxJSSxe3bJhI2rILwtXLKXdh8PuFFF
	 QwRMr4TpsUNf7BLCgHk8CfrhdKiRfHIQSEUNjasKqgi8L49G7Y+Ik+8TE9Ozj2PvU5
	 AGykGkUhCw38vB1iU9L5T0/boiWgfaIvVctEUvrPwz6OTfOoMEaqSKCrGIq9LICtnz
	 TDjmgCs1L1Q/A==
From: Bjorn Andersson <andersson@kernel.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Taniya Das <quic_tdas@quicinc.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Andy Gross <agross@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Michael Turquette <mturquette@baylibre.com>,
	Conor Dooley <conor+dt@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	jkona@quicinc.com,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	devicetree@vger.kernel.org,
	Imran Shaik <quic_imrashai@quicinc.com>,
	linux-clk@vger.kernel.org,
	quic_rohiagar@quicinc.com,
	netdev@vger.kernel.org
Subject: Re: (subset) [PATCH V2 0/5] Add GCC and RPMHCC support for sdx75
Date: Wed, 24 May 2023 21:54:39 -0700
Message-Id: <168499048185.3998961.8118041081683162755.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230512122347.1219-1-quic_tdas@quicinc.com>
References: <20230512122347.1219-1-quic_tdas@quicinc.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 12 May 2023 17:53:42 +0530, Taniya Das wrote:
> This series of patches extends the invert logic for branch2 clocks and adds
> GCC, RPMH clocks devicetree bindings and driver support for SDX75 platform.
> 
> Imran Shaik (5):
>   clk: qcom: branch: Extend the invert logic for branch2 clocks
>   dt-bindings: clock: qcom: Add GCC clocks for SDX75
>   dt-bindings: clock: qcom: Add RPMHCC for SDX75
>   clk: qcom: rpmh: Add RPMH clocks support for SDX75
>   clk: qcom: Add GCC driver support for SDX75
> 
> [...]

Applied, thanks!

[1/5] clk: qcom: branch: Extend the invert logic for branch2 clocks
      commit: 9092d1083a6253757c7f9449340173443c81768c
[3/5] dt-bindings: clock: qcom: Add RPMHCC for SDX75
      commit: 379d72721bc4308fbc038e9858b7d2e9191725b5
[4/5] clk: qcom: rpmh: Add RPMH clocks support for SDX75
      commit: 1c2360ff58162ab3a91c619ab8172c0061174151
[5/5] clk: qcom: Add GCC driver support for SDX75
      commit: 108cdc09b2dea5110533bba495b6953ca9c7c2a9

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>

