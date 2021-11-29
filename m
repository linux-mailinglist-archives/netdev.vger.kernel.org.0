Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA429460F3D
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 08:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbhK2HTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 02:19:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235063AbhK2HRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 02:17:08 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027C9C06174A
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 23:13:51 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id l16so34491018wrp.11
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 23:13:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=USEdERyxDAqbNUUyP+ChN65rew+1+W68cfC9XArTfjE=;
        b=hsq2XS0AKLAaAVVReXBpY/fRvQQ0Vbk4C6puLx3XTT5Gu1mR3JyDu1EsEXB0/UIuNK
         Mg5fRZScUK10vPwMIYXap5DFuzEYOZ8k+GI+MwueSnNfTizGFRIbl3Qo6h7mE0GWXb7d
         zBVQqiCnvB7DclFyhJ7DF48F8vagapkJ5XGdaU9b7b/z0WZN28nH/TrqZIzYDkxoInXi
         3FxC3uAOrVkdm7WEgeD3kLm5nU3qK8JCpb+UFM60d9fu2dlU11zdW19omB47Fzvy/0n4
         mKwXHEnyxEK9xKwE2eu6yKgGZKpTfyA5EhR06Nm5fcG2P+Th7Tv1A7dyya67rXwGBInw
         w06Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=USEdERyxDAqbNUUyP+ChN65rew+1+W68cfC9XArTfjE=;
        b=S3zDk3ZCABmVzJjDd7WXDhDv45p+ORhJNlUnhY5ONI0DfInuDugXIw+OBfV+6VLUqG
         uWgT4E98EBJFhgDmeMg6hAFV6v8AfAIexbnDAnBrxqoqZRvM/rnKHpQs98Au38+y4emE
         albL2q5bEjkNuE5p+EEf95AihnDm1WAxa8TdUCoX/zuL64pfnSRfZ9oZ5cJP06WSjN5i
         Z/sto2haW5XaBk0+mPmFc6QfAFl+74JvkOqlFvaJdXFh9lgrZl84cK4/po9DWAAbD/mj
         7mp8B7nZl1H4rLhQJ31UuL4PdRtwDD2teYv3lTeXGUW0aQy5TqleMApBvTHFV479qUDg
         HqRg==
X-Gm-Message-State: AOAM532gi0yFpjWxjxPkHOFb6qoMoGa0fEthNM1ZAB9UxLnd/5Iverkn
        iPgu57ZDx2a1e6OzL5vawLg=
X-Google-Smtp-Source: ABdhPJyhUoaxo8I3M19upjvc3vfEVCDCilPFpsmhpCl9TgwtFUGyXHGiZA/4bVxA8gM6VObhbXNSKA==
X-Received: by 2002:adf:d092:: with SMTP id y18mr32432832wrh.523.1638170029557;
        Sun, 28 Nov 2021 23:13:49 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:3c35:a12:9e4a:62d4? (p200300ea8f1a0f003c350a129e4a62d4.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:3c35:a12:9e4a:62d4])
        by smtp.googlemail.com with ESMTPSA id f13sm16294808wmq.29.2021.11.28.23.13.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Nov 2021 23:13:49 -0800 (PST)
Message-ID: <0948d94a-3a50-8cc4-7984-03a0fff0b7b1@gmail.com>
Date:   Mon, 29 Nov 2021 08:13:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH net 1/3] net: dsa: realtek-smi: don't log an error on
 EPROBE_DEFER
Content-Language: en-US
To:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alvin@pqrs.dk>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>
References: <20211126125007.1319946-1-alvin@pqrs.dk>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20211126125007.1319946-1-alvin@pqrs.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.11.2021 13:50, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> Probe deferral is not an error, so don't log this as an error:
> 
> [0.590156] realtek-smi ethernet-switch: unable to register switch ret = -517
> 
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> ---
>  drivers/net/dsa/realtek-smi-core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/realtek-smi-core.c b/drivers/net/dsa/realtek-smi-core.c
> index c66ebd0ee217..9415dd81ce5a 100644
> --- a/drivers/net/dsa/realtek-smi-core.c
> +++ b/drivers/net/dsa/realtek-smi-core.c
> @@ -456,7 +456,9 @@ static int realtek_smi_probe(struct platform_device *pdev)
>  	smi->ds->ops = var->ds_ops;
>  	ret = dsa_register_switch(smi->ds);
>  	if (ret) {
> -		dev_err(dev, "unable to register switch ret = %d\n", ret);
> +		if (ret != -EPROBE_DEFER)

Better use dev_err_probe().

> +			dev_err(dev, "unable to register switch ret = %d\n",
> +				ret);
>  		return ret;
>  	}
>  	return 0;
> 

