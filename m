Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C6B4891D7
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 08:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240112AbiAJHgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 02:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241560AbiAJHf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 02:35:57 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FDE8C025269
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 23:31:18 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id q25so41238365edb.2
        for <netdev@vger.kernel.org>; Sun, 09 Jan 2022 23:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to;
        bh=2qcjaleteJ+aVNUpiimF3SdhVBmhoBy7n9muTnJq+IM=;
        b=SXuMYCW7PC+w1kPP6ko34xrj+CToM/u+9OPwgYnr4lbKt+gmEKNSGxGsJ45kC1meI0
         P8PjVELYrGpSqeWsGMBf6ieoz/EvwrAAitgeixgKjP/sNEjr8XCcNAEFJyJpCPXoePP7
         myNoXqm9UfZ9wqgyM+PK21URsKz0tMI3bd0yE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to;
        bh=2qcjaleteJ+aVNUpiimF3SdhVBmhoBy7n9muTnJq+IM=;
        b=16CVRlGOn58gWqkajC2xXjokYHE/LX91tfiJTxQw7WMcx1hDvTcmYZoXBqgwf2eL3F
         nj8ilcvTLV9luayEa5GAYiG1RtiopBxHg6errxUb6nLoupOHJSALZ/WkBV/vEAstnHoG
         0b3vMzGJJVvBJq4+1afg9NBOki9oc7oWhrRP6313aSItO4KnUhPoevXjrPXiWossUmyk
         ksvaemxTrfg1HvIe5UOcmYYM1OwdGThrw7kBfkLOO8ec7EyY2Q1SjmMTTmZKPCho/cRa
         rWTXk5xvc3LeDm/Igv+0Qlco+3EcVaKBy8MjjJBSSlugd4LgDb2iYsNgS2AMykpwt2UN
         04QA==
X-Gm-Message-State: AOAM530fDpixY29P4RSw+Vk1SL9rTUettDKe9H9ecwpexIv/6uCTdf4M
        Huaej0bARwDQZlDHBeuyyQ2Yaw==
X-Google-Smtp-Source: ABdhPJzcqUFUcyau+JE99UOL3CsWj/phSfOLhbnr8767xEwydrl/xib9+q0VG6B1t0ak4+R9Rh3Bmg==
X-Received: by 2002:a17:907:7fa9:: with SMTP id qk41mr59746482ejc.422.1641799876948;
        Sun, 09 Jan 2022 23:31:16 -0800 (PST)
