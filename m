Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5B72F17F4
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 15:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729749AbhAKOTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 09:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbhAKOTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 09:19:33 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF59C061786;
        Mon, 11 Jan 2021 06:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qL64AjttEW9JEHxeSbQltZFeh4LrBW2rV86nspYAnAc=; b=voI79gzRU51wYkidD3A/JawqZ
        Zr9HzyER2woNYwJqYaeTGeKiSHrOV3YIOn9HJ1LcdWQj8+IRTQHJYpXEd8bSVmJoyRYX3cRTZ3pAl
        L7VJw2TTU455t+cSujZUm41suaq3n5OwyGxNWxIALfnQZVQ6vR2uHF5NIdefhGV+enkybW9dd7TG8
        PxTRLb0QXIQZzDGB/DSzx/FCqeUHy83dmAJbwG4L7+OCt+M1Ndx9IX5ZpXEAy0Z0+cYBL6JZOKhDC
        nk6CvPgChED2MtWhVDO/UrG35eB9w6pioM5Yg/D7DA6mNB82rRil4wtG1rvMLEJSQkJxpe12pbvKy
        QC4A7+0Tw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46622)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kyy1w-00078L-B8; Mon, 11 Jan 2021 14:18:48 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kyy1v-0005JB-9V; Mon, 11 Jan 2021 14:18:47 +0000
Date:   Mon, 11 Jan 2021 14:18:47 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH v1 0/2] Add 100 base-x mode
Message-ID: <20210111141847.GU1551@shell.armlinux.org.uk>
References: <20210111130657.10703-1-bjarni.jonasson@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111130657.10703-1-bjarni.jonasson@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 02:06:55PM +0100, Bjarni Jonasson wrote:
> Adding support for 100 base-x in phylink.
> The Sparx5 switch supports 100 base-x pcs (IEEE 802.3 Clause 24) 4b5b encoded.
> These patches adds phylink support for that mode.
> 
> Tested in Sparx5, using sfp modules:
> Axcen 100fx AXFE-1314-0521 
> Cisco GLC-FE-100LX
> HP SFP 100FX J9054C
> Excom SFP-SX-M1002

For each of these modules, please send me:

ethtool -m ethx raw on > module.bin

so I can validate future changes with these modules. Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
