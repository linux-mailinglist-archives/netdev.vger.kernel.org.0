Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6585A16883E
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 21:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbgBUUVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 15:21:23 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41346 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgBUUVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 15:21:23 -0500
Received: by mail-lj1-f196.google.com with SMTP id h23so3499978ljc.8
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 12:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dgRJegdeajWNNIPiQVz1AfvsuCRNKo1leBIkmbYTiS4=;
        b=DbgrIERlCr62p0+Atl1NKEwJhfCttIOxWETOrWP4vAzxqyP4DIx0JrS4LjCD802DVi
         MOZbqRuoCdJOaKySz7ukARKgCDNtLjENmzFU8qA+BzIiF0WI9t4VIsHNOp932B51Aa2n
         s0NDYamsphXemuKtzTwTQl6psRIExmOgZQupOt+voRpKDllYMrphhe7zyZIiXpjIDU29
         FZ/rCWq6hReBxc4MdxHV3vgvBzPbTXXC53acMe/tjzdZweQ8+UkKUfvBHBSfiaNpadej
         /V/VbyvfDAu+8ZkXSM2CFqHlvZUbEbTQoSN/FS7hbS9jsB/HbySkzQwS4PYbSaVyl4Rz
         DtjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dgRJegdeajWNNIPiQVz1AfvsuCRNKo1leBIkmbYTiS4=;
        b=GudPIsmGxmIlaCEiviJAxUDttBpVir1k4imTYFKdFpCxEY04gK9U9KCJIt0XkCT4Jw
         nWs7VuDaaHBrxoq7Ob7OxeQqtPPxWMr9YgEpZSfEJ1Tt97c/3S0B7A7h/HenDDNuRNIW
         csd2rPqkIEyhKDXSxLKAyQMnuT6mOcfyxkPiW7/WeLjkR1Lll1x91zH291ZOzusMcBpa
         /C9hXBbUSZUU66uk8HzMtQaiXdG61DED8UGCgNuAQJyWGOcgslfYUUyVgoDDxyPbg0rm
         8UpnvftjkJ51KV8zJkaij4ihjwAprzEuF1dv2rAO4u1vUOWy+QTlWOkKrgsRSYjUYa90
         YjNg==
X-Gm-Message-State: APjAAAV+cL2538wvtGq5le0BJfmz/438+IbboaaXldd/iqHR4WgdLHm9
        vUgvNfDm8/Zoc+7HVhZnE0vF87p7
X-Google-Smtp-Source: APXvYqxgUVVOa6lmC8l5jRzYKKNtakDV2bGAlAgMZZK++7synaO3oJIOeAFyb4QV9b2u6AJ9D1O1BQ==
X-Received: by 2002:a2e:9b95:: with SMTP id z21mr23044301lji.291.1582316481081;
        Fri, 21 Feb 2020 12:21:21 -0800 (PST)
Received: from [192.168.1.10] (hst-227-49.splius.lt. [62.80.227.49])
        by smtp.gmail.com with ESMTPSA id q26sm2135819lfp.85.2020.02.21.12.21.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 12:21:20 -0800 (PST)
Subject: Re: About r8169 regression 5.4
To:     Heiner Kallweit <hkallweit1@gmail.com>,
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
From:   Vincas Dargis <vindrg@gmail.com>
Message-ID: <86a87b0e-0a5b-46c7-50f5-5395a0de4a52@gmail.com>
Date:   Fri, 21 Feb 2020 22:21:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <356588e8-b46a-e0bb-e05b-89af81824dfa@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-02-20 20:32, Heiner Kallweit rašė:
> It would be great if you could test one more thing. Few chip versions have a hw issue with tx checksumming
> for very small packets. Maybe your chip version suffers from the same issue.
> Could you please test the following patch (with all features enabled, TSO and checksumming)?
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 8442b8767..bee90af57 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -4345,6 +4345,7 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
>   			case RTL_GIGA_MAC_VER_12:
>   			case RTL_GIGA_MAC_VER_17:
>   			case RTL_GIGA_MAC_VER_34:
> +			case RTL_GIGA_MAC_VER_44:
>   				features &= ~NETIF_F_CSUM_MASK;
>   				break;
>   			default:
> 

Sadly, network got hanged after ~1.5h of usage. I've built it with Debian's "debian/bin/test-patches" helper (kernel is now named 5.4.19-1a~test),
double-checked that line was actually added in source. `ethtool -K enp5s0f1 tx on sg on tso on` was executed after boot.
