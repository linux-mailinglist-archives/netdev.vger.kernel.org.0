Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 076261CFB6
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 21:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbfENTPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 15:15:21 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:52319 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfENTPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 15:15:20 -0400
Received: by mail-wm1-f54.google.com with SMTP id y3so220701wmm.2
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 12:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=BKc9S+V6XYZb9/ao8kj5EaEnA6esRAYMQsADePrdfv4=;
        b=XlXTc7QqfpzCjTAgMHTkS7MlynKaq1Gz9VMkIoQGK42r3IwSf7k9Fp5byPZmLT/ThC
         enPUt3CAN3E71zGcdv1JssQ4QJO3gofPFJa0sUnhsj66nOEmgpNNc/QJ8/KWOQFXUeK7
         sNH0i2nGqCLx1PPN+uso2hFGMtoEmnkFa4cWik/WnT7OrK2QF0goAduuPt8iyMfw24Lw
         oU5/1w470C3nPcqpGLZAaFHZaUM3hj4BOzMIBHX/s0RBlguj2Y2h/GSgBqthbjhL8DiQ
         9bOKP8SgqDYWmbJSqhv9PcsrUKv5Z+tGGoTj0Dz3T7HQTKTUKtupY640MLVA+W7fvYcC
         fllg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BKc9S+V6XYZb9/ao8kj5EaEnA6esRAYMQsADePrdfv4=;
        b=Hp++MN3GwdaGw8Nvdz3MtpCQRfP0N6/KHUhSOYM/otbgo8H7AqzqmfXAUMj1Hp56BD
         sFQ88jNYauaPM5cklNvPe458rYThiOW/WYX2tOE95LF8Qq9jjT1RVaJ/f3yL5revYesv
         HhXA96UjCVZ+WabDCT71Pj9Ws4p5ZT7qpMufCLxz4iThB3ekzKhk0vzjmvnhSmdNzs9F
         3Bj4Ol1Xw08eFQ4ns612A29bUNrnjRv7Dye8FzKzeCktLqecIu1w4th3IQ4Kj8QVlKiW
         4zVv6H4uIkoxA9o3tinruTUCeovvKCRMyNLGRdrVmQtJGQI2Wv7o4Vpgxaypl6kaQ70n
         aH/Q==
X-Gm-Message-State: APjAAAU6ywdMObib1S0XUYB5F6AlLbp/FBBUIBvmXMXleDNCHNF2+HGl
        MoRvCj/ORc5JBaGZe4LUiT7BY1e8OpA=
X-Google-Smtp-Source: APXvYqzNB9321c6eepq2a4K8U5uM10e4HE/3MNfZQTmFWAahcprFkJrdAI0sFEvWMpwl5fr77TuEPQ==
X-Received: by 2002:a05:600c:492:: with SMTP id d18mr5974846wme.59.1557861317701;
        Tue, 14 May 2019 12:15:17 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:5009:b160:f951:a9c? (p200300EA8BD457005009B160F9510A9C.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:5009:b160:f951:a9c])
        by smtp.googlemail.com with ESMTPSA id a10sm11722325wrm.94.2019.05.14.12.15.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 12:15:17 -0700 (PDT)
Subject: Re: IP-Aliasing for IPv6?
To:     "M. Buecher" <maddes+kernel@maddes.net>, netdev@vger.kernel.org
References: <5c3590c1568251d0f92b61138b7a7f10@maddes.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <e378673f-11bf-fce8-0273-3cc18d0d28bd@gmail.com>
Date:   Tue, 14 May 2019 21:15:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <5c3590c1568251d0f92b61138b7a7f10@maddes.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14.05.2019 20:49, M. Buecher wrote:
> Preamble: I'm just a network hobbyist at home, so please bear with me if something in this mail is "stupid" from an expert's point of view.
> 
> According to the documentation [1] "IP-Aliasing" is an obsolete way to manage multiple IP[v4]-addresses/masks on an interface.
> For having multiple IP[v4]-addresses on an interface this is absolutely true.
> 
> For me "IP-Aliasing" is still a valid, good and easy way to "group" ip addresses to run multiple instances of the same service with different IPs via virtual interfaces on a single physical NIC.
> 
This sounds like you don't necessarily need additional virtual interfaces
but simply additional IP addresses at the primary interface -> ip address help

> Short story:
> I recently added IPv6 to my LAN setup and recognized that IP-Aliasing is not support by the kernel.
> Could IP-Aliasing support for IPv6 be added to the kernel?
> 
> Long story:
> I tried to find out how to do virtual network interfaces "The Right Way (tm)" nowadays.
> So I came across MACVLAN, IPVLAN and alike on the internet, mostly in conjunction with containers or VMs.
> But MACVLAN/IPVLAN do not provide the same usability as "IP-Aliasing", e.g. user needs to learn a lot about network infrastructre, sysctl settings, forwarding, etc.
> They also do not provide the same functionality, e.g. the virtual interfaces cannot reach their parent interface.
> 
> In my tests with MACVLAN (bridge)/IPVLAN (L2) pinging between parent and virtual devices with `ping -I <device> <target ip>` failed for IPv4 and IPV6.
> Pinging from outside MACVLAN worked fine for IPv4 but not IPv6, while IPVLAN failed also for pinging with IPv4 to the virtual interfaces. Pinging to outside only worked from the parent device.
> Unfortunately I could not find any source on the internet that describes how to setup MACVLAN/IPVLAN and their surroundings correctly for a single machine. It seems they are just used for containers and VMs.
> 
> If it is possible to setup MACVLAN/IPVLAN that they can reach and also can be reached from their parent device, other virtual devices and from outside, then please guide me to the right direction or provide links. Would be much appreciated.
> Otherwise I would like to see IP-Aliasing for IPv6.
> 
> Hope to stimulate further thoughts and thanks for reading
> Matthias "Maddes" Bücher
> 
> [1] https://www.kernel.org/doc/html/latest/networking/alias.html
> 
> 

