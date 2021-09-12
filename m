Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE6A407FDA
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 22:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236137AbhILUGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 16:06:30 -0400
Received: from gateway24.websitewelcome.com ([192.185.51.31]:28961 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236017AbhILUG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 16:06:29 -0400
X-Greylist: delayed 1490 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Sep 2021 16:06:29 EDT
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id D9A1618EC
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 14:40:24 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id PVKymG9h9jSwzPVKymheCb; Sun, 12 Sep 2021 14:40:24 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xInK5cuk9Z7/fptDNUK7EUbuavajlWn9R4gJKnXzcjI=; b=e37OC2gnfebZs70nDOnYTwxBbU
        fsRKqZqk3EuCpZBEZWFUz4qcFPaw2KQtlyh1WI/B1tcLiNo4+nQKmlG7Sw8+EROVh4iy7qiF/91aw
        ka9mbtcOF6SH+x0IpnZpql3NOyIVmrbmND16jIzAxWKSZCU/MfXHYdE/sbjUhKhUzA76SqxaJymrX
        wnD7eyuaJxA09HEoAJ+iUp9i/Zf/Ts8wHAnZdP9O/BLzUHDmNry8ASb48oCj6awSuBHQtvCK5Rbd3
        X2lGrK4KfWmw8iRZ5BO4qWQHblMvGT4wZYPi52IktSNLeQ38BFLto1lrqF6nmIEJidQ8hmPPMhjqw
        D38axj5Q==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:57046 helo=[192.168.15.9])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1mPVKy-003pWr-Cw; Sun, 12 Sep 2021 14:40:24 -0500
Subject: Re: [PATCH][next] ath11k: Replace one-element array with
 flexible-array member
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20210823172159.GA25800@embeddedor>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <6e8229a1-187c-cd69-ad1c-018737e5e455@embeddedor.com>
Date:   Sun, 12 Sep 2021 14:44:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210823172159.GA25800@embeddedor>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1mPVKy-003pWr-Cw
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.9]) [187.162.31.110]:57046
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 19
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kalle,

I wonder if you can take this patch, please.

Thanks
--
Gustavo

