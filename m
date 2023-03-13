Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE5F66B7210
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 10:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbjCMJIL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 13 Mar 2023 05:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbjCMJHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 05:07:52 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DB95CC32;
        Mon, 13 Mar 2023 02:05:46 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 32D95NOR0032188, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 32D95NOR0032188
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Mon, 13 Mar 2023 17:05:23 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Mon, 13 Mar 2023 17:04:43 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Mon, 13 Mar 2023 17:04:42 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Mon, 13 Mar 2023 17:04:42 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Morgan <macroalpha82@gmail.com>,
        "Nitin Gupta" <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: RE: [PATCH v2 RFC 3/9] wifi: rtw88: mac: Support SDIO specific bits in the power on sequence
Thread-Topic: [PATCH v2 RFC 3/9] wifi: rtw88: mac: Support SDIO specific bits
 in the power on sequence
Thread-Index: AQHZU48SQkItyU0DS0St9KPoQOCyqq74bdTQ
Date:   Mon, 13 Mar 2023 09:04:42 +0000
Message-ID: <7330960d32664bf0bce8446aa93d10c8@realtek.com>
References: <20230310202922.2459680-1-martin.blumenstingl@googlemail.com>
 <20230310202922.2459680-4-martin.blumenstingl@googlemail.com>
In-Reply-To: <20230310202922.2459680-4-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Sent: Saturday, March 11, 2023 4:29 AM
> To: linux-wireless@vger.kernel.org
> Cc: Yan-Hsuan Chuang <tony0620emma@gmail.com>; Kalle Valo <kvalo@kernel.org>; Ulf Hansson
> <ulf.hansson@linaro.org>; linux-kernel@vger.kernel.org; netdev@vger.kernel.org;
> linux-mmc@vger.kernel.org; Chris Morgan <macroalpha82@gmail.com>; Nitin Gupta <nitin.gupta981@gmail.com>;
> Neo Jou <neojou@gmail.com>; Ping-Ke Shih <pkshih@realtek.com>; Jernej Skrabec <jernej.skrabec@gmail.com>;
> Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Subject: [PATCH v2 RFC 3/9] wifi: rtw88: mac: Support SDIO specific bits in the power on sequence
> 
> Add the code specific to SDIO HCI in the MAC power on sequence. This is
> based on the RTL8822BS and RTL8822CS vendor drivers.
> 
> Co-developed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
> Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
> Changes since v1:
> - only access REG_SDIO_HIMR for RTW_HCI_TYPE_SDIO
> - use proper BIT_HCI_SUS_REQ, BIT_HCI_RESUME_RDY and BIT_SDIO_PAD_E5
>   macros as suggested by Ping-Ke
> 
> 
>  drivers/net/wireless/realtek/rtw88/mac.c | 46 +++++++++++++++++++++---
>  1 file changed, 42 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
> index cfdfc8a2c836..17704394cca3 100644
> --- a/drivers/net/wireless/realtek/rtw88/mac.c
> +++ b/drivers/net/wireless/realtek/rtw88/mac.c
> @@ -7,6 +7,7 @@
>  #include "reg.h"
>  #include "fw.h"
>  #include "debug.h"
> +#include "sdio.h"
> 
>  void rtw_set_channel_mac(struct rtw_dev *rtwdev, u8 channel, u8 bw,
>                          u8 primary_ch_idx)
> @@ -60,6 +61,7 @@ EXPORT_SYMBOL(rtw_set_channel_mac);
> 
>  static int rtw_mac_pre_system_cfg(struct rtw_dev *rtwdev)
>  {
> +       unsigned int retry;
>         u32 value32;
>         u8 value8;
> 
> @@ -77,6 +79,28 @@ static int rtw_mac_pre_system_cfg(struct rtw_dev *rtwdev)
>         case RTW_HCI_TYPE_PCIE:
>                 rtw_write32_set(rtwdev, REG_HCI_OPT_CTRL, BIT_USB_SUS_DIS);
>                 break;
> +       case RTW_HCI_TYPE_SDIO:
> +               rtw_write8_clr(rtwdev, REG_SDIO_HSUS_CTRL, BIT_HCI_SUS_REQ);
> +
> +               for (retry = 0; retry < RTW_PWR_POLLING_CNT; retry++) {
> +                       if (rtw_read8(rtwdev, REG_SDIO_HSUS_CTRL) & BIT_HCI_RESUME_RDY)
> +                               break;
> +
> +                       usleep_range(10, 50);
> +               }
> +
> +               if (retry == RTW_PWR_POLLING_CNT) {
> +                       rtw_err(rtwdev, "failed to poll REG_SDIO_HSUS_CTRL[1]");
> +                       return -ETIMEDOUT;
> +               }
> +
> +               if (rtw_sdio_is_sdio30_supported(rtwdev))
> +                       rtw_write8_set(rtwdev, REG_HCI_OPT_CTRL + 2,
> +                                      BIT_SDIO_PAD_E5 >> 16);
> +               else
> +                       rtw_write8_clr(rtwdev, REG_HCI_OPT_CTRL + 2,
> +                                      BIT_SDIO_PAD_E5 >> 16);
> +               break;
>         case RTW_HCI_TYPE_USB:
>                 break;
>         default:
> @@ -248,6 +272,7 @@ static int rtw_mac_power_switch(struct rtw_dev *rtwdev, bool pwr_on)
>  {
>         const struct rtw_chip_info *chip = rtwdev->chip;
>         const struct rtw_pwr_seq_cmd **pwr_seq;
> +       u32 imr;
>         u8 rpwm;
>         bool cur_pwr;
>         int ret;
> @@ -273,18 +298,24 @@ static int rtw_mac_power_switch(struct rtw_dev *rtwdev, bool pwr_on)
>         if (pwr_on == cur_pwr)
>                 return -EALREADY;
> 
> +       if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_SDIO) {
> +               imr = rtw_read32(rtwdev, REG_SDIO_HIMR);
> +               rtw_write32(rtwdev, REG_SDIO_HIMR, 0);
> +       }
> +
>         if (!pwr_on)
>                 clear_bit(RTW_FLAG_POWERON, rtwdev->flags);
> 
>         pwr_seq = pwr_on ? chip->pwr_on_seq : chip->pwr_off_seq;
>         ret = rtw_pwr_seq_parser(rtwdev, pwr_seq);
> -       if (ret)
> -               return ret;
> +
> +       if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_SDIO)
> +               rtw_write32(rtwdev, REG_SDIO_HIMR, imr);
> 
>         if (pwr_on)
>                 set_bit(RTW_FLAG_POWERON, rtwdev->flags);

