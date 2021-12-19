Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B2A47A1FC
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 20:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235403AbhLST6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 14:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhLST6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 14:58:33 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268E8C061574
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 11:58:33 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so7636340pjp.0
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 11:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OMnqnv3ovCcU7eQaGdLnTsd19zrqzZTyuEJOloz9buo=;
        b=EBEPJBaIc1mvV4Tg8n2PIfqTXPF4dfXiY80f891uvpbFwlPjQEIBfKH7bDWdPjWuR6
         nmu1HZKtoLLWnm6CGp8NxewybU1LuCiYTUXyRPYBdfU3euagM6T1KNLS/yXOMUr9TQL1
         6N8kRTE2IYZzftph+Ml3gC7wdTjuFV/x6bBw+lD608981a//NK28iX9Rz6Oi+F8pNFMd
         AFbt3WNpqJeT/eKW6IMQJ4rq2o74f3hCqYY+Zcke9ak5ruGnN0LwqrVykdNz/cHKFwf2
         UTO2lRk5RHM/0zrHkHUOKdgpASdR94joEhTUsJnZ+kQobBcbqKkv2IknDAhoTaM9QbTW
         W3jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OMnqnv3ovCcU7eQaGdLnTsd19zrqzZTyuEJOloz9buo=;
        b=0paXdHrQXc8matfPUSLkdyG9Bgv7WBYjc2JY+BqOEg1DvZ6Hldhq+rC0rog6rS3I/8
         Ph6VKn/I9cNvj9Le0JDl5ny75yBweE5xG0Qba92HW7uXPJjN4HnOTAaU2PKSVKN7uyN+
         LeJ5vyfxbmgaMuyh2aDlCc+zfKS8BVOhR6VHIfVlhUTY1R9QFLpe69GX16GbCBhMW9V0
         0D7+U8AmUDK+3bE97B66y8AOr/Utaykm1ePeihXubE1xFJXLPAwpQEsrdLBJAa0DCqKO
         cA6aTXWOXRzUGsktFd/sekYXveQA625M2dtIAkcKp3Tmwe4YZ/fPiijbtvokgrhDgRAK
         pYHA==
X-Gm-Message-State: AOAM5314hUokFNcw1z4PDJnHMvmSQm0hpEkes86xi5toQ6J0blzFQAbL
        Tfhh2gjgbWbK1xjfx6c7Dige5byaD/Y=
X-Google-Smtp-Source: ABdhPJwIXD9+J1QstvIhKxpiVJx1gTyMRhFx8o1FnDsoMFa7oQpehUXRI3t9oK7LJKTJcZYBb4Vl/g==
X-Received: by 2002:a17:90a:604f:: with SMTP id h15mr18285038pjm.87.1639943912618;
        Sun, 19 Dec 2021 11:58:32 -0800 (PST)
Received: from [10.1.10.177] (c-71-198-249-153.hsd1.ca.comcast.net. [71.198.249.153])
        by smtp.gmail.com with ESMTPSA id b6sm16172309pfm.170.2021.12.19.11.58.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Dec 2021 11:58:30 -0800 (PST)
Message-ID: <71f3fa2d-56c0-3e9b-520e-3d6cc1225f1c@gmail.com>
Date:   Sun, 19 Dec 2021 11:58:29 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH net-next v2 06/13] net: dsa: realtek: use phy_read in
 ds->ops
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, alsi@bang-olufsen.dk, arinc.unal@arinc9.com
References: <20211216201342.25587-1-luizluca@gmail.com>
 <20211218081425.18722-1-luizluca@gmail.com>
 <20211218081425.18722-7-luizluca@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211218081425.18722-7-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/18/2021 12:14 AM, Luiz Angelo Daros de Luca wrote:
> The ds->ops->phy_read will only be used if the ds->slave_mii_bus
> was not initialized. Calling realtek_smi_setup_mdio will create a
> ds->slave_mii_bus, making ds->ops->phy_read dormant.
> 
> Using ds->ops->phy_read will allow switches connected through non-SMI
> interfaces (like mdio) to let ds allocate slave_mii_bus and reuse the
> same code.
> 
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> ---
>   drivers/net/dsa/realtek/realtek-smi.c |  8 ++++----
>   drivers/net/dsa/realtek/realtek.h     |  3 ---
>   drivers/net/dsa/realtek/rtl8365mb.c   | 10 ++++++----
>   drivers/net/dsa/realtek/rtl8366rb.c   | 10 ++++++----
>   4 files changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/dsa/realtek/realtek-smi.c b/drivers/net/dsa/realtek/realtek-smi.c
> index 351df8792ab3..32690bd28128 100644
> --- a/drivers/net/dsa/realtek/realtek-smi.c
> +++ b/drivers/net/dsa/realtek/realtek-smi.c
> @@ -328,17 +328,17 @@ static const struct regmap_config realtek_smi_mdio_regmap_config = {
>   
>   static int realtek_smi_mdio_read(struct mii_bus *bus, int addr, int regnum)
>   {
> -	struct realtek_priv *priv = bus->priv;
> +	struct dsa_switch *ds = ((struct realtek_priv *)bus->priv)->ds;

No need to cast a void pointer, this applies throughout the entire patch 
series.
-- 
Florian
