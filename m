Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA9241BCAB
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 04:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243766AbhI2CW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 22:22:57 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13385 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243226AbhI2CWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 22:22:55 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HK0Nz3w5xz8yr1;
        Wed, 29 Sep 2021 10:16:35 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 10:21:13 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Wed, 29 Sep
 2021 10:21:12 +0800
Subject: Re: [PATCH V2 net-next 3/6] ethtool: add support to set/get rx buf
 len via ethtool
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
References: <20210924142959.7798-1-huangguangbin2@huawei.com>
 <20210924142959.7798-4-huangguangbin2@huawei.com>
 <20210924104750.48ad3692@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <0f9fcdff-8cf9-8a56-196b-afd0aee7d0c7@huawei.com>
Date:   Wed, 29 Sep 2021 10:21:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20210924104750.48ad3692@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/9/25 1:47, Jakub Kicinski wrote:
> On Fri, 24 Sep 2021 22:29:56 +0800 Guangbin Huang wrote:
>> @@ -621,9 +631,13 @@ struct ethtool_ops {
>>   				struct kernel_ethtool_coalesce *,
>>   				struct netlink_ext_ack *);
>>   	void	(*get_ringparam)(struct net_device *,
>> -				 struct ethtool_ringparam *);
>> +				 struct ethtool_ringparam *,
>> +				 struct ethtool_ringparam_ext *,
>> +				 struct netlink_ext_ack *);
>>   	int	(*set_ringparam)(struct net_device *,
>> -				 struct ethtool_ringparam *);
>> +				 struct ethtool_ringparam *,
>> +				 struct ethtool_ringparam_ext *,
>> +				 struct netlink_ext_ack *);
> 
> You need to make the driver changes together with this chunk.
> Otherwise the build will be broken between the two during bisection.
> .
> 
Ok, thanks.
