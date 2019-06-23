Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 872184FA9A
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 09:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfFWH0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 03:26:18 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:41770 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbfFWH0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 03:26:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=m43ZE8MKC+K0JHxy+/izRqvSnOUhggHQ6xBTF5EVfHE=; b=qxpbWdFwmIy3iRch8hfOdoGLe
        OryEpd5UP394tqY25/VmZeDAz87HGv167MRLQ5MVuFKil3Z/CM9FROzLAnshsunC1im2Y4TOXmrgY
        u2RrGkKIcou7GAu/KPEJA36XF9rIB87xmMIEvlYEVujyZ2CmkR0lFaNnuxW49Y2bTjtf/jwdq+v8/
        gkfhfeKu3BKdsPGqafn8OTV+Ef0bTgha4oMIShparNRFSSgUxe17hBFKuYabIsAoLsr1ONxw4BmZx
        R35WFwzHBq5oE2BaBNvNFx+SYH4VzDzQi1RK3wvnC7m+Zc7ZGoPeSe76wWpzUqcdADrBXE8Rdte2b
        6FJggLgFg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:58912)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hewtC-0008Rg-Ea; Sun, 23 Jun 2019 08:26:14 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hewt4-0004qj-2B; Sun, 23 Jun 2019 08:26:06 +0100
Date:   Sun, 23 Jun 2019 08:26:05 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ido Schimmel <idosch@mellanox.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC net-next] net: dsa: add support for MC_DISABLED attribute
Message-ID: <20190623072605.2xqb56tjydqz2jkx@shell.armlinux.org.uk>
References: <20190620235639.24102-1-vivien.didelot@gmail.com>
 <5d653a4d-3270-8e53-a5e0-88ea5e7a4d3f@gmail.com>
 <20190621172952.GB9284@t480s.localdomain>
 <20190623070949.GB13466@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190623070949.GB13466@splinter>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 23, 2019 at 07:09:52AM +0000, Ido Schimmel wrote:
> When multicast snooping is enabled unregistered multicast traffic should
> only be flooded to mrouter ports.

Given that IPv6 relies upon multicast working, and multicast snooping
is a kernel configuration option, and MLD messages will only be sent
when whenever the configuration on the target changes, and there may
not be a multicast querier in the system, who does that ensure that
IPv6 can work on a bridge where the kernel configured and built with
multicast snooping enabled?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
