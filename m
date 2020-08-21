Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550E224CB1B
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 05:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgHUDCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 23:02:25 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:47752 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725852AbgHUDCY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 23:02:24 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 564FE26ECB8ED6D33E92;
        Fri, 21 Aug 2020 11:02:17 +0800 (CST)
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 21 Aug 2020 11:02:16 +0800
Subject: Re: [PATCH net-next] hinic: add debugfs support
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>
References: <20200820121432.23597-1-luobin9@huawei.com>
 <20200820090203.3f56024b@kicinski-fedora-PC1C0HJN>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <b4ad6d8e-0760-bcea-56a3-dd8d3ffc8237@huawei.com>
Date:   Fri, 21 Aug 2020 11:01:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200820090203.3f56024b@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme714-chm.china.huawei.com (10.1.199.110) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/8/21 0:02, Jakub Kicinski wrote:
> On Thu, 20 Aug 2020 20:14:32 +0800 Luo bin wrote:
>> +static int hinic_dbg_help(struct hinic_dev *nic_dev, const char *cmd_buf)
>> +{
>> +	netif_info(nic_dev, drv, nic_dev->netdev, "Available commands:\n");
>> +	netif_info(nic_dev, drv, nic_dev->netdev, "sq info <queue id>\n");
>> +	netif_info(nic_dev, drv, nic_dev->netdev, "sq wqe info <queue id> <wqe id>\n");
>> +	netif_info(nic_dev, drv, nic_dev->netdev, "rq info <queue id>\n");
>> +	netif_info(nic_dev, drv, nic_dev->netdev, "rq wqe info <queue id> <wqe id>\n");
>> +	netif_info(nic_dev, drv, nic_dev->netdev, "sq ci table <queue id>\n");
>> +	netif_info(nic_dev, drv, nic_dev->netdev, "rq cqe info <queue id> <cqe id>\n");
>> +	netif_info(nic_dev, drv, nic_dev->netdev, "mac table\n");
>> +	netif_info(nic_dev, drv, nic_dev->netdev, "global table\n");
>> +	netif_info(nic_dev, drv, nic_dev->netdev, "func table\n");
>> +	netif_info(nic_dev, drv, nic_dev->netdev, "port table\n");
>> +	return 0;
>> +}
>> +
>> +static const struct hinic_dbg_cmd_info g_hinic_dbg_cmd[] = {
>> +	{"help", hinic_dbg_help},
>> +	{"sq info", hinic_dbg_get_sq_info},
>> +	{"sq wqe info", hinic_dbg_get_sq_wqe_info},
>> +	{"rq info", hinic_dbg_get_rq_info},
>> +	{"rq wqe info", hinic_dbg_get_rq_wqe_info},
>> +	{"sq ci table", hinic_dbg_get_ci_table},
>> +	{"rq cqe info", hinic_dbg_get_rq_cqe_info},
>> +	{"mac table", hinic_dbg_get_mac_table},
>> +	{"global table", hinic_dbg_get_global_table},
>> +	{"func table", hinic_dbg_get_function_table},
>> +	{"port table", hinic_dbg_get_port_table},
>> +};
> 
> Please don't create command interfaces like this.
> 
> Instead create a read only file for objects you want to expose.
> 
> Split addition of each object into a separate patch and provide example
> output in the commit message.
> .
> 
Will fix. Thanks for your review.
