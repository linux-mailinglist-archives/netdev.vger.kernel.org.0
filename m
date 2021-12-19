Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B1A47A1FE
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 21:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236479AbhLSUGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 15:06:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhLSUG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 15:06:29 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D85C061574
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 12:06:29 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id o14so6429327plg.5
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 12:06:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yXj08Z6VZGwpcf/UGr+vArv0XRuQ8faXJFxcYvc5d+Q=;
        b=d/BmyFRxXYma2/b0Ey1vSui1+fJ92N4T12yB0FKcTK/IYM5moOieq8XwOjKtOkSCem
         T7BPGzvoyRFWhDcqA7XFElTqW1z6THjkfID4e3Dzgfx/lr2MeMHJ8bTmE3DdVVBysihr
         d6hiA5ka9v2uk4wMBfmDj8iZxFipTXDUc/z95GInCtvsuUk0lh2i4WOsY5UNyhfq5HmI
         gyFQm1iSWyQq8tgC8jRhASuP57bN34Y1R9wS82rR0hgWsk0mMintdAVaIxlZX3ffcjOQ
         iiDL+TaRGtR5mksFxO3FOkqe/sHPxTR/YAMSGnINdq6zRNEzpZDV+hwS/mmCMIoEEPDl
         80pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yXj08Z6VZGwpcf/UGr+vArv0XRuQ8faXJFxcYvc5d+Q=;
        b=vwNS9tUv6mBL0qjN2vVOzuIeVZZ0FSsYDkYr/u8DRgpL1qcRq+gCK0tYx1PcejlJC5
         Kbcuk+gnmznYX5ODwbgWajvaEBl1umN/akSmhnhBqiG0IQ4XjOZ3GWsWhWo32OuG9UcV
         QZ6VbjIuAKeWkuFMDJ66/9ZbvdClEl2G8wyYAr8KgwzisENZERaCXQsBXWugGvds75gb
         pL0cOBIXN4wdibf073y31yAQi7nB46CHpCOZ+0CLZ8B4cJYKmYsk9I8EQ5g0vzp7/k1k
         7tRMfVRqor+PLYSi8ktgTRaKm68SssNnodsoRg8ZwprWpm4I4Aegou1NJLK/u480fIU/
         woog==
X-Gm-Message-State: AOAM532wIbVAdT5l2lCmC5O3idCE3T46H58pkKq0xXSRisRykHdULT7M
        zbiQfjaAfWWskEuWbJ/dX7Q=
X-Google-Smtp-Source: ABdhPJxJGubDKbx2shR8j63ABn4quakZnieaTi8eoLvZa2V7++dOhbJUQcYGZFXcSoIWWxhkPOz4EA==
X-Received: by 2002:a17:90a:e514:: with SMTP id t20mr16007869pjy.5.1639944388490;
        Sun, 19 Dec 2021 12:06:28 -0800 (PST)
Received: from [10.1.10.177] (c-71-198-249-153.hsd1.ca.comcast.net. [71.198.249.153])
        by smtp.gmail.com with ESMTPSA id t1sm9082948pje.57.2021.12.19.12.06.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Dec 2021 12:06:27 -0800 (PST)
Message-ID: <47a7ad5b-aa12-1eb9-2556-a00793d01181@gmail.com>
Date:   Sun, 19 Dec 2021 12:06:26 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH net-next 11/13] net: dsa: realtek: rtl8367c: use
 GENMASK(n-1,0) instead of BIT(n)-1
Content-Language: en-US
To:     luizluca@gmail.com, netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, alsi@bang-olufsen.dk, arinc.unal@arinc9.com
References: <20211216201342.25587-1-luizluca@gmail.com>
 <20211216201342.25587-12-luizluca@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211216201342.25587-12-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/16/2021 12:13 PM, luizluca@gmail.com wrote:
> From: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> 
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> ---
>   drivers/net/dsa/realtek/rtl8367c.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/realtek/rtl8367c.c b/drivers/net/dsa/realtek/rtl8367c.c
> index 6aca48165d1f..f370ea948c59 100644
> --- a/drivers/net/dsa/realtek/rtl8367c.c
> +++ b/drivers/net/dsa/realtek/rtl8367c.c
> @@ -1955,7 +1955,7 @@ static int rtl8367c_detect(struct realtek_priv *priv)
>   		mb->priv = priv;
>   		mb->chip_id = chip_id;
>   		mb->chip_ver = chip_ver;
> -		mb->port_mask = BIT(priv->num_ports) - 1;
> +		mb->port_mask = GENMASK(priv->num_ports-1,0);

Missing spaces between priv->num_ports, and -1 here, and the comma 
before 0 as well:
		mb->port_mask = GENMASK(priv->num_ports - 1, 0);

is what we would expect to see.
-- 
Florian
