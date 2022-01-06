Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03848486311
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 11:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238057AbiAFKnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 05:43:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238018AbiAFKnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 05:43:10 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70B3C061212
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 02:43:09 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id g186-20020a1c9dc3000000b0034755f8fa58so211676wme.0
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 02:43:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to;
        bh=11Y5VgihKUEd59V0gBIwOYu47xW9MUJjQRz3XL8MhpI=;
        b=gfQYVIxdqL0F0DwrCqKFzR/8FTvwBiB4BLZ5j5EizSb2sDhMmmPKlDDteb9ReftysK
         gClZlEB/40mfbOztyDif8+r6OeN5ZwaNoNLxV2YyFGEa8KCi3k9S24PjihnhO3kkEYy4
         rED2NJY0L/Hodcur8qR1n9g4YRhtXcfzSXvIc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to;
        bh=11Y5VgihKUEd59V0gBIwOYu47xW9MUJjQRz3XL8MhpI=;
        b=EPwTd3BYBPNfh1E9oqn7FB9LePx/PfTaNdd/+la4c+Wi+dmOtc4Y32p4zNWEauR90m
         /5lrO3MRcEhcFJlalI5m9sCSHbVGQkTuTN+Non8YsuGYwzPIhOcA+BoJ3OCxK//tX/5A
         rUqO8hgDZAkrhxJy5JEdGAB49HcPncT0u7Y6abfwKlsX9KAWZo6x2QX9aHmTZ1rcPHzY
         dkjRByJNVVZYVgkD0W1ZWuLmRtaJmfAUuydjhbezcTOORKzcX2VEmC8TFYVrQF0+AS5+
         oQhO4Ovj9plitNLR9Q1x+/rNPOE+uyGbQK//92WS1abz32ATqMXmyDRu66dlpxLs0Ruk
         OfQg==
X-Gm-Message-State: AOAM531PhpIuoZLbswmPu6EVWJ8ikLWYcwr6ZeIkaN9wrtP30oc9kZPp
        Lu5kmzWOfUI+e6aOr3TsZuwdpA==
X-Google-Smtp-Source: ABdhPJx9zwGFxYdLiDGT1T6vU7KlJ1fkzoZRSUQYtbDiiOgtszxwLRJ+u7xXPdQOkVYn1urb/6yt0g==
X-Received: by 2002:a7b:c194:: with SMTP id y20mr6522016wmi.79.1641465788058;
        Thu, 06 Jan 2022 02:43:08 -0800 (PST)
