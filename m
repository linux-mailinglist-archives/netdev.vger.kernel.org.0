Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C194660428
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbjAFQVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjAFQVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:21:31 -0500
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1719A7622E;
        Fri,  6 Jan 2023 08:21:30 -0800 (PST)
Received: by mail-vs1-xe2f.google.com with SMTP id i188so1915229vsi.8;
        Fri, 06 Jan 2023 08:21:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rvoHA51dBPJxu29rUy3n+YN/knXWowFgBFUnc3YEs8M=;
        b=FAdRo3A0VAjazJq3nJhVSdkEXJObUUJGwMBwSzNqrSjqbhU8oaGvT+XzotRusmYoCu
         lxq00qMhKYRWByczvVg+rZibNLuwWv6u2mQJ1uMTZJP/xubGnYFnIT9SY17kHiWgLHMq
         NpXBcenbxYH81QzOYBhAtBtJuyJumxErMx08cRO7+Tm/vgOKxHeRHHxMOS9r5fSGlIZ3
         NRRfBiKWlJl8M2dVH3N1UBTHpHIrudhivsO/STC/Sl8lNIuZ7C4+U0bNLAnUYbreBOcB
         aAfrBU6xTVqs7XKj3+xlP8qXe8XfCzuqQiEUEd2gSczmAdDcqSA7I5qDjU8b0W+VwkPD
         8IUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rvoHA51dBPJxu29rUy3n+YN/knXWowFgBFUnc3YEs8M=;
        b=Cc6A1r5tHdJU1X27sGJKj7OjGnT3bCnTWkCXh+BTa99nOKawzHDvfqq/YbIJOvgE5x
         rfKuLol6tWKRHKdp4kerwoPAFxk8YxlmaZL/NbmSIAPEf02Jt/cnby1NLIAB6TUNWPfV
         E0neNul2mtwroGE9hXj6NbjC5toPnTngiPryecKmkJEcoYIJHXicZvYFX7AYEcZ7i3b4
         ihpkDajKD/R6XjjopKGyANFH96CxYLd/OeB3IMgSRNZtpDXLy1yxu1kDiiRgaP1Irfe6
         iYeKisblOHt5TBCRfT9NrV8GnCc/iI0ssOEnB727ZbN38LW6wJ6Rffh3MqGncdvG49oc
         GeLA==
X-Gm-Message-State: AFqh2koIv5BosIjuD/xP1uJNBpiZXzU8P2UB16q9oDjFboUh/56FI8AX
        uTFcX0uMYH2742F2+H5bnwY=
X-Google-Smtp-Source: AMrXdXtUBqYBEIxrsJKqTu09+T3ZT0gu9pPa3HUapKJ2qs+dCmOBEnr0MCnQ3Ef60Bfemm9khGBqhg==
X-Received: by 2002:a05:6102:1626:b0:3ce:c261:e8e with SMTP id cu38-20020a056102162600b003cec2610e8emr4716733vsb.17.1673022089152;
        Fri, 06 Jan 2023 08:21:29 -0800 (PST)
Received: from [192.168.178.136] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id w22-20020a05620a425600b006cbc00db595sm747029qko.23.2023.01.06.08.21.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 08:21:28 -0800 (PST)
Message-ID: <0b277149-867b-8acf-30d8-2cd68ba24c99@gmail.com>
Date:   Fri, 6 Jan 2023 17:21:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2] brcmfmac: Prefer DT board type over DMI board type
Content-Language: en-US
To:     "Ivan T. Ivanov" <iivanov@suse.de>, marcan@marcan.st
Cc:     franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        rmk+kernel@armlinux.org.uk, stefan.wahren@i2se.com,
        pbrobinson@gmail.com, jforbes@fedoraproject.org, kvalo@kernel.org,
        davem@davemloft.net, devicetree@vger.kernel.org,
        edumazet@google.com, krzysztof.kozlowski+dt@linaro.org,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, stable@vger.kernel.org
References: <20230106131905.81854-1-iivanov@suse.de>
From:   Arend Van Spriel <aspriel@gmail.com>
In-Reply-To: <20230106131905.81854-1-iivanov@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/6/2023 2:19 PM, Ivan T. Ivanov wrote:
> The introduction of support for Apple board types inadvertently changed
> the precedence order, causing hybrid SMBIOS+DT platforms to look up the
> firmware using the DMI information instead of the device tree compatible
> to generate the board type. Revert back to the old behavior,
> as affected platforms use firmwares named after the DT compatible.
> 
> Fixes: 7682de8b3351 ("wifi: brcmfmac: of: Fetch Apple properties")
> 
> [1] https://bugzilla.opensuse.org/show_bug.cgi?id=1206697#c13
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Ivan T. Ivanov <iivanov@suse.de>

Looks good to me. I do have a question about the devicetree node for 
brcmfmac. The driver does a compatible check against 
"brcm,bcm4329-fmac". I actually expect all devicetree specifications to 
use this. That said I noticed the check for it in brcmf_of_probe() 
should be moved so it is the first check done.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Reviewed-by: Hector Martin <marcan@marcan.st>
> ---
> Changes since v1
> Rewrite commit message according feedback.
> https://lore.kernel.org/all/20230106072746.29516-1-iivanov@suse.de/
> 
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> index a83699de01ec..fdd0c9abc1a1 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> @@ -79,7 +79,8 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
>   	/* Apple ARM64 platforms have their own idea of board type, passed in
>   	 * via the device tree. They also have an antenna SKU parameter
>   	 */
> -	if (!of_property_read_string(np, "brcm,board-type", &prop))
> +	err = of_property_read_string(np, "brcm,board-type", &prop);
> +	if (!err)
>   		settings->board_type = prop;
>   
>   	if (!of_property_read_string(np, "apple,antenna-sku", &prop))
> @@ -87,7 +88,7 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
>   
>   	/* Set board-type to the first string of the machine compatible prop */
>   	root = of_find_node_by_path("/");
> -	if (root && !settings->board_type) {
> +	if (root && err) {
>   		char *board_type;
>   		const char *tmp;
>   
