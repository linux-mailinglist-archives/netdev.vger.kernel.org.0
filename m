Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81FE62C6E56
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 03:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbgK1CBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 21:01:39 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8605 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730916AbgK1CAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 21:00:16 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CjZS420TpzLtWF;
        Sat, 28 Nov 2020 09:59:32 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Sat, 28 Nov 2020
 09:59:56 +0800
Subject: Re: [PATCH net-next 5/7] net: hns3: add more info to
 hns3_dbg_bd_info()
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
References: <1606466842-57749-1-git-send-email-tanhuazhong@huawei.com>
 <1606466842-57749-6-git-send-email-tanhuazhong@huawei.com>
 <20201127125342.05daa45a@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <3c35a579-bede-0c15-18f6-2c3d9c981f25@huawei.com>
Date:   Sat, 28 Nov 2020 09:59:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20201127125342.05daa45a@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/11/28 4:53, Jakub Kicinski wrote:
> On Fri, 27 Nov 2020 16:47:20 +0800 Huazhong Tan wrote:
>> Since TX hardware checksum and RX completion checksum have been
>> supported now, so add related information in hns3_dbg_bd_info().
>>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> 
> drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c:266:22: warning: incorrect type in assignment (different base types)
> drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c:266:22:    expected restricted __sum16 [usertype] csum
> drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c:266:22:    got unsigned int
> drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c:268:22: warning: invalid assignment: |=
> drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c:268:22:    left side has type restricted __sum16
> drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c:268:22:    right side has type unsigned int
> 

Will fix it, thanks.

> .
> 

