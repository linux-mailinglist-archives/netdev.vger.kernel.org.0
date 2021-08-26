Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B063F864A
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 13:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241984AbhHZLWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 07:22:54 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9367 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234144AbhHZLWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 07:22:53 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GwL1C4GGVz8vG1;
        Thu, 26 Aug 2021 19:17:51 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 26 Aug 2021 19:22:01 +0800
Received: from [10.67.102.67] (10.67.102.67) by dggemi759-chm.china.huawei.com
 (10.1.198.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 26
 Aug 2021 19:22:00 +0800
Subject: Re: [PATCH V2 ethtool-next 1/2] update UAPI header copies
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <amitc@mellanox.com>,
        <idosch@idosch.org>, <andrew@lunn.ch>, <o.rempel@pengutronix.de>,
        <f.fainelli@gmail.com>, <jacob.e.keller@intel.com>,
        <mlxsw@mellanox.com>, <netdev@vger.kernel.org>,
        <lipeng321@huawei.com>
References: <1629877513-23501-1-git-send-email-huangguangbin2@huawei.com>
 <1629877513-23501-2-git-send-email-huangguangbin2@huawei.com>
 <20210826094530.x4m3pvkuvtorwz6d@lion.mk-sys.cz>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <af871f69-9459-c65c-015b-6f7bbb2ac44d@huawei.com>
Date:   Thu, 26 Aug 2021 19:22:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20210826094530.x4m3pvkuvtorwz6d@lion.mk-sys.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/8/26 17:45, Michal Kubecek wrote:
> On Wed, Aug 25, 2021 at 03:45:12PM +0800, Guangbin Huang wrote:
>> Update to kernel commit 5b4ecc3d4c4a.
>>
>> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
>> ---
>>   uapi/linux/ethtool.h | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
>> index c6ec1111ffa3..bd1f09b23cf5 100644
>> --- a/uapi/linux/ethtool.h
>> +++ b/uapi/linux/ethtool.h
>> @@ -637,6 +637,8 @@ enum ethtool_link_ext_substate_link_logical_mismatch {
>>   enum ethtool_link_ext_substate_bad_signal_integrity {
>>   	ETHTOOL_LINK_EXT_SUBSTATE_BSI_LARGE_NUMBER_OF_PHYSICAL_ERRORS = 1,
>>   	ETHTOOL_LINK_EXT_SUBSTATE_BSI_UNSUPPORTED_RATE,
>> +	ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_REFERENCE_CLOCK_LOST,
>> +	ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_ALOS,
>>   };
>>   
>>   /* More information in addition to ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE. */
>> -- 
>> 2.8.1
>>
> 
> I replaced this commit with a full update of uapi headers. The point is
> that if we keep cherry picking only specific changes in the headers, it
> will become harder and harder to check if something is missing or if we
> diverged from kernel. This is why an update of uapi headers should
> always update all of them to the state of the same kernel commit
> (usually current master or net-next tree).
> 
> I added the link to ethtool-import-uapi script to devel documentation on
> the ethtool web page make things easier.
> 
> Michal
> 
Ok, thanks!
