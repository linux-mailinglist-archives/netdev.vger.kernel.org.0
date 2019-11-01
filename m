Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17058EBBC6
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 02:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbfKABmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 21:42:43 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5241 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728655AbfKABmn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 21:42:43 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1CDD27EBC0844FDF46F5;
        Fri,  1 Nov 2019 09:42:41 +0800 (CST)
Received: from [127.0.0.1] (10.133.219.218) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Fri, 1 Nov 2019
 09:42:35 +0800
Message-ID: <5DBB8D8A.5030607@huawei.com>
Date:   Fri, 1 Nov 2019 09:42:34 +0800
From:   zhong jiang <zhongjiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To:     Simon Horman <simon.horman@netronome.com>
CC:     <kvalo@codeaurora.org>, <stas.yakovlev@gmail.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/3] ipw2x00: Remove redundant variable "rc"
References: <1572529580-26594-1-git-send-email-zhongjiang@huawei.com> <1572529580-26594-2-git-send-email-zhongjiang@huawei.com> <20191031204449.GC30739@netronome.com>
In-Reply-To: <20191031204449.GC30739@netronome.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.219.218]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/11/1 4:44, Simon Horman wrote:
> On Thu, Oct 31, 2019 at 09:46:18PM +0800, zhong jiang wrote:
>> local variable "rc" is not used. hence it is safe to remove and
>> just return 0.
>>
>> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> It appears that there is only one caller of
> libipw_qos_convert_ac_to_parameters() and that it ignores the return value
> (which, as you point out is always 0). 
>
> Perhaps it would be cleaner if the return type of
> libipw_qos_convert_ac_to_parameters() was void.
will do in V2,  Thanks
>> ---
>>  drivers/net/wireless/intel/ipw2x00/libipw_rx.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
>> index 34cfd81..df0f37e4 100644
>> --- a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
>> +++ b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
>> @@ -1005,7 +1005,6 @@ static int libipw_qos_convert_ac_to_parameters(struct
>>  						  libipw_qos_parameters
>>  						  *qos_param)
>>  {
>> -	int rc = 0;
>>  	int i;
>>  	struct libipw_qos_ac_parameter *ac_params;
>>  	u32 txop;
>> @@ -1030,7 +1029,8 @@ static int libipw_qos_convert_ac_to_parameters(struct
>>  		txop = le16_to_cpu(ac_params->tx_op_limit) * 32;
>>  		qos_param->tx_op_limit[i] = cpu_to_le16(txop);
>>  	}
>> -	return rc;
>> +
>> +	return 0;
>>  }
>>  
>>  /*
>> -- 
>> 1.7.12.4
>>
> .
>


