Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E9B552B79
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 09:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345850AbiFUHI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 03:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236786AbiFUHI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 03:08:58 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F15B201A9
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 00:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mx9Ng+zjjKDgVyRmQJH2YZYOdnU3VzL5lamiomZhPxg=; b=ecKHTyD+ubE/JV3CX53z03vyU5
        6H8fmFikR/SF90HRPMO7jNnhRG02gapi8moJgIL4svvvoTbo5MhbfNuDdA9RIx/FEi5MUvCRl5itc
        owRmlcL5XLJ8yfnSNbLCfg72kwpPSjuJKkSSYuHFW797sFyB6fTXTMJooGJat25CcPGFpP39SVUCK
        H7rts10Ky0iTpptb3EVeOxknsA6bHV3N12ztekv8/pANuKJSFCDheYUEUMQrLQLEHYADFre362o8o
        gevVlqzMh23sk0ZvAIEGNY0InpcXPOnDQwjNUIGww+U7nT4ttfIPrSrFFAL51TSXy7qL6oXascji8
        6wcyX6GA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32954)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o3Y09-0001xN-LO; Tue, 21 Jun 2022 08:08:41 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o3Xzx-0005po-F9; Tue, 21 Jun 2022 08:08:29 +0100
Date:   Tue, 21 Jun 2022 08:08:29 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     kernel test robot <lkp@intel.com>, davem@davemloft.net,
        kbuild-all@lists.01.org, netdev@vger.kernel.org,
        edumazet@google.com, pabeni@redhat.com, andrew@lunn.ch,
        hkallweit1@gmail.com, boon.leong.ong@intel.com
Subject: Re: [PATCH net-next] net: pcs: xpcs: select PHYLINK in Kconfig
Message-ID: <YrFubYKuqPbT4fRc@shell.armlinux.org.uk>
References: <20220620201915.1195280-1-kuba@kernel.org>
 <202206210551.Fhz4xcTc-lkp@intel.com>
 <20220620174800.6dc60a5b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620174800.6dc60a5b@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 05:48:00PM -0700, Jakub Kicinski wrote:
> On Tue, 21 Jun 2022 05:49:57 +0800 kernel test robot wrote:
> > I love your patch! Yet something to improve:
> > 
> > [auto build test ERROR on net-next/master]
> > 
> > url:    https://github.com/intel-lab-lkp/linux/commits/Jakub-Kicinski/net-pcs-xpcs-select-PHYLINK-in-Kconfig/20220621-042123
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git dbca1596bbb08318f5e3b3b99f8ca0a0d3830a65
> > config: i386-tinyconfig
> > compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
> > reproduce (this is a W=1 build):
> >         # https://github.com/intel-lab-lkp/linux/commit/a3120516f7ee66896bb0d3c90fe653ce0cb3a09f
> >         git remote add linux-review https://github.com/intel-lab-lkp/linux
> >         git fetch --no-tags linux-review Jakub-Kicinski/net-pcs-xpcs-select-PHYLINK-in-Kconfig/20220621-042123
> >         git checkout a3120516f7ee66896bb0d3c90fe653ce0cb3a09f
> >         make W=1 ARCH=i386  tinyconfig
> >         make W=1 ARCH=i386 
> > 
> > If you fix the issue, kindly add following tag where applicable
> > Reported-by: kernel test robot <lkp@intel.com>
> > 
> > All errors (new ones prefixed by >>):
> > 
> > >> drivers/net/phy/Kconfig:16:error: recursive dependency detected!  
> >    drivers/net/phy/Kconfig:16: symbol PHYLIB is selected by PHYLINK
> >    drivers/net/phy/Kconfig:6: symbol PHYLINK is selected by PCS_XPCS
> >    drivers/net/pcs/Kconfig:8: symbol PCS_XPCS depends on MDIO_DEVICE
> >    drivers/net/mdio/Kconfig:6: symbol MDIO_DEVICE is selected by PHYLIB
> >    For a resolution refer to Documentation/kbuild/kconfig-language.rst
> >    subsection "Kconfig recursive dependency limitations"
> 
> Dunno what the best practice is in that case :S
> I'll leave this to the experts.

Would it work to make all the PCS drivers depend on PHYLINK ?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
