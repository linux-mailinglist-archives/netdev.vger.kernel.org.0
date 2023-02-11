Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E349F693342
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 20:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjBKTQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 14:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjBKTQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 14:16:05 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149FBFB;
        Sat, 11 Feb 2023 11:16:02 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id B65AF42300;
        Sat, 11 Feb 2023 19:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1676142961; bh=R7nPx5Q0d44U46OXUeCQa9uSKpfTp0ypZpN8xiIlHvg=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To;
        b=I6T+Rdg1r4uzOC5eQTA1UfuFCXLjOxtZADRIKtzN1gIQHf794tdHjo6E8i4ly5hXD
         iXFhuryEEL0+8sgpQdZfu3XCmCH1g3JpALgY0PSR0CfzNpZifCkyWEDPTXoGyOJFLz
         fgCcPz4kuHOc+FI9E/85HFSulRRKo1KHy93+CyegAj9RIqZR4EdacmQ2G6rBFmHSqX
         itXdeCO7Y7ScIhJx4kH4EaUqsKUNGB8fWe9sO6oGtLd6jjb6zzQUvV4cTas1uJuPpM
         2Cm1SGFETf4aVSEZsJuaJKPG0mGotm1msCO2WVF218Iui+n5E4mGUWjrIW0KpEEwXS
         141JOfrhImQtA==
Message-ID: <180b9e56-fbf4-4d98-3d18-a71f3b15e045@marcan.st>
Date:   Sun, 12 Feb 2023 04:15:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Aditya Garg <gargaditya08@live.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Prutskov <alep@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Ian Lin <ian.lin@infineon.com>,
        Soontak Lee <soontak.lee@cypress.com>,
        Joseph chuang <jiac@cypress.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Jonas Gorski <jonas.gorski@gmail.com>, asahi@lists.linux.dev,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230210025009.21873-1-marcan@marcan.st>
 <20230210025009.21873-2-marcan@marcan.st>
 <0cd45af5812345878faf0dc8fa6b0963@realtek.com>
 <624c0a20-f4e6-14a5-02a2-eaf7b36e9331@marcan.st>
 <18640374b38.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
 <e9dbfa3d-6599-94b9-0176-e25bb074b2c7@marcan.st>
 <BM1PR01MB0931D1A15E7945A0D48B828EB8DF9@BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM>
 <18640c70048.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
