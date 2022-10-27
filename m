Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBA460F8E9
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 15:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235978AbiJ0NVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 09:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235677AbiJ0NVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 09:21:06 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B449621D
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 06:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=eYuveK4Uv3yBuEmJ1fjmC0lAgK0pDhT5gTsKIbnGIIA=; b=n0hwrSMaQr6gUrT9C5ucfqeLpZ
        TEW6CI1qW4HuPyZPd/kSPeiG8NMAOFjzvrEigr8QhnCQFwbrMWWDp9NGsNqLAxqyBj2eZtZPgRv53
        lXvCIt8lcNE3XCrQ9NYGrV4spLs2IdJIIH4P8gQar45VupkQ5xGHpmZkYk/0dOduoAP+OHpMjEc76
        LHQuP6ymxT3/vnTxhM4/1rn1vDBUSF0dtY8mjc5ci+QLIAAhw4O6eIUvD84aS2CrLRsOlLfkTqUQR
        ezBGezR54VQ3+UVyajIfG2tmChpJ7WNTFe3vPJZxxOB9Px1gcFPg8Fh7CkKA5TfjvHQBkLz+EEjbf
        fuMFVb0Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34972)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oo2og-00071Z-Qs; Thu, 27 Oct 2022 14:21:02 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oo2of-0001aD-NR; Thu, 27 Oct 2022 14:21:01 +0100
Date:   Thu, 27 Oct 2022 14:21:01 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] Clean up SFP register definitions
Message-ID: <Y1qFvaDlLVM1fHdG@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This two-part patch series cleans up the SFP register definitions by
1. converting them from hex to decimal, as all the definitions in the
   documents use decimal, this makes it easier to cross-reference.
2. moving the bit definitions for each register along side their
   register address definition

 include/linux/sfp.h | 187 +++++++++++++++++++++++++++-------------------------
 1 file changed, 97 insertions(+), 90 deletions(-)
-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
