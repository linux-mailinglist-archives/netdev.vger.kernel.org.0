Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 839075B52A3
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 04:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiILCBh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 11 Sep 2022 22:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiILCBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 22:01:36 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B115D275ED;
        Sun, 11 Sep 2022 19:01:33 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 28C20AkN4002827, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 28C20AkN4002827
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Mon, 12 Sep 2022 10:00:10 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 12 Sep 2022 10:00:30 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 12 Sep 2022 10:00:29 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::402d:f52e:eaf0:28a2]) by
 RTEXMBS04.realtek.com.tw ([fe80::402d:f52e:eaf0:28a2%5]) with mapi id
 15.01.2375.007; Mon, 12 Sep 2022 10:00:29 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     sunliming <sunliming@kylinos.cn>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kelulanainsley@gmail.com" <kelulanainsley@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: RE: [PATCH] rtw89: coex: fix for variable set but not used warning
Thread-Topic: [PATCH] rtw89: coex: fix for variable set but not used warning
Thread-Index: AQHYxkk1LrygW/FN+UCxqSsY3SRR3q3bCAeA
Date:   Mon, 12 Sep 2022 02:00:29 +0000
Message-ID: <e4f549a7a60d4f01bf99a89e9f1cb8c4@realtek.com>
References: <20220912014411.1432175-1-sunliming@kylinos.cn>
In-Reply-To: <20220912014411.1432175-1-sunliming@kylinos.cn>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/9/11_=3F=3F_10:00:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: sunliming <sunliming@kylinos.cn>
> Sent: Monday, September 12, 2022 9:44 AM
> To: Ping-Ke Shih <pkshih@realtek.com>; kvalo@kernel.org; davem@davemloft.net; edumazet@google.com;
> kuba@kernel.org; pabeni@redhat.com
> Cc: linux-wireless@vger.kernel.org; netdev@vger.kernel.org; kelulanainsley@gmail.com; sunliming
> <sunliming@kylinos.cn>; kernel test robot <lkp@intel.com>
> Subject: [PATCH] rtw89: coex: fix for variable set but not used warning

The subject should be 'wifi: rtw89: coex: ...'.

> 
> Fix below kernel warning:
> drivers/net/wireless/realtek/rtw89/coex.c:3244:25: warning: variable 'cnt_connecting'
> set but not used [-Wunused-but-set-variable]
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: sunliming <sunliming@kylinos.cn>
> ---
>  drivers/net/wireless/realtek/rtw89/coex.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
> index 683854bba217..ee4817358c35 100644
> --- a/drivers/net/wireless/realtek/rtw89/coex.c
> +++ b/drivers/net/wireless/realtek/rtw89/coex.c
> @@ -3290,7 +3290,7 @@ static void _update_wl_info(struct rtw89_dev *rtwdev)
>  	struct rtw89_btc_wl_link_info *wl_linfo = wl->link_info;
>  	struct rtw89_btc_wl_role_info *wl_rinfo = &wl->role_info;
>  	struct rtw89_btc_wl_dbcc_info *wl_dinfo = &wl->dbcc_info;
> -	u8 i, cnt_connect = 0, cnt_connecting = 0, cnt_active = 0;
> +	u8 i, cnt_connect = 0, cnt_active = 0;
>  	u8 cnt_2g = 0, cnt_5g = 0, phy;
>  	u32 wl_2g_ch[2] = {0}, wl_5g_ch[2] = {0};
>  	bool b2g = false, b5g = false, client_joined = false;
> @@ -3324,9 +3324,7 @@ static void _update_wl_info(struct rtw89_dev *rtwdev)
> 
>  		if (wl_linfo[i].connected == MLME_NO_LINK) {
>  			continue;
> -		} else if (wl_linfo[i].connected == MLME_LINKING) {
> -			cnt_connecting++;
> -		} else {
> +		} else if (wl_linfo[i].connected != MLME_LINKING) {
>  			cnt_connect++;
>  			if ((wl_linfo[i].role == RTW89_WIFI_ROLE_P2P_GO ||
>  			     wl_linfo[i].role == RTW89_WIFI_ROLE_AP) &&

Though this patch can fix warning, we would like to show cnt_connecting in 
debug message, and then we can know the transient state between no link and 
connected. I will send it by myself.

So, nack this patch.

--
Ping-Ke

