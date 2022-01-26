Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3494F49C3D4
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 07:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236866AbiAZGso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 01:48:44 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:35873 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbiAZGso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 01:48:44 -0500
Received: from kwepemi100026.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JkDn42KZCzccrX;
        Wed, 26 Jan 2022 14:47:52 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100026.china.huawei.com (7.221.188.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 26 Jan 2022 14:48:42 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Wed, 26 Jan
 2022 14:48:41 +0800
Subject: Re: [RESEND PATCH net-next 1/2] net: hns3: add support for TX push
 mode
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <wangjie125@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>
References: <20220125072149.56604-1-huangguangbin2@huawei.com>
 <20220125072149.56604-2-huangguangbin2@huawei.com>
 <20220125195038.6a07b3c4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <83c5ef91-59c0-aa54-b698-9f069a8d8280@huawei.com>
Date:   Wed, 26 Jan 2022 14:48:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20220125195038.6a07b3c4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/1/26 11:50, Jakub Kicinski wrote:
> On Tue, 25 Jan 2022 15:21:48 +0800 Guangbin Huang wrote:
>> +	__iowrite64_copy(ring->tqp->mem_base, desc,
>> +			 (sizeof(struct hns3_desc) * HNS3_MAX_PUSH_BD_NUM) /
>> +			 HNS3_BYTES_PER_64BIT);
> 
> Doesn't build, missing closing bracket?
> .
> 
Hi Jakub,
Sorry, I didn't notice that net-next has not been merged patch
"asm-generic: Add missing brackets for io_stop_wc macro" at
https://git.kernel.org/arm64/c/440323b6cf5b.

When that patch can be merged in net-next?
