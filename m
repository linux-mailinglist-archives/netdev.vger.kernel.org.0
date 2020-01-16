Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8E313DC2D
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbgAPNfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 08:35:52 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:39616 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726832AbgAPNfw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 08:35:52 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0D31D4BFA032F94AF946;
        Thu, 16 Jan 2020 21:35:49 +0800 (CST)
Received: from [127.0.0.1] (10.177.131.64) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Thu, 16 Jan 2020
 21:35:45 +0800
Subject: Re: [PATCH -next] mac80111: fix build error without
 CONFIG_ATH11K_DEBUGFS
To:     Johannes Berg <johannes@sipsolutions.net>, <davem@davemloft.net>
References: <20200116125155.166749-1-chenzhou10@huawei.com>
 <d9e0af66e2d8cb26ef595e1a2133f55567f4b5e0.camel@sipsolutions.net>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
From:   Chen Zhou <chenzhou10@huawei.com>
Message-ID: <943b570c-48f9-fe5b-1691-37539e3eeec8@huawei.com>
Date:   Thu, 16 Jan 2020 21:35:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <d9e0af66e2d8cb26ef595e1a2133f55567f4b5e0.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.131.64]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi johannes,

On 2020/1/16 20:59, Johannes Berg wrote:
> On Thu, 2020-01-16 at 20:51 +0800, Chen Zhou wrote:
>> If CONFIG_ATH11K_DEBUGFS is n, build fails:
>>
>> drivers/net/wireless/ath/ath11k/debugfs_sta.c: In function ath11k_dbg_sta_open_htt_peer_stats:
>> drivers/net/wireless/ath/ath11k/debugfs_sta.c:416:4: error: struct ath11k has no member named debug
>>   ar->debug.htt_stats.stats_req = stats_req;
>>       ^~
>> and many more similar messages.
>>
>> Select ATH11K_DEBUGFS under config MAC80211_DEBUGFS to fix this.
> 
> Heh, no. You need to find a way in ath11 to fix this.

In file drivers/net/wireless/ath/ath11k/Makefile, "ath11k-$(CONFIG_MAC80211_DEBUGFS) += debugfs_sta.o",
that is, debugfs_sta only compiled when CONFIG_MAC80211_DEBUGFS is y.

Any suggestions about this?

Thanks,
Chen Zhou

> 
> johannes
> 
> 
> .
> 

