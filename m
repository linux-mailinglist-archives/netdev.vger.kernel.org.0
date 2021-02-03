Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F1830D455
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 08:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbhBCHwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 02:52:30 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:12385 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbhBCHw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 02:52:27 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DVv3y4b2Rz7gQj;
        Wed,  3 Feb 2021 15:50:22 +0800 (CST)
Received: from [10.174.179.241] (10.174.179.241) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Wed, 3 Feb 2021 15:51:36 +0800
Subject: Re: [PATCH] wireless: fix typo issue
To:     Johannes Berg <johannes@sipsolutions.net>,
        samirweng1979 <samirweng1979@163.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        wengjianfeng <wengjianfeng@yulong.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
References: <20210203070025.17628-1-samirweng1979@163.com>
 <9200710b2d9dafea4bfae4bb449a55fb44245d04.camel@sipsolutions.net>
From:   Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <74d4dfc5-51ae-5f53-6210-2cc14da55dcb@huawei.com>
Date:   Wed, 3 Feb 2021 15:51:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <9200710b2d9dafea4bfae4bb449a55fb44245d04.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.241]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/2/3 15:33, Johannes Berg wrote:
> On Wed, 2021-02-03 at 15:00 +0800, samirweng1979 wrote:
>> From: wengjianfeng <wengjianfeng@yulong.com>
>>
>> change 'iff' to 'if'.
>>
>> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
>> ---
>>  net/wireless/chan.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
>> index 285b807..2f17edf 100644
>> --- a/net/wireless/chan.c
>> +++ b/net/wireless/chan.c
>> @@ -1084,7 +1084,7 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
>>   * associated to an AP on the same channel or on the same UNII band
>>   * (assuming that the AP is an authorized master).
>>   * In addition allow operation on a channel on which indoor operation is
>> - * allowed, iff we are currently operating in an indoor environment.
>> + * allowed, if we are currently operating in an indoor environment.
>>   */
> 
> I suspect that was intentional, as a common abbreviation for "if and
> only if".

Yep. iff --> if and only if from:
https://mathvault.ca/math-glossary/#iff

> 
> johannes
> 
> .
> 

