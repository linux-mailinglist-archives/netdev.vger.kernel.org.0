Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B0E2C4198
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 15:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgKYOAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 09:00:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbgKYOAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 09:00:30 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5083C061A4E
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 06:00:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/CKbe7t78Oxd0QXuxXbGazDWW/Kf0BUGV6Kc9AVXx28=; b=dmisLQaFdL4g7Jy6MLnfdVRS4
        OQuam9dKMpiHCZ9VsYMPiVx/jNrb2c9VjVbVnDJG70Vxs/vZ5xFU6bDoALGp5DDYqOxN24Xnl5MwY
        oTLNKXgpu5cGUrhuGUuRQUPVX54hL0tQWjrxnZi29qxEnaFP07DtEvkTv56EEFPix7o0LbOfOIiqk
        KQO0oHnra4gyZtSkd1zFIV2e5tMdHRswzG6TXG2C6Zz8RVmu6ayTYNfWdxxYhDjJKyk2KwD/2ZzJl
        bT7JfSNO8Q7Zkzoz8I1N0jK9HQggrnNUynQlKCZhB/lBK4RQncHZCX+eod6Bpnv0NT6Dot35PzWcI
        PoarXzHGQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35932)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1khvLO-0000cS-AI; Wed, 25 Nov 2020 14:00:26 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1khvLI-0008Pq-VD; Wed, 25 Nov 2020 14:00:20 +0000
Date:   Wed, 25 Nov 2020 14:00:20 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     kernel test robot <lkp@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: sfp: VSOL V2801F / CarlitoxxPro
 CPGOS03-0490 v2.0 workaround
Message-ID: <20201125140020.GJ1551@shell.armlinux.org.uk>
References: <E1khJlv-0003Jq-ET@rmk-PC.armlinux.org.uk>
 <202011240816.ClA61wej-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202011240816.ClA61wej-lkp@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 08:18:56AM +0800, kernel test robot wrote:
> All warnings (new ones prefixed by >>):
> 
>    drivers/net/phy/sfp.c: In function 'sfp_i2c_read':
> >> drivers/net/phy/sfp.c:339:9: warning: variable 'block_size' set but not used [-Wunused-but-set-variable]
>      339 |  size_t block_size;
>          |         ^~~~~~~~~~

I'm waiting for Thomas to re-test the fixed patch I sent, but Thomas
seems to be of the opinion that there's no need to re-test, despite
the fixed patch having the intended effect of changing the behaviour
on the I2C bus.

If nothing is forthcoming, I'm intending to drop the patch; we don't
need to waste time supporting untested workarounds for what are
essentially broken SFPs by vendors twisting the SFP MSA in the
kernel.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
