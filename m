Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E47C3EF7C7
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 03:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236284AbhHRB6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 21:58:20 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:17033 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236121AbhHRB6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 21:58:19 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Gq9tH5NHZzbfLX;
        Wed, 18 Aug 2021 09:53:59 +0800 (CST)
Received: from dggpeml500024.china.huawei.com (7.185.36.10) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 18 Aug 2021 09:57:43 +0800
Received: from [10.67.103.6] (10.67.103.6) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 18 Aug
 2021 09:57:43 +0800
Subject: Re: [PATCH net-next 2/4] ethtool: extend coalesce setting uAPI with
 CQE mode
To:     Jakub Kicinski <kuba@kernel.org>
References: <1629167767-7550-1-git-send-email-moyufeng@huawei.com>
 <1629167767-7550-3-git-send-email-moyufeng@huawei.com>
 <20210817063903.6b62801c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <shenjian15@huawei.com>, <lipeng321@huawei.com>,
        <yisen.zhuang@huawei.com>, <linyunsheng@huawei.com>,
        <huangguangbin2@huawei.com>, <chenhao288@hisilicon.com>,
        <salil.mehta@huawei.com>, <linuxarm@huawei.com>,
        <linuxarm@openeuler.org>, <dledford@redhat.com>, <jgg@ziepe.ca>,
        <netanel@amazon.com>, <akiyano@amazon.com>,
        <thomas.lendacky@amd.com>, <irusskikh@marvell.com>,
        <michael.chan@broadcom.com>, <edwin.peer@broadcom.com>,
        <rohitm@chelsio.com>, <jacob.e.keller@intel.com>,
        <ioana.ciornei@nxp.com>, <vladimir.oltean@nxp.com>,
        <sgoutham@marvell.com>, <sbhatta@marvell.com>, <saeedm@nvidia.com>,
        <ecree.xilinx@gmail.com>, <grygorii.strashko@ti.com>,
        <merez@codeaurora.org>, <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>
From:   moyufeng <moyufeng@huawei.com>
Message-ID: <c03f3079-ec46-6bfc-5d14-1eaa7e1ef667@huawei.com>
Date:   Wed, 18 Aug 2021 09:57:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20210817063903.6b62801c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/8/17 21:39, Jakub Kicinski wrote:
> On Tue, 17 Aug 2021 10:36:05 +0800 Yufeng Mo wrote:
>> In order to support more coalesce parameters through netlink,
>> add an new structure kernel_ethtool_coalesce, and keep
>> struct ethtool_coalesce as the base(legacy) part, then the
>> new parameter can be added into struct kernel_ethtool_coalesce.
>>
>> Also add new extack parameter for .set_coalesce and .get_coalesce
>> then some extra info can return to user with the netlink API.
>>
>> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> 
> This and the following patches don't build, please make sure
> allmodconfig builds correctly. Here's an example failure, but
> IDK if there isn't more:
> 
> drivers/net/ethernet/ti/davinci_emac.c: In function ‘emac_dev_open’:
> drivers/net/ethernet/ti/davinci_emac.c:1469:3: error: too few arguments to function ‘emac_set_coalesce’
>  1469 |   emac_set_coalesce(ndev, &coal);
>       |   ^~~~~~~~~~~~~~~~~
> .
> 
Sorry, I'll check allmodconfig again and make sure all builds correctly.
