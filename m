Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4AC54942BB
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 23:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357482AbiASWCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 17:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343606AbiASWCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 17:02:14 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B57BC061574;
        Wed, 19 Jan 2022 14:02:14 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id y15so5540002lfa.9;
        Wed, 19 Jan 2022 14:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=InWqTkTbnVIeg3yZeoN2TSaiVZxmiWsL7/Xay8eEKBk=;
        b=ZcngD6Ryru4yOLrl8Smj58YokDWbrp4IaIQ2lhSfd3QstRbbDbSXfjTAO0Fez5tQ+v
         hzeMdk4KNa/CP+n6r0bCGeFT3dCUUaCNn/T5n4G8pDMVm+b6B0WlqpDWzz7EgwK0GFyK
         U6bxs/SEG7ps7yB+O4KhbsCKYzCpUrH/L6FHK+hbj4Sgr9ZD1aarg7JuSbtBLOb8UPQt
         Q3Tojc2pDX5f4GxLT/L0bHqzdtdqB2eHQHPKEmwwLJhdZ7EVHAc3N0PL7caeBmCvI4Hj
         PqM9bJMIwdM/gSzBY0vIh4Qaxow0W6mkgRCj8JXgoD4HgikRm2s8SFUZ+tiqbXES9dWC
         +jOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=InWqTkTbnVIeg3yZeoN2TSaiVZxmiWsL7/Xay8eEKBk=;
        b=2eGEWDFdIrVZPkN3vOdc6TDmcCxOoJtl73jeRvhHyK2JDduEqOcnMG9H34GM/7GGVT
         h12PeTRw5tckimd1H6xMqpoZCjkIktdxnIfF5xkFb52EF5DvXtsrH4P0i5Lh35Bm3Puk
         dveI3HG5BEvUkvCaItw/XVvFFe4NiXDrQUrPxix7cyom/FGPIzkFWCktpKvlAUGktOUA
         PTk3MwfHj/JEMypavLuJ/HKlMfXfCo+/6N/mFHHyf80vd+Yfhkgd34FAXdpWzuDul2rl
         9BSVWKpeIa6AuXqaAlFl6bNRuzVBdqXdbflSQrvBE31379u8Fq7DPxS6gsEZmXoJseV8
         pMgg==
X-Gm-Message-State: AOAM533oxEEBf8vmg3cMreMqqN16snqIp3v1YzjNRuDBziJu0ZDUMA6N
        qV6QbKmVc7jITwGXITVnTKs=
X-Google-Smtp-Source: ABdhPJyNXoA2WS6ShN1avPEC6d1v0hm8NZ5j/eKjxMJxBf16tCoJTMh+goTKLqVRbxz/R8aLjtg4vw==
X-Received: by 2002:a05:6512:15aa:: with SMTP id bp42mr22245503lfb.217.1642629732614;
        Wed, 19 Jan 2022 14:02:12 -0800 (PST)
Received: from [192.168.2.145] (109-252-139-36.dynamic.spd-mgts.ru. [109.252.139.36])
        by smtp.googlemail.com with ESMTPSA id s1sm87333lfs.215.2022.01.19.14.02.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jan 2022 14:02:12 -0800 (PST)
Message-ID: <be66ea27-c98a-68d3-40b1-f79ab62460d5@gmail.com>
Date:   Thu, 20 Jan 2022 01:02:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 3/9] brcmfmac: firmware: Do not crash on a NULL
 board_type
Content-Language: en-US
To:     Hector Martin <marcan@marcan.st>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20220117142919.207370-1-marcan@marcan.st>
 <20220117142919.207370-4-marcan@marcan.st>
From:   Dmitry Osipenko <digetx@gmail.com>
In-Reply-To: <20220117142919.207370-4-marcan@marcan.st>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

17.01.2022 17:29, Hector Martin пишет:
> This unbreaks support for USB devices, which do not have a board_type
> to create an alt_path out of and thus were running into a NULL
> dereference.
> 
> Fixes: 5ff013914c62 ("brcmfmac: firmware: Allow per-board firmware binaries")
> Signed-off-by: Hector Martin <marcan@marcan.st>

Technically, all patches that are intended to be included into next
stable kernel update require the "Cc: stable@vger.kernel.org" tag.

In practice such patches usually auto-picked by the patch bot, so no
need to resend.

> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> index 1001c8888bfe..63821856bbe1 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> @@ -599,6 +599,9 @@ static char *brcm_alt_fw_path(const char *path, const char *board_type)
>  	char alt_path[BRCMF_FW_NAME_LEN];
>  	char suffix[5];
>  
> +	if (!board_type)
> +		return NULL;
> +
>  	strscpy(alt_path, path, BRCMF_FW_NAME_LEN);
>  	/* At least one character + suffix */
>  	if (strlen(alt_path) < 5)

Good catch!

Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
