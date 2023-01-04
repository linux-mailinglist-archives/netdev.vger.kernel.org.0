Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA9B65DCB7
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 20:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239962AbjADT0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 14:26:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239670AbjADT0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 14:26:50 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4FE15F16
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 11:26:48 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id b2so36840283pld.7
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 11:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=in-reply-to:references:cc:to:subject:from:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=BtMsyfc1z5E3Xbfd2UZgvqXj2Qzu6xsRrQKYyM7lW/Y=;
        b=Xk5sXRkLllA/jLyv7teEFzomQh8NLBM0ukNGu0PM2t0Uq4PxLWAYDhxRwj9C2jm4kw
         gsD1fOZeDWlgZQMYG5gMj5zs03Bua7PcuYHsBIf5ewVVZhommc/a/ecjF2ZaCBGJugJ3
         n6GKq2FX4QNvJSE8c9Qgy7Hr30ZRD3JOpPneY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:references:cc:to:subject:from:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BtMsyfc1z5E3Xbfd2UZgvqXj2Qzu6xsRrQKYyM7lW/Y=;
        b=tDqBEv1YukSZeuYFDqVb8BJvJBPuPbmsai8YSHDRAiSMO6hUQMkZEgi7qKA4dbiI/E
         aroVpF7tWFxxHlWYd2TtNFSnZd0Szn4Ycofuz/vMcgsaMFvPl83FJ9ExVG00kWWPstgP
         HtXTJKy6toeKmIHVwp1yUxXbatcPI2D4NAiSulfNG7w7Ksumpu9H3drXQpb/4B28bArA
         +Z4ElR/XQreyKc0LqV7Wm0j4B0EZaPGnkrnBZIhNgMXqfKGgitO4BAOYD2WWauCA+G5Y
         qy+jhQESr/wrU/xqQ2iNvKBDtpBO6ziwsPS7g4Rh4LmSflAeHXjm8jTT/96n1G3Mr4zq
         0dqQ==
X-Gm-Message-State: AFqh2koKGTLwsaowaghB7QCGB72NF/5gkZzR/LhzC3/3My1kDRdg13vR
        0GFXc4MyLT3zy8713EyipEIuMg==
X-Google-Smtp-Source: AMrXdXvPOojh9FJ9SExq8M2prj8MvqqTM1Pnd+v4v0n6LjvmBe2ZHWAp7u22skIj6d1J54Jj439QOg==
X-Received: by 2002:a17:90a:664f:b0:226:7d42:3470 with SMTP id f15-20020a17090a664f00b002267d423470mr11429810pjm.7.1672860408151;
        Wed, 04 Jan 2023 11:26:48 -0800 (PST)
Received: from [192.168.178.136] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id a14-20020a65640e000000b0049c8aa4211asm12720222pgv.8.2023.01.04.11.26.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 11:26:47 -0800 (PST)
Message-ID: <7bcc0e05-d1ec-38c1-2108-1bf9741d954c@broadcom.com>
Date:   Wed, 4 Jan 2023 20:26:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH v1 1/4] wifi: brcmfmac: Rename Cypress 89459 to BCM4355
To:     Hector Martin <marcan@marcan.st>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Alexander Prutskov <alep@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Ian Lin <ian.lin@infineon.com>,
        Soontak Lee <soontak.lee@cypress.com>,
        Joseph chuang <jiac@cypress.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        asahi@lists.linux.dev, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230104100116.729-1-marcan@marcan.st>
 <20230104100116.729-2-marcan@marcan.st>
 <6517b791-1700-970d-ac0a-847f60a6fa6f@broadcom.com>
 <d242c9e4-e551-aa7a-0f20-f3f1351648a3@marcan.st>
In-Reply-To: <d242c9e4-e551-aa7a-0f20-f3f1351648a3@marcan.st>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000699b0405f1752aa7"
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000699b0405f1752aa7
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On January 4, 2023 5:35:08 PM Hector Martin <marcan@marcan.st> wrote:

