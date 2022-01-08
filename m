Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F85F4885C0
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 21:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbiAHUD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 15:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbiAHUD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 15:03:28 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D50C061401
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 12:03:27 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id a18so35281037edj.7
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 12:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to;
        bh=kgFqJoU6h4KzLWsY4tqhp0yy6+BJf16M0dK0dPSHoxc=;
        b=DeNnRDI/GXA4+n6Tofa9SsZkpjFCpbPPdBt53ojEl4P+I9CvummRp7OidPE5aF5Fnd
         knAdgqlvKTleAtBmpsmN1oK5t0XuaouVOnoQSCkam2bkfltCnQuM7dof62noU2SNn3Lc
         JDv1Sjvsf8fyUUpSrbuIBiZY3mGGbXqiOyrcA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to;
        bh=kgFqJoU6h4KzLWsY4tqhp0yy6+BJf16M0dK0dPSHoxc=;
        b=K4zGdKNypxh0Yh5FtfItU12O4MhBpwoDAi4AHMcWIHQYS73W4YasvTbD7PHgHqUfiM
         BSiu0pRBMPN+hCPHUnUQK7SYx1JOZ7LabwMEIy2R5zo3zTYPVqmpqcCbdlIe3gqZhuKI
         OUja1WczuahKbVQbutWeq8rZg4/9zpW0KxgmYuUt323tmuYhLAGqhDWgZ8MwuaW8iNvq
         JOV5/VBH/3JB88sORLUhXk+VBcSoU/L/Ng/Y9med2lG34gAXD/9BoRgwfRzUJbO3BbCx
         lIT4oge8igfx/PPepGY6I+Z4WuCuW+JwVgPXTcI9bwY1iCjz1/TQp/K6dtUwgiQBY57k
         Iywg==
X-Gm-Message-State: AOAM533lxRlPZpzTY9zv3dArQB5O8H9qcMzxBAaL+gUC7rP3sfjEwMQk
        5l3EnvVkpWH8vqkbMlsw0jnVRg==
X-Google-Smtp-Source: ABdhPJxOG3HajlEIK91A5aC9LG0/ayYQT2g9rcWtdkw+//IjK2AuS3X+m4dQ6tqxvqrwMJfEVQ/VPw==
X-Received: by 2002:a17:907:a427:: with SMTP id sg39mr57015014ejc.158.1641672205875;
        Sat, 08 Jan 2022 12:03:25 -0800 (PST)
Received: from [192.168.178.136] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id j17sm756558ejg.164.2022.01.08.12.03.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Jan 2022 12:03:24 -0800 (PST)
Message-ID: <0e169c4e-ce51-3592-f114-46cb3cde1f7d@broadcom.com>
Date:   Sat, 8 Jan 2022 21:03:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 09/35] brcmfmac: pcie: Perform firmware selection for
 Apple platforms
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
 <20220104072658.69756-10-marcan@marcan.st>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <20220104072658.69756-10-marcan@marcan.st>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000afee5f05d51798be"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000afee5f05d51798be
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/4/2022 8:26 AM, Hector Martin wrote:
> On Apple platforms, firmware selection uses the following elements:
> 
>    Property         Example   Source
>    ==============   =======   ========================
> * Chip name        4378      Device ID
> * Chip revision    B1        OTP
> * Platform         shikoku   DT (ARM64) or ACPI (x86)
> * Module type      RASP      OTP
> * Module vendor    m         OTP
> * Module version   6.11      OTP
> * Antenna SKU      X3        DT (ARM64) or ACPI (x86)
> 
> In macOS, these firmwares are stored using filenames in this format
> under /usr/share/firmware/wifi:
> 
>      C-4378__s-B1/P-shikoku-X3_M-RASP_V-m__m-6.11.txt
> 
> To prepare firmwares for Linux, we rename these to a scheme following
> the existing brcmfmac convention:
> 
>      brcmfmac<chip><lower(rev)>-pcie.apple,<platform>-<mod_type>-\
> 	<mod_vendor>-<mod_version>-<antenna_sku>.txt
> 
> The NVRAM uses all the components, while the firmware and CLM blob only
> use the chip/revision/platform/antenna_sku:
> 
>      brcmfmac<chip><lower(rev)>-pcie.apple,<platform>-<antenna_sku>.bin
> 
> e.g.
> 
>      brcm/brcmfmac4378b1-pcie.apple,shikoku-RASP-m-6.11-X3.txt
>      brcm/brcmfmac4378b1-pcie.apple,shikoku-X3.bin
> 
> In addition, since there are over 1000 files in total, many of which are
> symlinks or outright duplicates, we deduplicate and prune the firmware
> tree to reduce firmware filenames to fewer dimensions. For example, the
> shikoku platform (MacBook Air M1 2020) simplifies to just 4 files:
> 
>      brcm/brcmfmac4378b1-pcie.apple,shikoku.clm_blob
>      brcm/brcmfmac4378b1-pcie.apple,shikoku.bin
>      brcm/brcmfmac4378b1-pcie.apple,shikoku-RASP-m.txt
>      brcm/brcmfmac4378b1-pcie.apple,shikoku-RASP-u.txt
> 
> This reduces the total file count to around 170, of which 75 are
> symlinks and 95 are regular files: 7 firmware blobs, 27 CLM blobs, and
> 61 NVRAM config files. We also slightly process NVRAM files to correct
> some formatting issues.
> 
> To handle this, the driver must try the following path formats when
> looking for firmware files:
> 
>      brcm/brcmfmac4378b1-pcie.apple,shikoku-RASP-m-6.11-X3.txt
>      brcm/brcmfmac4378b1-pcie.apple,shikoku-RASP-m-6.11.txt
>      brcm/brcmfmac4378b1-pcie.apple,shikoku-RASP-m.txt
>      brcm/brcmfmac4378b1-pcie.apple,shikoku-RASP.txt
>      brcm/brcmfmac4378b1-pcie.apple,shikoku-X3.txt *
>      brcm/brcmfmac4378b1-pcie.apple,shikoku.txt
> 
> * Not relevant for NVRAM, only for firmware/CLM.
> 
> The chip revision nominally comes from OTP on Apple platforms, but it
> can be mapped to the PCI revision number, so we ignore the OTP revision
> and continue to use the existing PCI revision mechanism to identify chip
> revisions, as the driver already does for other chips. Unfortunately,
> the mapping is not consistent between different chip types, so this has
> to be determined experimentally.

