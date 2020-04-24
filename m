Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A541B74BC
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 14:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbgDXM20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 08:28:26 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2895 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728295AbgDXMYP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 08:24:15 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id EED1252A3DBC5F0F9B9A;
        Fri, 24 Apr 2020 20:24:07 +0800 (CST)
Received: from [127.0.0.1] (10.166.215.99) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Fri, 24 Apr 2020
 20:24:05 +0800
Subject: Re: [PATCH net-next] ptp: clockmatrix: remove unnecessary comparison
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        <richardcochran@gmail.com>, <vincent.cheng.xh@renesas.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1587716058-1840-1-git-send-email-yangyingliang@huawei.com>
 <2c85e220-3765-4424-ee22-c9acf27f9d22@cogentembedded.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <9f0ca7d9-06ff-a83e-03f0-6cfb5c2ecd47@huawei.com>
Date:   Fri, 24 Apr 2020 20:24:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <2c85e220-3765-4424-ee22-c9acf27f9d22@cogentembedded.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.166.215.99]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/24 18:12, Sergei Shtylyov wrote:
> Hello!
>
> On 24.04.2020 11:14, Yang Yingliang wrote:
>
>> The type of loaddr is u8 which is always '<=' 0xff, so the
>> loaddr <= 0xff is always true, we can remove this comparison.
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>>   drivers/ptp/ptp_clockmatrix.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/ptp/ptp_clockmatrix.c 
>> b/drivers/ptp/ptp_clockmatrix.c
>> index 032e112..56aee4f 100644
>> --- a/drivers/ptp/ptp_clockmatrix.c
>> +++ b/drivers/ptp/ptp_clockmatrix.c
>> @@ -780,7 +780,7 @@ static int idtcm_load_firmware(struct idtcm *idtcm,
>>                 /* Page size 128, last 4 bytes of page skipped */
>>               if (((loaddr > 0x7b) && (loaddr <= 0x7f))
>> -                 || ((loaddr > 0xfb) && (loaddr <= 0xff)))
>> +                 || loaddr <= 0xff)
>
>    Haven't you just said that this is always true? :-)

My bad, I sent the patch.

>
> [...]
>
> MBR, Sergei