Received: from [192.168.178.136] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id az15sm1363805wmb.47.2022.01.06.02.43.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jan 2022 02:43:06 -0800 (PST)
Message-ID: <fd95636e-b879-0c82-a7ba-a5c239f4f611@broadcom.com>
Date:   Thu, 6 Jan 2022 11:43:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 04/35] brcmfmac: firmware: Support having multiple alt
 paths
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
 <20220104072658.69756-5-marcan@marcan.st>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <20220104072658.69756-5-marcan@marcan.st>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000003af33905d4e789ee"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000003af33905d4e789ee
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/4/2022 8:26 AM, Hector Martin wrote:
> Apple platforms have firmware and config files identified with multiple
> dimensions. We want to be able to find the most specific firmware
> available for any given platform, progressively trying more general
> firmwares.
> 
> First, add support for having multiple alternate firmware paths.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Hector Martin <marcan@marcan.st>
> ---
>   .../broadcom/brcm80211/brcmfmac/firmware.c    | 75 ++++++++++++++-----
>   .../broadcom/brcm80211/brcmfmac/firmware.h    |  2 +
>   2 files changed, 59 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> index 0497b721136a..7570dbf22cdd 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> @@ -427,6 +427,8 @@ void brcmf_fw_nvram_free(void *nvram)
>   struct brcmf_fw {
>   	struct device *dev;
>   	struct brcmf_fw_request *req;
> +	const char *alt_paths[BRCMF_FW_MAX_ALT_PATHS];
> +	int alt_index;
>   	u32 curpos;
>   	void (*done)(struct device *dev, int err, struct brcmf_fw_request *req);
>   };
> @@ -592,14 +594,18 @@ static int brcmf_fw_complete_request(const struct firmware *fw,
>   	return (cur->flags & BRCMF_FW_REQF_OPTIONAL) ? 0 : ret;
>   }
>   
> -static char *brcm_alt_fw_path(const char *path, const char *board_type)
> +static int brcm_alt_fw_paths(const char *path, const char *board_type,
> +			     const char *alt_paths[BRCMF_FW_MAX_ALT_PATHS])
>   {
>   	char alt_path[BRCMF_FW_NAME_LEN];
>   	const char *suffix;
>   
> +	memset(alt_paths, 0, array_size(sizeof(*alt_paths),
> +					BRCMF_FW_MAX_ALT_PATHS));
> +
>   	suffix = strrchr(path, '.');
>   	if (!suffix || suffix == path)
> -		return NULL;
> +		return -EINVAL;
>   
>   	/* strip extension at the end */
>   	strscpy(alt_path, path, BRCMF_FW_NAME_LEN);
> @@ -609,7 +615,18 @@ static char *brcm_alt_fw_path(const char *path, const char *board_type)
>   	strlcat(alt_path, board_type, BRCMF_FW_NAME_LEN);
>   	strlcat(alt_path, suffix, BRCMF_FW_NAME_LEN);
>   
> -	return kstrdup(alt_path, GFP_KERNEL);
> +	alt_paths[0] = kstrdup(alt_path, GFP_KERNEL);
> +
> +	return 0;
> +}
> +
> +static void
> +brcm_free_alt_fw_paths(const char *alt_paths[BRCMF_FW_MAX_ALT_PATHS])
> +{
> +	unsigned int i;
> +
> +	for (i = 0; alt_paths[i]; i++)
> +		kfree(alt_paths[i]);
>   }
>   
>   static int brcmf_fw_request_firmware(const struct firmware **fw,
> @@ -617,19 +634,25 @@ static int brcmf_fw_request_firmware(const struct firmware **fw,
>   {
>   	struct brcmf_fw_item *cur = &fwctx->req->items[fwctx->curpos];
>   	int ret;
> +	unsigned int i;
>   
>   	/* Files can be board-specific, first try a board-specific path */
>   	if (fwctx->req->board_type) {
> -		char *alt_path;
> +		const char *alt_paths[BRCMF_FW_MAX_ALT_PATHS];
>   
> -		alt_path = brcm_alt_fw_path(cur->path, fwctx->req->board_type);
> -		if (!alt_path)
> +		if (brcm_alt_fw_paths(cur->path, fwctx->req->board_type,
> +				      alt_paths) != 0)
>   			goto fallback;
>   
> -		ret = request_firmware(fw, alt_path, fwctx->dev);
> -		kfree(alt_path);
> -		if (ret == 0)
> -			return ret;
> +		for (i = 0; i < BRCMF_FW_MAX_ALT_PATHS && alt_paths[i]; i++) {
> +			ret = firmware_request_nowarn(fw, alt_paths[i],
> +						      fwctx->dev);
> +			if (ret == 0) {
> +				brcm_free_alt_fw_paths(alt_paths);
> +				return ret;
> +			}
> +		}
> +		brcm_free_alt_fw_paths(alt_paths);
>   	}
>   
>   fallback:
> @@ -641,6 +664,8 @@ static void brcmf_fw_request_done(const struct firmware *fw, void *ctx)
>   	struct brcmf_fw *fwctx = ctx;
>   	int ret;
>   
> +	brcm_free_alt_fw_paths(fwctx->alt_paths);
> +
>   	ret = brcmf_fw_complete_request(fw, fwctx);
>   
>   	while (ret == 0 && ++fwctx->curpos < fwctx->req->n_items) {
> @@ -662,13 +687,27 @@ static void brcmf_fw_request_done_alt_path(const struct firmware *fw, void *ctx)
>   	struct brcmf_fw_item *first = &fwctx->req->items[0];
>   	int ret = 0;
>   
> -	/* Fall back to canonical path if board firmware not found */
> -	if (!fw)
> +	if (fw) {
> +		brcmf_fw_request_done(fw, ctx);
> +		return;
> +	}
> +
> +	fwctx->alt_index++;
> +	if (fwctx->alt_index < BRCMF_FW_MAX_ALT_PATHS &&
> +	    fwctx->alt_paths[fwctx->alt_index]) {
> +		/* Try the next alt firmware */
> +		ret = request_firmware_nowait(THIS_MODULE, true,
> +					      fwctx->alt_paths[fwctx->alt_index],
> +					      fwctx->dev, GFP_KERNEL, fwctx,
> +					      brcmf_fw_request_done_alt_path);
> +	} else {
> +		/* Fall back to canonical path if board firmware not found */
>   		ret = request_firmware_nowait(THIS_MODULE, true, first->path,
>   					      fwctx->dev, GFP_KERNEL, fwctx,
>   					      brcmf_fw_request_done);
> +	}
>   
> -	if (fw || ret < 0)
> +	if (ret < 0)
>   		brcmf_fw_request_done(fw, ctx);
>   }
>   
> @@ -693,7 +732,6 @@ int brcmf_fw_get_firmwares(struct device *dev, struct brcmf_fw_request *req,
>   {
>   	struct brcmf_fw_item *first = &req->items[0];
>   	struct brcmf_fw *fwctx;
> -	char *alt_path;
>   	int ret;
>   
>   	brcmf_dbg(TRACE, "enter: dev=%s\n", dev_name(dev));
> @@ -712,12 +750,13 @@ int brcmf_fw_get_firmwares(struct device *dev, struct brcmf_fw_request *req,
>   	fwctx->done = fw_cb;
>   
>   	/* First try alternative board-specific path if any */
> -	alt_path = brcm_alt_fw_path(first->path, fwctx->req->board_type);
> -	if (alt_path) {
> -		ret = request_firmware_nowait(THIS_MODULE, true, alt_path,
> +	if (brcm_alt_fw_paths(first->path, req->board_type,
> +			      fwctx->alt_paths) == 0) {
> +		fwctx->alt_index = 0;
> +		ret = request_firmware_nowait(THIS_MODULE, true,
> +					      fwctx->alt_paths[0],
>   					      fwctx->dev, GFP_KERNEL, fwctx,
>   					      brcmf_fw_request_done_alt_path);
> -		kfree(alt_path);
>   	} else {
>   		ret = request_firmware_nowait(THIS_MODULE, true, first->path,
>   					      fwctx->dev, GFP_KERNEL, fwctx,
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
> index e290dec9c53d..7f4e6e359c82 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
> @@ -11,6 +11,8 @@
>   
>   #define BRCMF_FW_DEFAULT_PATH		"brcm/"
>   
> +#define BRCMF_FW_MAX_ALT_PATHS	8
> +

Any motivation to have 8 here today? In patch #9 I see a list of 6 paths 
in the commit message so you need 6 and rounded up here to power of 2?

>   /**
>    * struct brcmf_firmware_mapping - Used to map chipid/revmask to firmware
>    *	filename and nvram filename. Each bus type implementation should create

--0000000000003af33905d4e789ee
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
h9J/RI6gsHbuMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCCCE73TES+MMIPKnpZ6
5k/QH8UTo72Ep3J3yefwV0lxjzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0yMjAxMDYxMDQzMDhaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCGSAFl
AwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAfnYo3BnBX2+xJrrn1s38h5d4zgZV3N6WCREs
JpI5KycqenxSqBufPqM/oO5AmOhkgIXkK9/uNHUVcutFsjtZ4K6l5UCfZDvNE8zjlq61Elf2ZQ43
nnK/qI9DBO2BYzwT9oOYc5vQaMENcPfu67YPaFalHQiwmArqdp7Wm8aCA/EuyzhSn+Emr1WmqcWD
ff5zFdmc/b3WZbHIhbdywS7yTQTiCFE7wIGw/m8P/Aa2radLtcgOFSBtFzVoVe/vwLfPmVuZ1biv
r3lhU1sRsEwcdZKjzFoSaBo3B5T2CJ+BqF5+dA1jb/GBxR4hpLIIJJuywCyiUEj1rt6Z14u7rp6Z
+w==
--0000000000003af33905d4e789ee--
