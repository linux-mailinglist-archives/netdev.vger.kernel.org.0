Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18FBF326BE9
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 07:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhB0GA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 01:00:27 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2911 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhB0GA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Feb 2021 01:00:26 -0500
Received: from dggeme701-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4DnbQq0dYbz5TCZ;
        Sat, 27 Feb 2021 13:57:39 +0800 (CST)
Received: from [127.0.0.1] (10.69.26.252) by dggeme701-chm.china.huawei.com
 (10.1.199.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2106.2; Sat, 27
 Feb 2021 13:59:42 +0800
Subject: Re: [PATCH net 0/3] net: hns3: fixes fot -net
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>
References: <1614396847-6001-1-git-send-email-tanhuazhong@huawei.com>
From:   Huazhong Tan <tanhuazhong@huawei.com>
Message-ID: <df387915-c22d-512e-f04b-22eee6c0a5c8@huawei.com>
Date:   Sat, 27 Feb 2021 13:59:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <1614396847-6001-1-git-send-email-tanhuazhong@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.69.26.252]
X-ClientProxiedBy: dggeme710-chm.china.huawei.com (10.1.199.106) To
 dggeme701-chm.china.huawei.com (10.1.199.97)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, please ignore this series, will resend it later.

On 2021/2/27 11:34, Huazhong Tan wrote:
> The patchset includes some fixes for the HNS3 ethernet driver.
>
> Jian Shen (3):
>    net: hns3: fix error mask definition of flow director
>    net: hns3: fix query vlan mask value error for flow director
>    net: hns3: fix bug when calculating the TCAM table info
>
>   drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h  | 6 +++---
>   drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 7 +++----
>   2 files changed, 6 insertions(+), 7 deletions(-)
>

