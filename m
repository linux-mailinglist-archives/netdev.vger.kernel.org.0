Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 053BD30605A
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 16:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235411AbhA0P5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 10:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235436AbhA0PCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 10:02:40 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BCA9C0617AB;
        Wed, 27 Jan 2021 06:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jRhQaZPsLOKrKD1rU43zmYCCpg4a8Ss3YvA3XyYhkMQ=; b=XX2M0suGmN3UwpJiD1QGQ24i0
        SdXmANK40Zv9e+i8bMs811ewm3FJop02t8EYq3wlY8Xm/WVyAL0C7j9iuuGP11PUc38qe4tfuUObL
        DGUtYeubh+EjsiHnPRk0qD/UnYeUm6HrIdtFqqLpWZvrLAaBTgdAtmW7V6vrYRhSPRZzJKlLpto55
        cVCDr091JFdh9Q6I8vWWQWOXPe8O8Zz5z0EtCgDZPl3I9+kuLrSqTS/Fg6nXaRhuk6MyouPSs1RM7
        YHBj1dUtUZh5GEK6WU/YkNI8Z26R4kWsaLztEx/UlTf/nK7AnURxrtzRnj1kqePi2LMDxh6IB3n15
        EvkxQO4jA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53420)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l4mIW-0005aN-TR; Wed, 27 Jan 2021 14:59:56 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l4mIV-0004uO-MV; Wed, 27 Jan 2021 14:59:55 +0000
Date:   Wed, 27 Jan 2021 14:59:55 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: Re: [EXT] Re: [PATCH v4 net-next 19/19] net: mvpp2: add TX FC
 firmware check
Message-ID: <20210127145955.GN1551@shell.armlinux.org.uk>
References: <1611747815-1934-1-git-send-email-stefanc@marvell.com>
 <1611747815-1934-20-git-send-email-stefanc@marvell.com>
 <20210127140552.GM1551@shell.armlinux.org.uk>
 <CO6PR18MB3873034EAC12E956E6879967B0BB9@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR18MB3873034EAC12E956E6879967B0BB9@CO6PR18MB3873.namprd18.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 02:37:34PM +0000, Stefan Chulski wrote:
> Your mcbin-ss is A8K AX or A8K B0? On AX revisions we do not have FC support in firmware.

How do I tell? I don't want to remove the heatsink, and I don't see
anything in MV-S111188-00E. I didn't grab a copy of the Errata before
I accidentally let me extranet access expire.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
