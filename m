Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C17F4885C7
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 21:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbiAHUD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 15:03:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232587AbiAHUD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 15:03:56 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869A2C061401
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 12:03:55 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id a18so35283916edj.7
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 12:03:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:in-reply-to;
        bh=ZUogIT+gcT2kOLa/Mbkv8A+dNloVXELHFhfvyez2skw=;
        b=OIQWZyU3eMiC3QT6DQc0cRRmrGrLXCo0eQTrQbIXxpj4kPFd3AKOtwc6+s+htCOyXz
         ADWLmrZt2V8iqXRA3gRQX8SEKDM8XC9Ljup1BPxzgPM4ikG0On2hrNxX1wgHFKtoUb7k
         SSWcYH/xkl7dJ4zVU7Ntcbgr3bDPFxkoHb02g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:in-reply-to;
        bh=ZUogIT+gcT2kOLa/Mbkv8A+dNloVXELHFhfvyez2skw=;
        b=3CzgblVUpUH/FRijM5Roj/RZKIvU3gRgjUp7o1GVSfKtH0Geb4ESCHFArFy/+bXQL2
         ZVS7irZrQ6SzHmILOUiCPxVXNEyArr5EzLwy/IP4WBPDRIvgK5DXXlREhA9LblBRjTZe
         5Ty73k0a6eSMQ/silBT45Dm9/hJ7G6jhvLJiM+5SDJ/TLe2vkk0w7mEfEY9aUYORjRlR
         iQ0l9e+92pQlIUM8hjTU7dYum024PouTfxSDpC0TdaTMXFuX+sJa7t+gMpIARJMUXIv/
         UZO4GsPXyceRnOJIDM5+YWcUuxHiADN6AH/vyrB3XWSKT5gupa2yKFm1S2ciLxG2yBAu
         itvA==
X-Gm-Message-State: AOAM531bxIV0LpbEbFQqmSo9kW4ksmF1SxbAhxKhWFCEBsz+RUkqGMtA
        nStA+8TAfnbnKMeVqNySd+emZg==
X-Google-Smtp-Source: ABdhPJxEj5QtxYp69Tu/sjz+rj4m98k40ICyCTgmMYaTtewbUseT2NOzXo6otD2YrgkQ9GXwCaE10A==
X-Received: by 2002:a17:906:b151:: with SMTP id bt17mr54435508ejb.193.1641672234004;
        Sat, 08 Jan 2022 12:03:54 -0800 (PST)
Received: from [192.168.178.136] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id cm12sm1123654edb.6.2022.01.08.12.03.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Jan 2022 12:03:52 -0800 (PST)
Message-ID: <ce80bf55-dad7-4f25-765b-67648007a651@broadcom.com>
Date:   Sat, 8 Jan 2022 21:03:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH v2 08/35] brcmfmac: of: Fetch Apple properties
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
        Wright Feng <wright.feng@infineon.com>,
        Dmitry Osipenko <digetx@gmail.com>
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
References: <20220104072658.69756-1-marcan@marcan.st>
 <20220104072658.69756-9-marcan@marcan.st>