Received: from [192.168.178.136] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id sc3sm2106026ejc.93.2022.01.09.23.31.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Jan 2022 23:31:15 -0800 (PST)
Message-ID: <1224597a-960c-71dd-817b-9f857697c9c6@broadcom.com>
Date:   Mon, 10 Jan 2022 08:31:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 13/35] brcmfmac: pcie: Support PCIe core revisions >=
 64
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
 <20220104072658.69756-14-marcan@marcan.st>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <20220104072658.69756-14-marcan@marcan.st>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000078284605d53552e3"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000078284605d53552e3
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/4/2022 8:26 AM, Hector Martin wrote:
> These newer PCIe core revisions include new sets of registers that must
> be used instead of the legacy ones. Introduce a brcmf_pcie_reginfo to
> hold the specific register offsets and values to use for a given
> platform, and change all the register accesses to indirect through it.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Hector Martin <marcan@marcan.st>
> ---
>   .../broadcom/brcm80211/brcmfmac/pcie.c        | 125 +++++++++++++++---
>   1 file changed, 105 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> index 595815164e18..f3744e806157 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> @@ -118,6 +118,12 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
>   #define BRCMF_PCIE_PCIE2REG_H2D_MAILBOX_0	0x140
>   #define BRCMF_PCIE_PCIE2REG_H2D_MAILBOX_1	0x144
>   
> +#define BRCMF_PCIE_64_PCIE2REG_INTMASK		0xC14
> +#define BRCMF_PCIE_64_PCIE2REG_MAILBOXINT	0xC30
> +#define BRCMF_PCIE_64_PCIE2REG_MAILBOXMASK	0xC34
> +#define BRCMF_PCIE_64_PCIE2REG_H2D_MAILBOX_0	0xA20
> +#define BRCMF_PCIE_64_PCIE2REG_H2D_MAILBOX_1	0xA24
> +
>   #define BRCMF_PCIE2_INTA			0x01
>   #define BRCMF_PCIE2_INTB			0x02
>   
> @@ -137,6 +143,8 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
>   #define	BRCMF_PCIE_MB_INT_D2H3_DB0		0x400000
>   #define	BRCMF_PCIE_MB_INT_D2H3_DB1		0x800000
>   
> +#define BRCMF_PCIE_MB_INT_FN0			(BRCMF_PCIE_MB_INT_FN0_0 | \
> +						 BRCMF_PCIE_MB_INT_FN0_1)
>   #define BRCMF_PCIE_MB_INT_D2H_DB		(BRCMF_PCIE_MB_INT_D2H0_DB0 | \
>   						 BRCMF_PCIE_MB_INT_D2H0_DB1 | \
>   						 BRCMF_PCIE_MB_INT_D2H1_DB0 | \
> @@ -146,6 +154,40 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
>   						 BRCMF_PCIE_MB_INT_D2H3_DB0 | \
>   						 BRCMF_PCIE_MB_INT_D2H3_DB1)
>   
> +#define	BRCMF_PCIE_64_MB_INT_D2H0_DB0		0x1
> +#define	BRCMF_PCIE_64_MB_INT_D2H0_DB1		0x2
> +#define	BRCMF_PCIE_64_MB_INT_D2H1_DB0		0x4
> +#define	BRCMF_PCIE_64_MB_INT_D2H1_DB1		0x8
> +#define	BRCMF_PCIE_64_MB_INT_D2H2_DB0		0x10
> +#define	BRCMF_PCIE_64_MB_INT_D2H2_DB1		0x20
> +#define	BRCMF_PCIE_64_MB_INT_D2H3_DB0		0x40
> +#define	BRCMF_PCIE_64_MB_INT_D2H3_DB1		0x80

Just an observation. So these are legacy ones with a 16 bit right shift...

> +#define	BRCMF_PCIE_64_MB_INT_D2H4_DB0		0x100
> +#define	BRCMF_PCIE_64_MB_INT_D2H4_DB1		0x200
> +#define	BRCMF_PCIE_64_MB_INT_D2H5_DB0		0x400
> +#define	BRCMF_PCIE_64_MB_INT_D2H5_DB1		0x800
> +#define	BRCMF_PCIE_64_MB_INT_D2H6_DB0		0x1000
> +#define	BRCMF_PCIE_64_MB_INT_D2H6_DB1		0x2000
> +#define	BRCMF_PCIE_64_MB_INT_D2H7_DB0		0x4000
> +#define	BRCMF_PCIE_64_MB_INT_D2H7_DB1		0x8000

...and these are new doorbell interrupts.

--00000000000078284605d53552e3
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
h9J/RI6gsHbuMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCCC8jysogIQKI0Bvql0
tk7WdbpnA/BKmufIVcbxPsoO7TAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0yMjAxMTAwNzMxMTdaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCGSAFl
AwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAjxt2/L6igEP+CMWj0XQbPBtjGO9v5Qj6CP6y
3vhx0WFW7B3ZmXjSkYX24PPv1ehrC2LZmMWzWw3TZjrrcZpbcYC2BpJhc2auRZtki+CKzzrggPqp
HjBD6ThNjbUT/iNe8osf/wX1SmI07QUAxRip7MOHeb5EqfNCxo77/gktEwcvOT4Lz3NHIMLB4Fhx
bWjmrSY1yIvrFtkeHye/ljb1CEZp31VYVecxulpKzbrPD6rawGP9ig6rO/yURSEY6pY8euuu1wQm
/QTtZCFazzVWpaDX9+rFIVr3V7U796ZcCmi1tcFANLL1MUYmIBxO/8mRRkYJXguCTv9WaJheWBXa
Mw==
--00000000000078284605d53552e3--
