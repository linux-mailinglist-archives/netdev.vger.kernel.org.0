Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9B8221DB0
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 09:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgGPHzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 03:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgGPHzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 03:55:01 -0400
Received: from filter01-ipv6-out02.totaalholding.nl (filter01-ipv6-out02.totaalholding.nl [IPv6:2a02:40c0:1:2:ffff::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2AE1C061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 00:55:00 -0700 (PDT)
Received: from www98.totaalholding.nl ([185.94.230.81])
        by filter01.totaalholding.nl with esmtps (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <mjbaars1977.netdev@cyberfiber.eu>)
        id 1jvxv5-0005Fj-I2
        for netdev@vger.kernel.org; Thu, 16 Jul 2020 09:03:09 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=cyberfiber.eu; s=default; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=K0Sh8zlOqwqK5ZHBASdC9Ao0dJyDOe7JIA3GAM4FBTA=; b=UBbkND0Fjq0VnO4rFsJV3dyDT4
        hse792Cqx72rk0XtpOI5mjy/I8tBfsjomxaXYH1Gg3ywzlTsCJi/UCYAHMgY3pmx61SNG/MHYBsgN
        uN/3BdHTVac34WOLrAq8ulgdDLCXR1ZeGZP8NJL7LRbHhQIFdzzpvjALWLEGnHtyfcIbbfZ1MroHf
        MozxgXGq4XUaNSJ05OoDky+a8ZIHoQBW57W/2LojNHT1bDgbY+Eke8jWyaKt3JvR7nEyMBTc1U3wc
        81+Nmw2Wb7Nf4YQJh0SGI3YYLbpdeUn+ghDiNELvkGDYnKh+JE/DuRYIAWhB6LDRJva3CuqrbK2Cu
        yz/bhFPg==;
Received: from 134-134-146-85.ftth.glasoperator.nl ([85.146.134.134]:41518 helo=as03.cyberfiber.eu)
        by www98.totaalholding.nl with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <mjbaars1977.netdev@cyberfiber.eu>)
        id 1jvxv5-0000Ex-4O; Thu, 16 Jul 2020 09:03:03 +0200
Message-ID: <73184ba904043f7bd20b699f009d2223ed12f6c9.camel@cyberfiber.eu>
Subject: Re: wake-on-lan
From:   "Michael J. Baars" <mjbaars1977.netdev@cyberfiber.eu>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
Date:   Thu, 16 Jul 2020 09:02:59 +0200
In-Reply-To: <b8f9ccd2-e56e-0965-3b4a-ff583a88829c@gmail.com>
References: <309b0348938a475f256cbc8afbbc127c285fec69.camel@cyberfiber.eu>
         <b8f9ccd2-e56e-0965-3b4a-ff583a88829c@gmail.com>
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
X-SpamExperts-Outgoing-Evidence: Combined (0.06)
X-Recommended-Action: accept
X-Filter-ID: Mvzo4OR0dZXEDF/gcnlw0ZZlDYW4q2llG44Qh0NJtYKpSDasLI4SayDByyq9LIhVMol9lxCx/Cod
 lYcgr5MZI0TNWdUk1Ol2OGx3IfrIJKywOmJyM1qr8uRnWBrbSAGDesseJUSjHz/88doLK5oKLCh4
 MK0k2uSGCYA7tfg2EIEg5+kxtshvcjbyy6uROIBDBMmyNbDn7R5kilAhwr3KtPRgtEKbbJiCf5yI
 2Oixqpv8turjVjucQC9RIshNVjRiiUJVo/88OaBUYn2f2rrWozvYRr+XMpd4TPSDwXbJnKXcg9aI
 mjFV4MsQPYDnL0bgiLsDClfbaI84RZiugwT8QWxGAXTBy8/H3WcrcQT70P7X5v+mYawbzB6hkUUt
 sqq08+yLLCmzUpugMpa8+70UXnWBkSeY/6oCOYH4zZN0NRXDtcI5nm/UQmvmCOPU+JDroQD5i54R
 ENh+eSCg+2n85lX9as2kVHNz96JURy2pjEMm9Jm2RoyB7MEvdTqE1m1dUW8gcqFiuZZBAe4mCUYa
 OoMW+lUPQ8n9Zncpv31g751BbyiRAJf82cBz1IrWgDkIcI5+17rf5V2oLKHXeaqjg0xYsHKVOH8s
 ++Y8aVPfETxoh9VoIekQHpwUfpYnEThm5DwyPjycEGbnv/kZOnEtRz9fRb8rIFnqBHhmauLXgPu+
 AydI1MhYOkUoWbimUwLAD8+U1Gs15Jq6FhEZcVId+ZdYjMtukHkHem3N+7nlLP0BPRa7yxFD1yWw
 eEzgeHQBRK0rNF96MqE3PI/6O6rpcbivsLJ73dl0Ye/aD7Kr7qwsZpl3Wn8WGGklIocC+EQbm+51
 22gqm46UIONxQAtBQEYsDx4UVqYtbh3Jgdb5gj51vE3zFH12TUBlyI7lwiy6ruLKNzT4LyuurApO
 kAJBXsOpyKA69LF1Ge2GaGfxmfrNgDQxvdWGg04vPf/WKY/aomL27H9hSYrFv98i9pQb7ps77ycx
 Fgv2R6RUvh2HHTrN3gZSyaolST7QqMNaVS9VLP9EgLlu5Qy4RPM96q9k14a7Gkt7x/nNEvEiMgCm
 6MHApnqpdot95Z1s2bBwfdm/p2aj0y1gHf0XQaMcetOu6w==
X-Report-Abuse-To: spam@filter01.totaalholding.nl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-07-15 at 15:17 +0200, Heiner Kallweit wrote:
> On 15.07.2020 11:27, Michael J. Baars wrote:
> > Hi Michal,
> > 
> > This is my network card:
> > 
> > 01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> > RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 0c)
> > 	Subsystem: Realtek Semiconductor Co., Ltd. Device 0123
> > 	Kernel driver in use: r8169
> > 
> > On the Realtek website (
> > https://www.realtek.com/en/products/communications-network-ics/item/rtl8168e
> > ) it says that both wake-on-lan and remote wake-on-lan are
> > supported. I got the wake-on-lan from my local network working, but
> > I have problems getting the remote wake-on-lan to work.
> > 
> > When I set 'Wake-on' to 'g' and suspend my system, everything works
> > fine (the router does lose the ip address assigned to the mac
> > address of the system). I
> > figured the SecureOn password is meant to forward magic packets to
> > the correct machine when the router does not have an ip address
> > assigned to a mac address,
> > i.e. port-forwarding does not work.
> > 
> > Ethtool 'Supports Wake-on' gives 'pumbg', and when I try to set
> > 'Wake-on' to 's' I get:
> > 
> > netlink error: cannot enable unsupported WoL mode (offset 36)
> > netlink error: Invalid argument
> > 
> > Does this mean that remote wake-on-lan is not supported (according
> > to ethtool)?
> > 
> > ---
> > 
> > I also tried to set 'Wake-on' to 'b' and 'bg' but then the systems
> > turns back on almost immediately for both settings.
> > 
> > ---
> > 
> > Hope you can help getting the remote wake-on-lan to work,
> > 
> > Best regards,
> > Mischa.
> > 
> > 
> > 
> > 
> This isn't really a question to Michal. r8169 supports pumbg as
> mentioned by you.
> On DASH-capable systems with Windows more may be supported by the
> vendor driver.
> But Realtek doesn't release any public datasheets, therefore there's
> no DASH support under Linux.

They do provide open-source drivers :)

