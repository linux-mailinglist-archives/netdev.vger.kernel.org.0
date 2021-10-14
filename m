Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12C942D2BF
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 08:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhJNGfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 02:35:10 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:24311 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhJNGfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 02:35:09 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HVKGn6brVzbd3T;
        Thu, 14 Oct 2021 14:28:33 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 14 Oct 2021 14:32:54 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Thu, 14 Oct
 2021 14:32:53 +0800
Subject: Re: [PATCH V3 net-next 4/6] ethtool: extend ringparam setting uAPI
 with rx_buf_len
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <mkubecek@suse.cz>, <andrew@lunn.ch>,
        <amitc@mellanox.com>, <idosch@idosch.org>, <danieller@nvidia.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <jdike@addtoit.com>, <richard@nod.at>,
        <anton.ivanov@cambridgegreys.com>, <netanel@amazon.com>,
        <akiyano@amazon.com>, <gtzalik@amazon.com>, <saeedb@amazon.com>,
        <chris.snook@gmail.com>, <ulli.kroll@googlemail.com>,
        <linus.walleij@linaro.org>, <jeroendb@google.com>,
        <csully@google.com>, <awogbemila@google.com>, <jdmason@kudzu.us>,
        <rain.1986.08.12@gmail.com>, <zyjzyj2000@gmail.com>,
        <kys@microsoft.com>, <haiyangz@microsoft.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <doshir@vmware.com>,
        <pv-drivers@vmware.com>, <jwi@linux.ibm.com>,
        <kgraul@linux.ibm.com>, <hca@linux.ibm.com>, <gor@linux.ibm.com>,
        <johannes@sipsolutions.net>, <netdev@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>,
        <linux-s390@vger.kernel.org>
References: <20211012134127.11761-1-huangguangbin2@huawei.com>
 <20211012134127.11761-5-huangguangbin2@huawei.com>
 <20211012092802.3d44b0ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <3e1d81be-7eee-99e9-6fb1-f14a0965380a@huawei.com>
Date:   Thu, 14 Oct 2021 14:32:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20211012092802.3d44b0ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/10/13 0:28, Jakub Kicinski wrote:
> On Tue, 12 Oct 2021 21:41:25 +0800 Guangbin Huang wrote:
>> From: Hao Chen <chenhao288@hisilicon.com>
>>
>> Add two new parameters ringparam_ext and extack for
>> .get_ringparam and .set_ringparam to extend more ring params
>> through netlink.
> 
> A few more warnings to fix:
> 
> drivers/net/ethernet/micrel/ksz884x.c:6329: warning: Function parameter or member 'extack' not described in 'netdev_get_ringparam'
> drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c:280: warning: Function parameter or member 'extack' not described in 'pch_gbe_get_ringparam'
> drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c:304: warning: Function parameter or member 'extack' not described in 'pch_gbe_set_ringparam'
> .
> 
Ok, we will fix them in next version.
