Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C04EA4F0B
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 08:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbfIBGHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 02:07:10 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42312 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729299AbfIBGHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 02:07:10 -0400
Received: by mail-wr1-f66.google.com with SMTP id b16so12616239wrq.9
        for <netdev@vger.kernel.org>; Sun, 01 Sep 2019 23:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aZ5yhpG1AvzEHVUh5pbSBFa79E4SS9Gu4iGsyjR3fgI=;
        b=a57bu/OD7MJ/EH5j5mj340qbCTL8hbY2B+VCxViKZtsKLvhZjs/FUC4FMzcOlQOGdj
         1EARXfDqHU/m+i7OrjvWuupPnwGa2Hcy48vmsrWTmLYzMoEVASOhhBo1UA/GBBJiXZPv
         2sxu9LjzTpZr05ny5i00G78hOkNJdPbaWQV7V67PqNRf9WXs3IhkpLb6HwXOAy5fqdRU
         Kqj+0CUtMp/hKYDBypRIiylYFZ4FGK0S674piUvLuo6pmKp86RGPEs12FVpdHqH6efxD
         L//Qi2ga6SFi/JG17GPn74IN1EMtyyLcE4IGPFiC4BAupd5/uu3kCNtyHvY2ge8MzECX
         rGiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aZ5yhpG1AvzEHVUh5pbSBFa79E4SS9Gu4iGsyjR3fgI=;
        b=qrshXu2BuYtj/f6jaTkfJzHFdAAnao1CU8fok3kz7Mgl/8Vud/oPwzh0/K+5iTw4gJ
         rnH7OgvioDzilbTO26CQO0fgxF6FVzqh6tEeSWl7xo9xyamFM6FjS8kHMBkIwUBTIiT5
         uvTYM4fpfptycfpOoMoVWIn2EBbFqUWzQ6E++GF+7C4sMsaTnC99jheI1+MjhbUyyu+V
         05gl3eRDEVpyg1cwjgFkFgs9PSOIMH/dQj8u/Az4Il2eVHbraK70M6aM9cnv93GJ6S7l
         GHDinyz73E6lZR2DDXNqieYVO2EuPGQ8PqexPeVpkSpajoNZpgX3sx9bfjzFNMuhUVEd
         cceA==
X-Gm-Message-State: APjAAAWT8A/ZNsqdipfss//bdvfiJ15neNQlNooIhwiAHBkV/GcaJaIM
        SSIRll28oStPOnrNMLjWSWmeOQBu
X-Google-Smtp-Source: APXvYqxTf9fbmI0dQ4x7Rbe7jRXXK9iglQXaWIzKQyfwZYxCXZU20gOhUjSd5gz+3+ipXKM3yOThSA==
X-Received: by 2002:adf:bd84:: with SMTP id l4mr34009204wrh.143.1567404427958;
        Sun, 01 Sep 2019 23:07:07 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:5d9c:1ca4:a630:705f? (p200300EA8F047C005D9C1CA4A630705F.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:5d9c:1ca4:a630:705f])
        by smtp.googlemail.com with ESMTPSA id w125sm29866191wmg.32.2019.09.01.23.07.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 01 Sep 2019 23:07:07 -0700 (PDT)
Subject: Re: [PATCH net-next 3/3] net: phy: realtek: add support for the
 2.5Gbps PHY in RTL8125
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ddbf28b9-f32e-7399-10a6-27b79ca0aaf9@gmail.com>
 <64769c3d-42b6-8eb8-26e4-722869408986@gmail.com>
 <20190808193743.GL27917@lunn.ch>
 <f34d1117-510f-861f-59f0-51e0e87ead1e@gmail.com>
 <20190808202029.GN27917@lunn.ch>
 <94cc3fe3-98ed-d8d2-2444-84bf3eae0c5e@gmail.com>
 <fafc1c05-d7ac-f108-74f9-207617773968@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <a37799d5-e2e0-7987-9f9d-0186060963a7@gmail.com>
Date:   Mon, 2 Sep 2019 08:07:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <fafc1c05-d7ac-f108-74f9-207617773968@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.09.2019 04:07, Florian Fainelli wrote:
> 
> 
> On 8/8/2019 1:24 PM, Heiner Kallweit wrote:
>> On 08.08.2019 22:20, Andrew Lunn wrote:
>>>> I have a contact in Realtek who provided the information about
>>>> the vendor-specific registers used in the patch. I also asked for
>>>> a method to auto-detect 2.5Gbps support but have no feedback so far.
>>>> What may contribute to the problem is that also the integrated 1Gbps
>>>> PHY's (all with the same PHY ID) differ significantly from each other,
>>>> depending on the network chip version.
>>>
>>> Hi Heiner
>>>
>>> Some of the PHYs embedded in Marvell switches have an OUI, but no
>>> product ID. We work around this brokenness by trapping the reads to
>>> the ID registers in the MDIO bus controller driver and inserting the
>>> switch product ID. The Marvell PHY driver then recognises these IDs
>>> and does the right thing.
>>>
>>> Maybe you can do something similar here?
>>>
>> Yes, this would be an idea. Let me check.
> 
> Since this is an integrated PHY you could have the MAC driver pass a
> specific phydev->dev_flag bit that indicates that this is RTL8215, since
> I am assuming that PCI IDs for those different chipsets do have to be
> allocated, right?
> 
Hi Florian,

thanks for the feedback. In the meantime Realtek provided a method to
identify NBaseT-capable PHY's, and the respective match_phy_device
callback implementations had been done in
5181b473d64e ("net: phy: realtek: add NBase-T PHY auto-detection").

Heiner
