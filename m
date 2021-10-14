Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B08842D2C3
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 08:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbhJNGhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 02:37:55 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14350 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhJNGhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 02:37:54 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HVKKY6YvLz9064;
        Thu, 14 Oct 2021 14:30:57 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 14 Oct 2021 14:35:48 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Thu, 14 Oct
 2021 14:35:47 +0800
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
 <20211012112637.5489ac9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <897d5405-8b51-da39-4720-21bb315946e5@huawei.com>
Date:   Thu, 14 Oct 2021 14:35:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20211012112637.5489ac9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/10/13 2:26, Jakub Kicinski wrote:
> On Tue, 12 Oct 2021 21:41:25 +0800 Guangbin Huang wrote:
>> @@ -80,7 +83,10 @@ static int rings_fill_reply(struct sk_buff *skb,
>>   	     (nla_put_u32(skb, ETHTOOL_A_RINGS_TX_MAX,
>>   			  ringparam->tx_max_pending) ||
>>   	      nla_put_u32(skb, ETHTOOL_A_RINGS_TX,
>> -			  ringparam->tx_pending))))
>> +			  ringparam->tx_pending)))  ||
>> +	    (ringparam_ext->rx_buf_len &&
>> +	     (nla_put_u32(skb, ETHTOOL_A_RINGS_RX_BUF_LEN,
>> +			  ringparam_ext->rx_buf_len))))
>>   		return -EMSGSIZE;
> 
> I think that this chunk belongs in the previous patch.
> .
> 
Ok, we will move them in next version.
