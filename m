Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C83E4900A0
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 04:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234224AbiAQDqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 22:46:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234174AbiAQDqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 22:46:49 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F203C061574
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 19:46:49 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id pf13so19539534pjb.0
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 19:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=S4liEXUQPzThxVB4e3xeVfiVdFs+mdUUf+apKmP/BVA=;
        b=f+VG7JVsYyolSyc7cvtpLhyg+v0zArqHb1DdJKMEDCLe2TyKxtrJfA8p8e/S6JilwX
         blCEOFkEIMns9irFsT/NwhdFeYL6MlCqpYwhsYHoxmrZ05Td1WEMedKIPIhSWAwRguzr
         fZzB3QP5G8UcxgTBHtRhOjSO1vybcm+FXtAETyGYBSYy5fyKKXHT14YnsSQcUIYB+Bvg
         j/FTvzoXl5xxbF9x7pa0OYlZek/FS+9UuJYbYo5GibGgWdN6+a7Lu+6oeibEkZvyfSzN
         e2bZdArJW8y83cqKi0bCGfKv9RB4JGUpFhvFFwkZhz7seyFEaJCRfq94ROxf49v5/qWt
         neZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=S4liEXUQPzThxVB4e3xeVfiVdFs+mdUUf+apKmP/BVA=;
        b=DbGM8Tr22cdKjgsM67AKZ4fRAIZWdiJbeac1ipmIh76EQ5Znf/jvSFGxiQJ3gm3T5W
         DOfqikbVYuSoOk7M8f1qJ5OTfKF41tviIdecAuChaaPT95icy7+SilBzCeEYNXM4tukY
         IURraeN/AkkkWqtfne+ziN8KcJGB33lUXTHfFNaedmgbIre65X24u3Soj+rWzXbD1YzE
         hMRS/5ftEGbFVqOPW/Xzc7/Zwo+oMmIlVHQpKo9tYPjGeP/ZL6VKdkt5qXmDWfyTdpEr
         f2l/eux5b+m9QktMRkk9o8cyI/S8fRk1i3Wm337US3+xPcoAgW+KHNH1QdN6jLVfT1zc
         1Xhg==
X-Gm-Message-State: AOAM530Ma+wHQ90LmKIc0xZsthUlL4JI4riwU11v9s78P/SliJaYVI0Q
        Y2UPuXW1+P2rLY0gOXyMa54=
X-Google-Smtp-Source: ABdhPJxqjah2LFpxpTIEwV12Zuhij4CniJsdRZdvZk5XlkqxrJw+lmmYeD/BHWCkxbmKRoyhuLTGcw==
X-Received: by 2002:a17:90a:3e44:: with SMTP id t4mr7278326pjm.3.1642391208116;
        Sun, 16 Jan 2022 19:46:48 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:10a9:f333:2ba1:b094? ([2600:8802:b00:4a48:10a9:f333:2ba1:b094])
        by smtp.gmail.com with ESMTPSA id p32sm10026754pgb.49.2022.01.16.19.46.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Jan 2022 19:46:47 -0800 (PST)
Message-ID: <d8c5c288-2890-c62b-1cb3-3b81319f1ee6@gmail.com>
Date:   Sun, 16 Jan 2022 19:46:46 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v4 03/11] net: dsa: realtek: remove direct calls
 to realtek-smi
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        frank-w@public-files.de
References: <20220105031515.29276-1-luizluca@gmail.com>
 <20220105031515.29276-4-luizluca@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220105031515.29276-4-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/4/2022 7:15 PM, Luiz Angelo Daros de Luca wrote:
> Remove the only two direct calls from subdrivers to realtek-smi.
> Now they are called from realtek_priv. Subdrivers can now be
> linked independently from realtek-smi.
> 
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> ---
[snip]

Just a nit below.

>   	return 0;
> @@ -1705,7 +1707,7 @@ static int rtl8366rb_reset_chip(struct realtek_priv *priv)
>   	u32 val;
>   	int ret;
>   
> -	realtek_smi_write_reg_noack(priv, RTL8366RB_RESET_CTRL_REG,
> +	priv->write_reg_noack(priv, RTL8366RB_RESET_CTRL_REG,
>   				    RTL8366RB_CHIP_CTRL_RESET_HW);

Only if you need to spin a new version, the second line should start at 
the character after the opening parenthesis on the previous line.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
