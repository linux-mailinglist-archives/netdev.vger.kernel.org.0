Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA67468C08
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 16:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbhLEQAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 11:00:22 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39438 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229838AbhLEQAV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Dec 2021 11:00:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=TzYIJ+jSAkT/5s7XQhX4qjF9HbtSwZ0MGFeSSwF1/n4=; b=OIoPTAkwrltrrBKg05VhELnKAO
        Zje2WILPOXwwIKe1ut/wSoRpEGv8A/gzz17N1o+msuw1hWYJUBeW8GKXXTauZkIbjMU/NmRFOSBMa
        KvpKwBzBGb43n6T1G6C9EUjV/1wpMqoWyM1IUHyCCk8RiQnZrzxZQojKPA/anp7wrrGA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mttsa-00FbOW-L9; Sun, 05 Dec 2021 16:56:44 +0100
Date:   Sun, 5 Dec 2021 16:56:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Yinbo Zhu <zhuyinbo@loongson.cn>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH v3 1/2] modpost: file2alias: make mdio alias configure
 match mdio uevent
Message-ID: <YazhPOIIzpl43tzq@lunn.ch>
References: <1638260517-13634-1-git-send-email-zhuyinbo@loongson.cn>
 <YaXrP1AyZ3AWaQzt@shell.armlinux.org.uk>
 <ea3f6904-c610-0ee6-fbab-913ba6ae36c5@loongson.cn>
 <Yas2+yq3h5/Bfvy9@shell.armlinux.org.uk>
 <YavYM2cs0RuY0JdM@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YavYM2cs0RuY0JdM@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The modalias string provided in the uevent sysfs file does not conform
> to the format used in PHY driver modules. One of the reasons is that
> udev loading of PHY driver modules has not been an expected use case.
> 
> This patch changes the MODALIAS entry for only PHY devices from:
> 	MODALIAS=of:Nethernet-phyT(null)
> to:
> 	MODALIAS=mdio:00000000001000100001010100010011

Hi Russell

You patch looks good for the straight forward cases.

What happens in the case of

        ethernet-phy@0 {
            compatible = "ethernet-phy-ieee802.3-c45";


Does this get appended to the end, or does it overwrite?

     Andrew
