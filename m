Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7FA2EAB6
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 04:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfE3CcW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 May 2019 22:32:22 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:37548 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbfE3CcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 22:32:21 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x4U2W8mC004450, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x4U2W8mC004450
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Thu, 30 May 2019 10:32:08 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Thu, 30 May
 2019 10:32:08 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] rtw88: Remove set but not used variable 'ip_sel' and 'orig'
Thread-Topic: [PATCH] rtw88: Remove set but not used variable 'ip_sel' and
 'orig'
Thread-Index: AQHVFi7tVKme6Dla+EywC8esuGtTIaaC8s0g
Date:   Thu, 30 May 2019 02:32:08 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D17FABE0@RTITMBSVM04.realtek.com.tw>
References: <20190529145740.22804-1-yuehaibing@huawei.com>
In-Reply-To: <20190529145740.22804-1-yuehaibing@huawei.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.183]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: YueHaibing [mailto:yuehaibing@huawei.com]
> Sent: Wednesday, May 29, 2019 10:58 PM
> To: Tony Chuang; kvalo@codeaurora.org; davem@davemloft.net
> Cc: linux-kernel@vger.kernel.org; netdev@vger.kernel.org;
> linux-wireless@vger.kernel.org; YueHaibing
> Subject: [PATCH] rtw88: Remove set but not used variable 'ip_sel' and 'orig'
> 
> Fixes gcc '-Wunused-but-set-variable' warnings:
> 
> drivers/net/wireless/realtek/rtw88/pci.c: In function rtw_pci_phy_cfg:
> drivers/net/wireless/realtek/rtw88/pci.c:978:6: warning: variable ip_sel set
> but not used [-Wunused-but-set-variable]
> drivers/net/wireless/realtek/rtw88/phy.c: In function
> phy_tx_power_limit_config:
> drivers/net/wireless/realtek/rtw88/phy.c:1607:11: warning: variable orig set
> but not used [-Wunused-but-set-variable]
> 
> They are never used, so can be removed.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/wireless/realtek/rtw88/pci.c | 3 ---
>  drivers/net/wireless/realtek/rtw88/phy.c | 3 +--
>  2 files changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c
> b/drivers/net/wireless/realtek/rtw88/pci.c
> index 353871c27779..8329f4e447b7 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.c
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -977,7 +977,6 @@ static void rtw_pci_phy_cfg(struct rtw_dev *rtwdev)
>  	u16 cut;
>  	u16 value;
>  	u16 offset;
> -	u16 ip_sel;
>  	int i;
> 
>  	cut = BIT(0) << rtwdev->hal.cut_version;
> @@ -990,7 +989,6 @@ static void rtw_pci_phy_cfg(struct rtw_dev *rtwdev)
>  			break;
>  		offset = para->offset;
>  		value = para->value;
> -		ip_sel = para->ip_sel;
>  		if (para->ip_sel == RTW_IP_SEL_PHY)
>  			rtw_mdio_write(rtwdev, offset, value, true);
>  		else
> @@ -1005,7 +1003,6 @@ static void rtw_pci_phy_cfg(struct rtw_dev
> *rtwdev)
>  			break;
>  		offset = para->offset;
>  		value = para->value;
> -		ip_sel = para->ip_sel;
>  		if (para->ip_sel == RTW_IP_SEL_PHY)
>  			rtw_mdio_write(rtwdev, offset, value, false);
>  		else
> diff --git a/drivers/net/wireless/realtek/rtw88/phy.c
> b/drivers/net/wireless/realtek/rtw88/phy.c
> index 404d89432c96..c3e75ffe27b5 100644
> --- a/drivers/net/wireless/realtek/rtw88/phy.c
> +++ b/drivers/net/wireless/realtek/rtw88/phy.c
> @@ -1604,12 +1604,11 @@ void rtw_phy_tx_power_by_rate_config(struct
> rtw_hal *hal)
>  static void
>  phy_tx_power_limit_config(struct rtw_hal *hal, u8 regd, u8 bw, u8 rs)
>  {
> -	s8 base, orig;
> +	s8 base;
>  	u8 ch;
> 
>  	for (ch = 0; ch < RTW_MAX_CHANNEL_NUM_2G; ch++) {
>  		base = hal->tx_pwr_by_rate_base_2g[0][rs];
> -		orig = hal->tx_pwr_limit_2g[regd][bw][rs][ch];
>  		hal->tx_pwr_limit_2g[regd][bw][rs][ch] -= base;
>  	}
> 


Hi Haibing

I have submitted a patch fix the unused variable in phy.c
Which is,

> drivers/net/wireless/realtek/rtw88/phy.c: In function
> phy_tx_power_limit_config:
> drivers/net/wireless/realtek/rtw88/phy.c:1607:11: warning: variable orig set
> but not used [-Wunused-but-set-variable]

Can you drop the changes in phy.c and remain the changes in pci.c?
Thanks.

Yan-Hsuan