If failed to power on, it still set RTW_FLAG_POWERON. Is it reasonable?
Did you meet real problem here?

Maybe, here can be 

         if (pwr_on && !ret)
                 set_bit(RTW_FLAG_POWERON, rtwdev->flags);

> 
> -       return 0;
> +       return ret;
>  }
> 
>  static int __rtw_mac_init_system_cfg(struct rtw_dev *rtwdev)
> @@ -455,6 +486,9 @@ static void download_firmware_reg_backup(struct rtw_dev *rtwdev,
>         rtw_write16(rtwdev, REG_FIFOPAGE_INFO_1, 0x200);
>         rtw_write32(rtwdev, REG_RQPN_CTRL_2, bckp[bckp_idx - 1].val);
> 
> +       if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_SDIO)
> +               rtw_read32(rtwdev, REG_SDIO_FREE_TXPG);
> +
>         /* Disable beacon related functions */
>         tmp = rtw_read8(rtwdev, REG_BCN_CTRL);
>         bckp[bckp_idx].len = 1;
> @@ -1067,8 +1101,12 @@ static int txdma_queue_mapping(struct rtw_dev *rtwdev)
>         if (rtw_chip_wcpu_11ac(rtwdev))
>                 rtw_write32(rtwdev, REG_H2CQ_CSR, BIT_H2CQ_FULL);
> 
> -       if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_USB)
> +       if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_SDIO) {
> +               rtw_read32(rtwdev, REG_SDIO_FREE_TXPG);
> +               rtw_write32(rtwdev, REG_SDIO_TX_CTRL, 0);
> +       } else if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_USB) {
>                 rtw_write8_set(rtwdev, REG_TXDMA_PQ_MAP, BIT_RXDMA_ARBBW_EN);
> +       }
> 
>         return 0;
>  }
> --
> 2.39.2

