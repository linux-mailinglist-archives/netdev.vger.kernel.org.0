Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B678CF615
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 11:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730024AbfJHJeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 05:34:01 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3220 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728866AbfJHJeB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 05:34:01 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id CE777E2A3884B38F2A20;
        Tue,  8 Oct 2019 17:33:58 +0800 (CST)
Received: from [127.0.0.1] (10.184.213.217) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Tue, 8 Oct 2019
 17:33:57 +0800
Subject: Re: [PATCH] rtw88: 8822c: Remove set but not used variable 'corr_val'
To:     <yhchuang@realtek.com>, <pkshih@realtek.com>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
References: <1570180736-133907-1-git-send-email-zhengbin13@huawei.com>
From:   "zhengbin (A)" <zhengbin13@huawei.com>
Message-ID: <08492ba6-eaf6-8c72-74fe-f49e0a95639e@huawei.com>
Date:   Tue, 8 Oct 2019 17:33:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <1570180736-133907-1-git-send-email-zhengbin13@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.184.213.217]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for the noise, please ignore this

On 2019/10/4 17:18, zhengbin wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/net/wireless/realtek/rtw88/rtw8822c.c: In function rtw8822c_dpk_dc_corr_check:
> drivers/net/wireless/realtek/rtw88/rtw8822c.c:2166:5: warning: variable corr_val set but not used [-Wunused-but-set-variable]
>
> It is not used since commit 5227c2ee453d ("rtw88:
> 8822c: add SW DPK support")
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> ---
>  drivers/net/wireless/realtek/rtw88/rtw8822c.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
> index a300efd..52682d5 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
> @@ -2163,7 +2163,7 @@ static void rtw8822c_dpk_rxbb_dc_cal(struct rtw_dev *rtwdev, u8 path)
>  static u8 rtw8822c_dpk_dc_corr_check(struct rtw_dev *rtwdev, u8 path)
>  {
>  	u16 dc_i, dc_q;
> -	u8 corr_val, corr_idx;
> +	u8 corr_idx;
>
>  	rtw_write32(rtwdev, REG_RXSRAM_CTL, 0x000900f0);
>  	dc_i = (u16)rtw_read32_mask(rtwdev, REG_STAT_RPT, GENMASK(27, 16));
> @@ -2176,7 +2176,6 @@ static u8 rtw8822c_dpk_dc_corr_check(struct rtw_dev *rtwdev, u8 path)
>
>  	rtw_write32(rtwdev, REG_RXSRAM_CTL, 0x000000f0);
>  	corr_idx = (u8)rtw_read32_mask(rtwdev, REG_STAT_RPT, GENMASK(7, 0));
> -	corr_val = (u8)rtw_read32_mask(rtwdev, REG_STAT_RPT, GENMASK(15, 8));
>
>  	if (dc_i > 200 || dc_q > 200 || corr_idx < 40 || corr_idx > 65)
>  		return 1;
> --
> 2.7.4
>
>
> .
>

