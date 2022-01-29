Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76AB4A2AE9
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 02:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351999AbiA2BOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 20:14:19 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:32130 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiA2BOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 20:14:18 -0500
Received: from kwepemi100001.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Jlx9J2Y0Rz8wWp;
        Sat, 29 Jan 2022 09:11:16 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100001.china.huawei.com (7.221.188.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 29 Jan 2022 09:14:16 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Sat, 29 Jan
 2022 09:14:15 +0800
Subject: Re: [RESEND PATCH net-next 2/2] net: hns3: add ethtool priv-flag for
 TX push
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <wangjie125@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>
References: <20220125072149.56604-1-huangguangbin2@huawei.com>
 <20220125072149.56604-3-huangguangbin2@huawei.com>
 <20220125195508.585b0c40@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <2b7029d4-c1a7-93af-1846-7b91703f9edf@huawei.com>
Date:   Sat, 29 Jan 2022 09:14:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20220125195508.585b0c40@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/1/26 11:55, Jakub Kicinski wrote:
> On Tue, 25 Jan 2022 15:21:49 +0800 Guangbin Huang wrote:
>> From: Yufeng Mo <moyufeng@huawei.com>
>>
>> Add a control private flag in ethtool for enable/disable
>> TX push feature.
> 
> I think it's a pretty standard feature for NICs which also support RDMA.
> Mellanox/nVidia has it (or at least it the previous gen HW did),
> Broadcom's bnxt driver does it as well.
> 
> Can we make this a standard knob via ethtool? Not entirely sure under
> which switch, maybe it's okay to add it under -g? Perhaps we need a new
> command similar to -k but for features contained entirely to the driver?
> .
> 
Hi Jakub,
We consider adding a new command for this feature. We will send RFC after we finish it.
