Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42BE914CBA0
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 14:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgA2Noy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 08:44:54 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58016 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726145AbgA2Noy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jan 2020 08:44:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1PsCyZiJNzWSh/X6Yn9bmxCT8M3pbnDTwTnNpHkX7cM=; b=6Xz9fGxdmDKu13Msi/iLjnxov/
        hLcxd6ClBqLKn7mV4k8sk58YcFO/NICBEHXYqKK18NYCAHaMlm8G4VjyKR5UDcNx04QbgqVt5YXMz
        ZVqby5uMl+ozrWtOZqnuDZrE2sXYFVivnqYIiR6gLhn1HFxjrgkJFWAL74dZaI16doH8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iwneB-0006em-9p; Wed, 29 Jan 2020 14:44:47 +0100
Date:   Wed, 29 Jan 2020 14:44:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ykaukab@suse.de" <ykaukab@suse.de>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next 1/2] net: phy: aquantia: add rate_adaptation
 indication
Message-ID: <20200129134447.GA25384@lunn.ch>
References: <1579701573-6609-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1579701573-6609-2-git-send-email-madalin.bucur@oss.nxp.com>
 <68921c8a-06b6-d5c0-e857-14e7bc2c0a94@gmail.com>
 <DB8PR04MB6985606F38572D8512E8D27EEC0F0@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <77e3ddcb-bddb-32d8-9c87-48ba9a7f2773@gmail.com>
 <CA+h21hq7U_EtetuLZN5rjXcq+cRUoD0y_76LxuHpoC53J70CEQ@mail.gmail.com>
 <DB8PR04MB6985139D4ABED85B701445A9EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <CA+h21hpSpgQsQ0kRmSaC2qfmFj=0KadDjwEK2Bvkz72g+iGxBQ@mail.gmail.com>
 <DB8PR04MB6985B0A712634DCFCD5390A4EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB6985B0A712634DCFCD5390A4EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I know it is set because someone does put some work in designing a system,
> in provisioning a correct firmware image.

Hi Madalin

That is one of the things i don't like about the aquantia PHY. It can
have all sorts of magic in its firmware, but the firmware is specific
to the board. Is this phydev->rate_adaptation going to be correct for
any other board using an Aquantia PHY?

I think at least you need to poke around in the Aquantia PHY registers
and ensure this feature is actually enabled before setting this bit to
true.

	Andrew
