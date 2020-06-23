Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C248F204A2B
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 08:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730972AbgFWGsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 02:48:38 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:40906 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730583AbgFWGsi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 02:48:38 -0400
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id EE0C2D9D8CF7C3E7A478;
        Tue, 23 Jun 2020 14:48:36 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Tue, 23 Jun 2020 14:48:36 +0800
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Tue, 23 Jun 2020 14:48:36 +0800
Subject: Re: [PATCH net-next v1 5/5] hinic: add support to get eeprom
 information
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
References: <20200620094258.13181-1-luobin9@huawei.com>
 <20200620094258.13181-6-luobin9@huawei.com>
 <20200622151520.79ab2af9@kicinski-fedora-PC1C0HJN>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <c980638a-2229-7ea4-79fd-2f19d70d40cf@huawei.com>
Date:   Tue, 23 Jun 2020 14:48:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200622151520.79ab2af9@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme709-chm.china.huawei.com (10.1.199.105) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/6/23 6:15, Jakub Kicinski wrote:
> On Sat, 20 Jun 2020 17:42:58 +0800 Luo bin wrote:
>> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.h b/drivers/net/ethernet/huawei/hinic/hinic_port.h
>> index 5c916875f295..0d0354241345 100644
>> --- a/drivers/net/ethernet/huawei/hinic/hinic_port.h
>> +++ b/drivers/net/ethernet/huawei/hinic/hinic_port.h
>> @@ -677,6 +677,37 @@ struct hinic_led_info {
>>  	u8	reset;
>>  };
>>  
>> +#define MODULE_TYPE_SFP		0x3
>> +#define MODULE_TYPE_QSFP28	0x11
>> +#define MODULE_TYPE_QSFP	0x0C
>> +#define MODULE_TYPE_QSFP_PLUS	0x0D
>> +
>> +#define STD_SFP_INFO_MAX_SIZE	640
> 
> Please use the existing defines, e.g. from #include <linux/sfp.h>
> there is no need for every driver to redefine those constants.
> .
> 
Will fix. Thanks for your review.
