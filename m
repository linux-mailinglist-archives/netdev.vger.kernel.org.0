Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4F4221D68
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 09:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbgGPH23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 03:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727768AbgGPH23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 03:28:29 -0400
X-Greylist: delayed 1516 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 16 Jul 2020 00:28:28 PDT
Received: from filter01-ipv6-out03.totaalholding.nl (filter01-ipv6-out03.totaalholding.nl [IPv6:2a02:40c0:1:2:ffff::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C30C061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 00:28:28 -0700 (PDT)
Received: from www98.totaalholding.nl ([185.94.230.81])
        by filter01.totaalholding.nl with esmtps (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <mjbaars1977.netdev@cyberfiber.eu>)
        id 1jvyJb-00052F-LI
        for netdev@vger.kernel.org; Thu, 16 Jul 2020 09:28:27 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=cyberfiber.eu; s=default; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=aCBEFQf+VNfRXHf7bNxRwvQrmCZ2wVHYHYFybHYvt+w=; b=rxNY0/MCBSgWlD+9Qe52by6G0
        XIb61hQP0W9ziGj2i/dr1tiTIlszD1t+WeWqx0YtTDcc9je7CnKEOxitUsOf3kDkibkGJscskNwvx
        gDlVMikE1T75ZHibFTL7id/uYuSDGx9F2mH/p6Z9wv4+momUrQkYceKTfYQLjENPjMj0vu1CYKJi9
        Uppkxvw5/rD86MnD9UrttAFQ4il1BESBErb8XRYwH+PCw66Mx0pi84kFu6aYzOQlhTYJVX5kCf6u/
        x9eSlg5w0mhvMMkw5Px/xTl7OQi1//Cjp7dSLtqVYnWSv5bdiVsArjWdHUbOnjgnnN2a6oKRsaSF6
        cXrZVzPJw==;
Received: from 134-134-146-85.ftth.glasoperator.nl ([85.146.134.134]:41530 helo=as03.cyberfiber.eu)
        by www98.totaalholding.nl with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <mjbaars1977.netdev@cyberfiber.eu>)
        id 1jvyJb-00012V-CE; Thu, 16 Jul 2020 09:28:23 +0200
Message-ID: <5bc8aee0916754b166c7b1fc84fe3ec87509d00b.camel@cyberfiber.eu>
Subject: Re: wake-on-lan
From:   "Michael J. Baars" <mjbaars1977.netdev@cyberfiber.eu>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
Date:   Thu, 16 Jul 2020 09:28:23 +0200
In-Reply-To: <20200715133922.tu2ptsfeu25fnuwe@lion.mk-sys.cz>
References: <309b0348938a475f256cbc8afbbc127c285fec69.camel@cyberfiber.eu>
         <20200715133922.tu2ptsfeu25fnuwe@lion.mk-sys.cz>
Content-Type: multipart/mixed; boundary="=-3wYcyBuGVYbjkK/u+0JO"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
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
X-SpamExperts-Outgoing-Evidence: Combined (0.13)
X-Recommended-Action: accept
X-Filter-ID: Mvzo4OR0dZXEDF/gcnlw0ZZlDYW4q2llG44Qh0NJtYKpSDasLI4SayDByyq9LIhV9K/yJ7nUdbxn
 Co5JHbLuAETNWdUk1Ol2OGx3IfrIJKywOmJyM1qr8uRnWBrbSAGDesseJUSjHz/88doLK5oKLCh4
 MK0k2uSGCYA7tfg2EIFrPMucuzAkSnJmK5BD8hEIBMmyNbDn7R5kilAhwr3KtPRgtEKbbJiCf5yI
 2Oixqpv8turjVjucQC9RIshNVjRiiUJVo/88OaBUYn2f2rrWozvYRr+XMpd4TPSDwXbJnKXcg9aI
 mjFV4MsQPYDnL0bgiLsDClfbaI84RZiugwT8QWxGAXTBy8/H3WcrcQT70P7X5v+mYawbzB6hkUUt
 sqq08+yLLCmzUpugMpa8+70UXnWBkSeY/6oCOYH4zZN0NRXDtcI5nm/UQmvmCOPU+JDroQD5i54R
 ENh+eSCg+2n85lX9as2kVHNz96JURy2pjEMm9Jm2RoyB7MEvdTqE1m1dUW8gcqFiuZZBAe4mCUYa
 OoMW+lUPQ8n9Zncpv31g751BbyiRAJf82cBz1IrWgDkIcI5+17rf5V2oLKHXeaqjg0xYsHKVOH8s
 ++Y8aVPfETxoh9VoIekQHpwUfpYnEThm5DwyPjycEGbnv/kZOnEtRz9fRb8rIFnqBHhmauLXgPtw
 hD/n7T/jEEW1j61KsVozD8+U1Gs15Jq6FhEZcVId+ZdYjMtukHkHem3N+7nlLP0BPRa7yxFD1yWw
 eEzgeHQBRK0rNF96MqE3PI/6O6rpcbivsLJ73dl0Ye/aD7Kr7qwsZpl3Wn8WGGklIocC+EQb5+db
 YZ1WNyaTrPDsij3Na8P3fE79+Kz/2iYs1rP52tJ1vE3zFH12TUBlyI7lwiy6ruLKNzT4LyuurApO
 kAJBXsOpyKA69LF1Ge2GaGfxmfrNgDQxvdWGg04vPf/WKY/aomL27H9hSYrFv98i9pQb7ps77ycx
 Fgv2R6RUvh2HHTrN3gZSyaolST7QqMNaVS9VLP9EgLlu5Qy4RPM96q9k14a7Gkt7x/nNEvEiMgCm
 6MHApnqpdot95Z1s2bBwfdm/p2aj0y1gHf0XQaMcetOu6w==
X-Report-Abuse-To: spam@filter01.totaalholding.nl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-3wYcyBuGVYbjkK/u+0JO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Wed, 2020-07-15 at 15:39 +0200, Michal Kubecek wrote:
> On Wed, Jul 15, 2020 at 11:27:20AM +0200, Michael J. Baars wrote:
> > Hi Michal,
> > 
> > This is my network card:
> > 
> > 01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> > RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 0c)
> > 	Subsystem: Realtek Semiconductor Co., Ltd. Device 0123
> > 	Kernel driver in use: r8169
> > 
> > On the Realtek website
> > (
> > https://www.realtek.com/en/products/communications-network-ics/item/rtl8168e
> > )
> > it says that both wake-on-lan and remote wake-on-lan are supported.
> > I
> > got the wake-on-lan from my local network working, but I have
> > problems
> > getting the remote wake-on-lan to work.
> > 
> > When I set 'Wake-on' to 'g' and suspend my system, everything works
> > fine (the router does lose the ip address assigned to the mac
> > address
> > of the system). I figured the SecureOn password is meant to forward
> > magic packets to the correct machine when the router does not have
> > an
> > ip address assigned to a mac address, i.e. port-forwarding does not
> > work.
> > 
> > Ethtool 'Supports Wake-on' gives 'pumbg', and when I try to set
> > 'Wake-on' to 's' I get:
> > 
> > netlink error: cannot enable unsupported WoL mode (offset 36)
> > netlink error: Invalid argument
> > 
> > Does this mean that remote wake-on-lan is not supported (according
> > to
> > ethtool)?
> 
> "MagicPacket" ('g') means that the NIC would wake on reception of
> packet
> containing specific pattern described e.g. here:
> 
>   https://en.wikipedia.org/wiki/Wake-on-LAN#Magic_packet
> 
> This is the most frequently used wake on LAN mode and, in my
> experience,
> what most people mean when they say "enable wake on LAN".
> 

