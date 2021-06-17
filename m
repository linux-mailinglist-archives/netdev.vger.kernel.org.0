Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36123AA867
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 03:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235049AbhFQBHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 21:07:21 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:11042 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbhFQBHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 21:07:20 -0400
Received: from dggeme755-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G53gD41KNzZfj7;
        Thu, 17 Jun 2021 09:02:16 +0800 (CST)
Received: from [10.67.100.138] (10.67.100.138) by
 dggeme755-chm.china.huawei.com (10.3.19.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 17 Jun 2021 09:05:12 +0800
Subject: Re: [PATCH net-next 7/8] net: hdlc_ppp: remove redundant spaces
To:     Andrew Lunn <andrew@lunn.ch>,
        Guangbin Huang <huangguangbin2@huawei.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1623836037-26812-1-git-send-email-huangguangbin2@huawei.com>
 <1623836037-26812-8-git-send-email-huangguangbin2@huawei.com>
 <YMolcod68MZqfNFL@lunn.ch>
From:   "lipeng (Y)" <lipeng321@huawei.com>
Message-ID: <fa50e103-563f-80ea-916d-908b7aed7fcd@huawei.com>
Date:   Thu, 17 Jun 2021 09:05:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <YMolcod68MZqfNFL@lunn.ch>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.100.138]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme755-chm.china.huawei.com (10.3.19.101)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/6/17 0:23, Andrew Lunn Ð´µÀ:
> On Wed, Jun 16, 2021 at 05:33:56PM +0800, Guangbin Huang wrote:
>> From: Peng Li <lipeng321@huawei.com>
>>
>> According to the chackpatch.pl,
>> no spaces is necessary at the start of a line.
>>
>> Signed-off-by: Peng Li <lipeng321@huawei.com>
>> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
>> ---
>>   drivers/net/wan/hdlc_ppp.c | 10 +++++-----
>>   1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/wan/hdlc_ppp.c b/drivers/net/wan/hdlc_ppp.c
>> index 7b7c02d..53c668e 100644
>> --- a/drivers/net/wan/hdlc_ppp.c
>> +++ b/drivers/net/wan/hdlc_ppp.c
>> @@ -34,8 +34,8 @@
>>   
>>   enum {IDX_LCP = 0, IDX_IPCP, IDX_IPV6CP, IDX_COUNT};
>>   enum {CP_CONF_REQ = 1, CP_CONF_ACK, CP_CONF_NAK, CP_CONF_REJ, CP_TERM_REQ,
>> -      CP_TERM_ACK, CP_CODE_REJ, LCP_PROTO_REJ, LCP_ECHO_REQ, LCP_ECHO_REPLY,
>> -      LCP_DISC_REQ, CP_CODES};
>> +	CP_TERM_ACK, CP_CODE_REJ, LCP_PROTO_REJ, LCP_ECHO_REQ, LCP_ECHO_REPLY,
>> +	LCP_DISC_REQ, CP_CODES};
> Do you think this looks better or worse after the change?
>
>     Andrew
> .

It is better after the change as the code style follow the same rule.

What's your suggestion?


