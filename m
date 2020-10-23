Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04FA72967CE
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 02:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373659AbgJWACW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 20:02:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373652AbgJWACW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 20:02:22 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2F66223C7;
        Fri, 23 Oct 2020 00:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603411341;
        bh=wTl3CZ9P6+wSUE2tMlJYNOvsszZ/KmhAv4DZfBm8MME=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wagBOTEwX0YBTsaQ2t1NWJSjvd42a2u7FMnIyoNJ1IBRYVMVviM2mBvY8xvVqQwv1
         g3TJxS0lrv1HQVLVBEBK6GCy1xDCGadrxhV7i4P0ZDwyLyfavqTNuc+Ij1zaj2/jw9
         EMzgzn4zePaKg1auXHdMeq0hpSVAj1Xp0iM2rcDU=
Date:   Thu, 22 Oct 2020 17:02:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <ardeleanalex@gmail.com>
Subject: Re: [PATCH v2 2/2] net: phy: adin: implement cable-test support
Message-ID: <20201022170219.13b03274@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201022074551.11520-2-alexandru.ardelean@analog.com>
References: <20201022074551.11520-1-alexandru.ardelean@analog.com>
        <20201022074551.11520-2-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Oct 2020 10:45:51 +0300 Alexandru Ardelean wrote:
> The ADIN1300/ADIN1200 support cable diagnostics using TDR.
> 
> The cable fault detection is automatically run on all four pairs looking at
> all combinations of pair faults by first putting the PHY in standby (clear
> the LINK_EN bit, PHY_CTRL_3 register, Address 0x0017) and then enabling the
> diagnostic clock (set the DIAG_CLK_EN bit, PHY_CTRL_1 register, Address
> 0x0012).
> 
> Cable diagnostics can then be run (set the CDIAG_RUN bit in the
> CDIAG_RUN register, Address 0xBA1B). The results are reported for each pair
> in the cable diagnostics results registers, CDIAG_DTLD_RSLTS_0,
> CDIAG_DTLD_RSLTS_1, CDIAG_DTLD_RSLTS_2, and CDIAG_DTLD_RSLTS_3, Address
> 0xBA1D to Address 0xBA20).
> 
> The distance to the first fault for each pair is reported in the cable
> fault distance registers, CDIAG_FLT_DIST_0, CDIAG_FLT_DIST_1,
> CDIAG_FLT_DIST_2, and CDIAG_FLT_DIST_3, Address 0xBA21 to Address 0xBA24).
> 
> This change implements support for this using phylib's cable-test support.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

# Form letter - net-next is closed

We have already sent a pull request for 5.10 and therefore net-next 
is closed for new drivers, features, and code refactoring.

Please repost when net-next reopens after 5.10-rc1 is cut.

(http://vger.kernel.org/~davem/net-next.html will not be up to date 
 this time around, sorry about that).

RFC patches sent for review only are obviously welcome at any time.
