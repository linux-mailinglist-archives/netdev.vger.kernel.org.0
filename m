Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF73B46AFA4
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 02:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354231AbhLGBXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 20:23:15 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:29092 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351747AbhLGBXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 20:23:11 -0500
Received: from kwepemi100005.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4J7MpC2fVcz1DK0Z;
        Tue,  7 Dec 2021 09:16:51 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100005.china.huawei.com (7.221.188.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 7 Dec 2021 09:19:39 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Tue, 7 Dec
 2021 09:19:39 +0800
Subject: Re: [PATCH net-next] Revert "net: hns3: add void before function
 which don't receive ret"
To:     Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Salil Mehta <salil.mehta@huawei.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
References: <ec8b4004475049060d03fd71b916cbf32858559d.1638705082.git.leonro@nvidia.com>
 <YayuDSbYTEdLdeMG@unreal>
 <20211206163422.0055f67b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <0d76e87f-9480-f700-18ea-e28dbefc6175@huawei.com>
Date:   Tue, 7 Dec 2021 09:19:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20211206163422.0055f67b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/12/7 8:34, Jakub Kicinski wrote:
> On Sun, 5 Dec 2021 14:18:21 +0200 Leon Romanovsky wrote:
>> On Sun, Dec 05, 2021 at 01:51:37PM +0200, Leon Romanovsky wrote:
>>> From: Leon Romanovsky <leonro@nvidia.com>
>>>
>>> There are two issues with this patch:
>>> 1. devlink_register() doesn't return any value. It is already void.
>>> 2. It is not kernel coding at all to cast return type to void.
>>>
>>> This reverts commit 5ac4f180bd07116c1e57858bc3f6741adbca3eb6.
>>>
>>> Link: https://lore.kernel.org/all/Yan8VDXC0BtBRVGz@unreal
>>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>>> ---
>>>   drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c   | 2 +-
>>>   drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c | 2 +-
>>>   2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> It was already sent, but not merged yet.
>> https://lore.kernel.org/all/20211204012448.51360-1-huangguangbin2@huawei.com
> 
> Indeed, Guangbin in the future please make sure to CC the person whose
> feedback the patches are based on.
> .
> 
Ok.
