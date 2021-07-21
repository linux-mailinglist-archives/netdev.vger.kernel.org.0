Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFDA63D0FA9
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 15:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238227AbhGUM6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 08:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238337AbhGUM5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 08:57:07 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C63C061574;
        Wed, 21 Jul 2021 06:37:09 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id q15so2053477qkm.8;
        Wed, 21 Jul 2021 06:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uh01RhYYBX/9cJeTpZ4herRqCYgg+c5yWd7RJP1vPE4=;
        b=ttPcGi41ChO5jWh67Rq2CEwXuAdMhJZawaeNETBMgEuClYxQgk9xjiRYl+d2b3KvLc
         CbracepViCUfG7fdHaJxDYWbxVsyDAnbdkyIitxTTUhvSEwSST5ank4/BhMtQsSfDbLW
         V3rPCA2trJSHl+I6Hgsbfeft/rSklrqmnx8vnuV58iQavmrTdNa6IWEwsXslXfoSP60+
         YCtBIomio9al5fBDKGf+C0OasZQN6K2Nr0UfukVjJTlvHhIf7933CTmzBLGyKnD0U49i
         NK+u2+SNKAsRKhLoxF19E7toNJb5PFEnYFK24n8OAvMgF0gPKCdWYzV1iTSBpLezB7o5
         gKig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uh01RhYYBX/9cJeTpZ4herRqCYgg+c5yWd7RJP1vPE4=;
        b=dzKUtuFdIBPUkGPIZg66Ykb9+wHScFTJtHe8aii0AzA9fyQadG+/AXZtsrPZLmHgbk
         CR84RJSb//e3grJc3FvUpTIwFXjmdrDf/dc71RZfM2Fj9NHUVNsSyPMaAPLjfuNlnXM2
         Hpq8vz8EBQELjZH1K+axpV/TdcqS9kXlY4MkcExxDpUt0ubHaJimbLdvjXQ0qO1Gcr3G
         pAKPB59bMOR0cy0rlPRYuFSYuaWtYLq3ATZesLOHGkQ6rV7uFBkprA5GcmUWaAvlKtQA
         K6sMJttmsjxKFOe8rCLybo1JBlR2CxGdIsVJb3aXTaTz/efH3xP1Yzbl1dQ9dtkYAQia
         Kd1g==
X-Gm-Message-State: AOAM531f/346JWe0YgbVhyJygZ82/D/iMw/tGlgtpQq/fcgHUoKHc67D
        MP65o+HDti2u+FUwC63/cWY=
X-Google-Smtp-Source: ABdhPJxyxcuUQq7+7lE+19VBeIl+gcagTSt9CBIWFUpKrnYFkf+yg0Tn031PfZiwNaPHNJwyiangEw==
X-Received: by 2002:a05:620a:1305:: with SMTP id o5mr17697082qkj.213.1626874628846;
        Wed, 21 Jul 2021 06:37:08 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:1102::1444? ([2620:10d:c091:480::1:8307])
        by smtp.gmail.com with ESMTPSA id c11sm9046470qth.29.2021.07.21.06.37.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jul 2021 06:37:08 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH] rtl8xxxu: remove unnecessary labels
To:     samirweng1979 <samirweng1979@163.com>, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
References: <20210720070040.20840-1-samirweng1979@163.com>
Message-ID: <eb5393c9-77d5-37f1-e9e8-67795958c9e6@gmail.com>
Date:   Wed, 21 Jul 2021 09:37:07 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210720070040.20840-1-samirweng1979@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/20/21 3:00 AM, samirweng1979 wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> Simplify the code by removing unnecessary labels and returning directly.
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)

NACK

Using gotos to have a unified exit path keeps the code cleaner and makes
it easier to ensure locking is correct where applicable.

Jes

> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c
> index 4f93f88..3fd14e6 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c
> @@ -256,10 +256,8 @@ static int rtl8723a_emu_to_active(struct rtl8xxxu_priv *priv)
>  		udelay(10);
>  	}
>  
> -	if (!count) {
> -		ret = -EBUSY;
> -		goto exit;
> -	}
> +	if (!count)
> +		return -EBUSY;
>  
>  	/* We should be able to optimize the following three entries into one */
>  
> @@ -292,10 +290,8 @@ static int rtl8723a_emu_to_active(struct rtl8xxxu_priv *priv)
>  		udelay(10);
>  	}
>  
> -	if (!count) {
> -		ret = -EBUSY;
> -		goto exit;
> -	}
> +	if (!count)
> +		return3RGD9F -EBUSY;
>  
>  	/* 0x4C[23] = 0x4E[7] = 1, switch DPDT_SEL_P output from WL BB */
>  	/*
> @@ -307,7 +303,6 @@ static int rtl8723a_emu_to_active(struct rtl8xxxu_priv *priv)
>  	val8 &= ~LEDCFG2_DPDT_SELECT;
>  	rtl8xxxu_write8(priv, REG_LEDCFG2, val8);
>  
> -exit:
>  	return ret;
>  }
>  
> @@ -327,7 +322,7 @@ static int rtl8723au_power_on(struct rtl8xxxu_priv *priv)
>  
>  	ret = rtl8723a_emu_to_active(priv);
>  	if (ret)
> -		goto exit;
> +		return ret;
>  
>  	/*
>  	 * 0x0004[19] = 1, reset 8051
> @@ -353,7 +348,7 @@ static int rtl8723au_power_on(struct rtl8xxxu_priv *priv)
>  	val32 &= ~(BIT(28) | BIT(29) | BIT(30));
>  	val32 |= (0x06 << 28);
>  	rtl8xxxu_write32(priv, REG_EFUSE_CTRL, val32);
> -exit:
> +
>  	return ret;
>  }
>  
> 

