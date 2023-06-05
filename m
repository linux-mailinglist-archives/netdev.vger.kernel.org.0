Return-Path: <netdev+bounces-7879-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 282A6721EF0
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:06:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8FEC2811C5
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 07:06:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC0A97497;
	Mon,  5 Jun 2023 07:06:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91448194
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F951C433EF;
	Mon,  5 Jun 2023 07:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685948801;
	bh=JrRk8+31vboG/VQHuPBXvcmI4AOcYJ94E5CXxrXjCIU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FiNs5MlC02+V1hliD8D46cJ6xPDu55/uvF0FE4SVAAmg6b2AnTZ4ugLr+EbsEMkd9
	 IMj7yFbrA+nY+g5g81mkl+7Mg8Bgx5TtgPPXv1Ku1Z7T2CqPU1JfF2cKcZGudIJ1ln
	 JdB/5Tv6KpVLXHoibY1MoxTlL34iwRmL2bI9N0n3MBhT2hxsUlUOnY9FTsWHaZ7hWg
	 R0fP1lXP/di3AMjKzi23o4ZbIVzOw6wtmE3ZXJbZtTSGZybI7uHXDXT+VLvLu7YOiS
	 i8D4I91LM5q+BSG+s6ipDSadzK5mI190sYeLbSI0GO6cGi62VH9FFGi23DQVnJ2RKf
	 EqosM3B6EombQ==
Date: Mon, 5 Jun 2023 12:36:36 +0530
From: Vinod Koul <vkoul@kernel.org>
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Bhupesh Sharma <bhupesh.sharma@linaro.org>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: Re: [PATCH net] net: stmmac: dwmac-qcom-ethqos: fix a regression on
 EMAC < 3
Message-ID: <ZH2JfDee+01/cajH@matsya>
References: <20230602190455.3123018-1-brgl@bgdev.pl>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602190455.3123018-1-brgl@bgdev.pl>

On 02-06-23, 21:04, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> We must not assign plat_dat->dwmac4_addrs unconditionally as for
> structures which don't set them, this will result in the core driver
> using zeroes everywhere and breaking the driver for older HW. On EMAC < 2
> the address should remain NULL.

Reviewed-by: Vinod Koul <vkoul@kernel.org>

-- 
~Vinod

