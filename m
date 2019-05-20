Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB38823E53
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 19:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392838AbfETRVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 13:21:39 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35800 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390814AbfETRVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 13:21:38 -0400
Received: by mail-wm1-f65.google.com with SMTP id q15so160243wmj.0;
        Mon, 20 May 2019 10:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4rN+/4exMJ3brABEj9hxnUozbRBkE4CNr387SFiijCY=;
        b=KAw5Hk2kfVfeMnER+eBKpBsGwqJIdvkyxSw8z4P11pzPy3ebfkrQIMiChxAM8Pvepf
         qEcBybl32bjB8Im1J7bbckhMReDVC+YbydVBg6xw44kQDcT+rxM9VJnRrRllUyTW9tfg
         tUhEvGOQNFqJ4piH+CXfqZXTXXnG+zmZdV7/vu3UjPKMDfkr3iuZjC14BSa6ddokEzr7
         alYpNU2556+MtFCCozDhN1g9Ju+LR0gbHECNLQdxRdjcc/abemL1PDQIWpn/x2e6R2Gp
         hw0XQn3z+2IAyOsxTV6RwODbEIDnLDqYjdUJ0xjCH8p7h+npUQYfOCAnvE0A9bPOlzOF
         z0Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=4rN+/4exMJ3brABEj9hxnUozbRBkE4CNr387SFiijCY=;
        b=i4cMhGCPnCsMOM83oHJ088q29mkxx79uGN+tkzBdpx+ogDcXMDDiL1cKBrQAkVpOn3
         s8LNlDiCoyOx2nhGezaO6BmX/rBTB4QZ5a+iNLjD6Iv0ugpFKtmR5aoNYXeDUOjNHRcV
         zYOyAfDT1m8a6u5cF1FiAVAnv+wtu/ti106UdWXbCWgUfxlExXPrlxY3Mskv8FLgWdqD
         8NNBYhccmf6y4Z30q0LBX9300D76aGSjhTePb9orEdyeeDLjs0k/NuKAlJdDIAecpPhp
         hEOGp87vR4z1WuTERva1sms+7CXIoSoJ7qqReuBXiPw9lzTtRZamtIsiX1LkduCzZqD5
         S3Vw==
X-Gm-Message-State: APjAAAU2DHVkZFyTfnna3rr8ab58aO+n+DVQMDrderLg3rnUnlvMfl3U
        JiQ/XEOs71yPOVecm52ITnUBa8mn
X-Google-Smtp-Source: APXvYqw8bgKdmbF9vX2CxOQaSRAjywnoCvlz27zDNfMVekCV1JVUVZntWf5JrB8zeCrBAilKsmTuHQ==
X-Received: by 2002:a1c:7e10:: with SMTP id z16mr177980wmc.98.1558372895405;
        Mon, 20 May 2019 10:21:35 -0700 (PDT)
Received: from [10.67.49.52] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k184sm296439wmk.0.2019.05.20.10.21.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 10:21:34 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH V5] net: phy: tja11xx: Add TJA11xx PHY driver
To:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
References: <20190517235123.32261-1-marex@denx.de>
 <20190518141456.GK14298@lunn.ch>
 <b69b9b70-a299-2754-de9f-c7562b31fa16@denx.de>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <be9bb84c-6c0c-3106-ccbb-99b15ad5b30e@gmail.com>
Date:   Mon, 20 May 2019 10:21:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <b69b9b70-a299-2754-de9f-c7562b31fa16@denx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On May 18, 2019 9:50:48 AM PDT, Marek Vasut <marex@denx.de> wrote:
>On 5/18/19 4:14 PM, Andrew Lunn wrote:
>> On Sat, May 18, 2019 at 01:51:23AM +0200, Marek Vasut wrote:
>>> Add driver for the NXP TJA1100 and TJA1101 PHYs. These PHYs are
>special
>>> BroadRReach 100BaseT1 PHYs used in automotive.
>> 
>> Hi Marek
>
>Hello Andrew,
>
>>> +	}, {
>>> +		PHY_ID_MATCH_MODEL(PHY_ID_TJA1101),
>>> +		.name		= "NXP TJA1101",
>>> +		.features       = PHY_BASIC_T1_FEATURES,
>> 
>> One thing i would like to do before this patch goes in is define
>> ETHTOOL_LINK_MODE_100baseT1_Full_BIT in ethtool.h, and use it here.
>> We could not do it earlier because were ran out of bits. But with
>> PHYLIB now using bitmaps, rather than u32, we can.
>> 
>> Once net-next reopens i will submit a patch adding it.
>
>I can understand blocking patches from being applied if they have
>review
>problems or need to be updated on some existing or even posted feature.
>But blocking a patch because some future yet-to-be-developed patch is a
>bit odd.
>

The net-next tree is currently closed which means there is ample time
for you and Andrew to work offline and have you submit both Andrew's
cleanup patches as well as this very one as a patch series when net-next
opens back up giving both of you your own cookies. Once submitted it
won't take weeks to get merged more like hours given David's typical
review and patch acceptance time.
--
Florian