Yes, about that. I've tried the 'system suspend' with 'ethtool -s 
enp1s0' wol g' several times this morning. It isn't working as fine as
I thought it was. The results are in the attachment, five columns for
five reboots, ten rows for ten trials. As you can see, the wake-on-lan
isn't working the first time after reboot. You can try for yourself, I
run kernel 5.7.8.

> The "SecureOn(tm) mode" ('s') is an extension of this which seems to
> be
> supported only by a handful of drivers; it involves a "password" (48-
> bit
> value set by sopass parameter of ethtool) which is appended to the
> MagicPacket.
> 

Funny, it looks more like a mac address to me than like a password :) 

> I'm not sure how is the remote wake-on-lan supposed to work but
> technically you need to get _any_ packet with the "magic" pattern to
> the
> NIC.

> > I figured the SecureOn password is meant to forward magic packets
> > to the correct machine when the router does not have an ip address
> > assigned to a mac address, i.e. port-forwarding does not work.

Like this? We put it on the broadcast address?

> 
> > I also tried to set 'Wake-on' to 'b' and 'bg' but then the systems
> > turns back on almost immediately for both settings.
> 
> This is not surprising as enabling "b" should wake the system upon
> reception of any broadcast which means e.g. any ARP request. Enabling
> multiple modes wakes the system on a packet matching any of them.
> 

