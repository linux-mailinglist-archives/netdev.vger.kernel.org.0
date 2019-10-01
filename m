Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB5CC305C
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 11:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbfJAJjK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 1 Oct 2019 05:39:10 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:59979 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbfJAJjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 05:39:09 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x919csE2032503, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x919csE2032503
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 1 Oct 2019 17:38:54 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Tue, 1 Oct 2019
 17:38:53 +0800
From:   Pkshih <pkshih@realtek.com>
To:     zhengbin <zhengbin13@huawei.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 3/6] rtlwifi: rtl8192ee: Remove set but not used variable 'err'
Thread-Topic: [PATCH 3/6] rtlwifi: rtl8192ee: Remove set but not used
 variable 'err'
Thread-Index: AQHVd2vU6ma7X7lkhU6QwwWxUnTANqdFiJ5Q
Date:   Tue, 1 Oct 2019 09:38:52 +0000
Message-ID: <5B2DA6FDDF928F4E855344EE0A5C39D1D5C77D56@RTITMBSVM04.realtek.com.tw>
References: <1569833692-93288-1-git-send-email-zhengbin13@huawei.com>
 <1569833692-93288-4-git-send-email-zhengbin13@huawei.com>
In-Reply-To: <1569833692-93288-4-git-send-email-zhengbin13@huawei.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.95]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@vger.kernel.org] On Behalf
> Of zhengbin
> Sent: Monday, September 30, 2019 4:55 PM
> To: Pkshih; kvalo@codeaurora.org; davem@davemloft.net; linux-wireless@vger.kernel.org;
> netdev@vger.kernel.org
> Cc: zhengbin13@huawei.com
> Subject: [PATCH 3/6] rtlwifi: rtl8192ee: Remove set but not used variable 'err'
> 
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c: In function rtl92ee_download_fw:
> drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c:111:6: warning: variable err set but not used
> [-Wunused-but-set-variable]
> 
> It is not used since commit c93ac39da006 ("rtlwifi:
> Remove some redundant code")
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> ---
>  drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
> b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
> index 67305ce..322798c 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
> @@ -108,7 +108,6 @@ int rtl92ee_download_fw(struct ieee80211_hw *hw, bool buse_wake_on_wlan_fw)
>  	struct rtlwifi_firmware_header *pfwheader;
>  	u8 *pfwdata;
>  	u32 fwsize;
> -	int err;
>  	enum version_8192e version = rtlhal->version;
> 
>  	if (!rtlhal->pfirmware)
> @@ -146,7 +145,7 @@ int rtl92ee_download_fw(struct ieee80211_hw *hw, bool buse_wake_on_wlan_fw)
>  	_rtl92ee_write_fw(hw, version, pfwdata, fwsize);
>  	_rtl92ee_enable_fw_download(hw, false);
> 
> -	err = _rtl92ee_fw_free_to_go(hw);
> +	(void)_rtl92ee_fw_free_to_go(hw);
> 
>  	return 0;

After checking the flow, it's ok 'return _rtl92ee_fw_free_to_go(hw);'.

>  }
> --
> 2.7.4
> 
> 
> ------Please consider the environment before printing this e-mail.
