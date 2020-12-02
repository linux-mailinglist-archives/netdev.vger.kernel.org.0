Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B04102CBE02
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 14:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbgLBNM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 08:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbgLBNM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 08:12:59 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C40C0613CF
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 05:12:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=iRdwwfnwPYLtwQxo0tflk8Yk3nC1LmQSdbS2ugVDHHo=; b=trGWmUo4wlKpTfC8SDaPvia96
        +vKKAx2vzlWhFnd6PT4DyXjEidhZf/4KuMrMIX7j3HKhKkYgQTLqUKsaYH5Q7D6/yHwSQ1waKkHmK
        /mIIUzqP71A7k5tCx9fwh2UxwgDCyGUheVih37BnOWJRyO9CiwNjWoAd8HrsNrJd1SWj0THk1+T7F
        KhDIG5kW+cIxkxpVBs6WNe6drdeRXKdEH2IAghavzbyPx+kwEA4hayniVI1omHTOeBK4vleOuPvf2
        ussnPEH6KOZCkRBNLE5y3RhFoYeWpoZ4CkHBj38gqfXU9YWtaESXkPknm7zuR58m6dBl4VJOw/3G4
        QzZHnNRuw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38836)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kkRvM-0001WA-78; Wed, 02 Dec 2020 13:12:00 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kkRvK-000746-Ou; Wed, 02 Dec 2020 13:11:58 +0000
Date:   Wed, 2 Dec 2020 13:11:58 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     kernel test robot <lkp@intel.com>,
        Thomas Schreiber <tschreibe@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: sfp: VSOL V2801F / CarlitoxxPro
 CPGOS03-0490 v2.0 workaround
Message-ID: <20201202131158.GK1605@shell.armlinux.org.uk>
References: <E1khJlv-0003Jq-ET@rmk-PC.armlinux.org.uk>
 <202011240816.ClA61wej-lkp@intel.com>
 <20201125140020.GJ1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201125140020.GJ1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 25, 2020 at 02:00:20PM +0000, Russell King - ARM Linux admin wrote:
> On Tue, Nov 24, 2020 at 08:18:56AM +0800, kernel test robot wrote:
> > All warnings (new ones prefixed by >>):
> > 
> >    drivers/net/phy/sfp.c: In function 'sfp_i2c_read':
> > >> drivers/net/phy/sfp.c:339:9: warning: variable 'block_size' set but not used [-Wunused-but-set-variable]
> >      339 |  size_t block_size;
> >          |         ^~~~~~~~~~
> 
> I'm waiting for Thomas to re-test the fixed patch I sent, but Thomas
> seems to be of the opinion that there's no need to re-test, despite
> the fixed patch having the intended effect of changing the behaviour
> on the I2C bus.
> 
> If nothing is forthcoming, I'm intending to drop the patch; we don't
> need to waste time supporting untested workarounds for what are
> essentially broken SFPs by vendors twisting the SFP MSA in the
> kernel.

I have had no further co-operation from Thomas so far. If I don't hear
from someone who is able to test this module by this weekend, I will be
dropping this patch from my repository.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
