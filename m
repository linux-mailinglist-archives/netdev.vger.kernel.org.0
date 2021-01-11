Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B4E2F1B65
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 17:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733136AbhAKQtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 11:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727826AbhAKQtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 11:49:00 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7153C061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 08:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+c2qKoog0tPpaQ+oIH0N3mVR5/AcLyc56G2+ApvZrq8=; b=RuqwIQzcu0ou9Gm630Zofuoa9
        UZDJ1jrtZpmmx8H2K5AjvRJtrz0MNFpUrok/xl5/CA79+h96c0mhvcAIRyf/pWirllBXss7avrUoq
        jvhaQJjGxDWxEauuRJlK1akIAh7pSgF28CCMfJWZ3/LKDw7bSmmKN6UUUkBjXqXmrp2ltost+ykIy
        jotMHHTG1ObiyjJmVkeCAZGM88FmDOp8W5WZ52LEY1AdziW+AcJUWESnin7CwYi/pKpolXsSMEd2+
        FTnwa8Jy0zkcBVKf6g8Gz8751vbZEQG54Q0vRZe0J2+Ivq4K7koRK3MUWPFHMNanCt4USZcQiu9LG
        O9ice3LiA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46670)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kz0MU-0007Hm-GA; Mon, 11 Jan 2021 16:48:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kz0MN-0005PD-HB; Mon, 11 Jan 2021 16:48:03 +0000
Date:   Mon, 11 Jan 2021 16:48:03 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        lkp@intel.com, davem@davemloft.net, ashkan.boldaji@digi.com,
        andrew@lunn.ch, Chris Packham <chris.packham@alliedtelesis.co.nz>,
        olteanv@gmail.com
Subject: Re: [PATCH net-next v14 2/6] net: phy: Add 5GBASER interface mode
Message-ID: <20210111164803.GY1551@shell.armlinux.org.uk>
References: <20210111012156.27799-1-kabel@kernel.org>
 <20210111012156.27799-3-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210111012156.27799-3-kabel@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 02:21:52AM +0100, Marek Behún wrote:
> From: Pavana Sharma <pavana.sharma@digi.com>
> 
> Add 5GBASE-R phy interface mode
> 
> Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Marek Behún <kabel@kernel.org>

Please document this in Documentation/networking/phy.rst under the
"PHY interface modes" section. Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