In-Reply-To: <20220104072658.69756-9-marcan@marcan.st>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000005d034905d5179a7d"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000005d034905d5179a7d
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/4/2022 8:26 AM, Hector Martin wrote:
> On Apple ARM64 platforms, firmware selection requires two properties
> that come from system firmware: the module-instance (aka "island", a
> codename representing a given hardware platform) and the antenna-sku.
> We map Apple's module codenames to board_types in the form
> "apple,<module-instance>".
> 
> The mapped board_type is added to the DTS file in that form, while the
> antenna-sku is forwarded by our bootloader from the Apple Device Tree
> into the FDT. Grab them from the DT so firmware selection can use
> them.
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Hector Martin <marcan@marcan.st>
> ---
>   .../wireless/broadcom/brcm80211/brcmfmac/common.h    |  1 +
>   .../net/wireless/broadcom/brcm80211/brcmfmac/of.c    | 12 +++++++++++-
>   2 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
> index 8b5f49997c8b..d4aa25d646fe 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
> @@ -50,6 +50,7 @@ struct brcmf_mp_device {
>   	bool		ignore_probe_fail;
>   	struct brcmfmac_pd_cc *country_codes;
>   	const char	*board_type;
> +	const char	*antenna_sku;
>   	union {
>   		struct brcmfmac_sdio_pd sdio;
>   	} bus;
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> index 513c7e6421b2..085d34176b78 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> @@ -63,14 +63,24 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
>   {
>   	struct brcmfmac_sdio_pd *sdio = &settings->bus.sdio;
>   	struct device_node *root, *np = dev->of_node;
> +	const char *prop;
>   	int irq;
>   	int err;
>   	u32 irqf;
>   	u32 val;
>   
> +	/* Apple ARM64 platforms have their own idea of board type, passed in
> +	 * via the device tree. They also have an antenna SKU parameter
> +	 */
> +	if (!of_property_read_string(np, "brcm,board-type", &prop))
> +		settings->board_type = devm_kstrdup(dev, prop, GFP_KERNEL);
> +
> +	if (!of_property_read_string(np, "apple,antenna-sku", &prop))
> +		settings->antenna_sku = devm_kstrdup(dev, prop, GFP_KERNEL);
> +
>   	/* Set board-type to the first string of the machine compatible prop */
>   	root = of_find_node_by_path("/");

I assume this only returns NULL when there is no device tree. Is that a 
safe assumption (Rob)? If so you could bail out here if root is NULL...

> -	if (root) {
> +	if (root && !settings->board_type) {

...and only check the board_type here. Or only check board_type and 
lookup the root node inside this if-statement if it is not needed 
elsewhere in this probe function.

>   		int i, len;
>   		char *board_type;
>   		const char *tmp;

--0000000000005d034905d5179a7d
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
XSlOP9s1dqWlRRnnNxV7BVC87lkKKy0+1M2DOF6qRYQlnW4EfOyCToYLAG5zeV+AjepMoX6J9bUz
yj4BlDtwH4HFjaRIlPPbdLshUA54/tV84x8woATuLGBq+hTZEpkZAgMBAAGjggHdMIIB2TAOBgNV
HQ8BAf8EBAMCBaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRwOi8vc2VjdXJl
Lmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcnQwQQYI
KwYBBQUHMAGGNWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24y
Y2EyMDIwME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3
dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRCMEAwPqA8oDqG
OGh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3Js
MCcGA1UdEQQgMB6BHGFyZW5kLnZhbnNwcmllbEBicm9hZGNvbS5jb20wEwYDVR0lBAwwCgYIKwYB
BQUHAwQwHwYDVR0jBBgwFoAUljPR5lgXWzR1ioFWZNW+SN6hj88wHQYDVR0OBBYEFKb+3b9pz8zo
0QsCHGb/p0UrBlU+MA0GCSqGSIb3DQEBCwUAA4IBAQCHisuRNqP0NfYfG3U3XF+bocf//aGLOCGj
NvbnSbaUDT/ZkRFb9dQfDRVnZUJ7eDZWHfC+kukEzFwiSK1irDPZQAG9diwy4p9dM0xw5RXSAC1w
FzQ0ClJvhK8PsjXF2yzITFmZsEhYEToTn2owD613HvBNijAnDDLV8D0K5gtDnVqkVB9TUAGjHsmo
aAwIDFKdqL0O19Kui0WI1qNsu1tE2wAZk0XE9FG0OKyY2a2oFwJ85c5IO0q53U7+YePIwv4/J5aP
OGM6lFPJCVnfKc3H76g/FyPyaE4AL/hfdNP8ObvCB6N/BVCccjNdglRsL2ewttAG3GM06LkvrLhv
UCvjMYICbTCCAmkCAQEwazBbMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1z
YTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMgUGVyc29uYWxTaWduIDIgQ0EgMjAyMAIMMSnY
h9J/RI6gsHbuMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCCl8msug+Mvk01mlJaw
y+VNxUWgjqgLsv6pfn+kbe797TAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0yMjAxMDgyMDAzNTRaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCGSAFl
AwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAmd/7fji1nmSw43x1It4wB08tw4GOhnGHo+Tq
UQ4JQytSLoT32gy+BKdlvlo8Y95I1XGJJP27VlxHnXtHLH54BokXHLrKfYNUZpsBhSM4yVTf856a
sPdCNTDLYW0BEUCYkXC7MGaPuCK5o2aS7AX8ziauVHRQBJdOiftuIr6FOYpVnKgXewEcyG+PtkSg
WpXApnbKhySdRuxIa9PoUCsQx5dUPD9rDdkanfSAQ7v0wIdN3tM3/T7DzDWPqRgjeN2x+xWgcy91
0nHmKuOuQSLdx0itLB0wqoVOPUzUGoR3zPdbkKFfERfM+XfQ7FI+X5DLtAzTrM8iCP2Gx1FxMB/L
Ig==
--0000000000005d034905d5179a7d--
