Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67113AA85A
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 03:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbhFQBDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 21:03:05 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:11041 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbhFQBDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 21:03:05 -0400
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G53ZJ6ZvNzZdgG;
        Thu, 17 Jun 2021 08:58:00 +0800 (CST)
Received: from [10.67.100.138] (10.67.100.138) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 17 Jun 2021 09:00:56 +0800
Subject: Re: [PATCH net-next 5/8] net: hdlc_ppp: fix the comments style issue
To:     Andrew Lunn <andrew@lunn.ch>,
        Guangbin Huang <huangguangbin2@huawei.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1623836037-26812-1-git-send-email-huangguangbin2@huawei.com>
 <1623836037-26812-6-git-send-email-huangguangbin2@huawei.com>
 <YMoktwkvCP8yGyhk@lunn.ch>
From:   "lipeng (Y)" <lipeng321@huawei.com>
Message-ID: <fed0521c-8ae0-7e71-fb87-94c4fd08e21d@huawei.com>
Date:   Thu, 17 Jun 2021 09:00:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <YMoktwkvCP8yGyhk@lunn.ch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.100.138]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/17 0:20, Andrew Lunn 写道:
>>   static int cp_table[EVENTS][STATES] = {
>>   	/* CLOSED     STOPPED STOPPING REQ_SENT ACK_RECV ACK_SENT OPENED
>> -	     0           1         2       3       4      5          6    */
>> +	 *   0           1         2       3       4      5          6
>> +	 */
>>   	{IRC|SCR|3,     INV     , INV ,   INV   , INV ,  INV    ,   INV   }, /* START */
>>   	{   INV   ,      0      ,  0  ,    0    ,  0  ,   0     ,    0    }, /* STOP */
>>   	{   INV   ,     INV     ,STR|2,  SCR|3  ,SCR|3,  SCR|5  ,   INV   }, /* TO+ */
> This probably reduces the readability of the code. So i would not make
> this change.
>
> Please remember these are only guidelines. Please don't blindly make
> changes, or change it because some bot says so. Check that it actually
> makes sense and the code is better afterwards.
>
>        Andrew
> .

Agree with you they are only guidelines.

The code should  follow the rules mostly, or  it will be diferent style 
from different developer.

If that's the exception, i will drop this patch.


Thanks

             Peng Li