From:   Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH v3 1/4] wifi: brcmfmac: Rename Cypress 89459 to BCM4355
In-Reply-To: <18640c70048.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/02/2023 23.00, Arend Van Spriel wrote:
> On February 11, 2023 1:50:00 PM Aditya Garg <gargaditya08@live.com> wrote:
> 
>>> On 11-Feb-2023, at 6:16 PM, Hector Martin <marcan@marcan.st> wrote:
>>>
>>> ﻿On 11/02/2023 20.23, Arend Van Spriel wrote:
>>>>> On February 11, 2023 11:09:02 AM Hector Martin <marcan@marcan.st> wrote:
>>>>>
>>>>> On 10/02/2023 12.42, Ping-Ke Shih wrote:
>>>>>>
>>>>>>
>>>>>>> -----Original Message-----
>>>>>>> From: Hector Martin <marcan@marcan.st>
>>>>>>> Sent: Friday, February 10, 2023 10:50 AM
>>>>>>> To: Arend van Spriel <aspriel@gmail.com>; Franky Lin
>>>>>>> <franky.lin@broadcom.com>; Hante Meuleman
>>>>>>> <hante.meuleman@broadcom.com>; Kalle Valo <kvalo@kernel.org>; David S.
>>>>>>> Miller <davem@davemloft.net>; Eric
>>>>>>> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo
>>>>>>> Abeni <pabeni@redhat.com>
>>>>>>> Cc: Alexander Prutskov <alep@cypress.com>; Chi-Hsien Lin
>>>>>>> <chi-hsien.lin@cypress.com>; Wright Feng
>>>>>>> <wright.feng@cypress.com>; Ian Lin <ian.lin@infineon.com>; Soontak Lee
>>>>>>> <soontak.lee@cypress.com>; Joseph
>>>>>>> chuang <jiac@cypress.com>; Sven Peter <sven@svenpeter.dev>; Alyssa
>>>>>>> Rosenzweig <alyssa@rosenzweig.io>;
>>>>>>> Aditya Garg <gargaditya08@live.com>; Jonas Gorski <jonas.gorski@gmail.com>;
>>>>>>> asahi@lists.linux.dev;
>>>>>>> linux-wireless@vger.kernel.org; brcm80211-dev-list.pdl@broadcom.com;
>>>>>>> SHA-cyfmac-dev-list@infineon.com;
>>>>>>> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Hector Martin
>>>>>>> <marcan@marcan.st>; Arend van Spriel
>>>>>>> <arend.vanspriel@broadcom.com>
>>>>>>> Subject: [PATCH v3 1/4] wifi: brcmfmac: Rename Cypress 89459 to BCM4355
>>>>>>>
>>>>>>> The commit that introduced support for this chip incorrectly claimed it
>>>>>>> is a Cypress-specific part, while in actuality it is just a variant of
>>>>>>> BCM4355 silicon (as evidenced by the chip ID).
>>>>>>>
>>>>>>> The relationship between Cypress products and Broadcom products isn't
>>>>>>> entirely clear but given what little information is available and prior
>>>>>>> art in the driver, it seems the convention should be that originally
>>>>>>> Broadcom parts should retain the Broadcom name.
>>>>>>>
>>>>>>> Thus, rename the relevant constants and firmware file. Also rename the
>>>>>>> specific 89459 PCIe ID to BCM43596, which seems to be the original
>>>>>>> subvariant name for this PCI ID (as defined in the out-of-tree bcmdhd
>>>>>>> driver).
>>>>>>>
>>>>>>> v2: Since Cypress added this part and will presumably be providing
>>>>>>> its supported firmware, we keep the CYW designation for this device.
>>>>>>>
>>>>>>> v3: Drop the RAW device ID in this commit. We don't do this for the
>>>>>>> other chips since apparently some devices with them exist in the wild,
>>>>>>> but there is already a 4355 entry with the Broadcom subvendor and WCC
>>>>>>> firmware vendor, so adding a generic fallback to Cypress seems
>>>>>>> redundant (no reason why a device would have the raw device ID *and* an
>>>>>>> explicitly programmed subvendor).
>>>>>>
>>>>>> Do you really want to add changes of v2 and v3 to commit message? Or,
>>>>>> just want to let reviewers know that? If latter one is what you want,
>>>>>> move them after s-o-b with delimiter ---
>>>>>
>>>>> Both; I thought those things were worth mentioning in the commit message
>>>>> as it stands on its own, and left the version tags in so reviewers know
>>>>> when they were introduced.
>>>>
>>>> The commit message is documenting what we end up with post reviewing so
>>>> patch versions are meaningless there. Of course useful information that
>>>> came up in review cycles should end up in the commit message.
>>>
>>> Do you really want me to respin this again just to remove 8 characters
>>> from the commit message? I know it doesn't have much meaning post review
>>> but it's not unheard of either, grep git logs and you'll find plenty of
>>> examples.
>>>
>>> - Hector
>>
>> Adding to that, I guess the maintainers can do a bit on their part. Imao it’s
>> really frustrating preparing the same patch again and again, especially for
>> bits like these.
> 
> Frustrating? I am sure that maintainers have another view on that when they 
> have to mention the same type of submission errors again and again. That's 
> why there is a wireless wiki page on the subject:
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

Which does not mention this particular issue as far as I can tell. How
exactly is this a "submission error"? Neither you nor Kalle pointed it
out through two revisions, only a drive-by reviewer did.

> If Kalle is willing to cleanup the commit message in the current patch you 
> are lucky. You are free to ask. Otherwise it should be not too much trouble 
> resubmitting it.

It's even less trouble to just take it as is, since an extra "v2: " in
the commit message doesn't hurt anyone other than those who choose to be
hurt by it. And as I said there's *tons* of commits with a changelog
like this in Linux. It's not uncommon.

I swear, some maintainers seem to take a perverse delight in making
things as painful as possible for submitters, even when there is
approximately zero benefit to the end result. And I say this as a
maintainer myself.

Maybe y'all should be the ones feeling lucky that so many people are
willing to put up with all this bullshit to get things upstreamed to
Linux. It's literally the worst open source project to upstream things
to, by a *very long* shot. I'll respin a v4 if I must, but but it's.
Just. This. Kind. Of. Nonsense. Every. Single. Time. And. Every. Single.
Time. It's. Something. Different. This stuff burns people out and
discourages submissions and turns huge numbers of people off from ever
contributing to Linux, and you all need to seriously be aware of that.

- Hector
