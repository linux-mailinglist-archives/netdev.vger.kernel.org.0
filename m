Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 012673EF7C9
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 03:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236372AbhHRB72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 21:59:28 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8868 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbhHRB72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 21:59:28 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Gq9vF5Yh5z8sY6;
        Wed, 18 Aug 2021 09:54:49 +0800 (CST)
Received: from dggpeml500024.china.huawei.com (7.185.36.10) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 18 Aug 2021 09:58:52 +0800
Received: from [10.67.103.6] (10.67.103.6) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 18 Aug
 2021 09:58:51 +0800
Subject: Re: [PATCH net-next 2/4] ethtool: extend coalesce setting uAPI with
 CQE mode
To:     Jakub Kicinski <kuba@kernel.org>
References: <1629167767-7550-1-git-send-email-moyufeng@huawei.com>
 <1629167767-7550-3-git-send-email-moyufeng@huawei.com>
 <20210817064003.00733801@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
Message-ID: <3f45d740-a732-7f18-92ef-2cea8cf2b84c@huawei.com>
Date:   Wed, 18 Aug 2021 09:58:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20210817064003.00733801@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/8/17 21:40, Jakub Kicinski wrote:
> On Tue, 17 Aug 2021 10:36:05 +0800 Yufeng Mo wrote:
>>  include/linux/ethtool.h                            | 16 ++++++++++--
>>  net/ethtool/coalesce.c                             | 29 ++++++++++++++++++----
>>  net/ethtool/ioctl.c                                | 15 ++++++++---
>>  net/ethtool/netlink.h                              |  2 +-
> 
> I'd move changes to these files to the first patch, otherwise 
> they're hard to find in all the driver modifications.
> .
> 
ok, thanks.
