Return-Path: <netdev+bounces-8953-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4CBC726667
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:49:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73A102814B7
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:49:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF4251772E;
	Wed,  7 Jun 2023 16:49:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959EA63B5;
	Wed,  7 Jun 2023 16:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C83C4339C;
	Wed,  7 Jun 2023 16:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686156564;
	bh=sPQfBEs+boCICdljlPBIqh6xD9H5WlMiLwV1L8x3Bl8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Tza99j3Xr7OwMypJ1xp/n7ZysXrZ9SNMGZhCXlPbAx9eRALgF1bCNRPunfaedKfDq
	 N8oqFNdiMLkslnznfnMbdl1xwVPM10YPvsq1DuuNhGVymOnXlqXSnPwBUhU6vtvPKL
	 wH1fjEXy8DRQwSEATgiNK1SkA2cw/P1HnEKGbO/QaRJRpiqL2Y9N4dKwV3QvJUV+xy
	 4KD2H5NF1T9aFg2ayUdtIsdc0c4soIvd+tlrg98C/yI+OYagyAsJi7uwc5G2MyT/D5
	 f729US8K44B33nuwA1gTnZV9Yr51NwrwRnD/nIAjHcu+cWXHbIDDVQ+77yzkb1YTH5
	 YnseoP5b8gtSA==
Date: Wed, 7 Jun 2023 09:49:22 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, loic.poulain@linaro.org
Subject: Re: [PATCH v2 0/2] Add MHI Endpoint network driver
Message-ID: <20230607094922.43106896@kernel.org>
In-Reply-To: <20230607152427.108607-1-manivannan.sadhasivam@linaro.org>
References: <20230607152427.108607-1-manivannan.sadhasivam@linaro.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  7 Jun 2023 20:54:25 +0530 Manivannan Sadhasivam wrote:
> This series adds a network driver for the Modem Host Interface (MHI) endpoint
> devices that provides network interfaces to the PCIe based Qualcomm endpoint
> devices supporting MHI bus (like Modems). This driver allows the MHI endpoint
> devices to establish IP communication with the host machines (x86, ARM64) over
> MHI bus.
> 
> On the host side, the existing mhi_net driver provides the network connectivity
> to the host.

Why are you posting the next version before the discussion on the
previous one concluded? :|

In any case, I'm opposed to reuse of the networking stack to talk
to firmware. It's a local device. The networking subsystem doesn't
have to cater to fake networks. Please carry:

Nacked-by: Jakub Kicinski <kuba@kernel.org>

if there are future submissions.

