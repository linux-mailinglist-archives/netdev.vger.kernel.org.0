Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504401D1C00
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 19:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389431AbgEMROl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 13:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732731AbgEMROk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 13:14:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513FFC061A0C;
        Wed, 13 May 2020 10:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=HStHYMCHMAld2jAQY6gz1O8fAw0LWyJlNm7iC5JM3JA=; b=w3mvih03C8N35b+4Bo9Ot7tr2
        jgtW5Sh5X8sNAYy+j5tqw4QcbGeYxbFikVgq8C+oIlEF5CjnIMqJO1PWLeN7cBnMjSyiV3x+FcIAf
        US/X62EecXyz/0yIwlFJMTbYLsLBo89lYTmYwkBOQs9mSvd6WpfW9toFpDcXegZcAnjyT0TyrCNsz
        WuYZRUoazDCr7Of5oCHqIJ0mCfcP4jmBLBcT3DsE0L9yqVM4K+VY0vrT9Y022pjMxYVkkOzXcarUr
        Y7jc3k7yCWBKIsDshlPTRoynB/MT993/+xWLOX+Y8l2oDGgTLuRwTnoAHxtwI3n/d4/YDrnTgy49T
        nHSAJfAkw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:39836)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jYuxe-0005Lq-1O; Wed, 13 May 2020 18:14:29 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jYuxY-0007xA-TL; Wed, 13 May 2020 18:14:20 +0100
Date:   Wed, 13 May 2020 18:14:20 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/4] net: ethernet: validate pause autoneg
 setting
Message-ID: <20200513171420.GL1551@shell.armlinux.org.uk>
References: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
 <1589243050-18217-2-git-send-email-opendmb@gmail.com>
 <20200512004714.GD409897@lunn.ch>
 <ae63b295-b6e3-6c34-c69d-9e3e33bf7119@gmail.com>
 <20200512185503.GD1551@shell.armlinux.org.uk>
 <0cf740ed-bd13-89d5-0f36-1e5305210e97@gmail.com>
 <20200513053405.GE1551@shell.armlinux.org.uk>
 <20200513092050.GB1605@shell.armlinux.org.uk>
 <20200513134925.GE499265@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513134925.GE499265@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 03:49:25PM +0200, Andrew Lunn wrote:
> Hi Russell, Doug
> 
> With netlink ethtool we have the possibility of adding a new API to
> control this. And we can leave the IOCTL API alone, and the current
> ethtool commands. We can add a new command to ethtool which uses the new API.
> 
> Question is, do we want to do this? Would we be introducing yet more
> confusion, rather than making the situation better?

The conclusion I came to was that I would document the deficiencies
and do no more; I think people are used to its current quirky
behaviour.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