On 8/23/21 12:21, Gustavo A. R. Silva wrote:
> There is a regular need in the kernel to provide a way to declare having a
> dynamically sized set of trailing elements in a structure. Kernel code
> should always use "flexible array members"[1] for these cases. The older
> style of one-element or zero-length arrays should no longer be used[2].
> 
> Refactor the code a bit according to the use of a flexible-array member in
> struct scan_chan_list_params instead of a one-element array, and use the
> struct_size() helper.
> 
> Also, save 25 (too many) bytes that were being allocated:
> 
> $ pahole -C channel_param drivers/net/wireless/ath/ath11k/reg.o
> struct channel_param {
> 	u8                         chan_id;              /*     0     1 */
> 	u8                         pwr;                  /*     1     1 */
> 	u32                        mhz;                  /*     2     4 */
> 
> 	/* Bitfield combined with next fields */
> 
> 	u32                        half_rate:1;          /*     4:16  4 */
> 	u32                        quarter_rate:1;       /*     4:17  4 */
> 	u32                        dfs_set:1;            /*     4:18  4 */
> 	u32                        dfs_set_cfreq2:1;     /*     4:19  4 */
> 	u32                        is_chan_passive:1;    /*     4:20  4 */
> 	u32                        allow_ht:1;           /*     4:21  4 */
> 	u32                        allow_vht:1;          /*     4:22  4 */
> 	u32                        allow_he:1;           /*     4:23  4 */
> 	u32                        set_agile:1;          /*     4:24  4 */
> 	u32                        psc_channel:1;        /*     4:25  4 */
> 
> 	/* XXX 6 bits hole, try to pack */
> 
> 	u32                        phy_mode;             /*     8     4 */
> 	u32                        cfreq1;               /*    12     4 */
> 	u32                        cfreq2;               /*    16     4 */
> 	char                       maxpower;             /*    20     1 */
> 	char                       minpower;             /*    21     1 */
> 	char                       maxregpower;          /*    22     1 */
> 	u8                         antennamax;           /*    23     1 */
> 	u8                         reg_class_id;         /*    24     1 */
> 
> 	/* size: 25, cachelines: 1, members: 21 */
> 	/* sum members: 23 */
> 	/* sum bitfield members: 10 bits, bit holes: 1, sum bit holes: 6 bits */
> 	/* last cacheline: 25 bytes */
> } __attribute__((__packed__));
> 
> as previously, sizeof(struct scan_chan_list_params) was 32 bytes:
> 
> $ pahole -C scan_chan_list_params drivers/net/wireless/ath/ath11k/reg.o
> struct scan_chan_list_params {
> 	u32                        pdev_id;              /*     0     4 */
> 	u16                        nallchans;            /*     4     2 */
> 	struct channel_param       ch_param[1];          /*     6    25 */
> 
> 	/* size: 32, cachelines: 1, members: 3 */
> 	/* padding: 1 */
> 	/* last cacheline: 32 bytes */
> };
> 
> and now with the flexible array transformation it is just 8 bytes:
> 
> $ pahole -C scan_chan_list_params drivers/net/wireless/ath/ath11k/reg.o
> struct scan_chan_list_params {
> 	u32                        pdev_id;              /*     0     4 */
> 	u16                        nallchans;            /*     4     2 */
> 	struct channel_param       ch_param[];           /*     6     0 */
> 
> 	/* size: 8, cachelines: 1, members: 3 */
> 	/* padding: 2 */
> 	/* last cacheline: 8 bytes */
> };
> 
> This helps with the ongoing efforts to globally enable -Warray-bounds and
> get us closer to being able to tighten the FORTIFY_SOURCE routines on
> memcpy().
> 
> This issue was found with the help of Coccinelle and audited and fixed,
> manually.
> 
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://github.com/KSPP/linux/issues/109
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/net/wireless/ath/ath11k/reg.c | 7 ++-----
>  drivers/net/wireless/ath/ath11k/wmi.c | 2 +-
>  drivers/net/wireless/ath/ath11k/wmi.h | 2 +-
>  3 files changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/reg.c b/drivers/net/wireless/ath/ath11k/reg.c
> index e1a1df169034..c83d265185f1 100644
> --- a/drivers/net/wireless/ath/ath11k/reg.c
> +++ b/drivers/net/wireless/ath/ath11k/reg.c
> @@ -97,7 +97,6 @@ int ath11k_reg_update_chan_list(struct ath11k *ar)
>  	struct channel_param *ch;
>  	enum nl80211_band band;
>  	int num_channels = 0;
> -	int params_len;
>  	int i, ret;
>  
>  	bands = hw->wiphy->bands;
> @@ -117,10 +116,8 @@ int ath11k_reg_update_chan_list(struct ath11k *ar)
>  	if (WARN_ON(!num_channels))
>  		return -EINVAL;
>  
> -	params_len = sizeof(struct scan_chan_list_params) +
> -			num_channels * sizeof(struct channel_param);
> -	params = kzalloc(params_len, GFP_KERNEL);
> -
> +	params = kzalloc(struct_size(params, ch_param, num_channels),
> +			 GFP_KERNEL);
>  	if (!params)
>  		return -ENOMEM;
>  
> diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
> index 6c253eae9d06..0a634ba04509 100644
> --- a/drivers/net/wireless/ath/ath11k/wmi.c
> +++ b/drivers/net/wireless/ath/ath11k/wmi.c
> @@ -2285,7 +2285,7 @@ int ath11k_wmi_send_scan_chan_list_cmd(struct ath11k *ar,
>  	u16 num_send_chans, num_sends = 0, max_chan_limit = 0;
>  	u32 *reg1, *reg2;
>  
> -	tchan_info = &chan_list->ch_param[0];
> +	tchan_info = chan_list->ch_param;
>  	while (chan_list->nallchans) {
>  		len = sizeof(*cmd) + TLV_HDR_SIZE;
>  		max_chan_limit = (wmi->wmi_ab->max_msg_len[ar->pdev_idx] - len) /
> diff --git a/drivers/net/wireless/ath/ath11k/wmi.h b/drivers/net/wireless/ath/ath11k/wmi.h
> index d35c47e0b19d..d9c83726f65d 100644
> --- a/drivers/net/wireless/ath/ath11k/wmi.h
> +++ b/drivers/net/wireless/ath/ath11k/wmi.h
> @@ -3608,7 +3608,7 @@ struct wmi_stop_scan_cmd {
>  struct scan_chan_list_params {
>  	u32 pdev_id;
>  	u16 nallchans;
> -	struct channel_param ch_param[1];
> +	struct channel_param ch_param[];
>  };
>  
>  struct wmi_scan_chan_list_cmd {
> 