> On 04/01/2023 22.29, Arend van Spriel wrote:
>> On 1/4/2023 11:01 AM, 'Hector Martin' via BRCM80211-DEV-LIST,PDL wrote:
>>> The commit that introduced support for this chip incorrectly claimed it
>>> is a Cypress-specific part, while in actuality it is just a variant of
>>> BCM4355 silicon (as evidenced by the chip ID).
>>>
>>> The relationship between Cypress products and Broadcom products isn't
>>> entirely clear, but given what little information is available and prior
>>> art in the driver, it seems the convention should be that originally
>>> Broadcom parts should retain the Broadcom name.
>>>
>>> Thus, rename the relevant constants and firmware file. Also rename the
>>> specific 89459 PCIe ID to BCM43596, which seems to be the original
>>> subvariant name for this PCI ID (as defined in the out-of-tree bcmdhd
>>> driver). Also declare the firmware as CLM-capable, since it is.
>>>
>>> Fixes: dce45ded7619 ("brcmfmac: Support 89459 pcie")
>>> Signed-off-by: Hector Martin <marcan@marcan.st>
>>> ---
>>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c   | 5 ++---
>>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c   | 8 ++++----
>>> .../net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 6 +++---
>>> 3 files changed, 9 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c 
>>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
>>> index 121893bbaa1d..3e42c2bd0d9a 100644
>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
>>
>> [...]
>>
>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c 
>>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>>> index ae57a9a3ab05..3264be485e20 100644
>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>>
>> [...]
>>
>>> @@ -2590,6 +2590,7 @@ static const struct pci_device_id 
>>> brcmf_pcie_devid_table[] = {
>>> BRCMF_PCIE_DEVICE(BRCM_PCIE_4350_DEVICE_ID, WCC),
>>> BRCMF_PCIE_DEVICE_SUB(0x4355, BRCM_PCIE_VENDOR_ID_BROADCOM, 0x4355, WCC),
>>> BRCMF_PCIE_DEVICE(BRCM_PCIE_4354_RAW_DEVICE_ID, WCC),
>>> + BRCMF_PCIE_DEVICE(BRCM_PCIE_4355_RAW_DEVICE_ID, WCC),
>>
>> A bit of a problem here. If Cypress want to support this device,
>> regardless how they branded it, they will provide its firmware. Given
>> that they initially added it (as 89459) I suppose we should mark it with
>> CYW and not WCC. Actually, see my comment below on RAW dev ids.
>
> Right, I thought we might wind up with this issue. So then the question
> becomes: can we give responsibility over PCI ID 0x4415 to Cypress and
> mark just that one as CYW (if so it probably makes sense to keep that
> labeled CYW89459 instead of BCM43596), and if not, is there some other
> way to tell apart Cypress and Broadcom products we can use? I believe
> the Apple side firmware is developed by Broadcom, not Cypress.
>
> Note that even if we split by PCI device ID here, we still have a
> problem with firmware selection, since that means we're requesting the
> same firmware filename for both vendors (since that only tests the chip
> ID and revision ID). If Apple is the *only* Broadcom customer using
> these chips then we can get away with this, since I can just make sure
> the fancy Apple firmware selection will never collide with the vanilla
> firmware filename. But if other customers of both companies are both
> shipping the same chip with different and incompatible generic firmware,
> we need some way to tell them apart.

AFAIK Apple chips are exclusive. The vendor marking was added by recent 
patch series I worked on. So per device id we assign the vendor. If 
needed we can use subvendor or subdevid to separate them appropriately.

>
>
>>
>>> BRCMF_PCIE_DEVICE(BRCM_PCIE_4356_DEVICE_ID, WCC),
>>> BRCMF_PCIE_DEVICE(BRCM_PCIE_43567_DEVICE_ID, WCC),
>>> BRCMF_PCIE_DEVICE(BRCM_PCIE_43570_DEVICE_ID, WCC),
>>
>> [...]
>>
>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h 
>>> b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
>>> index f4939cf62767..cacc43db86eb 100644
>>> --- a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
>>
>> [...]
>>
>>> @@ -72,6 +72,7 @@
>>> #define BRCM_PCIE_4350_DEVICE_ID 0x43a3
>>> #define BRCM_PCIE_4354_DEVICE_ID 0x43df
>>> #define BRCM_PCIE_4354_RAW_DEVICE_ID 0x4354
>>> +#define BRCM_PCIE_4355_RAW_DEVICE_ID 0x4355
>>
>> I would remove all RAW device ids. These should not be observed outside
>> chip vendor walls.
>
> Ack, I'll remove this one instead of renaming it (or I can just drop all
> the existing RAW IDs first in one commit at the head of v2 if you prefer
> that).

