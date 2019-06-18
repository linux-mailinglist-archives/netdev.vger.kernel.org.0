Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7599C49771
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 04:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbfFRCV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 22:21:28 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45071 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfFRCV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 22:21:28 -0400
Received: by mail-pf1-f196.google.com with SMTP id r1so6685639pfq.12;
        Mon, 17 Jun 2019 19:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NsjjamiHywVJwuDhs9qzFwONr1IfbljCo22+ABIa6RU=;
        b=Lb7ZYZ8eAoLQjcgzpTdcuHyv08gyQmXEiJs+GSflPaSlkduYpX1FOr9IF5xUFjAPLB
         D9aRmIOGcJ3FAvubJxHTGk/UWphbLY2ZCSTCdGVu9llIOsg0izHUuXMV/oYGecUvYyqA
         fubTyz7H7qI4LEDHpCw6mzRUSXPEzh6T2TdOOks//po6DMSLVMdsPl1yF0djFW2bDgT6
         qxsp9Xo3WBgZ7eMWxANiAJZJFeWFnXjgVA1KEovkCpbAbzc137v5xLdu0Bvnbxjo7qjs
         GVgpFbTL7GbBqvsyGRCw1nDmJvPsZHHs+zzMFwmd34PLpSBSJ0yIlE8+Y5uX7GSdAtCT
         A7Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NsjjamiHywVJwuDhs9qzFwONr1IfbljCo22+ABIa6RU=;
        b=VHyM68JEI1CvFlH8RPLxSQE3RpGdaiaYUoqldpUoeucFOOUlzgxzqP7KK4TdQDN/mm
         2cu/BUdBltD4gbgZjAgP8Tumdics05R2JyeExEjIFRujp7WXS0+HsgW2KCmkOmAlo9x+
         XB56woAjGNSFvbcqk4WifWNM2wk2LsqfPXrkxOhfPxVeSjYNkZhlW+zcUHW4mrELTRAg
         bl+Rn0T+JBcPpxUOncj5Q+/RYTag76LBVwWZ7krIJI4EpP9SllKRx6udx6vDAUjEsCsI
         +dcdU+Z0yO+z4fatOwmjfkhuC8bcPxEQOFOY+q8vbt7pMBWwdDp9vOphxDogeo3nYw09
         f1Gg==
X-Gm-Message-State: APjAAAWXjc+t6L2xcPXdS2DTvegjL2mD85pdJoXCbT6uMGi7Gi+HJ38t
        6zWQN0GbYkuBthG7wp6jSOhV7zCY
X-Google-Smtp-Source: APXvYqzS2TPeZ0VyOHWynWIii1uHUY9Z5G8S3f8YM40HbYBfNx/Pyt9a6VqMWFukTK3R1G4G/+exyQ==
X-Received: by 2002:a63:6a47:: with SMTP id f68mr374781pgc.230.1560824486685;
        Mon, 17 Jun 2019 19:21:26 -0700 (PDT)
Received: from [10.230.1.150] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id r7sm19780617pfl.134.2019.06.17.19.21.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 19:21:25 -0700 (PDT)
Subject: Re: [PATCH net-next 0/2] net: mediatek: Add MT7621 TRGMII mode
 support
To:     Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, john@phrozen.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org
References: <20190616182010.18778-1-opensource@vdorst.com>
 <20190617140223.GC25211@lunn.ch>
 <20190617213312.Horde.fcb9-g80Zzfd-IMC8EQy50h@www.vdorst.com>
 <20190617214428.GO17551@lunn.ch>
 <20190617232004.Horde.mAVymZdeb9Jjf29W2PeOggU@www.vdorst.com>
 <20190618015309.GA18088@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <7f2fc770-1787-72f8-b91d-e2b12e74d39e@gmail.com>
Date:   Mon, 17 Jun 2019 19:21:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190618015309.GA18088@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/17/2019 6:53 PM, Andrew Lunn wrote:
>> By adding some extra speed states in the code it seems to work.
>>
>> +               if (state->speed == 1200)
>> +                       mcr |= PMCR_FORCE_SPEED_1000;
> 
> Hi René
> 
> Is TRGMII always 1.2G? Or can you set it to 1000 or 1200? This
> PMCR_FORCE_SPEED_1000 feels wrong.

It is not uncommon to have to "force" 1G to get a higher speed, there is
something similar with B53 switches configuring the CPU ports at 2GB/sec
(proprietary too and not standardized either).

> 
>>> We could consider adding 1200BaseT/Full?
>>
>> I don't have any opinion about this.
>> It is great that it shows nicely in ethtool but I think supporting more
>> speeds in phy_speed_to_str() is enough.
>>
>> Also you may want to add other SOCs trgmii ranges too:
>> - 1200BaseT/Full for mt7621 only
>> - 2000BaseT/Full for mt7623 and mt7683
>> - 2600BaseT/Full for mt7623 only
> 
> Are these standardised in any way? Or MTK proprietary?  Also, is the T
> in BaseT correct? These speeds work over copper cables? Or should we
> be talking about 1200BaseKX?

Looks like this is MTK proprietary:

http://lists.infradead.org/pipermail/linux-mediatek/2016-September/007083.html
https://patchwork.kernel.org/patch/9341129/
-- 
Florian
