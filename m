Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0AB73BE57A
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 11:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbhGGJYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 05:24:51 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:10426 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbhGGJYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 05:24:50 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GKYl50kQ0zZrcG;
        Wed,  7 Jul 2021 17:18:57 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 7 Jul 2021 17:22:02 +0800
Received: from [10.67.102.67] (10.67.102.67) by dggemi759-chm.china.huawei.com
 (10.1.198.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 7 Jul
 2021 17:22:02 +0800
Subject: Re: [RFC PATCH net-next 7/8] net: hns3: add support for PF setting
 rx/tx buffer size by devlink param
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <jiri@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>
References: <1625553692-2773-1-git-send-email-huangguangbin2@huawei.com>
 <1625553692-2773-8-git-send-email-huangguangbin2@huawei.com>
 <20210706161626.05548f65@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <0cc52414-58f6-177c-66cc-c1f2fa741f32@huawei.com>
Date:   Wed, 7 Jul 2021 17:22:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20210706161626.05548f65@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/7/7 7:16, Jakub Kicinski wrote:
> On Tue, 6 Jul 2021 14:41:31 +0800 Guangbin Huang wrote:
>> From: Hao Chen <chenhao288@hisilicon.com>
>>
>> Add support for PF setting rx/tx buffer size by devlink param
> 
> Please document what this parameter does under
> Documentation/networking/devlink/ - see the driver
> documentation already present there.
> .
> 
Ok, thanks.
