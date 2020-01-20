Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9503514219B
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 03:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbgATChO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 21:37:14 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:50290 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728874AbgATChO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jan 2020 21:37:14 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6196DC053B8285566763;
        Mon, 20 Jan 2020 10:37:11 +0800 (CST)
Received: from [127.0.0.1] (10.177.131.64) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Mon, 20 Jan 2020
 10:37:02 +0800
Subject: Re: [PATCH -next] net: hns3: replace snprintf with scnprintf in
 hns3_dbg_cmd_read
To:     tanhuazhong <tanhuazhong@huawei.com>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <davem@davemloft.net>
References: <20200119124147.30394-1-chenzhou10@huawei.com>
 <2e1ab30a-af35-6bc6-f880-a3051375a6a8@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   Chen Zhou <chenzhou10@huawei.com>
Message-ID: <dbd54fd8-b356-18a2-cb16-ad3aaaa933ca@huawei.com>
Date:   Mon, 20 Jan 2020 10:37:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <2e1ab30a-af35-6bc6-f880-a3051375a6a8@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.131.64]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/1/20 9:28, tanhuazhong wrote:
> 
> 
> On 2020/1/19 20:41, Chen Zhou wrote:
>> The return value of snprintf may be greater than the size of
>> HNS3_DBG_READ_LEN, use scnprintf instead in hns3_dbg_cmd_read.
>>
>> Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
>> ---
>>   drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
>> index 6b328a2..8fad699 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
>> @@ -297,7 +297,7 @@ static ssize_t hns3_dbg_cmd_read(struct file *filp, char __user *buffer,
>>       if (!buf)
>>           return -ENOMEM;
>>   -    len = snprintf(buf, HNS3_DBG_READ_LEN, "%s\n",
>> +    len = scnprintf(buf, HNS3_DBG_READ_LEN, "%s\n",
>>                  "Please echo help to cmd to get help information");
> 
> not align?

Ok, i will fix in next version.

Thanks,
Chen Zhou

> 
>>       uncopy_bytes = copy_to_user(buffer, buf, len);
>>  
> 
> 
> .
> 

