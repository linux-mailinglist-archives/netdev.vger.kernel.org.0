Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEAB23E4372
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 11:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233882AbhHIJ7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 05:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233842AbhHIJ7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 05:59:36 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA2AC0613D3;
        Mon,  9 Aug 2021 02:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1hoY8riowLJ4bGTuyocZGdD11OkuSsTIdR5YrgprP04=; b=kZ/CkK8TfZkmZFMIQNFz15+Qn
        329LqomRb4k3yMyB28GLqzwZIcoOYZjG5tSpCS7tMmj0TAYohQeDMyQwg89A5bZszSLnLaalz2TV7
        oZmI556AqlGZRGAQM/bGy3YqeH2wxSx3T/XKnlB4YS7ZZCjstrGskHaDLBV2c3nxuTOG3sqt2hyWX
        Lp+2hmSso+8AT4yjOeSGDPCiPS+6SOuYVmemuI6uZ0MW2Zb3LlhUbvqNx35l1Cb09Bcdrt8NcnpUM
        wlSOGnneB0FgPUZnmq3m9Lasgqvb24lh0gecosM/8pUWrHPZ+A/Xx8a2PDYhpOqZ3U2jtqmFlCx4U
        UZb719R3w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47106)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mD23j-0005Qj-Eq; Mon, 09 Aug 2021 10:59:03 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mD23g-00015j-CC; Mon, 09 Aug 2021 10:59:00 +0100
Date:   Mon, 9 Aug 2021 10:59:00 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     chaochao2021666@163.com
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Chao Zeng <chao.zeng@siemens.com>
Subject: Re: [PATCH 2/2] net:phy:dp83867:implement the binding for status led
Message-ID: <20210809095900.GS22278@shell.armlinux.org.uk>
References: <20210809085510.324205-1-chaochao2021666@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809085510.324205-1-chaochao2021666@163.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 04:55:10PM +0800, chaochao2021666@163.com wrote:
> From: Chao Zeng <chao.zeng@siemens.com>
> 
> the DP83867 has different function option for the status led.
> It is possible to set the status led for different function
> 
> Signed-off-by: Chao Zeng <chao.zeng@siemens.com>

Private properties for status LEDs are no longer permitted for new code.

Instead, there is work ongoing to add LED subsystem support for PHY
status indicators, a recent patch set can be found here:
https://lore.kernel.org/netdev/20210602144439.4d20b295@dellmb/T/
You may be interested in helping this effort along.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
