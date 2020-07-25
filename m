Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 028F622D384
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 03:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbgGYBTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 21:19:13 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2662 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726884AbgGYBTM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 21:19:12 -0400
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id B65F9D5E8D476D63CD58;
        Sat, 25 Jul 2020 09:19:10 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Sat, 25 Jul 2020 09:19:10 +0800
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Sat, 25 Jul 2020 09:19:08 +0800
Subject: Re: [PATCH net-next v3 1/2] hinic: add support to handle hw abnormal
 event
To:     Edward Cree <ecree@solarflare.com>,
        David Miller <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
References: <20200723144038.10430-1-luobin9@huawei.com>
 <20200723144038.10430-2-luobin9@huawei.com>
 <20200723.120852.1882569285026023193.davem@davemloft.net>
 <92dac9af-8623-bd1e-7a4d-9d12671699ad@solarflare.com>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <22a8ad8f-93c2-b5fb-b2d7-cc99e65d32ec@huawei.com>
Date:   Sat, 25 Jul 2020 09:19:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <92dac9af-8623-bd1e-7a4d-9d12671699ad@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme719-chm.china.huawei.com (10.1.199.115) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/7/24 17:57, Edward Cree wrote:
> On 23/07/2020 20:08, David Miller wrote:
>> From: Luo bin <luobin9@huawei.com>
>> Date: Thu, 23 Jul 2020 22:40:37 +0800
>>
>>> +static int hinic_fw_reporter_dump(struct devlink_health_reporter *reporter,
>>> +				  struct devlink_fmsg *fmsg, void *priv_ctx,
>>> +				  struct netlink_ext_ack *extack)
>>> +{
>>> +	struct hinic_mgmt_watchdog_info *watchdog_info;
>>> +	int err;
>>> +
>>> +	if (priv_ctx) {
>>> +		watchdog_info = priv_ctx;
>>> +		err = mgmt_watchdog_report_show(fmsg, watchdog_info);
>>> +		if (err)
>>> +			return err;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>> This 'watchdog_info' variable is completely unnecessary, just pass
>> 'priv_ctx' as-is into mgmt_watchdog_report_show().
> Looks like the 'err' variable is unnecessary too...
> 
> -ed
> .
> 
Will fix. Thanks for your review.
