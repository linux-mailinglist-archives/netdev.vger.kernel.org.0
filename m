Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE4F1F7811
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 16:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfKKPw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 10:52:58 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35296 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726857AbfKKPw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 10:52:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+Dj5SnGRt+SZTxF4emgU/+zWRs/FZHCITnlTwkh/8e8=; b=DU0/2qQgSjiCqHJ6Htq5wfgk/
        vF93m7365MoECxCCegeOV7rU1mA97pMgTQPWY4fgHlO3Vz+QMdEqg6J1Wzv9gE+xuBwzipsywUL5U
        PFcpWFOdX0ikdZhJMD+kh9W/g7VFRWd+FWILWN+87M9F25b3YsaFKEr3ZYOFXQQ70Z9AcjxkGgjze
        ulRk/BqerZA2e03EAYUi8ijY4Uj/11zK22KG8RJNSiqY8EYfKVFqTDbz9VVgXod14q+WXfhI0vWuy
        fBpmkqf4GxV+mkMXKWL2Htl+B+izDekLAQYHabGVIAvv68uYb+ZA7o+XOe46fWPfBOIP/uvAi+tQl
        XxpqYe8yg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:54844)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iUBzm-0006cK-Dh; Mon, 11 Nov 2019 15:52:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iUBzj-0000c2-T4; Mon, 11 Nov 2019 15:52:47 +0000
Date:   Mon, 11 Nov 2019 15:52:47 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Frank Rowand <frowand.list@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/2] net: phy: add core phylib sfp support
Message-ID: <20191111155247.GJ25745@shell.armlinux.org.uk>
References: <20191110142226.GB25745@shell.armlinux.org.uk>
 <E1iTo7N-0005Sj-Nk@rmk-PC.armlinux.org.uk>
 <20191110161307.GC25889@lunn.ch>
 <20191110164007.GC25745@shell.armlinux.org.uk>
 <20191110170040.GG25889@lunn.ch>
 <20191111140114.GH25745@shell.armlinux.org.uk>
 <CAL_JsqJe1xUKnREx17vY=Umf9dQimvK7QTqAkunvUxF8GKzjMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqJe1xUKnREx17vY=Umf9dQimvK7QTqAkunvUxF8GKzjMQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 09:01:22AM -0600, Rob Herring wrote:
> The dependencies are all documented in writing-schema.rst (formerly
> .md) in the 'Dependencies' section.
> 
> TL;DR: pip3 install git+https://github.com/devicetree-org/dt-schema.git@master

I've mentioned it in a few IRC forums, and it seems that I'm not the
only one who has trouble with this - so, this DT schema stuff totally
fails the "keep it simple" approach, which is bad news if you want
people to use it.  It's a blocker when you have to do something with
these .yaml files - or take the approach that you'd write something
that looks write and hope that someone else checks it.

So, to help people, please consider adding to that section information
such as:

8<====
For debian stable (buster), you will need to install:

 - python3-pip

for the pip3 tool.

You do not need other python3 packages, as the pip3 tool will install
the latest versions of any dependent packages into your ~/.local
directory. However, note that these will not be kept up to date by
your distribution.
8<====

It may be useful if the instructions for other distros are also added.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
