Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 499F44896F0
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 12:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244387AbiAJLEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 06:04:42 -0500
Received: from marcansoft.com ([212.63.210.85]:47138 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244377AbiAJLEl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 06:04:41 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 9E6693FA5E;
        Mon, 10 Jan 2022 11:04:29 +0000 (UTC)
Message-ID: <7f124c47-9bc8-0a5a-8590-bed352538453@marcan.st>
Date:   Mon, 10 Jan 2022 20:04:26 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v2 14/35] brcmfmac: pcie: Add IDs/properties for BCM4378
Content-Language: en-US
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
 <20220104072658.69756-15-marcan@marcan.st>
 <b652e98b-1b09-4639-95c4-779fb6cc989f@broadcom.com>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <b652e98b-1b09-4639-95c4-779fb6cc989f@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/01/10 18:10, Arend van Spriel wrote:
> On 1/4/2022 8:26 AM, Hector Martin wrote:
>> This chip is present on Apple M1 (t8103) platforms:
>>
>> * atlantisb (apple,j274): Mac mini (M1, 2020)
>> * honshu    (apple,j293): MacBook Pro (13-inch, M1, 2020)
>> * shikoku   (apple,j313): MacBook Air (M1, 2020)
>> * capri     (apple,j456): iMac (24-inch, 4x USB-C, M1, 2020)
>> * santorini (apple,j457): iMac (24-inch, 2x USB-C, M1, 2020)
> 
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Hector Martin <marcan@marcan.st>
>> ---
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c   | 2 ++
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c   | 8 ++++++++
>>   .../net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 2 ++
>>   3 files changed, 12 insertions(+)
> 
> [...]
> 
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>> index f3744e806157..cc76f00724e6 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>> @@ -58,6 +58,7 @@ BRCMF_FW_DEF(4365C, "brcmfmac4365c-pcie");
>>   BRCMF_FW_DEF(4366B, "brcmfmac4366b-pcie");
>>   BRCMF_FW_DEF(4366C, "brcmfmac4366c-pcie");
>>   BRCMF_FW_DEF(4371, "brcmfmac4371-pcie");
>> +BRCMF_FW_CLM_DEF(4378B1, "brcmfmac4378b1-pcie");
>>   
>>   /* firmware config files */
>>   MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.txt");
>> @@ -87,6 +88,7 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
>>   	BRCMF_FW_ENTRY(BRCM_CC_43664_CHIP_ID, 0xFFFFFFF0, 4366C),
>>   	BRCMF_FW_ENTRY(BRCM_CC_43666_CHIP_ID, 0xFFFFFFF0, 4366C),
>>   	BRCMF_FW_ENTRY(BRCM_CC_4371_CHIP_ID, 0xFFFFFFFF, 4371),
>> +	BRCMF_FW_ENTRY(BRCM_CC_4378_CHIP_ID, 0xFFFFFFFF, 4378B1), /* 3 */
> 
> what does the trailing comment reflect?

PCI revision IDs seen in the wild. The mask currently accepts all of
them, but B1 specifically seems to map to rev3. This is important for
4364 since there are two revisions in the wild, and so that one has more
selective masks. I can change it to "rev3" to make it more obvious.

I'm actually not sure what the best approach for the masks is. We could
also only accept known exact revisions; that would be better if a newer
revision is incompatible, but worse if it is and would otherwise just work.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
