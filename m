Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C27489763
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 12:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244702AbiAJL0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 06:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239652AbiAJL0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 06:26:25 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F53BC061759
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 03:26:21 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id y9so10840681pgr.11
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 03:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to;
        bh=6ny8Vi9KhGqBq6v5cVuCErOLgGS2bfkTxlO2bm2/W40=;
        b=NuJJKfyZTdGUJjmmuK/stQfeayhiaEmOxmHSverrHjv/J6T/33oWl14z0eNdxaB+bV
         LsTwz1Ck96yS+5pJYp0s30Rxwuydn0g1gKUNR9dAj0YM/wDK0h2T3cKCdUuIyR0QLmqp
         ptYkRPTW8PIoKgVhCFozUkqh9FB8NiQkpKpGw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to;
        bh=6ny8Vi9KhGqBq6v5cVuCErOLgGS2bfkTxlO2bm2/W40=;
        b=aJjZKwP9Rqorq8rcHnlqo/D0ocmlWHEKeN5W7mluuSCLb4Ux5EcGesSraUImNRn2PV
         qKPedJvczAMCvk42yW2DHz0VnZ6Vgrst9mjmYg2Xn8IBcRB9GqFWN3pd/5y/QCqBe7N+
         QGG3rnWhGDANu/dpOtPJ7Qe8tLCZaFoNSwG9PX9t8rj3tY7VHUr8IHSv88ENs6TChoJS
         bE+F5YOzsOkZt23ws+S8ws2Z4Jz9X3+UrQwGN7BcxTyPoALo6hUPPuTwVnD5fYPXHozC
         KfXiy4Ufncqq+CDARA/ZqP9sXwCatmZSpujoaAmByK37GBY7+XUnlbDW43LVqKjkPNwY
         MXeQ==
X-Gm-Message-State: AOAM532HzQqRC6rlLBKTjkj440xL2tHFnuKc6yAqlGqbvezFdTySTP5o
        hLiHFhRGZ+/q0PJAnUZLEIvuDw==
X-Google-Smtp-Source: ABdhPJyLgj9HvtdqraoJgeK9Kc2v7CG2uiPxLxoBQVj1I3D4oJ38HdSEziC+h3mCqyYZEtQsQlDSvg==
X-Received: by 2002:a05:6a00:14c9:b0:4bb:62ca:4e1c with SMTP id w9-20020a056a0014c900b004bb62ca4e1cmr74467264pfu.28.1641813980682;
        Mon, 10 Jan 2022 03:26:20 -0800 (PST)
