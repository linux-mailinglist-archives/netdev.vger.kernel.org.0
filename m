Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8531EB2B8
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 02:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgFBAbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 20:31:31 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2094 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725446AbgFBAbb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 20:31:31 -0400
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 7E800B4F617355E8C91B;
        Tue,  2 Jun 2020 08:31:29 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Tue, 2 Jun 2020 08:31:28 +0800
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Tue, 2 Jun 2020 08:31:28 +0800
Subject: Re: [PATCH net-next v5] hinic: add set_channels ethtool_ops support
To:     David Miller <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>
References: <20200601105748.27511-1-luobin9@huawei.com>
 <20200601.105339.1821963108388271707.davem@davemloft.net>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <acb398e4-ffde-2753-03ca-cbed8933daff@huawei.com>
Date:   Tue, 2 Jun 2020 08:31:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200601.105339.1821963108388271707.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme711-chm.china.huawei.com (10.1.199.107) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/6/2 1:53, David Miller wrote:
> From: Luo bin <luobin9@huawei.com>
> Date: Mon, 1 Jun 2020 18:57:48 +0800
>
>> @@ -470,6 +470,11 @@ netdev_tx_t hinic_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
>>   	struct hinic_txq *txq;
>>   	struct hinic_qp *qp;
>>   
>> +	if (unlikely(!netif_carrier_ok(netdev))) {
>> +		dev_kfree_skb_any(skb);
>> +		return NETDEV_TX_OK;
>> +	}
> As stated by another reviewer, this change is unrelated to adding
> set_channels support.  Please remove it from this patch.
Will fix. Thanks.
> .
