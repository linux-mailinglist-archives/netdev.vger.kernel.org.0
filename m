Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDA52CDDEE
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 19:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbgLCSnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 13:43:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:59260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgLCSnD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 13:43:03 -0500
Date:   Thu, 3 Dec 2020 10:42:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607020943;
        bh=Zz1XEis3hrEl11pjxIpv8Dayjorw97G0bbHa8HVFh/Q=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=iHsfkUnGEVAIVjBgRN1C2Z5YZ4u5fYhgyTHI/6nXtSCqUcnOckfL2+oRdiGJOlbYY
         x0lrf4aSHiES3fGaGg2n9yGq0OOo+dyvASoFMNIdSuQx6EoY3I9sSAtPhM0boHgNMM
         UR6nLugrGkQmftGQpTvINa7nWcnBBhirW+sP4+o/ey/eQpFv+UyZ5zaOxIT864JF83
         wi3vn9L2/bFAa6SM0UvCfXDfSqwLjevdBvt8imZqofkDVLLH5tfJsNWMo2UwZ/NgCI
         hmzNrHFVdRhMjzm5/kL0dRSw0QcQhQ3tsjLwEk5y1mKvAG3JGPoPJP1Ov1eZ5yfM7z
         2C+SXpszWGvRw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, linux-imx@nxp.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: overwrite the dma_cap.addr64 according to
 HW design
Message-ID: <20201203104221.6b692285@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201203024423.23764-1-qiangqing.zhang@nxp.com>
References: <20201203024423.23764-1-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Dec 2020 10:44:23 +0800 Joakim Zhang wrote:
> From: Fugang Duan <fugang.duan@nxp.com>
> 
> The current IP register MAC_HW_Feature1[ADDR64] only defines
> 32/40/64 bit width, but some SOCs support others like i.MX8MP
> support 34 bits but it maps to 40 bits width in MAC_HW_Feature1[ADDR64].
> So overwrite dma_cap.addr64 according to HW real design.
> 
> Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>

This is refactoring, not a fix, right?