Received: from [192.168.178.136] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id s30sm6594384pfw.195.2022.01.10.03.26.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 03:26:18 -0800 (PST)
Message-ID: <bdee859c-35fd-0ded-6a87-3948f6e792e2@broadcom.com>
Date:   Mon, 10 Jan 2022 12:26:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 16/35] brcmfmac: acpi: Add support for fetching Apple
 ACPI properties
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
 <20220104072658.69756-17-marcan@marcan.st>
 <d72bf3e4-1a49-d354-9439-5f52334d2698@broadcom.com>
 <908a6ded-08fb-647f-ffa2-1a5182d2f075@marcan.st>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <908a6ded-08fb-647f-ffa2-1a5182d2f075@marcan.st>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000020674d05d5389bb1"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000020674d05d5389bb1
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/10/2022 12:07 PM, Hector Martin wrote:
> On 2022/01/10 18:11, Arend van Spriel wrote:
>> On 1/4/2022 8:26 AM, Hector Martin wrote:
>>> On DT platforms, the module-instance and antenna-sku-info properties
>>> are passed in the DT. On ACPI platforms, module-instance is passed via
>>> the analogous Apple device property mechanism, while the antenna SKU
>>> info is instead obtained via an ACPI method that grabs it from
>>> non-volatile storage.
>>>
>>> Add support for this, to allow proper firmware selection on Apple
>>> platforms.
>>>
>>> Signed-off-by: Hector Martin <marcan@marcan.st>
>>> ---
>>>    .../broadcom/brcm80211/brcmfmac/Makefile      |  2 +
>>>    .../broadcom/brcm80211/brcmfmac/acpi.c        | 47 +++++++++++++++++++
>>>    .../broadcom/brcm80211/brcmfmac/common.c      |  1 +
>>>    .../broadcom/brcm80211/brcmfmac/common.h      |  9 ++++
>>>    4 files changed, 59 insertions(+)
>>>    create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c
>>
>> [...]
>>
>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c
>>> new file mode 100644
>>> index 000000000000..2b1a4448b291
>>> --- /dev/null
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c
>>> @@ -0,0 +1,47 @@
>>> +// SPDX-License-Identifier: ISC
>>> +/*
>>> + * Copyright The Asahi Linux Contributors
>>> + */
>>> +
>>> +#include <linux/acpi.h>
>>> +#include "debug.h"
>>> +#include "core.h"
>>> +#include "common.h"
>>> +
>>> +void brcmf_acpi_probe(struct device *dev, enum brcmf_bus_type bus_type,
>>> +		      struct brcmf_mp_device *settings)
>>> +{
>>> +	acpi_status status;
>>> +	const union acpi_object *o;
>>> +	struct acpi_buffer buf = {ACPI_ALLOCATE_BUFFER, NULL};
>>> +	struct acpi_device *adev = ACPI_COMPANION(dev);
>>> +
>>> +	if (!adev)
>>> +		return;
>>> +
>>> +	if (!ACPI_FAILURE(acpi_dev_get_property(adev, "module-instance",
>>> +						ACPI_TYPE_STRING, &o))) {
>>> +		brcmf_dbg(INFO, "ACPI module-instance=%s\n", o->string.pointer);
>>> +		settings->board_type = devm_kasprintf(dev, GFP_KERNEL,
>>> +						      "apple,%s",
>>> +						      o->string.pointer);
>>> +	} else {
>>> +		brcmf_dbg(INFO, "No ACPI module-instance\n");
>>
>> Do you need to obtain the antenna-sku when there is no module-instance?
> 
> In principle I don't think any machines would have antenna-sku and no
> module-instance, though the firmware selection will still work without
> it (it'll just end up using the DMI machine name instead).

Right. That was my assumption as well. I would bail out here and skip 
obtaining the antenna-sku.

>>
>>> +	}
>>> +
>>> +	status = acpi_evaluate_object(adev->handle, "RWCV", NULL, &buf);
>>
>> Can you clarify what the above does? What does the "RWCV" mean?
> 
> No idea what it *means* :-)
> 
> What it is, though, is the ACPI method name to get the antenna-sku.

Wow. So much for meaning-full naming ;-)

--00000000000020674d05d5389bb1
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
h9J/RI6gsHbuMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCApPVUj9EIxJasExeeD
R9dddmi5PnKi4nLzM8C1Y/2CyTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0yMjAxMTAxMTI2MjFaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCGSAFl
AwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAT7gq4iK9XoXCGevdYJYT2A31WqRkFNaQNjkv
KUzjO/lAZuKx9d78m0pn1JvU5LMRgUN5imTXSvhJ79l295WwRqzwzDFiF0j1B0zSVXTaXm4Ana3m
BDWagAzHVkufOXN36lnBIPidWAAVoej4+i1ZA0wsT+/GjGWgXbTTrppFT88s6erKSwQbEz07GXId
8d0SK4YOc2qQJaxMNhLFDP3lZoHBhFfvl9LHkc0BsFLe8hyibHyoll9f5YqEBh7lAq9KO1ibmS7s
LiHbeBA4PE7VYSO8C2Q8C+gWITMhlJ+6PGCyRI30qYqvmiTOaYjiTa/w9kP4ysu25tJyyB3GITA5
Eg==
--00000000000020674d05d5389bb1--
