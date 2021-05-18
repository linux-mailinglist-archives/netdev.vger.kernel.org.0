Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8E1387609
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 12:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348320AbhERKIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 06:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241178AbhERKIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 06:08:01 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7E9C061573;
        Tue, 18 May 2021 03:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=XcUE59BbQI5VCk62NQ98jAv25zo//emUHUedcxxcgyA=; b=B+1u6ZG4uJf1OSsB0tVOyeq0N
        H+f35qC+o3JQhJf0dqEAUIURiaEown3+hepXFL/kFsdRe5AnAXhCIr6odFUcrSryaajMcfXd7lHSV
        oERv2lMclyCkH88TtgEHbvmIjNuiaaskphGn/68qNsJVObsFzkALdGKWJnX2FP1mqe6ytC45X9SUH
        JOZlL7c8SLi92/bJOPHxXqYy/CdA1jei51V5eRNuZvzT7bn/n+6/NXPoPu+KSzaxpEWV+9shIdC8z
        pzsC2s8JthkHOanWWYH+W3ao8o0rzYPudZqRQqUkWQJea5CTgYcaXde0QKP4Qyg7/QjPw/chMtbu+
        FgWLQSc9Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44126)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1liwcR-00042a-B7; Tue, 18 May 2021 11:06:31 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1liwcN-0007nP-Tc; Tue, 18 May 2021 11:06:27 +0100
Date:   Tue, 18 May 2021 11:06:27 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>
Cc:     "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] net: stmmac: Add callbacks for DWC xpcs
 Energy Efficient Ethernet
Message-ID: <20210518100627.GT12395@shell.armlinux.org.uk>
References: <20210517094332.24976-1-michael.wei.hong.sit@intel.com>
 <20210517094332.24976-3-michael.wei.hong.sit@intel.com>
 <20210517105424.GP12395@shell.armlinux.org.uk>
 <CO1PR11MB50447EDBEB4835C3EB5B3C7A9D2D9@CO1PR11MB5044.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB50447EDBEB4835C3EB5B3C7A9D2D9@CO1PR11MB5044.namprd11.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 11:37:12AM +0000, Sit, Michael Wei Hong wrote:
> > From: Russell King <linux@armlinux.org.uk>
> > 
> > On Mon, May 17, 2021 at 05:43:32PM +0800, Michael Sit Wei Hong
> > wrote:
> > > Link xpcs callback functions for MAC to configure the xpcs EEE
> > feature.
> > >
> > > The clk_eee frequency is used to calculate the
> > MULT_FACT_100NS. This
> > > is to adjust the clock tic closer to 100ns.
> > >
> > > Signed-off-by: Michael Sit Wei Hong
> > <michael.wei.hong.sit@intel.com>
> > 
> > What is the initial state of the EEE configuration before the first
> > call to stmmac_ethtool_op_set_eee()? Does it reflect the default
> > EEE settings?
> 
> The register values before the first call are the default reset values in
> the registers. The reset values assumes the clk_eee_i time period is 10ns,
> Hence, the reset value is set to 9.
> According to the register description,
> This value should be programmed such that the
> clk_eee_i_time_period * (MULT_FACT_100NS + 1) should be
> within 80 ns to 120 ns.
> 
> Since we are using a fixed 19.2MHz clk_eee, which is 52ns,
> we are setting the value to 1.

Does that hardware default configuration match what is returned by
ethtool --show-eee ?
 
-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
