Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D017301C1A
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 14:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbhAXNS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 08:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbhAXNS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 08:18:56 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE45C061573;
        Sun, 24 Jan 2021 05:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=tp8I5qxyZLfJni0H826iBCyyCGmDjvJSbWV9cluqpf0=; b=iMevhbVGRkdpHGiY7ZiFsbNj5
        w7Eb9e06DWPXmyzHtdCiF7kiKVPHkBMuc1/AetEexKzpObH65O/GEX0wpMvDslgxZs+uP5FSbLYfl
        jN5L1zfoLX/dYyRr0nYrYSiUNQcObude3zx6yGzJ6diMgY95m+6gWX9kBKmk5wGs4AijUFfpkxVUp
        O11UfwmurLTLcz/csutD3nlbVjXpHr0ubwNRIOwBYNwcvYY5vAFv7ZMqTGYsNG19P16mgV3URIF31
        H+W5a10AHnNFX6VYWjhHGK/ieyt5xV1h4B31SK3XEcoP3hOQyk+uWwDIvlEGivsSb9ElPoEpeNGA2
        QEOAPJtKA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52128)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l3fHR-0002PD-Ni; Sun, 24 Jan 2021 13:18:13 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l3fHP-0001kQ-3P; Sun, 24 Jan 2021 13:18:11 +0000
Date:   Sun, 24 Jan 2021 13:18:11 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch, atenart@kernel.org
Subject: Re: [PATCH v2 RFC net-next 04/18] net: mvpp2: add PPv23 version
 definition
Message-ID: <20210124131810.GZ1551@shell.armlinux.org.uk>
References: <1611488647-12478-1-git-send-email-stefanc@marvell.com>
 <1611488647-12478-5-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611488647-12478-5-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 24, 2021 at 01:43:53PM +0200, stefanc@marvell.com wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> This patch add PPv23 version definition.
> PPv23 is new packet processor in CP115.
> Everything that supported by PPv22, also supported by PPv23.
> No functional changes in this stage.
> 
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 24 ++++++++++++--------
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 17 +++++++++-----
>  2 files changed, 25 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> index aec9179..89b3ede 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> @@ -60,6 +60,9 @@
>  /* Top Registers */
>  #define MVPP2_MH_REG(port)			(0x5040 + 4 * (port))
>  #define MVPP2_DSA_EXTENDED			BIT(5)
> +#define MVPP2_VER_ID_REG			0x50b0
> +#define MVPP2_VER_PP22				0x10
> +#define MVPP2_VER_PP23				0x11

Looking at the Armada 8040 docs, it seems this register exists on
PPv2.1 as well, and holds the value zero there.

I wonder whether we should instead read it's value directly into
hw_version, and test against these values, rather than inventing our
own verison enum.

I've also been wondering whether your != MVPP21 comparisons should
instead be >= MVPP22.

Any thoughts?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
