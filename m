Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 129D01985D8
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 22:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgC3UxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 16:53:12 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36836 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727750AbgC3UxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 16:53:12 -0400
Received: by mail-wr1-f65.google.com with SMTP id 31so23357799wrs.3
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 13:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AzyTzH/MkuZ95NK4FE7abu4C/HyqLhv8wVJ5OvjJMHI=;
        b=aDiCJoIUxMbTWV56vpbP/0qk8R93qiqf/15sKTMf8SAHVnPesEMwVo9xkofOeYz/iQ
         6fQ44F4lU0UfAFwPqrFci3dMis4RJroKAhJwzMH4PwbaudwH+cQXKUc57xcLGKuxl6Bh
         xwQwwP6VM2BIt0IoXqwDaRpFGFoJ+ax0oB2CIujK9m+6gf45RsF0b9I7o/ybfZ+dKdpI
         s9P2U3zMNY6qANc34Pf79kjJ5W+23rLeuLdK6ehq6egQq/d51cfV8tAjaFoo9fuKPlhM
         byVHjSZ5GWDJS8m0qaUpYtLI8kW8DYI1ie2pC+FyI84IPj9mAkMbLamYm+INOalNCfcB
         qEVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=AzyTzH/MkuZ95NK4FE7abu4C/HyqLhv8wVJ5OvjJMHI=;
        b=mYerVlxBsiT37VOoEV7a9efsXWlJQFp3qBPrDyRdPvjN58Fu3v0S4pGobUwlFX3nHV
         SDlC3ebE/KgsQHKlAOFQFXMbW/VGGdEVq1m0L3M6Ph/Vr/gyEY7/x+/v1vvc/PV/CMnu
         RVB9dJbQF1WPWr4EMwUtmRMY3OwNEjIJb9H+ONXMk0Z7mjFW4MCXfdbByjfQn6dA+B8w
         SLoXHTDsleOd1u4qtTivyq9KHtF2eIMrNGJh3x3kMufk6vyraOaE/8/O14zGOwrMj/kr
         z7JNJc7YiOvyPukNT6MUbK5YY9fW5Y3pwuUcb3NVzb2Nac7C4PxrMl81zsEguwE1R8eT
         EhcA==
X-Gm-Message-State: ANhLgQ0SMBwsSe9EQH3xWtdpp0OMt6zxwD8QKZwXrZ/YJc6q4/T26XeO
        w++ML0+Xh8f2gMTN/sCsVcA=
X-Google-Smtp-Source: ADFU+vuboTODP2QrTuCFjL8dZa7zLV2aio6Y1kfM2Ax83hQv+ublxT4fnz+UubI9rh0cdUzPSZZCwQ==
X-Received: by 2002:adf:bbca:: with SMTP id z10mr16807120wrg.34.1585601589148;
        Mon, 30 Mar 2020 13:53:09 -0700 (PDT)
Received: from [10.230.186.223] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u17sm28038864wra.63.2020.03.30.13.53.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2020 13:53:08 -0700 (PDT)
Subject: Re: [PATCH net-next 0/9] net: dsa: b53 & bcm_sf2 updates for 7278
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, davem@davemloft.net,
        kuba@kernel.org, dan.carpenter@oracle.com
References: <20200330204032.26313-1-f.fainelli@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <b8b45686-1df3-f59b-e9a4-f6c3f04d4227@gmail.com>
Date:   Mon, 30 Mar 2020 13:53:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200330204032.26313-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On 3/30/2020 1:40 PM, Florian Fainelli wrote:
> Hi David, Andrew, Vivien,
> 
> This patch series contains some updates to the b53 and bcm_sf2 drivers
> specifically for the 7278 Ethernet switch.
> 
> The first patch is technically a bug fix so it should ideally be
> backported to -stable, provided that Dan also agress with my resolution
> on this.
> 
> Patches #2 through #4 are minor changes to the core b53 driver to
> restore VLAN configuration upon system resumption as well as deny
> specific bridge/VLAN operations on port 7 with the 7278 which is special
> and does not support VLANs.
> 
> Patches #5 through #9 add support for matching VLAN TCI keys/masks to
> the CFP code.

Please ignore this version, some comments were not updated to match the
code, I will spin a v2 shortly.

Thank you

> 
> Florian Fainelli (9):
>   net: dsa: bcm_sf2: Fix overflow checks
>   net: dsa: b53: Restore VLAN entries upon (re)configuration
>   net: dsa: b53: Prevent tagged VLAN on port 7 for 7278
>   net: dsa: b53: Deny enslaving port 7 for 7278 into a bridge
>   net: dsa: bcm_sf2: Disable learning for ASP port
>   net: dsa: bcm_sf2: Check earlier for FLOW_EXT and FLOW_MAC_EXT
>   net: dsa: bcm_sf2: Move writing of CFP_DATA(5) into slicing functions
>   net: dsa: bcm_sf2: Add support for matching VLAN TCI
>   net: dsa: bcm_sf2: Support specifying VLAN tag egress rule
> 
>  drivers/net/dsa/b53/b53_common.c |  29 +++++++
>  drivers/net/dsa/bcm_sf2.c        |  10 ++-
>  drivers/net/dsa/bcm_sf2_cfp.c    | 139 ++++++++++++++++++++++---------
>  3 files changed, 136 insertions(+), 42 deletions(-)
> 

-- 
Florian
