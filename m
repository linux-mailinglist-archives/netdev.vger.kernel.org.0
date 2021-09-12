Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB03C407FD8
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 22:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236129AbhILUCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 16:02:40 -0400
Received: from gateway31.websitewelcome.com ([192.185.144.91]:17811 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236017AbhILUCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 16:02:32 -0400
X-Greylist: delayed 1333 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Sep 2021 16:02:32 EDT
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id AF7EA260E2
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 14:39:03 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id PVJfmA41NBvjyPVJfmpavf; Sun, 12 Sep 2021 14:39:03 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GKDQOkt6TxsQsetnoiDEY3nKbPSKGF4Zl9dUo5Mi4w4=; b=nh/NrY6N0h/ZYNN5wLYNvFPOwe
        SNOaz+OgddxQ4fy7OD5EelQD2K5zPLTNMeJbHpNvHjzGKXwwtSEh5vBEo6W266p7FI8rYP0/LSU7K
        vHJvPkU0QYuEnOgDOU2WaSuCgnruI+/1mdg8gAjv1/xRIcHxQgz4ke7niwCeGmVenWBwVGcZfCFRb
        zPcS3AmwpWCG2642FS8OylNM6xs8mMcyv79O4BKzsELZdujqO6hhyyfIYzFxShW9ipj6kmZvvajbV
        J2Sxd9xTC5alM5stuGa7QOf6J9cuQTMZ/SCc4YReytU9FllgYKhnmsPVbxHmbu6N7Rzly325EcgHc
        prPk/OFw==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:57030 helo=[192.168.15.9])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1mPVJd-003oAk-Ox; Sun, 12 Sep 2021 14:39:01 -0500
Subject: Re: [PATCH] ath11k: Replace one-element array with flexible-array
 member
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Len Baker <len.baker@gmx.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210904114937.6644-1-len.baker@gmx.com>
 <20210912193140.GC146608@embeddedor>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <7a9ba7d3-b5e7-00ab-3bd3-7fca476aae94@embeddedor.com>
Date:   Sun, 12 Sep 2021 14:42:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210912193140.GC146608@embeddedor>
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
X-Exim-ID: 1mPVJd-003oAk-Ox
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.9]) [187.162.31.110]:57030
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 10
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/12/21 14:31, Gustavo A. R. Silva wrote:
> 
> There is already a patch for this:
> 
> https://lore.kernel.org/lkml/20210823172159.GA25800@embeddedor/
> 
> which I will now add to my -next tree.

Well, in this case I think it's much better if Kalle can take it. :)

--
Gustavo
> On Sat, Sep 04, 2021 at 01:49:37PM +0200, Len Baker wrote:
>> There is a regular need in the kernel to provide a way to declare having
>> a dynamically sized set of trailing elements in a structure. Kernel code
>> should always use "flexible array members"[1] for these cases. The older
>> style of one-element or zero-length arrays should no longer be used[2].
>>
>> Also, refactor the code a bit to make use of the struct_size() helper in
>> kzalloc().
>>
>> [1] https://en.wikipedia.org/wiki/Flexible_array_member
>> [2] https://www.kernel.org/doc/html/v5.14/process/deprecated.html#zero-length-and-one-element-arrays
>>
>> Signed-off-by: Len Baker <len.baker@gmx.com>
>> ---
>>  drivers/net/wireless/ath/ath11k/reg.c | 7 ++-----
>>  drivers/net/wireless/ath/ath11k/wmi.h | 2 +-
>>  2 files changed, 3 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath11k/reg.c b/drivers/net/wireless/ath/ath11k/reg.c
>> index e1a1df169034..c83d265185f1 100644
>> --- a/drivers/net/wireless/ath/ath11k/reg.c
>> +++ b/drivers/net/wireless/ath/ath11k/reg.c
>> @@ -97,7 +97,6 @@ int ath11k_reg_update_chan_list(struct ath11k *ar)
>>  	struct channel_param *ch;
>>  	enum nl80211_band band;
>>  	int num_channels = 0;
>> -	int params_len;
>>  	int i, ret;
>>
>>  	bands = hw->wiphy->bands;
>> @@ -117,10 +116,8 @@ int ath11k_reg_update_chan_list(struct ath11k *ar)
>>  	if (WARN_ON(!num_channels))
>>  		return -EINVAL;
>>
>> -	params_len = sizeof(struct scan_chan_list_params) +
>> -			num_channels * sizeof(struct channel_param);
>> -	params = kzalloc(params_len, GFP_KERNEL);
>> -
>> +	params = kzalloc(struct_size(params, ch_param, num_channels),
>> +			 GFP_KERNEL);
>>  	if (!params)
>>  		return -ENOMEM;
>>
>> diff --git a/drivers/net/wireless/ath/ath11k/wmi.h b/drivers/net/wireless/ath/ath11k/wmi.h
>> index d35c47e0b19d..d9c83726f65d 100644
>> --- a/drivers/net/wireless/ath/ath11k/wmi.h
>> +++ b/drivers/net/wireless/ath/ath11k/wmi.h
>> @@ -3608,7 +3608,7 @@ struct wmi_stop_scan_cmd {
>>  struct scan_chan_list_params {
>>  	u32 pdev_id;
>>  	u16 nallchans;
>> -	struct channel_param ch_param[1];
>> +	struct channel_param ch_param[];
>>  };
>>
>>  struct wmi_scan_chan_list_cmd {
>> --
>> 2.25.1
>>
