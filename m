Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD29115CFF9
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 03:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbgBNCex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 21:34:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:60940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727988AbgBNCex (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 21:34:53 -0500
Received: from dragon (80.251.214.228.16clouds.com [80.251.214.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F1C22168B;
        Fri, 14 Feb 2020 02:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581647692;
        bh=NlFy+G7BwmwZJMBQsFrSrIwD/y9XhSxODCQxDfIySuU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tvDhV6jnoCeie0Kwf0B+4/6TxT/wSlWvZLZsiX8vs8ajAKJ0yfALbjrvcK2l0+bkS
         AvwKa6FDFPJOQ8yH6dfj/kBs/lYzCaF5ONijXXAs6mBCE0fhaOQaFDnljR+nhutpuW
         tQsMQxacnQ9HAQBNuIv/cDEos3n2wO0wy5wBdwRA=
Date:   Fri, 14 Feb 2020 10:34:46 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     devicetree@vger.kernel.org, leoyang.li@nxp.com,
        claudiu.manoil@nxp.com, robh+dt@kernel.org, pavel@denx.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: ls1021a: Restore MDIO compatible to gianfar
Message-ID: <20200214023446.GF22842@dragon>
References: <20200126194950.31699-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200126194950.31699-1-olteanv@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 26, 2020 at 09:49:50PM +0200, Vladimir Oltean wrote:
> The difference between "fsl,etsec2-mdio" and "gianfar" has to do with
> the .get_tbipa function, which calculates the address of the TBIPA
> register automatically, if not explicitly specified. [ see
> drivers/net/ethernet/freescale/fsl_pq_mdio.c ]. On LS1021A, the TBIPA
> register is at offset 0x30 within the port register block, which is what
> the "gianfar" method of calculating addresses actually does.
> 
> Luckily, the bad "compatible" is inconsequential for ls1021a.dtsi,
> because the TBIPA register is explicitly specified via the second "reg"
> (<0x0 0x2d10030 0x0 0x4>), so the "get_tbipa" function is dead code.
> Nonetheless it's good to restore it to its correct value.
> 
> Background discussion:
> https://www.spinics.net/lists/stable/msg361156.html
> 
> Fixes: c7861adbe37f ("ARM: dts: ls1021: Fix SGMII PCS link remaining down after PHY disconnect")
> Reported-by: Pavel Machek <pavel@denx.de>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied, thanks.
