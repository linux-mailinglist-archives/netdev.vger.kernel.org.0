Return-Path: <netdev+bounces-1902-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4549A6FF742
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 18:30:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DB6C281820
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:30:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDF8F63B0;
	Thu, 11 May 2023 16:30:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7868F68
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 16:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9F5C433EF;
	Thu, 11 May 2023 16:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683822615;
	bh=Zs6HS+LhQsL65kXS1dDBGurrU/0i4pxZb2uUlUCbWFU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ngk3IDFvzbk44ahJBMRCL7/6ykr6qw1ibcNGNb8wKaN7/5TtT9RPwrw+1Rc1KnFKQ
	 IDS3saOhr3E+OZ9r953ZCBbtF01MM1+w8j07vqaL8SyRGxC6/ZW8GaL7ftZzISmKKf
	 qYO49B0k+ukEgB97k/z1o1EVqZHXeOdRqGy3FJO83XNNn0l4cBEiK4PDEB8a2D8ME0
	 DC4BTHewwmy8ZwEVQyBFdTTlBTt0gZtkdGwpa/bJc6aMi5ETQ2kYRSyLrzChlY1fPN
	 oqqBrt8UHg68Nca/Y014wk1mL1qWo+YMNS+nErNX6C2ht3xySw/Zy9JDLj5bgMQzfN
	 xnAuaNfUtNstA==
Date: Thu, 11 May 2023 09:33:52 -0700
From: Bjorn Andersson <andersson@kernel.org>
To: Rohit Agarwal <quic_rohiagar@quicinc.com>
Cc: agross@kernel.org, konrad.dybcio@linaro.org, linus.walleij@linaro.org,
	robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
	richardcochran@gmail.com, manivannan.sadhasivam@linaro.org,
	andy.shevchenko@gmail.com, linux-arm-msm@vger.kernel.org,
	linux-gpio@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v7 2/4] pinctrl: qcom: Remove the msm_function struct
Message-ID: <20230511163352.kfjpvagh2rysyelo@ripper>
References: <1683730825-15668-1-git-send-email-quic_rohiagar@quicinc.com>
 <1683730825-15668-3-git-send-email-quic_rohiagar@quicinc.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1683730825-15668-3-git-send-email-quic_rohiagar@quicinc.com>

On Wed, May 10, 2023 at 08:30:23PM +0530, Rohit Agarwal wrote:
> Remove the msm_function struct to reuse the generic pinfunction
> struct. Also, define a generic PINFUNCTION macro that can be used across
> qcom target specific pinctrl files to avoid code repetition.
> 

Looks nice! No need to carry our own structs for things that has made it
into the framework.

Reviewed-by: Bjorn Andersson <andersson@kernel.org>

But, ipq9574.c has made it into linux-next now, so this breaks the build
of that driver. So please update this patch. And please send the two
refactoring patches on their own, followed by the SDX75 based on that,
so we can get those merged quickly, before any other impediments are
introduced.

Regards,
Bjorn

