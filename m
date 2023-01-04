Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17B6565D9B5
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 17:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240031AbjADQ1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 11:27:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239980AbjADQ1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 11:27:20 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341593F10A;
        Wed,  4 Jan 2023 08:27:14 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 9FA1A41DF4;
        Wed,  4 Jan 2023 16:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1672849632; bh=CyB6nBdwWKmnMF5EnKIpG3XVjcUbBPWolPGePYu6aHs=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To;
        b=ZFcYfazb5ofGvHpZhd4vo4wCI/Euispc2vhvGew9YeFe0W6od6eOyJfBvn8XX4J14
         M+OqOZ9tmBNHZEo2BYLybSCDVkcBr4i88ejbzqQd5N/NuRKr4d2tdvkOtVLm8VFtKT
         nNbbbCXBXPPCL/D0vf0XTB5CVCBbRdEVoiEo+UxpATWG2RhRFHj49Z6wS5VGXt2nbu
         wJCnQIk/OS3MS+sIiuP33sSoHkgizDyXFZ7Ah5T2MlJX4NtvumXL1+CoKvKbi8eJdr
         NWydl6B6H41U+laQ1EVo2MSSC1CJ9Usc1R9ZXSDOMI10m50GXKhFFkVassPW9vHcaU
         Wd8kZ+GXW9uFg==
Message-ID: <fdc60ff9-78b1-73e8-84d2-f6156a157057@marcan.st>
Date:   Thu, 5 Jan 2023 01:27:03 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
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
 <20230104100116.729-3-marcan@marcan.st>
 <ca904d05-7f11-80dd-cb1c-1cd54c4d7222@broadcom.com>
From:   Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH v1 2/4] brcmfmac: pcie: Add IDs/properties for BCM4355
In-Reply-To: <ca904d05-7f11-80dd-cb1c-1cd54c4d7222@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/01/2023 22.35, Arend van Spriel wrote:
> On 1/4/2023 11:01 AM, 'Hector Martin' via BRCM80211-DEV-LIST,PDL wrote:
>> This chip is present on at least these Apple T2 Macs:
>>
>> * hawaii: MacBook Air 13" (Late 2018)
>> * hawaii: MacBook Air 13" (True Tone, 2019)
>>
>> Users report seeing PCI revision ID 12 for this chip, which Arend
>> reports should be revision C2, but Apple has the firmware tagged as
>> revision C1. Assume the right cutoff point for firmware versions is
>> revision ID 11 then, and leave older revisions using the non-versioned
>> firmware filename (Apple only uses C1 firmware builds).
> 
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Signed-off-by: Hector Martin <marcan@marcan.st>
>> ---
>>   .../net/wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 10 +++++++++-
>>   .../wireless/broadcom/brcm80211/include/brcm_hw_ids.h  |  1 +
>>   2 files changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>> index 3264be485e20..bb4faea0f0b6 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> 
> [...]
> 
>> @@ -1994,6 +1996,11 @@ static int brcmf_pcie_read_otp(struct brcmf_pciedev_info *devinfo)
>>   	int ret;
>>   
>>   	switch (devinfo->ci->chip) {
>> +	case BRCM_CC_4355_CHIP_ID:
>> +		coreid = BCMA_CORE_CHIPCOMMON;
>> +		base = 0x8c0;
>> +		words = 0xb2;
>> +		break;
>>   	case BRCM_CC_4378_CHIP_ID:
>>   		coreid = BCMA_CORE_GCI;
>>   		base = 0x1120;
> 
> This bit is not described in the commit message. Can you remind me why 
> the driver needs to read OTP?

Apple platforms use a vendor-specific OTP area to store identification
information used to select the right firmware/txcap/clm/nvram blobs. See
6bad3eeab6d3d (already upstream) and the immediately preceding commits
for how this all works.

In principle this should just return gracefully if that part of the OTP
is empty, though when I originally wrote this code we only knew of Apple
platforms using these chips anyway. If you think this might possibly
introduce issues to other platforms using the same chips (e.g. if
reading the OTP fails outright for some reason), we could gate it on the
presence of a valid devinfo->settings->antenna_sku, which would indicate
an Apple platform (since that property is specific to the Apple
firmware-selection process and only populated on those platforms).

- Hector