Let's drop the existing RAW IDs with a separate patch explaining why ;-)

Regards,
Arend



--000000000000699b0405f1752aa7
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
2Gzj3QNJRLsZu1TLyOyBBIr/BE7UiY3RabgRzknBGAPmzhS+fmyM8OtM5BYBsFBrSUFtZZO2p/tf
Nbc24J2zf2peoZ8MK+7WQqummYlOnz+FyDkA9EybeNMcS5C+xi/PAgMBAAGjggHdMIIB2TAOBgNV
HQ8BAf8EBAMCBaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRwOi8vc2VjdXJl
Lmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcnQwQQYI
KwYBBQUHMAGGNWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24y
Y2EyMDIwME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3
dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRCMEAwPqA8oDqG
OGh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3Js
MCcGA1UdEQQgMB6BHGFyZW5kLnZhbnNwcmllbEBicm9hZGNvbS5jb20wEwYDVR0lBAwwCgYIKwYB
BQUHAwQwHwYDVR0jBBgwFoAUljPR5lgXWzR1ioFWZNW+SN6hj88wHQYDVR0OBBYEFIikAXd8CEtv
ZbDflDRnf3tuStPuMA0GCSqGSIb3DQEBCwUAA4IBAQCdS5XCYx6k2GGZui9DlFsFm75khkqAU7rT
zBX04sJU1+B1wtgmWTVIzW7ugdtDZ4gzaV0S9xRhpDErjJaltxPbCylb1DEsLj+AIvBR34caW6ZG
sQk444t0HPb29HnWYj+OllIGMbdJWr0/P95ZrKk2bP24ub3ZP/8SyzrohfIba9WZKMq6g2nTLZE3
BtkeSGJx/8dy0h8YmRn+adOrxKXHxhSL8BNn8wsmIZyYWe6fRcBtO3Ks2DOLyHCdkoFlN8x9VUQF
N2ulEgqCbRKkx+qNirW86eF138lr1gRxzclu/38ko//MmkAYR/+hP3WnBll7zbpIt0jc9wyFkSqH
p8a1MYICbTCCAmkCAQEwazBbMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1z
YTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMgUGVyc29uYWxTaWduIDIgQ0EgMjAyMAIMTv1t
bpIzNUky46LXMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCCxCi88zZcAkwdbgww8
TJt4dM/oI5z78JFnEPnnQyNy/jAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0yMzAxMDQxOTI2NDhaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCGSAFl
AwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAF1SOPuFiVneXG3CPqWhC546EnqMSylFcjhQG
cAKJ+lJrbI6Qg9qFWAKXGXEKIzqcF8JkX4njV+dD0hA165w16OzZv7h3ig1xBErqM1FKYV3ujx1f
PyWOGTCVSnIphszf9ZABULxp8EXQ+N/cJxApcJDvqYh+a+oS4dzQ0e/GzP7ZWTQuQX5gXCizfgkt
FGktHCnOBTEsENUbvCmImEOau+aYLlo08NVA8pgTRSFvTQ5KmgdwS6axav69jGvdgFVDUyofA6gi
CAJJ0xn9njr9+QK//JlM7Hi1mwiLibkvmgmSQKfPfIiTkn9rRP1V5J9Lzz6DLU3FRVcXbt9Sk5Sd
uA==
--000000000000699b0405f1752aa7--
