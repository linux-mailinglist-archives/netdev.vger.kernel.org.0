Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 041F3692FE8
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 11:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjBKKJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 05:09:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjBKKJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 05:09:08 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26C632E44;
        Sat, 11 Feb 2023 02:09:02 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id B70BE42300;
        Sat, 11 Feb 2023 10:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1676110140; bh=xgElBP+tjDeZkk5no9nEVPZ3v18CazedQGwUh/vJETY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=JTGXd2AlOil2xNP6nYXSH5OsC7cMUTKh+G/WVZq/vjZOIFMtzd48SnDx53Mg/VcND
         NfPRMPuvczFn4Ie2BgxvPlQHe7bAhsXUjKVuBCsB4E+L6BagmaMBpMRNa3ntuui5WS
         PEZzsusPZw8DNVpngYjxdVpa60xQOIrDys+JMkVs28ZbiaV5w/5SMCMPzmvSaZHzFe
         N6+bO8EH8aZX8biwIz84pNymvzZ3vuSll3vEg0g+QXUKEgAfvxuMiFdXlgE7DIGNjZ
         RSKFel60jXPwhiambKMVND1UKQ0yLdnnuionb/8wQZ91Wmam+5AvQbr5igoVWIaKR8
         x+SQSq5juSoRQ==
Message-ID: <624c0a20-f4e6-14a5-02a2-eaf7b36e9331@marcan.st>
Date:   Sat, 11 Feb 2023 19:08:50 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v3 1/4] wifi: brcmfmac: Rename Cypress 89459 to BCM4355
Content-Language: en-US
To:     Ping-Ke Shih <pkshih@realtek.com>,
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
        Aditya Garg <gargaditya08@live.com>,
        Jonas Gorski <jonas.gorski@gmail.com>,
        "asahi@lists.linux.dev" <asahi@lists.linux.dev>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
References: <20230210025009.21873-1-marcan@marcan.st>
 <20230210025009.21873-2-marcan@marcan.st>
 <0cd45af5812345878faf0dc8fa6b0963@realtek.com>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <0cd45af5812345878faf0dc8fa6b0963@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/02/2023 12.42, Ping-Ke Shih wrote:
> 
> 
>> -----Original Message-----
>> From: Hector Martin <marcan@marcan.st>
>> Sent: Friday, February 10, 2023 10:50 AM
>> To: Arend van Spriel <aspriel@gmail.com>; Franky Lin <franky.lin@broadcom.com>; Hante Meuleman
>> <hante.meuleman@broadcom.com>; Kalle Valo <kvalo@kernel.org>; David S. Miller <davem@davemloft.net>; Eric
>> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>
>> Cc: Alexander Prutskov <alep@cypress.com>; Chi-Hsien Lin <chi-hsien.lin@cypress.com>; Wright Feng
>> <wright.feng@cypress.com>; Ian Lin <ian.lin@infineon.com>; Soontak Lee <soontak.lee@cypress.com>; Joseph
>> chuang <jiac@cypress.com>; Sven Peter <sven@svenpeter.dev>; Alyssa Rosenzweig <alyssa@rosenzweig.io>;
>> Aditya Garg <gargaditya08@live.com>; Jonas Gorski <jonas.gorski@gmail.com>; asahi@lists.linux.dev;
>> linux-wireless@vger.kernel.org; brcm80211-dev-list.pdl@broadcom.com; SHA-cyfmac-dev-list@infineon.com;
>> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Hector Martin <marcan@marcan.st>; Arend van Spriel
>> <arend.vanspriel@broadcom.com>
>> Subject: [PATCH v3 1/4] wifi: brcmfmac: Rename Cypress 89459 to BCM4355
>>
>> The commit that introduced support for this chip incorrectly claimed it
>> is a Cypress-specific part, while in actuality it is just a variant of
>> BCM4355 silicon (as evidenced by the chip ID).
>>
>> The relationship between Cypress products and Broadcom products isn't
>> entirely clear but given what little information is available and prior
>> art in the driver, it seems the convention should be that originally
>> Broadcom parts should retain the Broadcom name.
>>
>> Thus, rename the relevant constants and firmware file. Also rename the
>> specific 89459 PCIe ID to BCM43596, which seems to be the original
>> subvariant name for this PCI ID (as defined in the out-of-tree bcmdhd
>> driver).
>>
>> v2: Since Cypress added this part and will presumably be providing
>> its supported firmware, we keep the CYW designation for this device.
>>
>> v3: Drop the RAW device ID in this commit. We don't do this for the
>> other chips since apparently some devices with them exist in the wild,
>> but there is already a 4355 entry with the Broadcom subvendor and WCC
>> firmware vendor, so adding a generic fallback to Cypress seems
>> redundant (no reason why a device would have the raw device ID *and* an
>> explicitly programmed subvendor).
> 
> Do you really want to add changes of v2 and v3 to commit message? Or,
> just want to let reviewers know that? If latter one is what you want,
> move them after s-o-b with delimiter ---

Both; I thought those things were worth mentioning in the commit message
as it stands on its own, and left the version tags in so reviewers know
when they were introduced.

- Hector
