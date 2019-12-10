Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9325911848B
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 11:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbfLJKMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 05:12:25 -0500
Received: from mout.web.de ([212.227.15.3]:37609 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727032AbfLJKMY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 05:12:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1575972737;
        bh=3pTHW4Q8tyW+6nWjz/mcweMqA2s1Pt/POPAPISyIziw=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=m2m7N6ntcSuVfQN3D5ryfKP7j5okQF5gFM0nD7aGhu/AG1sTRgdw19cuo6Dy+C+Bf
         bWN5EUVB5NVigklAQUWRlunV7c4/4qKmriIrRqIHer2FQSQjXKuWerhuUgYLVq4GKa
         4+61OyhPt9SY2fWUNnCgUEf++UzR/IldpGeWsoxE=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.43.108] ([89.204.137.56]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0Lj2Cs-1i1h7O2m3a-00dDCn; Tue, 10
 Dec 2019 11:12:16 +0100
Subject: Re: [PATCH 5/8] brcmfmac: add support for BCM4359 SDIO chipset
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20191209223822.27236-1-smoch@web.de>
 <20191209223822.27236-5-smoch@web.de>
 <ea33f5b2-0748-1837-ee59-5b00177f7f4e@cypress.com>
 <1910862f-2564-6252-535c-8916e6c5e150@cypress.com>
From:   Soeren Moch <smoch@web.de>
Message-ID: <d41c6942-abaf-ca0b-3858-07e1f95f9b15@web.de>
Date:   Tue, 10 Dec 2019 11:12:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <1910862f-2564-6252-535c-8916e6c5e150@cypress.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:5vJ0I53uaFC3igMAqUvXs+svR8AgkAyoI6gi8SHgsWC/4t95XoC
 ULY5aGlIRgTk4Nl0UGzwxlzxCCASMh4Igih2kU9X7lMbgEdWKns1ViS8S380Jag8ydGmTSf
 7eeoQxHYy0IzQEzZl7tMA3kFaLle9uq6P3HVW9DUVrIvr7hA6bwBRKddNFtVpFZ94Ae8oQ5
 CSxm0HYYWKdFSV1ND5qeQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZOqwXIJv5FU=:F2EAtCwZH40CsbH89Q0HiK
 euYX67SdY5mNBD+uiVhBUi+Tp+cWrQy9n8GSOk9nuHaVMGGBMPNQJwc+BQxc2fePnenSQMD8w
 8O8T4UwnmZTfjB+Bh/7ob7acfE6rJvJbylJTYC1TENlBssLJEWipPnwWgFd13/jngKr/A28bS
 1gWRJTkqiIrp9kq1KJjHriT0AAMEo4pJUekUcOKmEvP1JYPpzPa2cLa+g6nAPo6bnbA26syDp
 bID915cskbBUNVorKpUKYKKBH+tMLK90r6NBl1gF+oKgtBZ2SNmKed4TW1i4fSuomm/TQDAu7
 uHiS2f3zhoP8soHOLM398+6FqylW8ezj0b5VI37ds0x7qA6//Y2T1KQKzhEGg5jYFyyopM2u5
 /gEJ34uCZ/tHoJs7Gxi63o/4qoBu5n1ZaxODCBvM36yhPoI/gdsgYrnaAxrxZ/NlRFEYYudmF
 N53ZxxHwHKaQmZCDng0+c8ll7EfP64pv21tKcR6JgvNhXJhfQ1OTtWqGyxcvyaBWaQaI9UK9R
 BlWN06ldbQF7c6tA3l5Of5nZNxia76eH3yQuBlcTBEi/FiuejMCOIqa+wDmmtb/K+p7PHvAaG
 rRqvZk39/4k3eHTwJGvqFcYG/Hak5bd+wyUMCAZkArmB6gzjTxB8hlXEF0kv6VlBlbVfIG/+I
 j+SCmcgk4nVqDDzmerWgYzUkTFyGAeZcFrlEOjjL3/dYNnllhd5ajOPqgR0CxoGQosZhvVpV/
 o8znxsatouwaXH/P4x2njkbgzf32+56maByn9XvUygfpg/Dz7/I9TMyA4fHWlbLeX5TGLLEf3
 Y4mP5RP9uPNREq10HXISLOhXPZEV1Fc1OSLtApy3aeyg+iKHyK1cwyROYmDEOYkBxxGkQsiGn
 +BC3imz7D2dH9UFtism5Zm4PW1UjffRNGpRb7707XfxPNViXKST1OEDVgs4wtfmPMtvmd83qI
 7OHZXfS5kqnjficc2QK7iJ39wq8SOtebgiFP4wqCAvNhCnyDKLkbtIRzRtgLFGTuHO5M3/wwf
 qSrF3PysSYNpQt4QsnKitGXIQjYevQkGP4gA1sVJp4wiwJ8PmgmnMatGSLtDeHHG9q0ZqhtDT
 r6OZaVlo9qHllg+H8KTE2yihC/+XKn4m7UPXOq5/CmkQxZs+jVlU8GobKGMRuxt6U7C9Z3MbX
 FtufxIBqMNA2B3M1aaIXYWf54A0Gqm2kkj0FoLVhZsZp5j9FKeVPTkf3ai0TqIkdO8/pDaMKv
 NTU7MfFyJQISjovJoAoZmEAoI+Rfso5Y0Cee8lg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10.12.19 07:32, Chi-Hsien Lin wrote:
>
> On 12/10/2019 11:38, Chi-Hsien Lin wrote:
>>
>> On 12/10/2019 6:38, Soeren Moch wrote:
>>> BCM4359 is a 2x2 802.11 abgn+ac Dual-Band HT80 combo chip and it
>>> supports Real Simultaneous Dual Band feature.
>>>
>>> Based on a similar patch by: Wright Feng <wright.feng@cypress.com>
>> Hi Soeren,
>>
>> Is it possible to also keep the ID in the original patch from Wright?
>> You can use below IDs and allow both to be supported:
>>
>> #define SDIO_DEVICE_ID_BROADCOM_4359		0x4359
>> #define SDIO_DEVICE_ID_CY_89359			0x4355
> Fix a typo. The ID should be
>
> #define SDIO_DEVICE_ID_CYPRESS_89359			0x4355
>
> Note that brcmf_sdmmc_ids[] also needs an entry for the above ID. The
> chipid references can remain unchanged.
Hi Chi-hsien,

thanks for all your reviews. I will re-add this ID and send a v2 of this
series.

Thanks again,
Soeren
>
> Chi-hsien Lin
>
>>
>> Chi-hsien Lin
>>
>>
>>> Signed-off-by: Soeren Moch <smoch@web.de>
>>> ---
>>> Cc: Kalle Valo <kvalo@codeaurora.org>
>>> Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
>>> Cc: Franky Lin <franky.lin@broadcom.com>
>>> Cc: Hante Meuleman <hante.meuleman@broadcom.com>
>>> Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
>>> Cc: Wright Feng <wright.feng@cypress.com>
>>> Cc: linux-wireless@vger.kernel.org
>>> Cc: brcm80211-dev-list.pdl@broadcom.com
>>> Cc: brcm80211-dev-list@cypress.com
>>> Cc: netdev@vger.kernel.org
>>> Cc: linux-kernel@vger.kernel.org
>>> ---
>>>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 1 +
>>>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c   | 1 +
>>>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   | 2 ++
>>>    include/linux/mmc/sdio_ids.h                              | 1 +
>>>    4 files changed, 5 insertions(+)
>>>
>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c=
 b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
>>> index 68baf0189305..5b57d37caf17 100644
>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
>>> @@ -973,6 +973,7 @@ static const struct sdio_device_id brcmf_sdmmc_ids=
[] =3D {
>>>    	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43455),
>>>    	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4354),
>>>    	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4356),
>>> +	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4359),
>>>    	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_CYPRESS_4373),
>>>    	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_CYPRESS_43012),
>>>    	{ /* end: all zeroes */ }
>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b=
/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
>>> index baf72e3984fc..282d0bc14e8e 100644
>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
>>> @@ -1408,6 +1408,7 @@ bool brcmf_chip_sr_capable(struct brcmf_chip *pu=
b)
>>>    		addr =3D CORE_CC_REG(base, sr_control0);
>>>    		reg =3D chip->ops->read32(chip->ctx, addr);
>>>    		return (reg & CC_SR_CTL0_ENABLE_MASK) !=3D 0;
>>> +	case BRCM_CC_4359_CHIP_ID:
>>>    	case CY_CC_43012_CHIP_ID:
>>>    		addr =3D CORE_CC_REG(pmu->base, retention_ctl);
>>>    		reg =3D chip->ops->read32(chip->ctx, addr);
>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b=
/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>> index 21e535072f3f..c4012ed58b9c 100644
>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>> @@ -616,6 +616,7 @@ BRCMF_FW_DEF(43455, "brcmfmac43455-sdio");
>>>    BRCMF_FW_DEF(43456, "brcmfmac43456-sdio");
>>>    BRCMF_FW_DEF(4354, "brcmfmac4354-sdio");
>>>    BRCMF_FW_DEF(4356, "brcmfmac4356-sdio");
>>> +BRCMF_FW_DEF(4359, "brcmfmac4359-sdio");
>>>    BRCMF_FW_DEF(4373, "brcmfmac4373-sdio");
>>>    BRCMF_FW_DEF(43012, "brcmfmac43012-sdio");
>>>
>>> @@ -638,6 +639,7 @@ static const struct brcmf_firmware_mapping brcmf_s=
dio_fwnames[] =3D {
>>>    	BRCMF_FW_ENTRY(BRCM_CC_4345_CHIP_ID, 0xFFFFFDC0, 43455),
>>>    	BRCMF_FW_ENTRY(BRCM_CC_4354_CHIP_ID, 0xFFFFFFFF, 4354),
>>>    	BRCMF_FW_ENTRY(BRCM_CC_4356_CHIP_ID, 0xFFFFFFFF, 4356),
>>> +	BRCMF_FW_ENTRY(BRCM_CC_4359_CHIP_ID, 0xFFFFFFFF, 4359),
>>>    	BRCMF_FW_ENTRY(CY_CC_4373_CHIP_ID, 0xFFFFFFFF, 4373),
>>>    	BRCMF_FW_ENTRY(CY_CC_43012_CHIP_ID, 0xFFFFFFFF, 43012)
>>>    };
>>> diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids=
.h
>>> index 08b25c02b5a1..930ef2d8264a 100644
>>> --- a/include/linux/mmc/sdio_ids.h
>>> +++ b/include/linux/mmc/sdio_ids.h
>>> @@ -41,6 +41,7 @@
>>>    #define SDIO_DEVICE_ID_BROADCOM_43455		0xa9bf
>>>    #define SDIO_DEVICE_ID_BROADCOM_4354		0x4354
>>>    #define SDIO_DEVICE_ID_BROADCOM_4356		0x4356
>>> +#define SDIO_DEVICE_ID_BROADCOM_4359		0x4359
>>>    #define SDIO_DEVICE_ID_CYPRESS_4373		0x4373
>>>    #define SDIO_DEVICE_ID_CYPRESS_43012		43012
>>>
>>> --
>>> 2.17.1
>>>
>>> .
>>>

