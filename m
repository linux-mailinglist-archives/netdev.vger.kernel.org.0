Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA6C31459A
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 02:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbhBIB06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 20:26:58 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:3012 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbhBIB0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 20:26:54 -0500
Received: from dggeme705-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4DZQDR1mMWzR9LY;
        Tue,  9 Feb 2021 09:24:55 +0800 (CST)
Received: from [127.0.0.1] (10.69.26.252) by dggeme705-chm.china.huawei.com
 (10.1.199.101) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2106.2; Tue, 9 Feb
 2021 09:26:10 +0800
Subject: Re: [PATCH net-next 03/12] net: hns3: check cmdq message parameters
 sent from VF
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        Yufeng Mo <moyufeng@huawei.com>
References: <1612784382-27262-1-git-send-email-tanhuazhong@huawei.com>
 <1612784382-27262-4-git-send-email-tanhuazhong@huawei.com>
 <20210208133447.14e1118a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Huazhong Tan <tanhuazhong@huawei.com>
Message-ID: <ac2f3605-a724-3196-6709-d24491a06f10@huawei.com>
Date:   Tue, 9 Feb 2021 09:26:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20210208133447.14e1118a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.69.26.252]
X-ClientProxiedBy: dggeme713-chm.china.huawei.com (10.1.199.109) To
 dggeme705-chm.china.huawei.com (10.1.199.101)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/9 5:34, Jakub Kicinski wrote:
> On Mon, 8 Feb 2021 19:39:33 +0800 Huazhong Tan wrote:
>> From: Yufeng Mo <moyufeng@huawei.com>
>>
>> The parameters sent from VF may be unreliable. If these
>> parameters are used directly, memory overwriting may occur.
>> Therefore, we need to check parameters before using.
>>
>> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> Are you sure this is not a fix which should target net and stable?


Yes, this patch should be a fix for below:

Fixes: 1a426f8b40fc ("net: hns3: fix the VF queue reset flow error")
Fixes: 84e095d64ed9 ("net: hns3: Change PF to add ring-vect binding & 
resetQ to mailbox")
Fixes: a638b1d8cc87 ("net: hns3: fix get VF RSS issue")


>
> Other than that the patches look good to me.


Could you apply other patches into -next? and i resend this one for the net.

Or I send a V2 without this patch?


>
> .

