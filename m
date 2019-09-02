Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E17FAA4D3D
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 04:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729238AbfIBCHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 22:07:09 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44739 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727517AbfIBCHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 22:07:08 -0400
Received: by mail-pf1-f193.google.com with SMTP id q21so3029100pfn.11
        for <netdev@vger.kernel.org>; Sun, 01 Sep 2019 19:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wfQdJhtHjp8N3UU6YoldslXA6QTYlbDUVF5WpTqqN3g=;
        b=ECEGQYsA/l5WIEizo5Qop0EPwHZuMB8N3nSXNNB72bde0QQZ6dSXivI8yyWkybMfpM
         Qppc5d2ShBHGHjKGjEdJgbLe7fKdJbkEVztoc/4YJu37mEKBO78oIvQBInLqWvUZBVYl
         E5A5QnHVLTC4pf/5R523HE7dI0OpdECx49yfIowccNe6Tztzp8ABEmOTWx2lQ5niBOKJ
         KSZFpEutkQuX74O89j6qw1Y8vK85ZpMjedKiCV2mq2/hMGcQ9tWnegfYHPgZZSCA4aGR
         Zg1uqGl2JI3I+PrrzZtL1P5MGY+BOW3ClKswZJDGj9GIUSWrwWua+6a6QcOSngEIjdot
         sF4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wfQdJhtHjp8N3UU6YoldslXA6QTYlbDUVF5WpTqqN3g=;
        b=evru5m7/sF6HDXs+ZN6AZJLZTEezOpgnNMFLwA0GOjWv12dkM3UFEK2S1zENoZat1g
         68FqVxAuTPnjjB+s80XZsiDA2zXSaWkPQFXVUIA2zyXMMG/3LcuwSjuYt5b4y3JeZ1rL
         /reCeqLeQCLGQTAhpPXeEr+RPOEeZJMPHbgRTVha++Bw5GdXKmdasr1zmp5ODVD3twrq
         QDAUytRH2a2F4mqSQVaNxiswfs56DSpSyo2ezsyjm/PwVREsWfG1qMIxmyPrKh/jgJwX
         xT5OOUhrG0DrRTATI0aMvwpM6P+rcjOt09iuXcHu61mgwAVyfoU9R8WPonR6AXTsIupq
         C8WA==
X-Gm-Message-State: APjAAAW1Mj1C7D2EMjzitoUBaPqi/0KMoNfJdAqJJUXAfBFPcpXFvGY9
        YdwUpTfysSz4Pb7l8F2QuehxEeuktVA=
X-Google-Smtp-Source: APXvYqwMy0h26nkyhE1Gm15mX3wfv2jckTNYVg/WN3XkjWNVaOI550Y+fJvSGWiYTqGqx6hJEfnoRA==
X-Received: by 2002:a62:5343:: with SMTP id h64mr17236747pfb.4.1567390027926;
        Sun, 01 Sep 2019 19:07:07 -0700 (PDT)
Received: from [10.230.28.130] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n185sm11366667pga.16.2019.09.01.19.07.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 01 Sep 2019 19:07:06 -0700 (PDT)
Subject: Re: [PATCH net-next 3/3] net: phy: realtek: add support for the
 2.5Gbps PHY in RTL8125
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ddbf28b9-f32e-7399-10a6-27b79ca0aaf9@gmail.com>
 <64769c3d-42b6-8eb8-26e4-722869408986@gmail.com>
 <20190808193743.GL27917@lunn.ch>
 <f34d1117-510f-861f-59f0-51e0e87ead1e@gmail.com>
 <20190808202029.GN27917@lunn.ch>
 <94cc3fe3-98ed-d8d2-2444-84bf3eae0c5e@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <fafc1c05-d7ac-f108-74f9-207617773968@gmail.com>
Date:   Sun, 1 Sep 2019 19:07:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <94cc3fe3-98ed-d8d2-2444-84bf3eae0c5e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/8/2019 1:24 PM, Heiner Kallweit wrote:
> On 08.08.2019 22:20, Andrew Lunn wrote:
>>> I have a contact in Realtek who provided the information about
>>> the vendor-specific registers used in the patch. I also asked for
>>> a method to auto-detect 2.5Gbps support but have no feedback so far.
>>> What may contribute to the problem is that also the integrated 1Gbps
>>> PHY's (all with the same PHY ID) differ significantly from each other,
>>> depending on the network chip version.
>>
>> Hi Heiner
>>
>> Some of the PHYs embedded in Marvell switches have an OUI, but no
>> product ID. We work around this brokenness by trapping the reads to
>> the ID registers in the MDIO bus controller driver and inserting the
>> switch product ID. The Marvell PHY driver then recognises these IDs
>> and does the right thing.
>>
>> Maybe you can do something similar here?
>>
> Yes, this would be an idea. Let me check.

Since this is an integrated PHY you could have the MAC driver pass a
specific phydev->dev_flag bit that indicates that this is RTL8215, since
I am assuming that PCI IDs for those different chipsets do have to be
allocated, right?
-- 
Florian