Not sure I understand this. The chip revision comes from the chipcommon 
register [1]. Maybe that is what you mean by "PCI revision number". For 
some chips it is possible OTP is used to override that.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Hector Martin <marcan@marcan.st>
> ---
>   .../broadcom/brcm80211/brcmfmac/pcie.c        | 58 ++++++++++++++++++-
>   1 file changed, 56 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> index 74c9a4f74813..250e0bd40cb3 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> @@ -2094,8 +2094,62 @@ brcmf_pcie_prepare_fw_request(struct brcmf_pciedev_info *devinfo)
>   	fwreq->domain_nr = pci_domain_nr(devinfo->pdev->bus) + 1;
>   	fwreq->bus_nr = devinfo->pdev->bus->number;
>   
> -	brcmf_dbg(PCIE, "Board: %s\n", devinfo->settings->board_type);
> -	fwreq->board_types[0] = devinfo->settings->board_type;
> +	/* Apple platforms with fancy firmware/NVRAM selection */
> +	if (devinfo->settings->board_type &&
> +	    devinfo->settings->antenna_sku &&
> +	    devinfo->otp.valid) {
> +		char *buf;
> +		int len;
> +
> +		brcmf_dbg(PCIE, "Apple board: %s\n",
> +			  devinfo->settings->board_type);

maybe good to use local reference for devinfo->settings->board_type, 
which is used several times below.

> +
> +		/* Example: apple,shikoku-RASP-m-6.11-X3 */
> +		len = (strlen(devinfo->settings->board_type) + 1 +
> +		       strlen(devinfo->otp.module) + 1 +
> +		       strlen(devinfo->otp.vendor) + 1 +
> +		       strlen(devinfo->otp.version) + 1 +
> +		       strlen(devinfo->settings->antenna_sku) + 1);
> +
> +		/* apple,shikoku */
> +		fwreq->board_types[5] = devinfo->settings->board_type;

[1] 
https://elixir.bootlin.com/linux/latest/source/include/linux/bcma/bcma_driver_chipcommon.h#L12

--000000000000afee5f05d51798be
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
h9J/RI6gsHbuMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCDsnc8BBY4UFK4vmPhe
chPqQa5ul+YB+LivRDlveMD7uTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0yMjAxMDgyMDAzMjZaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCGSAFl
AwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEATgRX/OsfHEqeY22wFGwGBp/Ul+kGNKh2x0De
TSsxqZO9YUpXf7P+1pAKU4rUxCYolVHZw4ATtUgBz6vh7J5skkAM0vOpUI3DDs/z7NYBoRH0kv7p
bcWJHK9Jf3G+Yzbk9b8i/l5aYPd/t5p65yfH89ThxSU6v4A2Dqh+rsnJ66kHlT2H3ud3fr+ACXQ6
RNXyisODf3MH6N75wX3lsUpZgICtX715WHsr+YvM/mHEBStyriyrFy9ZpNCs3g8/DbFlrRv4OJXC
DjgmYCkg+WL8FtFUFU1mq0KZXB4JeWqWMm7W+bJiAfBijBHkstkrRxeTOKAVznnuVGQ6peZ5c/Im
4Q==
--000000000000afee5f05d51798be--
