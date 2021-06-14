Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB743A6762
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 15:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233589AbhFNNGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 09:06:02 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6468 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233421AbhFNNGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 09:06:01 -0400
Received: from dggeme755-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G3Wly5SD2zZfDR;
        Mon, 14 Jun 2021 21:01:02 +0800 (CST)
Received: from [10.67.100.138] (10.67.100.138) by
 dggeme755-chm.china.huawei.com (10.3.19.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 14 Jun 2021 21:03:56 +0800
Subject: Re: [PATCH net-next 04/11] net: z85230: remove redundant
 initialization for statics
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Guangbin Huang <huangguangbin2@huawei.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <xie.he.0141@gmail.com>, <ms@dev.tdt.de>,
        <willemb@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1623569903-47930-1-git-send-email-huangguangbin2@huawei.com>
 <1623569903-47930-5-git-send-email-huangguangbin2@huawei.com>
 <YMYw4kJ/Erq6fbVh@lunn.ch> <3b15d3bd-4116-ebed-ba86-13efbe7958f4@huawei.com>
 <YMdLYzr4QjrQIe0o@lunn.ch>
From:   "lipeng (Y)" <lipeng321@huawei.com>
Message-ID: <bf51962d-b567-5d87-188a-6a0e4d79c670@huawei.com>
Date:   Mon, 14 Jun 2021 21:03:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <YMdLYzr4QjrQIe0o@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.100.138]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme755-chm.china.huawei.com (10.3.19.101)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/14 20:28, Andrew Lunn 写道:
> On Mon, Jun 14, 2021 at 06:16:12PM +0800, lipeng (Y) wrote:
>> 在 2021/6/14 0:22, Andrew Lunn 写道:
>>
>>      On Sun, Jun 13, 2021 at 03:38:16PM +0800, Guangbin Huang wrote:
>>
>>          From: Peng Li <lipeng321@huawei.com>
>>
>>          Should not initialise statics to 0.
>>
>>          Signed-off-by: Peng Li <lipeng321@huawei.com>
>>          Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
>>          ---
>>           drivers/net/wan/z85230.c | 2 +-
>>           1 file changed, 1 insertion(+), 1 deletion(-)
>>
>>          diff --git a/drivers/net/wan/z85230.c b/drivers/net/wan/z85230.c
>>          index 94ed9a2..f815bb5 100644
>>          --- a/drivers/net/wan/z85230.c
>>          +++ b/drivers/net/wan/z85230.c
>>          @@ -685,7 +685,7 @@ irqreturn_t z8530_interrupt(int irq, void *dev_id)
>>           {
>>                  struct z8530_dev *dev=dev_id;
>>                  u8 intr;
>>          -       static volatile int locker=0;
>>          +       static int locker;
>>
>>      Is the volatile unneeded? Please document that in the commit message.
>>
>>         Andrew
>>      .
>>
>> Hi,  Andrew:
>>
>> When i create this patch, it will WARNING: Use of volatile is usually wrong:
>> see Documentation/process/volatile-considered-harmful.rst
>>
>> According to the file in kernel:    Documentation/process/volatile-considered-​
>> harmful.rst
>>
>> the "volatile" type class should not be used.
>>
>> So i remove  "volatile" in this patch.
> Please be very careful to explain exactly why it is wrong, in this
> specific case.  You could also consider adding another patch which
> replaces the volatile with what is recommended.
>
>         Andrew
> .
Hi,  Andrew:

I will remove patch  04/11 from this clean-up patchset.
Will send another patch with detail reason for this line if needed.
Thanks for your comments.

         Peng Li


