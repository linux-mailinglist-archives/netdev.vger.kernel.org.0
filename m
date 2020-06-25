Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227AE20A3BB
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 19:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406671AbgFYRJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 13:09:28 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37465 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404317AbgFYRJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 13:09:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593104964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5CfCap0F3wZuekOuBaQ6nE/M+wEkk6ovUVrJUS5pGSM=;
        b=ipf6+WdyDvGjXi0vDOqnHkp767cXCwHV0q/KjLSAIO2ra3sRFBx55YscUpmYV1G1CQCV0O
        ljfCwPcxkQcWeCgl8BRWdN5r/MBBh9gxngP6aDjLuC9BJCkJLpgW8cXPFO18v0E1xW5TT7
        PYlDYWVrPgufc8d69pdTPtf3FIwS6rA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-pcEEcc63PVGrS9MHXyJr-Q-1; Thu, 25 Jun 2020 13:09:22 -0400
X-MC-Unique: pcEEcc63PVGrS9MHXyJr-Q-1
Received: by mail-ej1-f71.google.com with SMTP id op28so3853054ejb.15
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 10:09:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5CfCap0F3wZuekOuBaQ6nE/M+wEkk6ovUVrJUS5pGSM=;
        b=SepTx+PdZ24C0IiLyoEXAIu+3oThoVpvipnl6266za2kLjMZnffNFq/isP5NkpH9lE
         Dx/8Hv8WmCOijp+zmVD/NcNvcb28e+D55Gymh4o4XVfzA9bYBKWVn90S8XuhLTb2X8c3
         w74nIC/Ch8M076N3W3fns1MZf3fJ1E+oFKYSPFRMnUVvJQpH8rM4GdzVxnPOAkujqvgA
         XKe2N18qBniSD9QgJynSR3VaP15mAo4jaCHeI565EH5rhyXNKUnuX9IYtyHPEGENlAgD
         EC5tAEoND0Ur/dluJyPw4tJSjWH05g/5HQ7y5unGq5anE5HdiQ1QbHATrQ01mI606uz0
         daOg==
X-Gm-Message-State: AOAM532KZmYk3TdDzEL+nHP0bs7+GQHXbg9VWIUcogbyCV9agJ9eNYun
        iSju22o7BoRJMoUZgt5zhTr1vNW1Giiw+N9FtFrcyIyT+p0nXdKRC8okXti+WsYE+yOj0Mn9Aei
        s3dSuPSELTTwc3SGi
X-Received: by 2002:a50:9f6a:: with SMTP id b97mr7418218edf.322.1593104961203;
        Thu, 25 Jun 2020 10:09:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZTjd/YE7d5FmBNF9ZnN/QkhB3RzdoBfx/jxbtUHsAmF7gle9idP0YebzTqxtW7V6HeE10/w==
X-Received: by 2002:a50:9f6a:: with SMTP id b97mr7418199edf.322.1593104961004;
        Thu, 25 Jun 2020 10:09:21 -0700 (PDT)
Received: from x1.localdomain ([2a0e:5700:4:11:334c:7e36:8d57:40cb])
        by smtp.gmail.com with ESMTPSA id e20sm17061524ejh.22.2020.06.25.10.09.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 10:09:20 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: Transform compatible string for FW loading
To:     matthias.bgg@kernel.org, arend.vanspriel@broadcom.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chi-hsien.lin@cypress.com, wright.feng@cypress.com,
        mbrugger@suse.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200625160725.31581-1-matthias.bgg@kernel.org>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <389d35d9-fb94-b5fd-7b87-9511dacad0b2@redhat.com>
Date:   Thu, 25 Jun 2020 19:09:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200625160725.31581-1-matthias.bgg@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 6/25/20 6:07 PM, matthias.bgg@kernel.org wrote:
> From: Matthias Brugger <mbrugger@suse.com>
> 
> The driver relies on the compatible string from DT to determine which
> FW configuration file it should load. The DTS spec allows for '/' as
> part of the compatible string. We change this to '-' so that we will
> still be able to load the config file, even when the compatible has a
> '/'. This fixes explicitly the firmware loading for
> "solidrun,cubox-i/q".
> 
> Signed-off-by: Matthias Brugger <mbrugger@suse.com>
> ---
>   .../wireless/broadcom/brcm80211/brcmfmac/of.c  | 18 +++++++++++++++---
>   1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> index b886b56a5e5a..8a41b7f9cad3 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> @@ -17,7 +17,6 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
>   {
>   	struct brcmfmac_sdio_pd *sdio = &settings->bus.sdio;
>   	struct device_node *root, *np = dev->of_node;
> -	struct property *prop;
>   	int irq;
>   	u32 irqf;
>   	u32 val;
> @@ -25,8 +24,21 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
>   	/* Set board-type to the first string of the machine compatible prop */
>   	root = of_find_node_by_path("/");
>   	if (root) {
> -		prop = of_find_property(root, "compatible", NULL);
> -		settings->board_type = of_prop_next_string(prop, NULL);
> +		int i;
> +		char *board_type;
> +		const char *tmp;
> +
> +		of_property_read_string_index(root, "compatible", 0, &tmp);
> +
> +		/* get rid of '/' in the compatible string to be able to find the FW */
> +		board_type = devm_kzalloc(dev, strlen(tmp), GFP_KERNEL);

strlen() needs to be strlen() + 1 here to make place for the terminating zero.

> +		strncpy(board_type, tmp, strlen(tmp));

Please do not us strncpy, it is THE worst strcpy function
in existence, it does not guarantee 0 termination, so
it sucks, it sucks a lot do not use, thanks.

Instead use strlcpy or snprintf(..., "%s", ...)

> +		for (i = 0; i < strlen(board_type); i++) {

(The strlen here relies on there being a 0 behind the memory you
allocated because of the missing + 1)

> +			if (board_type[i] == '/')
> +				board_type[i] = '-';
> +		}
> +		settings->board_type = board_type;
> +
>   		of_node_put(root);
>   	}
>   
> 

Otherwise this looks good to me.

Regards,

Hans

