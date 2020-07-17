Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4F54223738
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 10:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgGQIgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 04:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbgGQIgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 04:36:32 -0400
Received: from filter03-ipv6-out05.totaalholding.nl (filter03-ipv6-out05.totaalholding.nl [IPv6:2a02:c207:2038:8169::5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192A9C061755
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 01:36:32 -0700 (PDT)
Received: from www98.totaalholding.nl ([185.94.230.81])
        by filter03.totaalholding.nl with esmtps (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <mjbaars1977.netdev@cyberfiber.eu>)
        id 1jwLqw-0005iy-6J
        for netdev@vger.kernel.org; Fri, 17 Jul 2020 10:36:27 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=cyberfiber.eu; s=default; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cEor1kchDrTnLQT7r5hM39XA8q3Mj7T3SvD1QNTo/tU=; b=lQYtmJaTGEOeMR1ys3Lf/QDx+M
        BN2tF/mO6s8VStGHmC5f4C4wkecYR1Q87qwjevIer+OFLaSvWTLfC8CaLLa5+PcHTZKK58pdycQhb
        Noqs2tmI3yEn3oCKyF4oG6FEbRZS3WbIBAlwoJxAYNOSNEwV9n7lPBiYtK1KKnsG07yB1UKobxyzs
        uHKnf0LakJ9KCKAqfFoAZOH+mb2JgCwLxgYnOzCt92WAslfH3GWhljYsLvjvHD4qku0ShiJL4/Hol
        AV2M28ovbmcMrGEjTJZGBELp/+QO+Oyv6zO01H9/ilHJUgMvkSCx4htoYMXlXvojy/LLkE0jZDlch
        iuU6ahQg==;
Received: from 134-134-146-85.ftth.glasoperator.nl ([85.146.134.134]:42638 helo=as02.cyberfiber.eu)
        by www98.totaalholding.nl with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <mjbaars1977.netdev@cyberfiber.eu>)
        id 1jwLqv-0008Bt-0T; Fri, 17 Jul 2020 10:36:21 +0200
Message-ID: <6246a77d65364ebc1ea592755b0b7364be1d82e3.camel@cyberfiber.eu>
Subject: Re: wake-on-lan
From:   "Michael J. Baars" <mjbaars1977.netdev@cyberfiber.eu>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
Date:   Fri, 17 Jul 2020 10:36:21 +0200
In-Reply-To: <7d4c5243-8949-6617-781b-915eadd9fbf0@gmail.com>
References: <309b0348938a475f256cbc8afbbc127c285fec69.camel@cyberfiber.eu>
         <20200715133922.tu2ptsfeu25fnuwe@lion.mk-sys.cz>
         <5bc8aee0916754b166c7b1fc84fe3ec87509d00b.camel@cyberfiber.eu>
         <7d4c5243-8949-6617-781b-915eadd9fbf0@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - www98.totaalholding.nl
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - cyberfiber.eu
X-Get-Message-Sender-Via: www98.totaalholding.nl: authenticated_id: mjbaars1977.netdev@cyberfiber.eu
X-Authenticated-Sender: www98.totaalholding.nl: mjbaars1977.netdev@cyberfiber.eu
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Originating-IP: 185.94.230.81
X-SpamExperts-Domain: out.totaalholding.nl
X-SpamExperts-Username: 185.94.230.81
Authentication-Results: totaalholding.nl; auth=pass smtp.auth=185.94.230.81@out.totaalholding.nl
X-SpamExperts-Outgoing-Class: ham
X-SpamExperts-Outgoing-Evidence: Combined (0.11)
X-Recommended-Action: accept
X-Filter-ID: Mvzo4OR0dZXEDF/gcnlw0ZZlDYW4q2llG44Qh0NJtYKpSDasLI4SayDByyq9LIhV41hlOWfPmQeE
 TnWUepBl50TNWdUk1Ol2OGx3IfrIJKywOmJyM1qr8uRnWBrbSAGDesseJUSjHz/88doLK5oKLCh4
 MK0k2uSGCYA7tfg2EIEwyE7wBSbX2EQmmkDjbwbBBMmyNbDn7R5kilAhwr3KtPRgtEKbbJiCf5yI
 2Oixqpv8turjVjucQC9RIshNVjRiiUJVo/88OaBUYn2f2rrWozvYRr+XMpd4TPSDwXbJnKUT8lKd
 CCiWAQU/4ieyu/iwiLsDClfbaI84RZiugwT8QWxGAXTBy8/H3WcrcQT70P7X5v+mYawbzB6hkUUt
 sqq08+yLLCmzUpugMpa8+70UXnWBkSeY/6oCOYH4zZN0NRXDtcI5nm/UQmvmCOPU+JDroQD5i54R
 ENh+eSCg+2n85lX9as2kVHNz96JURy2pjEMm9Jm2RoyB7MEvdTqE1m1dUW8gcqFiuZZBAe4mCUYa
 OoMW+lUPQ8n9Zncpv31g751BbyiRAJf82cBz1IrWgDkIcI5+17rf5V2oLKHXeaqjg0xYsHKVOH8s
 ++Y8aVPfETxoh9VoIekQHpwUfpYnEThmIdyFnm7yDHRBdByJCXc8vLe+EC8mEY5XM21Bk7zkAcF9
 gocot3i9mq39AbtG4RqENcpMnHYV5nYzKa1EY8f6kuxgo7FjjNmrcNu3yplkDNH90M8VAYw5SMav
 wmOhlgPPiwQzKw+6v3CaIMG6s7LqJG6CQeNMJ/uu1fLWZ0yH5nf6TTDOvSxJH/uDkqrKru3t8Hpc
 sCGCZIaQaqNChKwUoyH7at1GK6Ij8imKv2nzg9pRXxKF5tPxTxfD0dMN+t5Z7mICg/IgFPLHKYSa
 tKBN0t1FZIV+/GXHWbViba4uJV2v9S/fTs8Lg45u5W78s+n/2NBYfQNswA2q9ExqYBxOI940eTXl
 WiUAYdLmsJdAoPIFemVVgKqJgQi9QDrzr6FixvMZd7pIsHd9jbNAm4nOXTiiLDLpPIjqcoJ5Q1Hu
 u+CBdnA1akISDqYmAh3OWMNa8z+L+DhnNO2xLycvoOPrPw==
X-Report-Abuse-To: spam@filter01.totaalholding.nl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-07-16 at 18:09 +0200, Heiner Kallweit wrote:
> On 16.07.2020 09:28, Michael J. Baars wrote:
> > On Wed, 2020-07-15 at 15:39 +0200, Michal Kubecek wrote:
> > > On Wed, Jul 15, 2020 at 11:27:20AM +0200, Michael J. Baars wrote:
> > > > Hi Michal,
> > > > 
> > > > This is my network card:
> > > > 
> > > > 01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> > > > RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 0c)
> > > > 	Subsystem: Realtek Semiconductor Co., Ltd. Device 0123
> > > > 	Kernel driver in use: r8169
> > > > 
> > > > On the Realtek website
> > > > (
> > > > https://www.realtek.com/en/products/communications-network-ics/item/rtl8168e
> > > > )
> > > > it says that both wake-on-lan and remote wake-on-lan are supported.
> > > > I
> > > > got the wake-on-lan from my local network working, but I have
> > > > problems
> > > > getting the remote wake-on-lan to work.
> > > > 
> > > > When I set 'Wake-on' to 'g' and suspend my system, everything works
> > > > fine (the router does lose the ip address assigned to the mac
> > > > address
> > > > of the system). I figured the SecureOn password is meant to forward
> > > > magic packets to the correct machine when the router does not have
> > > > an
> > > > ip address assigned to a mac address, i.e. port-forwarding does not
> > > > work.
> > > > 
> > > > Ethtool 'Supports Wake-on' gives 'pumbg', and when I try to set
> > > > 'Wake-on' to 's' I get:
> > > > 
> > > > netlink error: cannot enable unsupported WoL mode (offset 36)
> > > > netlink error: Invalid argument
> > > > 
> > > > Does this mean that remote wake-on-lan is not supported (according
> > > > to
> > > > ethtool)?
> > > 
> > > "MagicPacket" ('g') means that the NIC would wake on reception of
> > > packet
> > > containing specific pattern described e.g. here:
> > > 
> > >   https://en.wikipedia.org/wiki/Wake-on-LAN#Magic_packet
> > > 
> > > This is the most frequently used wake on LAN mode and, in my
> > > experience,
> > > what most people mean when they say "enable wake on LAN".
> > > 
> > 
> > Yes, about that. I've tried the 'system suspend' with 'ethtool -s 
> > enp1s0' wol g' several times this morning. It isn't working as fine as
> > I thought it was. The results are in the attachment, five columns for
> > five reboots, ten rows for ten trials. As you can see, the wake-on-lan
> > isn't working the first time after reboot. You can try for yourself, I
> > run kernel 5.7.8.
> > 
> > > The "SecureOn(tm) mode" ('s') is an extension of this which seems to
> > > be
> > > supported only by a handful of drivers; it involves a "password" (48-
> > > bit
> > > value set by sopass parameter of ethtool) which is appended to the
> > > MagicPacket.
> > > 
> > 
> > Funny, it looks more like a mac address to me than like a password :) 
> > 
> > > I'm not sure how is the remote wake-on-lan supposed to work but
> > > technically you need to get _any_ packet with the "magic" pattern to
> > > the
> > > NIC.
> > > > I figured the SecureOn password is meant to forward magic packets
> > > > to the correct machine when the router does not have an ip address
> > > > assigned to a mac address, i.e. port-forwarding does not work.
> > 
> > Like this? We put it on the broadcast address?
> > 
> > > > I also tried to set 'Wake-on' to 'b' and 'bg' but then the systems
> > > > turns back on almost immediately for both settings.
> > > 
> > > This is not surprising as enabling "b" should wake the system upon
> > > reception of any broadcast which means e.g. any ARP request. Enabling
> > > multiple modes wakes the system on a packet matching any of them.
> > > 
> > 
> > I think the "bg" was supposed to wake the system on a packet matching
> > both of them. We want to wake up on a packet with the magic packet
> > signature on the broadcast address,
> > 
> This needs to be supported by the hardware. And also r8168 vendor driver
> doesn't support the signature mode, you can check the r8168 sources.
> 

I already suspected this. It's a work in progress. Programming the network nodes from a laptop in Paris will have to wait :)

> > > _any_ packet with the "magic" pattern
> > > Michal

Cheerz,
Mischa.

