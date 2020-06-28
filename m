Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6768620CAEC
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 00:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgF1WUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 18:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgF1WUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 18:20:39 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1BBEC03E979
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 15:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=QuE8hzYOrQGxzusgLR9HpCrd/arYRyC/3hQGZ9kyvFk=; b=CHATXm81l9YrtYOKNHsth9D19
        TryYrMgl1nhyIfRfrYOAmIIPX0PsDXpRmZwmyCB8l/Dl+42zNizd793w3RbaR9W7YLvJcPFvaKNUB
        iz0k9qkdeOGaT0Ypul2Z06W3fGQrCNyGi984F2ySHCV+fk8PPuadmBLFHjJSpe4PxcWzBjYLTDTm0
        J1SSAqy33IOuWvHUhim/XwTCdhSjBq2LvHSC8XDWCXTasqocvtpO917WTLcDNwHHiQfZo1EzJmiv6
        MCZs5/C7jFf7FkCjQFNWamylMoIIGFwDxulV3D3ez9PVm4k9H5QRtp3WCcgRqjVq7Bt2aWT/IhbeK
        +HEEZEn0A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32810)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jpffB-0006tG-2I; Sun, 28 Jun 2020 23:20:37 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jpffA-0006Sw-IM; Sun, 28 Jun 2020 23:20:36 +0100
Date:   Sun, 28 Jun 2020 23:20:36 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Colton Lewis <colton.w.lewis@protonmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v3] net: phylink: correct trivial kernel-doc
 inconsistencies
Message-ID: <20200628222036.GR1551@shell.armlinux.org.uk>
References: <20200621154248.GB338481@lunn.ch>
 <20200621155345.GV1551@shell.armlinux.org.uk>
 <3315816.iIbC2pHGDl@laptop.coltonlewis.name>
 <20200621234431.GZ1551@shell.armlinux.org.uk>
 <3034206.AJdgDx1Vlc@laptop.coltonlewis.name>
 <20200627235803.101718-1-colton.w.lewis@protonmail.com>
 <20200628093634.GQ1551@shell.armlinux.org.uk>
 <6541539.18pcnM708K@laptop.coltonlewis.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6541539.18pcnM708K@laptop.coltonlewis.name>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 28, 2020 at 09:36:35PM +0000, Colton Lewis wrote:
> > We seem to be having a communication breakdown.  In review to your
> > version 2 patch set, I said:
> > 
> >    However, please drop all your changes for everything but the
> >    "struct phylink_config" documentation change; I'm intending to change
> >    all these method signatures, which means your changes will conflict.
> > 
> > But the changes still exist in version 3.  What gives?
> 
> You said *drop all your changes* for *everything but* the struct phylink_config change. I interpreted this to mean you wanted *only* struct phylink_config. In context of your previous comments, I might have guessed you meant the opposite.

It seems we're using different versions of English, because your v4 is
still wrong.

Want I want for the phylink change is to see the hunk that changes
struct phylink_config ONLY and NOT any of the individual method
configuration.  In other words, I want:

diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index cc5b452a184e..cb3230590a1f 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -62,6 +62,8 @@ enum phylink_op_type {
  * @dev: a pointer to a struct device associated with the MAC
  * @type: operation type of PHYLINK instance
  * @pcs_poll: MAC PCS cannot provide link change interrupt
+ * @poll_fixed_state: poll link state with @get_fixed_state
+ * @get_fixed_state: read link state into struct phylink_link_state
  */
 struct phylink_config {
        struct device *dev;


But I don't want:

@@ -331,7 +333,7 @@ void pcs_get_state(struct phylink_config *config,
  *
  * For most 10GBASE-R, there is no advertisement.
  */
-int (*pcs_config)(struct phylink_config *config, unsigned int mode,
+int *pcs_config(struct phylink_config *config, unsigned int mode,
                  phy_interface_t interface, const unsigned long *advertising);

 /**

and the rest of those in that file.

I really don't think I could have been clearer without creating the
damn patch for you.

Second thoughts, don't bother, I'll do it myself, the amount of effort
wasted here is rediculous, and I really don't want to go round this
loop yet again.

Thanks for pointing the issues out.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
