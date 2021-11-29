Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3ED346221F
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 21:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbhK2U0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 15:26:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237109AbhK2UXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 15:23:06 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA03C09CE4A
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 08:57:45 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id o19-20020a1c7513000000b0033a93202467so12905427wmc.2
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 08:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fsK0ffSNkX2YjoYb60JhZcQmLthgW35olO/nH3s6QI0=;
        b=AhTNkxz488YZec9ItbtcQtFJ6AdTyDdofUwyTnB4VyLkWI9uA1Hi7KO4aDZttCZvKM
         hekXy+iFpbKC7EDtRES5xWth4QiMc8gZor/yo9QJEwUxzjsEQN5B3XnADAX0cAvWtA3P
         +//QUZ5XHjtfFaGrOPoBaP/mv5Qh0OJQUL036P1/3b2PaHYZ+UUFulg2IHirH8Z3RCPa
         idaJL6WUuU36nrFlPqj41UqRSKU7Lg8seIVsuY6nzQngYCAgmamy9wXDDwaVrn8QYdyC
         3lBSYzltNDlafp5yaENnzhI6vjCfGHYx3aj760zfpofOjitXUcwtQK23Wg2uxl26M85n
         aBnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fsK0ffSNkX2YjoYb60JhZcQmLthgW35olO/nH3s6QI0=;
        b=kiBCJqIDRGFms/AfpTlXIhtyKy6zVtwpi4u8l6le526tEMMbczt78xo5LQxMjGS37k
         aZE1fGsqMZngmLqgSfiAeMSm4Cxv1jv8rWQgoJ+kZIAMIVL3FdjuOFSM19OPAnMjo9Aa
         4wQFczBby/MfQfQg15pKoyOXqasjjm4DQWHqQL22eq6d760cStiINroXXAmNrq1gRkhW
         lxo65mf2fQKbaMLx6JfJW+Dbe9/Ybulm4DGz4KhvGB6RzoxAMuclCyI4GFFrd5LoOy5f
         /y4AA7xJsErjThwAUctnZm3Q6MEF95VKHSp7NulX9NtM+wif2gt4CUIuGf0yDsOAoCxI
         9tYA==
X-Gm-Message-State: AOAM533j0c0ly0ITJm6xKh2ncmxSs39cVayS/MdZffIQtte5/L+LIEIE
        jM1cSGB6XAVcmykb3dS+9yQ=
X-Google-Smtp-Source: ABdhPJwZfHWaXfiyiz9jIOgYHLCgPa9loM4i5Wp3GlzveDF6fMHLGtSydiBdenW27BL18AuOdrtrFQ==
X-Received: by 2002:a7b:c097:: with SMTP id r23mr36791398wmh.193.1638205064267;
        Mon, 29 Nov 2021 08:57:44 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:e474:c9cc:78a6:961d? (p200300ea8f1a0f00e474c9cc78a6961d.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:e474:c9cc:78a6:961d])
        by smtp.googlemail.com with ESMTPSA id m1sm15367933wme.39.2021.11.29.08.57.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 08:57:43 -0800 (PST)
Message-ID: <15522e0b-242e-5721-4761-be170c93e249@gmail.com>
Date:   Mon, 29 Nov 2021 17:57:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH net v2 1/3] net: dsa: realtek-smi: don't log an error on
 EPROBE_DEFER
Content-Language: en-US
To:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alvin@pqrs.dk>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linus.walleij@linaro.org,
        andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        vivien.didelot@gmail.com,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>
References: <20211129103019.1997018-1-alvin@pqrs.dk>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20211129103019.1997018-1-alvin@pqrs.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.11.2021 11:30, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> Probe deferral is not an error, so don't log this as an error:
> 
> [0.590156] realtek-smi ethernet-switch: unable to register switch ret = -517
> 
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> ---
>  drivers/net/dsa/realtek-smi-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> v2: use dev_err_probe() instead of manually checking ret
> 
> diff --git a/drivers/net/dsa/realtek-smi-core.c b/drivers/net/dsa/realtek-smi-core.c
> index c66ebd0ee217..aae46ada8d83 100644
> --- a/drivers/net/dsa/realtek-smi-core.c
> +++ b/drivers/net/dsa/realtek-smi-core.c
> @@ -456,7 +456,7 @@ static int realtek_smi_probe(struct platform_device *pdev)
>  	smi->ds->ops = var->ds_ops;
>  	ret = dsa_register_switch(smi->ds);
>  	if (ret) {
> -		dev_err(dev, "unable to register switch ret = %d\n", ret);
> +		dev_err_probe(dev, ret, "unable to register switch\n");
>  		return ret;

Nit, following would have been simpler:

if (ret)
	return dev_err_probe(dev, ret, "unable to register switch\n");

>  	}
>  	return 0;
> 

