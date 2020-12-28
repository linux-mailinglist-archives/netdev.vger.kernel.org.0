Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C300A2E6C05
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730217AbgL1Wzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:52302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729529AbgL1Vdv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Dec 2020 16:33:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48A0521534;
        Mon, 28 Dec 2020 21:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609191190;
        bh=k8OpuFpokwJ7ApQRmQfF+NIj+sWatwa1908bKcSvfXY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o8tWx+OHUrCl5bymf+cZbN8LPQJ1FIq5joc72IGz9th+he275E1pLLH+Bi+N/XUXR
         hCC6WQkvf3LC3N2ewf5H62QeccMag0DxgXxxYtmFMVPEemYtYEcn4IFGAPIrGUzzMp
         kUYH0GIOGhNE9iFdtVS1lAt/5ItDznXJYDxBRrNnUzQha92ylUhx6xfQ05OcqaUmu4
         KaLykpHuTlUpqFT6lt2fm8GVlay7YyylLIP+IVb6PnXMXHltA4m0YbkRctL17JdKwc
         5GCmm0RRSzj6ruqBdl6Qke93hjko+abUd2GQ5loOtBlVHPsfZVw5WFZAExuZQY8Bb8
         uYzUzgRxTEovA==
Date:   Mon, 28 Dec 2020 13:33:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>
Subject: Re: [PATCH net] net: ethernet: ti: cpts: fix ethtool output when no
 ptp_clock registered
Message-ID: <20201228133309.7d0c1047@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201224212136.GB1229@hoboy.vegasvil.org>
References: <20201224162405.28032-1-grygorii.strashko@ti.com>
        <20201224212136.GB1229@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Dec 2020 13:21:36 -0800 Richard Cochran wrote:
> On Thu, Dec 24, 2020 at 06:24:05PM +0200, Grygorii Strashko wrote:
> > The CPTS driver registers PTP PHC clock when first netif is going up and
> > unregister it when all netif are down. Now ethtool will show:
> >  - PTP PHC clock index 0 after boot until first netif is up;
> >  - the last assigned PTP PHC clock index even if PTP PHC clock is not
> > registered any more after all netifs are down.
> > 
> > This patch ensures that -1 is returned by ethtool when PTP PHC clock is not
> > registered any more.
> > 
> > Fixes: 8a2c9a5ab4b9 ("net: ethernet: ti: cpts: rework initialization/deinitialization")
> > Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>  
> 
> Acked-by: Richard Cochran <richardcochran@gmail.com>

Applied, thank you!
