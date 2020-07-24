Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38EB322BB31
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 02:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbgGXA6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 20:58:46 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:52358 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728394AbgGXA6q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 20:58:46 -0400
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 027A69CF4C2AC7613C9E;
        Fri, 24 Jul 2020 08:58:44 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 24 Jul 2020 08:58:43 +0800
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 24 Jul 2020 08:58:43 +0800
Subject: Re: [PATCH net-next v3 1/2] hinic: add support to handle hw abnormal
 event
To:     David Miller <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
References: <20200723144038.10430-1-luobin9@huawei.com>
 <20200723144038.10430-2-luobin9@huawei.com>
 <20200723.120852.1882569285026023193.davem@davemloft.net>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <7c97e18d-fd4a-280c-343f-6338d069d40b@huawei.com>
Date:   Fri, 24 Jul 2020 08:58:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200723.120852.1882569285026023193.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme708-chm.china.huawei.com (10.1.199.104) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/7/24 3:08, David Miller wrote:
> From: Luo bin <luobin9@huawei.com>
> Date: Thu, 23 Jul 2020 22:40:37 +0800
> 
>> +static int hinic_fw_reporter_dump(struct devlink_health_reporter *reporter,
>> +				  struct devlink_fmsg *fmsg, void *priv_ctx,
>> +				  struct netlink_ext_ack *extack)
>> +{
>> +	struct hinic_mgmt_watchdog_info *watchdog_info;
>> +	int err;
>> +
>> +	if (priv_ctx) {
>> +		watchdog_info = priv_ctx;
>> +		err = mgmt_watchdog_report_show(fmsg, watchdog_info);
>> +		if (err)
>> +			return err;
>> +	}
>> +
>> +	return 0;
>> +}
> 
> This 'watchdog_info' variable is completely unnecessary, just pass
> 'priv_ctx' as-is into mgmt_watchdog_report_show().
> .
> 
Will fix. Thanks for your review.
