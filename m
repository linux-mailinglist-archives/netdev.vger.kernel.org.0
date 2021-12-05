Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA0A9468B36
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 14:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234267AbhLENtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 08:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234261AbhLENtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 08:49:16 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E26FC061714;
        Sun,  5 Dec 2021 05:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=H8pM3TyqjbKyunBfWpoNweltkBelaa10RsNOsqZh/Ao=; b=iXQuuL8oP1dTHM0ppVdd4l9bv8
        Dc3RRfag17WZnJO0Jp4HGbV9/IuKGOugvkej2xfxv3vAbloweytQYDiSn8IbFhYai8so/wovZQmjb
        7N/cZeQKmeqAJxH4XL2xTzRNI3ZDwlsFJmnAyG7fTpnUPiFUvL/mbCzzVTZOBwODi/cp4akuMFUlW
        LYnzSBDBDpooYSjvgRgkpKguO4toBVZRm8bupONJ3N93q8aUQDT5m0S2lLujc1ndUq6TlP3HvL5ZN
        Wtzj/+rbAThRgXBHqtsjyQ67nhEMIPS+sZv0oVjtrbajkMAZGiUYz88HyznlrIv9EN8p57Lu+3pW3
        6zzKO4rQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56084)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mtrpp-0003xH-H6; Sun, 05 Dec 2021 13:45:45 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mtrpm-0003RP-Kt; Sun, 05 Dec 2021 13:45:42 +0000
Date:   Sun, 5 Dec 2021 13:45:42 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Yanteng Si <siyanteng01@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, netdev@vger.kernel.org,
        corbet@lwn.net, chenhuacai@kernel.org, linux-doc@vger.kernel.org,
        Yanteng Si <siyanteng@loongson.cn>
Subject: Re: [PATCH] net: phy: Remove unnecessary indentation in the comments
 of phy_device
Message-ID: <YazChnNvaEMHzCQG@shell.armlinux.org.uk>
References: <20211205132141.4124145-1-siyanteng@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211205132141.4124145-1-siyanteng@loongson.cn>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 05, 2021 at 09:21:41PM +0800, Yanteng Si wrote:
> Fix warning as:
> 
> linux-next/Documentation/networking/kapi:122: ./include/linux/phy.h:543: WARNING: Unexpected indentation.
> linux-next/Documentation/networking/kapi:122: ./include/linux/phy.h:544: WARNING: Block quote ends without a blank line; unexpected unindent.
> linux-next/Documentation/networking/kapi:122: ./include/linux/phy.h:546: WARNING: Unexpected indentation.

This seems to be at odds with the documentation in
Documentation/doc-guide/kernel-doc.rst.

The warning refers to lines 543, 544 and 546.

543: *              Bits [23:16] are currently reserved for future use.
544: *              Bits [31:24] are reserved for defining generic
545: *                           PHY driver behavior.
546: * @irq: IRQ number of the PHY's interrupt (-1 if none)

This doesn't look quite right with the warning messages above, because
544 doesn't unindent, and I've checked net-next, net, and mainline
trees, and they're all the same.

So, I think we first need to establish exactly which lines you are
seeing this warning for before anyone can make a suggestion.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
