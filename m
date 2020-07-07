Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0269216E6E
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 16:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbgGGOMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 10:12:03 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2561 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725944AbgGGOMD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 10:12:03 -0400
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 77806EFD1C50DBE9BFBC;
        Tue,  7 Jul 2020 22:11:59 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Tue, 7 Jul 2020 22:11:59 +0800
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Tue, 7 Jul 2020 22:11:58 +0800
Subject: Re: [PATCH net-next] hinic: add firmware update support
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>
References: <20200706145406.7742-1-luobin9@huawei.com>
 <20200706095758.713a069a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <cdd42929-99ae-7865-6812-9bb392b7b182@huawei.com>
Date:   Tue, 7 Jul 2020 22:11:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200706095758.713a069a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme713-chm.china.huawei.com (10.1.199.109) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/7/7 0:57, Jakub Kicinski wrote:
> On Mon, 6 Jul 2020 22:54:06 +0800 Luo bin wrote:
>> add support to update firmware with with "ethtool -f" cmd
>>
>> Signed-off-by: Luo bin <luobin9@huawei.com>
> 
> drivers/net/ethernet/huawei/hinic/hinic_ethtool.c:1996:44: warning: missing braces around initializer
> drivers/net/ethernet/huawei/hinic/hinic_ethtool.c:1996:44: warning: missing braces around initializer
> 
> But really - please try to implement the devlink flashing API, using
> ethtool for this is deprecated.
> .
> 
Okay. Will fix. Thanks for your review.
