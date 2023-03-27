Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7CFF6C9906
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 02:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbjC0AiH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 26 Mar 2023 20:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbjC0AiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 20:38:06 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A3912E;
        Sun, 26 Mar 2023 17:38:05 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 32R0bIhoD005218, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 32R0bIhoD005218
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Mon, 27 Mar 2023 08:37:18 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.95) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Mon, 27 Mar 2023 08:37:34 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Mon, 27 Mar 2023 08:37:34 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Mon, 27 Mar 2023 08:37:34 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Cai Huoqing <cai.huoqing@linux.dev>
CC:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ath11k@lists.infradead.org" <ath11k@lists.infradead.org>,
        "ath12k@lists.infradead.org" <ath12k@lists.infradead.org>
Subject: RE: [PATCH 5/5] wifi: rtw89: Remove redundant pci_clear_master
Thread-Topic: [PATCH 5/5] wifi: rtw89: Remove redundant pci_clear_master
Thread-Index: AQHZXXpgQZeubkOvMUyQJYDWG6thja8NzZ5A
Date:   Mon, 27 Mar 2023 00:37:33 +0000
Message-ID: <90e016cbdf5846b6989af90c1f57d532@realtek.com>
References: <20230323112613.7550-1-cai.huoqing@linux.dev>
 <20230323112613.7550-5-cai.huoqing@linux.dev>
In-Reply-To: <20230323112613.7550-5-cai.huoqing@linux.dev>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS02.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Cai Huoqing <cai.huoqing@linux.dev>
> Sent: Thursday, March 23, 2023 7:26 PM
> To: cai.huoqing@linux.dev
> Cc: Kalle Valo <kvalo@kernel.org>; David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Yan-Hsuan Chuang
> <tony0620emma@gmail.com>; Ping-Ke Shih <pkshih@realtek.com>; ath10k@lists.infradead.org;
> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> ath11k@lists.infradead.org; ath12k@lists.infradead.org
> Subject: [PATCH 5/5] wifi: rtw89: Remove redundant pci_clear_master
> 
> Remove pci_clear_master to simplify the code,
> the bus-mastering is also cleared in do_pci_disable_device,
> like this:
> ./drivers/pci/pci.c:2197
> static void do_pci_disable_device(struct pci_dev *dev)
> {
>         u16 pci_command;
> 
>         pci_read_config_word(dev, PCI_COMMAND, &pci_command);
>         if (pci_command & PCI_COMMAND_MASTER) {
>                 pci_command &= ~PCI_COMMAND_MASTER;
>                 pci_write_config_word(dev, PCI_COMMAND, pci_command);
>         }
> 
>         pcibios_disable_device(dev);
> }.
> And dev->is_busmaster is set to 0 in pci_disable_device.
> 
> Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

> ---
>  drivers/net/wireless/realtek/rtw89/pci.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
> index ec8bb5f10482..75bd3ac4dd71 100644
> --- a/drivers/net/wireless/realtek/rtw89/pci.c
> +++ b/drivers/net/wireless/realtek/rtw89/pci.c
> @@ -2694,7 +2694,6 @@ static int rtw89_pci_claim_device(struct rtw89_dev *rtwdev,
>  static void rtw89_pci_declaim_device(struct rtw89_dev *rtwdev,
>                                      struct pci_dev *pdev)
>  {
> -       pci_clear_master(pdev);
>         pci_disable_device(pdev);
>  }
> 
> --
> 2.34.1

