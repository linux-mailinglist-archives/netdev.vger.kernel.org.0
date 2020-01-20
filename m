Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 652A314219E
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 03:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgATCin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 21:38:43 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:56460 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728874AbgATCin (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jan 2020 21:38:43 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 46703BD5F194AA73C08D;
        Mon, 20 Jan 2020 10:38:41 +0800 (CST)
Received: from [127.0.0.1] (10.177.131.64) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Mon, 20 Jan 2020
 10:38:31 +0800
Subject: Re: [PATCH -next] net: hns3: replace snprintf with scnprintf in
 hns3_update_strings
To:     tanhuazhong <tanhuazhong@huawei.com>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <davem@davemloft.net>
References: <20200119124053.30262-1-chenzhou10@huawei.com>
 <3762cced-2a4a-7d54-787f-751c6fde2148@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   Chen Zhou <chenzhou10@huawei.com>
Message-ID: <e7ae2607-1464-2268-03f7-244d6a2f2f43@huawei.com>
Date:   Mon, 20 Jan 2020 10:38:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <3762cced-2a4a-7d54-787f-751c6fde2148@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.131.64]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/1/20 9:27, tanhuazhong wrote:
> 
> 
> On 2020/1/19 20:40, Chen Zhou wrote:
>> snprintf returns the number of bytes that would be written, which may be
>> greater than the the actual length to be written. Here use extra code to
>> handle this.
>>
>> scnprintf returns the number of bytes that was actually written, just use
>> scnprintf to simplify the code.
>>
>> Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
>> ---
>>   drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
>> index 6e0212b..fa01888 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
>> @@ -423,9 +423,8 @@ static void *hns3_update_strings(u8 *data, const struct hns3_stats *stats,
>>               data[ETH_GSTRING_LEN - 1] = '\0';
>>                 /* first, prepend the prefix string */
>> -            n1 = snprintf(data, MAX_PREFIX_SIZE, "%s%d_",
>> +            n1 = scnprintf(data, MAX_PREFIX_SIZE, "%s%d_",
>>                         prefix, i);
> 
> not align?

Ok, I will fix it in next version.

Thanks,
Chen Zhou

> 
>> -            n1 = min_t(uint, n1, MAX_PREFIX_SIZE - 1);
>>               size_left = (ETH_GSTRING_LEN - 1) - n1;
>>                 /* now, concatenate the stats string to it */
>>
> 
> 
> .
> 

