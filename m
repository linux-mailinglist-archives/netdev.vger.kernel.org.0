Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D58BA16887E
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 22:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgBUVB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 16:01:28 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54182 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbgBUVB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 16:01:27 -0500
Received: by mail-wm1-f65.google.com with SMTP id s10so3160877wmh.3
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 13:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KS7zlHKpGTKzoxtsGkUNB+4+DXIvXSlSQHumfEw5VSY=;
        b=hL4ORJtDIKXyd5puwRvgOG76uw0Hm8uKlh2zAgonrmmrpJvdnIUWXRREx7DFXbJIPn
         +XzJFOR7AqAj5oOQm8PWWtKQt4EhL4Po9QYk8lFuMFYW074vSkAUX//GUt4bbbcNZK4I
         3AmUqfmmnN4Ah1/S/5N0y2D3usKBfPz3R1kTUJJaU3QsCXhojzoFW6fc+765t4spdlez
         q0jVjF9dsRPrqq21gFHmFLvfUubwZgm7d2zo3MN0B/BCQ1rlneD1MGR0gm4dICtLEjfx
         EsBVeg4kiI8OTGnG0Na96NYIYLquRL7d/6BNWhLMqVbi+PfqfVX0HUaUXbfc+IV+Ek5t
         I2XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KS7zlHKpGTKzoxtsGkUNB+4+DXIvXSlSQHumfEw5VSY=;
        b=TZ6H5c+E+ill5Co4lww1dR+0w0ilRoyccoG5ymA7+NK35tLiN4m037zWzHYFt+y/Jp
         WdpyRfUV/Igt0Xfsf5VB9GYTmvhqlCzFVXydFTeKmabzfmbJihfVS47PlfEj/3eRh5MJ
         n4CBItMxWj+q8toxUv0763F2jn4yXVWiGvEjRhd4HRYhpJmcAojRr0LsGbmzjs4ahLxe
         P4HEi82/tu7b0V8p1bsYvDAePezh3T7gFZe3RdhDwVK2KxizLKviSYzEufQ3EjRXyfDd
         4zLMKtk3+1O6D2uyKm0NXkhu+IQRxnWdnK2pfWVNcHif9vf/f1c4ZMtOyu51U98Udh1u
         izJg==
X-Gm-Message-State: APjAAAWUbQ0Csn3azq4T8VCQdxWL7/O2ob59x77Qz/3dybf7iG2yYTN5
        gMIJDDUeZ9g/MPGUu0Mb11ykQxWH
X-Google-Smtp-Source: APXvYqxHzllh6m/4nattXUMqyb1pnMFsmVVKYhazjPjzY1h7GVmwB0c0jPluO6dPdJLK+FDZ+zQDMw==
X-Received: by 2002:a1c:9a0d:: with SMTP id c13mr5489780wme.41.1582318884201;
        Fri, 21 Feb 2020 13:01:24 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:b575:3371:21d5:d8aa? (p200300EA8F296000B575337121D5D8AA.dip0.t-ipconnect.de. [2003:ea:8f29:6000:b575:3371:21d5:d8aa])
        by smtp.googlemail.com with ESMTPSA id x21sm5000949wmi.30.2020.02.21.13.01.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 13:01:23 -0800 (PST)
Subject: Re: About r8169 regression 5.4
To:     Vincas Dargis <vindrg@gmail.com>,
        Salvatore Bonaccorso <carnil@debian.org>
Cc:     netdev@vger.kernel.org
References: <b46d29d8-faf6-351e-0d9f-a4d4c043a54c@gmail.com>
 <9e865e39-0406-d5e0-5022-9978ef4ec6ac@gmail.com>
 <97b0eb30-7ae2-80e2-6961-f52a8bb26b81@gmail.com>
 <20200215161247.GA179065@eldamar.local>
 <269f588f-78f2-4acf-06d3-eeefaa5d8e0f@gmail.com>
 <3ad8a76d-5da1-eb62-689e-44ea0534907f@gmail.com>
 <74c2d5db-3396-96c4-cbb3-744046c55c46@gmail.com>
 <81548409-2fd3-9645-eeaf-ab8f7789b676@gmail.com>
 <e0c43868-8201-fe46-9e8b-5e38c2611340@gmail.com>
 <badbb4f9-9fd2-3f7b-b7eb-92bd960769d9@gmail.com>
 <d2b5d904-61e1-6c14-f137-d4d5a803dcf6@gmail.com>
 <356588e8-b46a-e0bb-e05b-89af81824dfa@gmail.com>
 <86a87b0e-0a5b-46c7-50f5-5395a0de4a52@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <11c9c70f-5192-9f02-c622-f6e03db7dfb2@gmail.com>
Date:   Fri, 21 Feb 2020 22:01:16 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <86a87b0e-0a5b-46c7-50f5-5395a0de4a52@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21.02.2020 21:21, Vincas Dargis wrote:
> 2020-02-20 20:32, Heiner Kallweit rašė:
>> It would be great if you could test one more thing. Few chip versions have a hw issue with tx checksumming
>> for very small packets. Maybe your chip version suffers from the same issue.
>> Could you please test the following patch (with all features enabled, TSO and checksumming)?
>>
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>> index 8442b8767..bee90af57 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>> @@ -4345,6 +4345,7 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
>>               case RTL_GIGA_MAC_VER_12:
>>               case RTL_GIGA_MAC_VER_17:
>>               case RTL_GIGA_MAC_VER_34:
>> +            case RTL_GIGA_MAC_VER_44:
>>                   features &= ~NETIF_F_CSUM_MASK;
>>                   break;
>>               default:
>>
> 
> Sadly, network got hanged after ~1.5h of usage. I've built it with Debian's "debian/bin/test-patches" helper (kernel is now named 5.4.19-1a~test),
> double-checked that line was actually added in source. `ethtool -K enp5s0f1 tx on sg on tso on` was executed after boot.

OK, thanks anyway for testing. I forwarded your testing results with Realtek's r8168 driver to Realtek,
let's see whether they can identify the root cause of the problem.
