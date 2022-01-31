Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C124A4C43
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 17:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380532AbiAaQhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 11:37:16 -0500
Received: from marcansoft.com ([212.63.210.85]:42382 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376682AbiAaQhP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 11:37:15 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 57D0341982;
        Mon, 31 Jan 2022 16:37:06 +0000 (UTC)
Subject: Re: [PATCH v2 27/35] brcmfmac: pcie: Add IDs/properties for BCM4387
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
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
 <20220104072658.69756-28-marcan@marcan.st>
 <1f37951b-aed7-64ca-7452-7332df791931@broadcom.com>
From:   Hector Martin <marcan@marcan.st>
Message-ID: <dbf841a7-a848-fed0-484d-1c7c8ced94d6@marcan.st>
Date:   Tue, 1 Feb 2022 01:37:04 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1f37951b-aed7-64ca-7452-7332df791931@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: es-ES
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/01/2022 16.35, Arend van Spriel wrote:
> On 1/4/2022 8:26 AM, Hector Martin wrote:
>> @@ -96,6 +97,7 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
>>   	BRCMF_FW_ENTRY(BRCM_CC_4371_CHIP_ID, 0xFFFFFFFF, 4371),
>>   	BRCMF_FW_ENTRY(BRCM_CC_4377_CHIP_ID, 0xFFFFFFFF, 4377B3), /* 4 */
>>   	BRCMF_FW_ENTRY(BRCM_CC_4378_CHIP_ID, 0xFFFFFFFF, 4378B1), /* 3 */
>> +	BRCMF_FW_ENTRY(BRCM_CC_4387_CHIP_ID, 0xFFFFFFFF, 4387C2), /* 7 */
> 
> Regarding the revmask in this firmware mapping table my common practice 
> was to disable older revisions and enable for given revision and newer 
> until proven otherwise. So for the 4387c2 that would have to following 
> mask 0xFFFFFF80 (if rev 7 indeed matches with c2).
> 

Makes sense, I changed it to that for all the additions :)

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
