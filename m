Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45B922AAEA0
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 01:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbgKIA6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 19:58:00 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7063 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728068AbgKIA57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 19:57:59 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CTszf73VzzhfnT;
        Mon,  9 Nov 2020 08:57:50 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Mon, 9 Nov 2020
 08:57:50 +0800
Subject: Re: [PATCH net-next 02/11] net: hns3: add support for 1us unit GL
 configuration
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
References: <1604730681-32559-1-git-send-email-tanhuazhong@huawei.com>
 <1604730681-32559-3-git-send-email-tanhuazhong@huawei.com>
 <20201107094613.261fe05b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <c9249ca4-db17-bd86-66ce-e860fd445a0b@huawei.com>
Date:   Mon, 9 Nov 2020 08:57:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20201107094613.261fe05b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/11/8 1:46, Jakub Kicinski wrote:
> On Sat, 7 Nov 2020 14:31:12 +0800 Huazhong Tan wrote:
>> For device whose version is above V3(include V3), the GL
>> configuration can set as 1us unit, so adds support for
>> configuring this field.
>>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> 
> Doesn't build.
> 
> drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c: In function ‘hns3_check_gl_coalesce_para’:
> drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c:1152:6: error: ‘ae_dev’ undeclared (first use in this function); did you mean ‘netdev’?
>   1152 |  if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3)
>        |      ^~~~~~
>        |      netdev
> drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c:1152:6: note: each undeclared identifier is reported only once for each function it appears in
> make[6]: *** [drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.o] Error 1
> make[5]: *** [drivers/net/ethernet/hisilicon/hns3] Error 2
> make[4]: *** [drivers/net/ethernet/hisilicon] Error 2
> make[4]: *** Waiting for unfinished jobs....
> make[3]: *** [drivers/net/ethernet] Error 2
> make[2]: *** [drivers/net] Error 2
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [drivers] Error 2
> make: *** [__sub-make] Error 2
> 

Will fix it.
Thanks.

> .
> 

