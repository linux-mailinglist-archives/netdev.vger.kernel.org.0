Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A3D2209A3
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 12:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731026AbgGOKPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 06:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgGOKP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 06:15:29 -0400
X-Greylist: delayed 2881 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 15 Jul 2020 03:15:29 PDT
Received: from filter03-ipv6-out05.totaalholding.nl (filter03-ipv6-out05.totaalholding.nl [IPv6:2a02:c207:2038:8169::5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C5E2C061755
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 03:15:29 -0700 (PDT)
Received: from www98.totaalholding.nl ([185.94.230.81])
        by filter03.totaalholding.nl with esmtps (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <mjbaars1977.netdev@cyberfiber.eu>)
        id 1jvdhB-0007Ld-AL
        for netdev@vger.kernel.org; Wed, 15 Jul 2020 11:27:27 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=cyberfiber.eu; s=default; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=wwjfyk0Hj6f/do4f9VqpoGkv7cu51y1RoqdOzV/JZ3M=; b=s6zL06BdNE7jUEh0r4nbGUbHJR
        nrf9Ort1c9S79r3KviWFgvw43NEiJgk4HTji0yUyUALqzAk+o83tn2qkrVXtt/UnbnyWo5hcKd53G
        b9tln0T0LsEktloSWMmo3xx4b5i5LfCycQkLNqoioRbGSXd3+ZuqkmvUhS3Gkyqmt4+6W9yt1w7BH
        O8ratL0sXFlWdclIPZZGCo02KEgaWwbhW3kxlTzM7xWNuq1y1+xMa/gjFr7K0aKFaEEB7Zh3oiSb5
        FXgZEcNEuoLnJlrPCuu/nMsch/J3EdJoqGGw4HTZJro4S6Dv+wNe5HCo0BTfwCqg3LxfWy3t2Q0cI
        UwRFIyKw==;
Received: from 134-134-146-85.ftth.glasoperator.nl ([85.146.134.134]:47572 helo=as02.cyberfiber.eu)
        by www98.totaalholding.nl with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <mjbaars1977.netdev@cyberfiber.eu>)
        id 1jvdhA-00062m-Cf; Wed, 15 Jul 2020 11:27:20 +0200
Message-ID: <309b0348938a475f256cbc8afbbc127c285fec69.camel@cyberfiber.eu>
Subject: wake-on-lan
From:   "Michael J. Baars" <mjbaars1977.netdev@cyberfiber.eu>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
Date:   Wed, 15 Jul 2020 11:27:20 +0200
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
X-Filter-ID: Mvzo4OR0dZXEDF/gcnlw0ZZlDYW4q2llG44Qh0NJtYKpSDasLI4SayDByyq9LIhV7CPR9SGJ2WsG
 3aP7R6NehkTNWdUk1Ol2OGx3IfrIJKywOmJyM1qr8uRnWBrbSAGDesseJUSjHz/88doLK5oKLCh4
 MK0k2uSGCYA7tfg2EIHURjmw+/PuA1Del5zWs00kBMmyNbDn7R5kilAhwr3KtPRgtEKbbJiCf5yI
 2Oixqpv8turjVjucQC9RIshNVjRiiUJVo/88OaBUYn2f2rrWozvYRr+XMpd4TPSDwXbJnKUT8lKd
 CCiWAQU/4ieyu/iwiLsDClfbaI84RZiugwT8QWxGAXTBy8/H3WcrcQT70P7X5v+mYawbzB6hkUUt
 sqq08+yLLCmzUpugMpa8+70UXnWBkSeY/6oCOYH4zZN0NRXDtcI5nm/UQmvmCOPU+JDroQD5i54R
 ENh+eSCg+2n85lX9as2kVHNz96JURy2pjEMm9Jm2RoyB7MEvdTqE1m1dUW8gcqFiuZZBAe4mCUYa
 OoMW+lUPQ8n9Zncpv31g751BbyiRAJf82cBz1IrWgDkIcI5+17rf5V2oLKHXeaqjg0xYsHKVOH8s
 ++Y8aVPfETxoh9VoIekQHpwUfpYnEThmIdyFnm7yDHRBdByJCXc8vLe+EC8mEY5XM21Bk7zkAcFX
 jW5ZljrbPpIKsYmFYJBfNcpMnHYV5nYzKa1EY8f6kuxgo7FjjNmrcNu3yplkDNH90M8VAYw5SMav
 wmOhlgPPiwQzKw+6v3CaIMG6s7LqJG6CQeNMJ/uu1fLWZ0yH5nf6TTDOvSxJH/uDkqrKru3tmVh0
 6/CU7I11rxSSJycOpQYX91UVTGP0uO1ZBIAeSvxRXxKF5tPxTxfD0dMN+t5Z7mICg/IgFPLHKYSa
 tKBN0t1FZIV+/GXHWbViba4uJV2v9S/fTs8Lg45u5W78s+n/2NBYfQNswA2q9ExqYBxOI940eTXl
 WiUAYdLmsJdAoPIFemVVgKqJgQi9QDrzr6FixvMZd7pIsHd9jbNAm4nOXTiiLDLpPIjqcoJ5Q1Hu
 u+CBdnA1akISDqYmAh3OWMNa8z+L+DhnNO2xLycvoOPrPw==
X-Report-Abuse-To: spam@filter01.totaalholding.nl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,

This is my network card:

01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 0c)
	Subsystem: Realtek Semiconductor Co., Ltd. Device 0123
	Kernel driver in use: r8169

On the Realtek website (https://www.realtek.com/en/products/communications-network-ics/item/rtl8168e) it says that both wake-on-lan and remote wake-on-lan are
supported. I got the wake-on-lan from my local network working, but I have problems getting the remote wake-on-lan to work.

When I set 'Wake-on' to 'g' and suspend my system, everything works fine (the router does lose the ip address assigned to the mac address of the system). I
figured the SecureOn password is meant to forward magic packets to the correct machine when the router does not have an ip address assigned to a mac address,
i.e. port-forwarding does not work.

Ethtool 'Supports Wake-on' gives 'pumbg', and when I try to set 'Wake-on' to 's' I get:

netlink error: cannot enable unsupported WoL mode (offset 36)
netlink error: Invalid argument

Does this mean that remote wake-on-lan is not supported (according to ethtool)?

---

I also tried to set 'Wake-on' to 'b' and 'bg' but then the systems turns back on almost immediately for both settings.

---

Hope you can help getting the remote wake-on-lan to work,

Best regards,
Mischa.




