Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A5F21023D
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 04:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgGACyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 22:54:53 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2621 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725862AbgGACyx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 22:54:53 -0400
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 3938AD9B095F7E5FE054;
        Wed,  1 Jul 2020 10:54:51 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Wed, 1 Jul 2020 10:54:51 +0800
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Wed, 1 Jul 2020 10:54:50 +0800
Subject: Re: [PATCH net] hinic: fix passing non negative value to ERR_PTR
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>
References: <20200630063554.14639-1-luobin9@huawei.com>
 <20200630092041.55d8a245@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <17c8110c-5cf8-1140-a877-faf74489542b@huawei.com>
Date:   Wed, 1 Jul 2020 10:54:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200630092041.55d8a245@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme716-chm.china.huawei.com (10.1.199.112) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/7/1 0:20, Jakub Kicinski wrote:
> On Tue, 30 Jun 2020 14:35:54 +0800 Luo bin wrote:
>> get_dev_cap and set_resources_state functions may return a positive
>> value because of hardware failure, and the positive return value
>> can not be passed to ERR_PTR directly.
>>
>> Fixes: 7dd29ee12865 ("net-next/hinic: add sriov feature support")
>> Signed-off-by: Luo bin <luobin9@huawei.com>
> 
> Fixes tag: Fixes: 7dd29ee12865 ("net-next/hinic: add sriov feature support")
> Has these problem(s):
> 	- Subject does not match target commit subject
> 	  Just use
> 		git log -1 --format='Fixes: %h ("%s")'
> .
> 
Will fix. Thanks.
