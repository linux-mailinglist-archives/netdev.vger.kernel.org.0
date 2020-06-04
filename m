Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD5F1EDB8D
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 05:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgFDDIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 23:08:48 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2157 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726146AbgFDDIr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 23:08:47 -0400
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 1AA4597754FD4DB2E412;
        Thu,  4 Jun 2020 11:08:45 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Thu, 4 Jun 2020 11:08:44 +0800
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Thu, 4 Jun 2020 11:08:44 +0800
Subject: Re: [PATCH net-next 5/5] hinic: add support to get eeprom information
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <chiqijun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>
References: <20200603062015.12640-1-luobin9@huawei.com>
 <20200603062015.12640-6-luobin9@huawei.com>
 <20200603200145.41cf76fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <1a2dbd8d-9e93-4dcf-dfb0-5a7186fd8729@huawei.com>
Date:   Thu, 4 Jun 2020 11:08:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200603200145.41cf76fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme701-chm.china.huawei.com (10.1.199.97) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/6/4 11:01, Jakub Kicinski wrote:
> On Wed, 3 Jun 2020 14:20:15 +0800 Luo bin wrote:
>> add support to get eeprom information from the plug-in module
>> with ethtool -m cmd.
>>
>> Signed-off-by: Luo bin <luobin9@huawei.com>
> 
> drivers/net/ethernet/huawei/hinic/hinic_port.c:1386:5: warning: variable port_id set but not used [-Wunused-but-set-variable]
>  1386 |  u8 port_id;
>       |     ^~~~~~~
> .
> 
Will fix. Thanks.
