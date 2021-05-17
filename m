Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9596382A54
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 12:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236589AbhEQK42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 06:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236556AbhEQK41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 06:56:27 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D397C061573;
        Mon, 17 May 2021 03:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/jXKRvEAGHf4XcoVw2En2iOfrxY4eQ22yvfNze/jORc=; b=lqRFR80I/wSPtHYniW1bDyEUf
        cUrsWt0HhhyqUWfhPPBnUvFm8Eki/Z25W8/fBog//DEmgWyVPtEDcT2EQJDBjAE99yRG8uZONXwC1
        xo153AxgP/6c7ejMd2dWgtsbEDTG1DGQTxUvc+26zHmsRR6MJmz/yknSly84bMdz8RLxOVpXc5utZ
        beYdwnC6JwOs8ZrZnz1VIXQPQ8kNflGlZqImlC7vcQeOj0v5P47JGRbNqpSJc6PKKiUv8u/tiRdof
        k954LYDr6WpuIg0fBhub1a8aXk8Yo+WZTSPxFXo75chhgvUx02SKd1/9BR5vHNWBF0khhIZnrI/Zd
        tK0xR2UMw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44096)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1liatI-0002KM-FV; Mon, 17 May 2021 11:54:28 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1liatE-0006st-Fw; Mon, 17 May 2021 11:54:24 +0100
Date:   Mon, 17 May 2021 11:54:24 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, weifeng.voon@intel.com,
        boon.leong.ong@intel.com, tee.min.tan@intel.com,
        vee.khee.wong@linux.intel.com, vee.khee.wong@intel.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: stmmac: Add callbacks for DWC xpcs
 Energy Efficient Ethernet
Message-ID: <20210517105424.GP12395@shell.armlinux.org.uk>
References: <20210517094332.24976-1-michael.wei.hong.sit@intel.com>
 <20210517094332.24976-3-michael.wei.hong.sit@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210517094332.24976-3-michael.wei.hong.sit@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 05:43:32PM +0800, Michael Sit Wei Hong wrote:
> Link xpcs callback functions for MAC to configure the xpcs EEE feature.
> 
> The clk_eee frequency is used to calculate the MULT_FACT_100NS. This is
> to adjust the clock tic closer to 100ns.
> 
> Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>

What is the initial state of the EEE configuration before the first
call to stmmac_ethtool_op_set_eee()? Does it reflect the default EEE
settings?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