I think the "bg" was supposed to wake the system on a packet matching
both of them. We want to wake up on a packet with the magic packet
signature on the broadcast address,

> _any_ packet with the "magic" pattern

> Michal



--=-3wYcyBuGVYbjkK/u+0JO
Content-Type: application/vnd.oasis.opendocument.spreadsheet; name="wake-on-lan.ods"
Content-Disposition: attachment; filename="wake-on-lan.ods"
Content-Transfer-Encoding: base64

UEsDBBQAAAgAAEE58FCFbDmKLgAAAC4AAAAIAAAAbWltZXR5cGVhcHBsaWNhdGlvbi92bmQub2Fz
aXMub3BlbmRvY3VtZW50LnNwcmVhZHNoZWV0UEsDBBQAAAgAAEE58FAAAAAAAAAAAAAAAAAYAAAA
Q29uZmlndXJhdGlvbnMyL3Rvb2xiYXIvUEsDBBQAAAgAAEE58FAAAAAAAAAAAAAAAAAYAAAAQ29u
ZmlndXJhdGlvbnMyL2Zsb2F0ZXIvUEsDBBQAAAgAAEE58FAAAAAAAAAAAAAAAAAYAAAAQ29uZmln
dXJhdGlvbnMyL21lbnViYXIvUEsDBBQAAAgAAEE58FAAAAAAAAAAAAAAAAAaAAAAQ29uZmlndXJh
dGlvbnMyL3BvcHVwbWVudS9QSwMEFAAACAAAQTnwUAAAAAAAAAAAAAAAABwAAABDb25maWd1cmF0
aW9uczIvYWNjZWxlcmF0b3IvUEsDBBQAAAgAAEE58FAAAAAAAAAAAAAAAAAaAAAAQ29uZmlndXJh
dGlvbnMyL3Rvb2xwYW5lbC9QSwMEFAAACAAAQTnwUAAAAAAAAAAAAAAAABwAAABDb25maWd1cmF0
aW9uczIvcHJvZ3Jlc3NiYXIvUEsDBBQAAAgAAEE58FAAAAAAAAAAAAAAAAAaAAAAQ29uZmlndXJh
dGlvbnMyL3N0YXR1c2Jhci9QSwMEFAAACAAAQTnwUAAAAAAAAAAAAAAAAB8AAABDb25maWd1cmF0
aW9uczIvaW1hZ2VzL0JpdG1hcHMvUEsDBBQACAgIAEE58FAAAAAAAAAAAAAAAAAMAAAAbWFuaWZl
c3QucmRmzZPNboMwEITvPIVlzthALwUFcijKuWqfwDWGWAUv8poS3r6Ok1ZRpKrqn9TjrkYz3460
m+1hHMiLsqjBVDRjKSXKSGi16Ss6uy65pds62ti2Kx+aHfFqg6WfKrp3bio5X5aFLTcMbM+zoih4
mvM8T7wiwdU4cUgMxrSOCAkejUJp9eR8GjnO4glmV1F066CQefcgPYvdOqmgsgphtlK9h7YgkYFA
jQlMyoR0gxy6TkvFM5bzUTnBoe3ix2C904OiPGDwK47P2N6IDKblXuC9sO5cg998lWh67mN6ddPF
8d8jlGCcMu5P6rs7ef/n/i7P/xnir7R2RGxAzqNn+pDntPIfVUevUEsHCLT3aNIFAQAAgwMAAFBL
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
dC54bWxQSwUGAAAAABEAEQBlBAAAeB0AAAAA


--=-3wYcyBuGVYbjkK/u+0JO--

