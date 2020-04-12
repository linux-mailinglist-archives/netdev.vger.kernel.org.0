Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5721A5BBA
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 03:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgDLBP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 21:15:57 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:52234 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbgDLBP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Apr 2020 21:15:57 -0400
Received: by mail-pj1-f65.google.com with SMTP id ng8so2395965pjb.2;
        Sat, 11 Apr 2020 18:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nzgXVCmGCB2h+fYHwYNmPaz3ajnzbIPh10nAQ9+5zFc=;
        b=rmuRKusMg6uuLqh9+NYfoKVmOTDgZ7nFSoX1oSV/al8wErzBeJpLCTY/MWLuM52wPI
         Un9lscTJZXYsD2wg4mb6W1JO1Y6ZwpZuOSYGKGteCwAOv5xAEks6uO6ZytOk0ZcaJyU7
         Z66ZpZF3e/jJppkHmygYYJV8ghRzIDveJ8lsdfIuRYJRMWOIZPuv3hy0HfZE7vEDmDgs
         0Rpi5FMXoakgI9s4RaXL+VPscXfTwkneISyJ6eVysRbuR4tGeDgWvnh24cEP1aYLgtRY
         rjbCtvldLDwC/nfMmXB5Oki8gq1KMw5zFlSuog3OlkVTfTTEVOdgZntjNEwyU4QXCe2j
         8o5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=nzgXVCmGCB2h+fYHwYNmPaz3ajnzbIPh10nAQ9+5zFc=;
        b=Lz4Gten6Wofqa7ZOAdtZqmmbgFTj/6VIH1etuMFlrynudmDouZJa+WgjiMmd62PSTB
         wUpBBexKe31C5+4WqNjp1tQLN8EOSS0AWjp7UjGymuy8q+mg0uOnG8g90JDCVwosKO65
         eTUL4bOCcuExfpI76hWFWZx5nB+sZwO4wU2K9IbNkyQkkaPL4Snvt0j8o/U+Ky0PgVAF
         eX8yQa7nlKhbuWmnSuwPrXrR9h6YxAxtj4hiZOhgfcNWFPZm0JpRJiTkpWMyrz85A/aK
         Sj7QF+NxGHeZ/PfVc7U6A8J0CITnyPiyAnBQPsqvQClM9n7D7ZW26G1lBBueChXfnxCu
         3jAw==
X-Gm-Message-State: AGi0PuZ4dkfboKLd8mc7/YYttdU4PE/PsTMiZ8nMs9BHzMHKo0W9dt+B
        re1FHJ9Wdpe4oM6lA5omwvUp5Nft
X-Google-Smtp-Source: APiQypKS4NdUz6Fx5jz6jZBDIHOtm/POexqYOFZVoGYCc36GODtzHf2PiUuTClW54IVrxmEsgL20eg==
X-Received: by 2002:a17:90a:8c10:: with SMTP id a16mr4250128pjo.78.1586654155606;
        Sat, 11 Apr 2020 18:15:55 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id q201sm5165026pfq.32.2020.04.11.18.15.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Apr 2020 18:15:54 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 4.14 19/37] net: dsa: bcm_sf2: Also configure Port
 5 for 2Gb/sec on 7278
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20200411231327.26550-1-sashal@kernel.org>
 <20200411231327.26550-19-sashal@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <485a30d3-0677-dce4-c35d-4ccfdc523efe@gmail.com>
Date:   Sat, 11 Apr 2020 18:15:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200411231327.26550-19-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/11/2020 4:13 PM, Sasha Levin wrote:
> From: Florian Fainelli <f.fainelli@gmail.com>
> 
> [ Upstream commit 7458bd540fa0a90220b9e8c349d910d9dde9caf8 ]
> 
> Either port 5 or port 8 can be used on a 7278 device, make sure that
> port 5 also gets configured properly for 2Gb/sec in that case.

This was later reverted with:

3f02735e5da5367e4cd563ce6e5c21ce27922248 ("Revert "net: dsa: bcm_sf2:
Also configure Port 5 for 2Gb/sec on 7278") please drop it from this
selection.

> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/dsa/bcm_sf2.c      | 3 +++
>  drivers/net/dsa/bcm_sf2_regs.h | 1 +
>  2 files changed, 4 insertions(+)
> 
> diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
> index 6bca42e34a53d..4b0c48a40ba6e 100644
> --- a/drivers/net/dsa/bcm_sf2.c
> +++ b/drivers/net/dsa/bcm_sf2.c
> @@ -691,6 +691,9 @@ static void bcm_sf2_sw_adjust_link(struct dsa_switch *ds, int port,
>  	if (phydev->duplex == DUPLEX_FULL)
>  		reg |= DUPLX_MODE;
>  
> +	if (priv->type == BCM7278_DEVICE_ID && dsa_is_cpu_port(ds, port))
> +		reg |= GMIIP_SPEED_UP_2G;
> +
>  	core_writel(priv, reg, offset);
>  
>  	if (!phydev->is_pseudo_fixed_link)
> diff --git a/drivers/net/dsa/bcm_sf2_regs.h b/drivers/net/dsa/bcm_sf2_regs.h
> index 49695fcc2ea8f..3c4fd7cda701a 100644
> --- a/drivers/net/dsa/bcm_sf2_regs.h
> +++ b/drivers/net/dsa/bcm_sf2_regs.h
> @@ -162,6 +162,7 @@ enum bcm_sf2_reg_offs {
>  #define  RXFLOW_CNTL			(1 << 4)
>  #define  TXFLOW_CNTL			(1 << 5)
>  #define  SW_OVERRIDE			(1 << 6)
> +#define  GMIIP_SPEED_UP_2G		(1 << 7)
>  
>  #define CORE_WATCHDOG_CTRL		0x001e4
>  #define  SOFTWARE_RESET			(1 << 7)
> 

-- 
Florian
