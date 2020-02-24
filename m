Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D090C16B08F
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 20:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgBXTtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 14:49:52 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45636 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgBXTtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 14:49:52 -0500
Received: by mail-wr1-f66.google.com with SMTP id g3so11819807wrs.12
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 11:49:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YM1x2qSQNQYgxfXPNhWZJJOkzQlPpo0R0ZTQp4pM9n0=;
        b=W++yOLiq6PvMM1lNJAUqi8byy/Gor1wqjvmVcb8gUFA63d24wpIMn+N2dvX65IS0ok
         iCyUnX+bMC9O+DfJn0wnuMN+nn7GA4nWhP+yCjcMFxsUSuN4C41tTbDgRbpNtEChUvc4
         6RjVhA6kBa0/N4BDoxNeeUGBJe/fnsfrfkrqBBwfjZNCAcfHkEoKQsu+xHyus3e7Llly
         ZhGAHIN/K6w/QpPK1CkmhH+LDRynF+ltZnRLf0Vn6aoedLCzvzFfjoduQszwv5dLs+hp
         36qW+B5Bono6Oj9Ff5LKqfIy9cQOjipoG62Kjp9ltezBEzNHNn+QrA60n6tagDgIV498
         JyNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YM1x2qSQNQYgxfXPNhWZJJOkzQlPpo0R0ZTQp4pM9n0=;
        b=KHD0tMjjahirA8Ww3OjSu/Gy/v2JOjeOa3cl6WsuDkx/RKEtcIyy3aXnVulod6jFZ7
         0sq1/fEYyiRdK/PA07yHwdOz+DiELX3u+9GS5DxKJN2VX5zGHtUK/3x/N4lGmoFqjNrm
         vIPIiyHE528YYBcbcC6b7cYZ4WP4HNf7GVm7jNDvYdzP+F41ePtjgrllWfu/hw13QRv2
         +vaencPWJzqdhaQMDDfhXt7R7kOUw3O3q9+T7ytfV2s6FQYrUwn7Mb5zCUGex11nGhQb
         YYbfQ79QpFU3LX6TUFgYIhEk+jfjLC6ckON4GuZrXT7sHCFyD3SfZhMMDJ6iJ/7MBisc
         bLnw==
X-Gm-Message-State: APjAAAUKMKQwoGL55vgBn6Q+YTrrsnduBi9cASTDdTfyVQXYy6PyWxiy
        e0JrU6TvqQxX9XUiYs50PQ4OFFM7
X-Google-Smtp-Source: APXvYqzJZn3Is1FLolMjgfqfKP0AEQ0ZzRKoZwXo9kInaZGiKs3uZIm1BodSVnxBp/eLPvg8kHbPoQ==
X-Received: by 2002:adf:f084:: with SMTP id n4mr67924215wro.200.1582573790056;
        Mon, 24 Feb 2020 11:49:50 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:3d90:eff:31bc:c6a9? (p200300EA8F2960003D900EFF31BCC6A9.dip0.t-ipconnect.de. [2003:ea:8f29:6000:3d90:eff:31bc:c6a9])
        by smtp.googlemail.com with ESMTPSA id p15sm552613wma.40.2020.02.24.11.49.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 11:49:49 -0800 (PST)
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
Message-ID: <90776f02-5c98-235b-663f-962ad68e1c93@gmail.com>
Date:   Mon, 24 Feb 2020 20:49:42 +0100
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

Realtek responded that they can't reproduce the issue. They suggested to not enable tx offloading
per default as a workaround. So for now you have to disable tx offloading via ethtool.
