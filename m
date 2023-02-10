Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D50F691745
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 04:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbjBJDoQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 9 Feb 2023 22:44:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbjBJDoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 22:44:15 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471676F21A;
        Thu,  9 Feb 2023 19:44:05 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 31A3giYoB027680, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 31A3giYoB027680
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Fri, 10 Feb 2023 11:42:44 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Fri, 10 Feb 2023 11:42:44 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Fri, 10 Feb 2023 11:42:44 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Fri, 10 Feb 2023 11:42:43 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Hector Martin <marcan@marcan.st>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC:     Alexander Prutskov <alep@cypress.com>,
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
        "Arend van Spriel" <arend.vanspriel@broadcom.com>
Subject: RE: [PATCH v3 1/4] wifi: brcmfmac: Rename Cypress 89459 to BCM4355
Thread-Topic: [PATCH v3 1/4] wifi: brcmfmac: Rename Cypress 89459 to BCM4355
Thread-Index: AQHZPPqASPo0Y2xlw0ybs7L5iADUua7Hh+hg
Date:   Fri, 10 Feb 2023 03:42:43 +0000
Message-ID: <0cd45af5812345878faf0dc8fa6b0963@realtek.com>
References: <20230210025009.21873-1-marcan@marcan.st>
 <20230210025009.21873-2-marcan@marcan.st>
In-Reply-To: <20230210025009.21873-2-marcan@marcan.st>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Hector Martin <marcan@marcan.st>
> Sent: Friday, February 10, 2023 10:50 AM
> To: Arend van Spriel <aspriel@gmail.com>; Franky Lin <franky.lin@broadcom.com>; Hante Meuleman
> <hante.meuleman@broadcom.com>; Kalle Valo <kvalo@kernel.org>; David S. Miller <davem@davemloft.net>; Eric
> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>
> Cc: Alexander Prutskov <alep@cypress.com>; Chi-Hsien Lin <chi-hsien.lin@cypress.com>; Wright Feng
> <wright.feng@cypress.com>; Ian Lin <ian.lin@infineon.com>; Soontak Lee <soontak.lee@cypress.com>; Joseph
> chuang <jiac@cypress.com>; Sven Peter <sven@svenpeter.dev>; Alyssa Rosenzweig <alyssa@rosenzweig.io>;
> Aditya Garg <gargaditya08@live.com>; Jonas Gorski <jonas.gorski@gmail.com>; asahi@lists.linux.dev;
> linux-wireless@vger.kernel.org; brcm80211-dev-list.pdl@broadcom.com; SHA-cyfmac-dev-list@infineon.com;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Hector Martin <marcan@marcan.st>; Arend van Spriel
> <arend.vanspriel@broadcom.com>
> Subject: [PATCH v3 1/4] wifi: brcmfmac: Rename Cypress 89459 to BCM4355
> 
> The commit that introduced support for this chip incorrectly claimed it
> is a Cypress-specific part, while in actuality it is just a variant of
> BCM4355 silicon (as evidenced by the chip ID).
> 
> The relationship between Cypress products and Broadcom products isn't
> entirely clear but given what little information is available and prior
> art in the driver, it seems the convention should be that originally
> Broadcom parts should retain the Broadcom name.
> 
> Thus, rename the relevant constants and firmware file. Also rename the
> specific 89459 PCIe ID to BCM43596, which seems to be the original
> subvariant name for this PCI ID (as defined in the out-of-tree bcmdhd
> driver).
> 
> v2: Since Cypress added this part and will presumably be providing
> its supported firmware, we keep the CYW designation for this device.
> 
> v3: Drop the RAW device ID in this commit. We don't do this for the
> other chips since apparently some devices with them exist in the wild,
> but there is already a 4355 entry with the Broadcom subvendor and WCC
> firmware vendor, so adding a generic fallback to Cypress seems
> redundant (no reason why a device would have the raw device ID *and* an
> explicitly programmed subvendor).

Do you really want to add changes of v2 and v3 to commit message? Or,
just want to let reviewers know that? If latter one is what you want,
move them after s-o-b with delimiter ---

> 
> Fixes: dce45ded7619 ("brcmfmac: Support 89459 pcie")
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Hector Martin <marcan@marcan.st>
---
I mean here.
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c    | 5 ++---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 7 +++----
>  .../net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h  | 5 ++---
>  3 files changed, 7 insertions(+), 10 deletions(-)
> 

