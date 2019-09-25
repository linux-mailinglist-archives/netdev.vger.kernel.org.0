Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30A01BE363
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 19:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634174AbfIYRbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 13:31:18 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44837 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfIYRbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 13:31:18 -0400
Received: by mail-pg1-f196.google.com with SMTP id g3so197790pgs.11;
        Wed, 25 Sep 2019 10:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GECBsDviO4R03B/RCsfVCSEdE0MlOr5oah5nwGqAhaM=;
        b=Ye2CbRFRK+bj0HJmEfrKPJba37xlaeXmMh6X69JiYAlCk6mRB9JkaVpgm6hBreSSWR
         Nw6A3i436J/E6K6qGdvOWifR4HazsiCdIuKHaTW6YUgfbcZixV3XPO+5Mpn1oWSX48CK
         JEfzzwPywgniB8H6iHcXhqa2b/c9ymutKOspxYkpHzjdB4OGEV6aHlENcJw4vcrbKvYs
         YO0MraI15x9eVa2YnMLihpTofBfqHSpuXOuN9Zj5lr9TjxvoTMpvMHRJg+1hLTONiH+K
         dsA+aQxrTv2RaxUtd5P1HtHEdnce1eT+0YvXEzaCH2OgfIQnuPR2qW9DlYJtMzQdGMiV
         Gbxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=GECBsDviO4R03B/RCsfVCSEdE0MlOr5oah5nwGqAhaM=;
        b=THCMtgEjNouYlG//WP5JdvtB20LhvvJbHEYraVO5WRT3f+PQ25P7VEyvZnRHlbZKtx
         G4H1NalNwvWeG/P2RXsZNKZ2sussMVqQvb4PgU5WO8Pn+U6LnBA8w6TcAm5qAPU2dK0z
         Pp5qHW4ntcw4/W2tcxbUiLKxHJqngIzM4wb+5Zcv27OqqDE+4FMqrUJbPUtjQuQTdkrf
         J3FTayTSrhFlFc61oVTPaq1IG9xjjFvBTmRkc8uJgsXKawtXbtam7x2Tj5R27oLr6OWZ
         dnCLr2/FQOzT3HbI9qqHDmHYUaqcivqMOJUTPWyB/emNIJnff+FlichVrp8JYFMGdX0L
         E12Q==
X-Gm-Message-State: APjAAAWd7Gihjy+5kBxyBto5hWtF9iOk4GqwwNhpdhBAS825Z9Uz1jq+
        pEu9yOjVQ22bJwlSq/qmj3CIolp+
X-Google-Smtp-Source: APXvYqzgUDjDcxF5G7aeh4nwNizcRypmCkv4HZkuJvYFRLdhjtjMagJzTD7c5awvom7BV6ilcZrPkw==
X-Received: by 2002:a63:504b:: with SMTP id q11mr483359pgl.188.1569432676432;
        Wed, 25 Sep 2019 10:31:16 -0700 (PDT)
Received: from [10.67.50.53] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r30sm5012627pfl.42.2019.09.25.10.31.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Sep 2019 10:31:15 -0700 (PDT)
Subject: Re: [PATCH v3 0/2] net: stmmac: Enhanced addressing mode for DWMAC
 4.10
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        David Miller <davem@davemloft.net>
Cc:     "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "bbiswas@nvidia.com" <bbiswas@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20190920170036.22610-1-thierry.reding@gmail.com>
 <20190924.214508.1949579574079200671.davem@davemloft.net>
 <BN8PR12MB3266F851B071629898BB775AD3870@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190925.133353.1445361137776125638.davem@davemloft.net>
 <BN8PR12MB3266A2F1F5F3F18F3A80BFC1D3870@BN8PR12MB3266.namprd12.prod.outlook.com>
 <BN8PR12MB32667F9FDDB2161E9B63C1AFD3870@BN8PR12MB3266.namprd12.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <9f0e2386-c4b1-52b0-6881-e72093eb1b05@gmail.com>
Date:   Wed, 25 Sep 2019 10:31:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <BN8PR12MB32667F9FDDB2161E9B63C1AFD3870@BN8PR12MB3266.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/25/19 4:46 AM, Jose Abreu wrote:
> From: Jose Abreu <joabreu@synopsys.com>
> Date: Sep/25/2019, 12:41:04 (UTC+00:00)
> 
>> From: David Miller <davem@davemloft.net>
>> Date: Sep/25/2019, 12:33:53 (UTC+00:00)
>>
>>> From: Jose Abreu <Jose.Abreu@synopsys.com>
>>> Date: Wed, 25 Sep 2019 10:44:53 +0000
>>>
>>>> From: David Miller <davem@davemloft.net>
>>>> Date: Sep/24/2019, 20:45:08 (UTC+00:00)
>>>>
>>>>> From: Thierry Reding <thierry.reding@gmail.com>
>>>>> Date: Fri, 20 Sep 2019 19:00:34 +0200
>>>>>
>>>>> Also, you're now writing to the high 32-bits unconditionally, even when
>>>>> it will always be zero because of 32-bit addressing.  That looks like
>>>>> a step backwards to me.
>>>>
>>>> Don't agree. As per previous discussions and as per my IP knowledge, if 
>>>> EAME is not enabled / not supported the register can still be written. 
>>>> This is not fast path and will not impact any remaining operation. Can 
>>>> you please explain what exactly is the concern about this ?
>>>>
>>>> Anyway, this is an important feature for performance so I hope Thierry 
>>>> re-submits this once -next opens and addressing the review comments.
>>>
>>> Perhaps I misunderstand the context, isn't this code writing the
>>> descriptors for every packet?
>>
>> No, its just setting up the base address for the descriptors which is 
>> done in open(). The one that's in the fast path is the tail address, 
>> which is always the lower 32 bits.
> 
> Oops, sorry. Indeed it's done in refill operation in function 
> dwmac4_set_addr() for rx/tx which is fast path so you do have a point 
> that I was not seeing. Thanks for bringing this up!
> 
> Now, the point would be:
> 	a) Is it faster to have an condition check in dwmac4_set_addr(), or
> 	b) Always write to descs the upper 32 bits. Which always exists in the 
> IP and is a standard write to memory.

The way I would approach it (as done in bcmgenet.c) is that if the
platform both has CONFIG_PHYS_ADDR_T_64BIT=y and supports > 32-bits
addresses, then you write the upper 32-bits otherwise, you do not. Given
you indicate that the registers are safe to write regardless, then maybe
just the check on CONFIG_PHYS_ADDR_T_64BIT is enough for your case. The
rationale in my case is that register writes to on-chip descriptors are
fairly expensive (~200ns per operation) and get in the hot-path.

The CONFIG_PHYS_ADDR_T_64BIT check addresses both native 64-bit
platforms (e.g.: ARM64) and those that do support LPAE (ARM LPAE for
instance).
-- 
Florian
