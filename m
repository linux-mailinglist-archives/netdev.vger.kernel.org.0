Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC0B233CCE
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 03:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731036AbgGaBLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 21:11:51 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3002 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730960AbgGaBLu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 21:11:50 -0400
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 0F5FA83248DB63CA2950;
        Fri, 31 Jul 2020 08:56:37 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 31 Jul 2020 08:56:36 +0800
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 31 Jul 2020 08:56:36 +0800
Subject: Re: [PATCH net-next v1 1/2] hinic: add generating mailbox random
 index support
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>
References: <20200730083716.4613-1-luobin9@huawei.com>
 <20200730083716.4613-2-luobin9@huawei.com>
 <20200730092502.4582ac4e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <0dfc0fd6-8ab2-5ba3-98e7-bbd875e03106@huawei.com>
Date:   Fri, 31 Jul 2020 08:56:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200730092502.4582ac4e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme701-chm.china.huawei.com (10.1.199.97) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/7/31 0:25, Jakub Kicinski wrote:
> On Thu, 30 Jul 2020 16:37:15 +0800 Luo bin wrote:
>> +bool check_vf_mbox_random_id(struct hinic_mbox_func_to_func *func_to_func,
>> +			     u8 *header)
> 
> This set seems to add new W=1 C=1 warnings:
> 
> drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c:572:6: warning: no previous prototype for ‘check_vf_mbox_random_id’ [-Wmissing-prototypes]
>   572 | bool check_vf_mbox_random_id(struct hinic_mbox_func_to_func *func_to_func,
>       |      ^~~~~~~~~~~~~~~~~~~~~~~
> 
> drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c:1352:28: warning: symbol 'hw_cmd_support_vf' was not declared. Should it be static?
> .
> 
Will fix. Thanks for your review.
