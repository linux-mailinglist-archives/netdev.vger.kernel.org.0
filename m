Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45ED869310B
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 13:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjBKMqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 07:46:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBKMqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 07:46:23 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2006134C2C;
        Sat, 11 Feb 2023 04:46:20 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 3BC8242300;
        Sat, 11 Feb 2023 12:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1676119578; bh=MVlPxiIveZiTcCKjMuVtaBBakIxzsD9vD0OuhB7O+FU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=dq6j5a4K2+b2c98egs58CH6cFxzzCuHrYprXnO1YA/cxeEHxbFZy9kLOxRPcFz1Ss
         oEREwkB8Q4qE9XaezmJiT9wI7YPo2rNLi2HgXEcMBmQyZ+C8XxzYidVjFAZi0zRd/D
         9EDjRrYo+gEBqmmchA7yxYgNChdz9DvJz5yVB1+V3lFw9pasnLHLUv3kpnP9Lwc7k0
         JZvaTpWzgojXCq/ZPA/lkJRUeE+NeMlQVaK4w1zb4WSXvPKouK4zdxq8j5xNY96Ojq
         fDCXWRnBgASGXPzhuYEDDaQaXda+Dk9qHyxDv7k6aRBGq294J20NCdi0m4PmbxM0e/
         6hWj04b2cs2Aw==
Message-ID: <e9dbfa3d-6599-94b9-0176-e25bb074b2c7@marcan.st>
Date:   Sat, 11 Feb 2023 21:46:09 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v3 1/4] wifi: brcmfmac: Rename Cypress 89459 to BCM4355
Content-Language: en-US
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
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
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <18640374b38.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
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

On 11/02/2023 20.23, Arend Van Spriel wrote:
> On February 11, 2023 11:09:02 AM Hector Martin <marcan@marcan.st> wrote:
> 
>> On 10/02/2023 12.42, Ping-Ke Shih wrote:
>>>
>>>
>>>> -----Original Message-----
>>>> From: Hector Martin <marcan@marcan.st>
>>>> Sent: Friday, February 10, 2023 10:50 AM
>>>> To: Arend van Spriel <aspriel@gmail.com>; Franky Lin 
>>>> <franky.lin@broadcom.com>; Hante Meuleman
>>>> <hante.meuleman@broadcom.com>; Kalle Valo <kvalo@kernel.org>; David S. 
>>>> Miller <davem@davemloft.net>; Eric
>>>> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo 
>>>> Abeni <pabeni@redhat.com>
>>>> Cc: Alexander Prutskov <alep@cypress.com>; Chi-Hsien Lin 
>>>> <chi-hsien.lin@cypress.com>; Wright Feng
>>>> <wright.feng@cypress.com>; Ian Lin <ian.lin@infineon.com>; Soontak Lee 
>>>> <soontak.lee@cypress.com>; Joseph
>>>> chuang <jiac@cypress.com>; Sven Peter <sven@svenpeter.dev>; Alyssa 
>>>> Rosenzweig <alyssa@rosenzweig.io>;
>>>> Aditya Garg <gargaditya08@live.com>; Jonas Gorski <jonas.gorski@gmail.com>; 
>>>> asahi@lists.linux.dev;
>>>> linux-wireless@vger.kernel.org; brcm80211-dev-list.pdl@broadcom.com; 
>>>> SHA-cyfmac-dev-list@infineon.com;
>>>> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Hector Martin 
>>>> <marcan@marcan.st>; Arend van Spriel
>>>> <arend.vanspriel@broadcom.com>
>>>> Subject: [PATCH v3 1/4] wifi: brcmfmac: Rename Cypress 89459 to BCM4355
>>>>
>>>> The commit that introduced support for this chip incorrectly claimed it
>>>> is a Cypress-specific part, while in actuality it is just a variant of
>>>> BCM4355 silicon (as evidenced by the chip ID).
>>>>
>>>> The relationship between Cypress products and Broadcom products isn't
>>>> entirely clear but given what little information is available and prior
>>>> art in the driver, it seems the convention should be that originally
>>>> Broadcom parts should retain the Broadcom name.
>>>>
>>>> Thus, rename the relevant constants and firmware file. Also rename the
>>>> specific 89459 PCIe ID to BCM43596, which seems to be the original
>>>> subvariant name for this PCI ID (as defined in the out-of-tree bcmdhd
>>>> driver).
>>>>
>>>> v2: Since Cypress added this part and will presumably be providing
>>>> its supported firmware, we keep the CYW designation for this device.
>>>>
>>>> v3: Drop the RAW device ID in this commit. We don't do this for the
>>>> other chips since apparently some devices with them exist in the wild,
>>>> but there is already a 4355 entry with the Broadcom subvendor and WCC
>>>> firmware vendor, so adding a generic fallback to Cypress seems
>>>> redundant (no reason why a device would have the raw device ID *and* an
>>>> explicitly programmed subvendor).
>>>
>>> Do you really want to add changes of v2 and v3 to commit message? Or,
>>> just want to let reviewers know that? If latter one is what you want,
>>> move them after s-o-b with delimiter ---
>>
>> Both; I thought those things were worth mentioning in the commit message
>> as it stands on its own, and left the version tags in so reviewers know
>> when they were introduced.
> 
> The commit message is documenting what we end up with post reviewing so 
> patch versions are meaningless there. Of course useful information that 
> came up in review cycles should end up in the commit message.
> 

Do you really want me to respin this again just to remove 8 characters
from the commit message? I know it doesn't have much meaning post review
but it's not unheard of either, grep git logs and you'll find plenty of
examples.

- Hector
