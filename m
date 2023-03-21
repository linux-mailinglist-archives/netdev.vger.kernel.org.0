Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7BE6C265D
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 01:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjCUAd5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Mar 2023 20:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjCUAd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 20:33:56 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C26614226;
        Mon, 20 Mar 2023 17:33:53 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 32L0X2Og8021089, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 32L0X2Og8021089
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Tue, 21 Mar 2023 08:33:02 +0800
Received: from RTEXMBS03.realtek.com.tw (172.21.6.96) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Tue, 21 Mar 2023 08:32:27 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Tue, 21 Mar 2023 08:32:26 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Tue, 21 Mar 2023 08:32:26 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Tom Rix <trix@redhat.com>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>
Subject: RE: [PATCH] wifi: rtw88: remove unused rtw_pci_get_tx_desc function
Thread-Topic: [PATCH] wifi: rtw88: remove unused rtw_pci_get_tx_desc function
Thread-Index: AQHZW4S2PiAeUP74qUG+p5pnBukePa8EYhmQ
Date:   Tue, 21 Mar 2023 00:32:26 +0000
Message-ID: <e9ca21b87b4246ddaafc5b0cabc9eb74@realtek.com>
References: <20230320233448.1729899-1-trix@redhat.com>
In-Reply-To: <20230320233448.1729899-1-trix@redhat.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS03.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2023/3/20_=3F=3F_10:00:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Tom Rix <trix@redhat.com>
> Sent: Tuesday, March 21, 2023 7:35 AM
> To: tony0620emma@gmail.com; kvalo@kernel.org; davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; nathan@kernel.org; ndesaulniers@google.com
> Cc: linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> llvm@lists.linux.dev; Tom Rix <trix@redhat.com>
> Subject: [PATCH] wifi: rtw88: remove unused rtw_pci_get_tx_desc function
> 
> clang with W=1 reports
> drivers/net/wireless/realtek/rtw88/pci.c:92:21: error:
>   unused function 'rtw_pci_get_tx_desc' [-Werror,-Wunused-function]
> static inline void *rtw_pci_get_tx_desc(struct rtw_pci_tx_ring *tx_ring, u8 idx)
>                     ^
> This function is not used, so remove it.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

> ---
>  drivers/net/wireless/realtek/rtw88/pci.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
> index b4bd831c9845..6a8e6ee82069 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.c
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -89,13 +89,6 @@ static void rtw_pci_write32(struct rtw_dev *rtwdev, u32 addr, u32 val)
>         writel(val, rtwpci->mmap + addr);
>  }
> 
> -static inline void *rtw_pci_get_tx_desc(struct rtw_pci_tx_ring *tx_ring, u8 idx)
> -{
> -       int offset = tx_ring->r.desc_size * idx;
> -
> -       return tx_ring->r.head + offset;
> -}
> -
>  static void rtw_pci_free_tx_ring_skbs(struct rtw_dev *rtwdev,
>                                       struct rtw_pci_tx_ring *tx_ring)
>  {
> --
> 2.27.0

