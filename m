Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47382B1709
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 09:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgKMIQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 03:16:01 -0500
Received: from muru.com ([72.249.23.125]:48202 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbgKMIQB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 03:16:01 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id A87178096;
        Fri, 13 Nov 2020 08:16:05 +0000 (UTC)
Date:   Fri, 13 Nov 2020 10:15:56 +0200
From:   Tony Lindgren <tony@atomide.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Vignesh Raghavendra <vigneshr@ti.com>
Subject: Re: [PATCH] net: ethernet: ti: cpsw: fix cpts irq after suspend
Message-ID: <20201113081556.GW26857@atomide.com>
References: <20201112111546.20343-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112111546.20343-1-grygorii.strashko@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Grygorii Strashko <grygorii.strashko@ti.com> [201112 11:15]:
> Depending on the SoC/platform the CPSW can completely lose context after a
> suspend/resume cycle, including CPSW wrapper (WR) which will cause reset of
> WR_C0_MISC_EN register, so CPTS IRQ will became disabled.
> 
> Fix it by moving CPTS IRQ enabling in cpsw_ndo_open() where CPTS is
> actually started.
> 
> Fixes: 84ea9c0a95d7 ("net: ethernet: ti: cpsw: enable cpts irq")
> Reported-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Thanks this works for me:

Tested-by: Tony Lindgren <tony@atomide.com>
