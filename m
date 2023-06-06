Return-Path: <netdev+bounces-8627-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C64F724EBB
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 23:22:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11FDB281013
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 21:22:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 395C72A9F6;
	Tue,  6 Jun 2023 21:22:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF0AFBED;
	Tue,  6 Jun 2023 21:22:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4021FC433EF;
	Tue,  6 Jun 2023 21:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686086548;
	bh=arMmkPx8p+KotVlOtO31lWA8+Pl1GfABSl2za4V1r20=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FTHj4vTz7NWJnMxSdDybrPffLiwOAAt/GT+LbZOR0Ea9wmewUx1puAh7RGeWhU72B
	 Lqsmu3YUzXRCvdsU0m7+ZK7MOJhH6BGtuRbolezWOAri8oSHNJEw4IlR4zm34jwa+j
	 7tUSSbnCwD56iKhsdTxVokZG4P+dfKEMZzrjdWSZ9PdQKm4LKmLV00Tq9FSQsaiEGF
	 BbW2Odh+XYTE9AmxtPBskCYfFXfWkRXeoTiNQYYtvtuy7tP7LUN/fXtuo+KqQU/FNE
	 44srhnybLUp4f4vWhva+Wvh8muHKen2dr8tw3WA7wKDU3ZG4qmlqr3vrT34ktCMXw8
	 VtQhu8TPTcphg==
Date: Tue, 6 Jun 2023 14:22:27 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, loic.poulain@linaro.org
Subject: Re: [PATCH 0/3] Add MHI Endpoint network driver
Message-ID: <20230606142227.4f8fcfee@kernel.org>
In-Reply-To: <20230606123119.57499-1-manivannan.sadhasivam@linaro.org>
References: <20230606123119.57499-1-manivannan.sadhasivam@linaro.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  6 Jun 2023 18:01:16 +0530 Manivannan Sadhasivam wrote:
> This series adds a network driver for the Modem Host Interface (MHI) endpoint
> devices that provides network interfaces to the PCIe based Qualcomm endpoint
> devices supporting MHI bus (like Modems). This driver allows the MHI endpoint
> devices to establish IP communication with the host machines (x86, ARM64) over
> MHI bus.
> 
> On the host side, the existing mhi_net driver provides the network connectivity
> to the host.

So the host can talk to the firmware over IP?

