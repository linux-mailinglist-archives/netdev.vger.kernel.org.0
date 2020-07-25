Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E09422D386
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 03:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgGYBTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 21:19:51 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2588 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726777AbgGYBTu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 21:19:50 -0400
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id 0FCCDB8834938B0A3D5F;
        Sat, 25 Jul 2020 09:19:49 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Sat, 25 Jul 2020 09:19:48 +0800
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Sat, 25 Jul 2020 09:19:33 +0800
Subject: Re: [PATCH net-next v4 1/2] hinic: add support to handle hw abnormal
 event
To:     David Miller <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
References: <20200724091732.19819-1-luobin9@huawei.com>
 <20200724091732.19819-2-luobin9@huawei.com>
 <20200724.170415.1190789583922952011.davem@davemloft.net>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <aa6e490a-2c02-5deb-0df5-ed6dab0f7c8b@huawei.com>
Date:   Sat, 25 Jul 2020 09:19:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200724.170415.1190789583922952011.davem@davemloft.net>
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

On 2020/7/25 8:04, David Miller wrote:
> From: Luo bin <luobin9@huawei.com>
> Date: Fri, 24 Jul 2020 17:17:31 +0800
> 
>> +static int hinic_fw_reporter_dump(struct devlink_health_reporter *reporter,
>> +				  struct devlink_fmsg *fmsg, void *priv_ctx,
>> +				  struct netlink_ext_ack *extack)
>> +{
>> +	int err;
>> +
>> +	if (priv_ctx) {
>> +		err = mgmt_watchdog_report_show(fmsg, priv_ctx);
>> +		if (err)
>> +			return err;
>> +	}
>> +
>> +	return 0;
>> +}
> 
> As Edward Cree pointed out for v3 of this patch series, this 'err' is not
> necessary at all.
> .
> 
Will fix. Thanks.
