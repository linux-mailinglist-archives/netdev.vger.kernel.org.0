Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7E93A1478
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 14:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbhFIMcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 08:32:18 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:5357 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232910AbhFIMcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 08:32:16 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G0RDK6GF0z6tkR;
        Wed,  9 Jun 2021 20:26:25 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 20:30:17 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Wed, 9 Jun 2021
 20:30:17 +0800
Subject: Re: [RFC net-next 0/8] Introducing subdev bus and devlink extension
To:     Parav Pandit <parav@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
CC:     moyufeng <moyufeng@huawei.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Or Gerlitz <gerlitz.or@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "michal.lkml@markovi.net" <michal.lkml@markovi.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "lipeng (Y)" <lipeng321@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "shenjian15@huawei.com" <shenjian15@huawei.com>,
        "chenhao (DY)" <chenhao288@hisilicon.com>,
        Jiaran Zhang <zhangjiaran@huawei.com>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <1551418672-12822-1-git-send-email-parav@mellanox.com>
 <cf961f69-c559-eaf0-e168-b014779a1519@huawei.com>
 <20210602093440.15dc5713@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <857e7a19-1559-b929-fd15-05e8f38e9d45@huawei.com>
 <20210603105311.27bb0c4d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <c9afecb5-3c0e-6421-ea58-b041d8173636@huawei.com>
 <20210604114109.3a7ada85@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <4e7a41ed-3f4d-d55d-8302-df3bc42dedd4@huawei.com>
 <20210607124643.1bb1c6a1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <530ff54c-3cee-0eb6-30b0-b607826f68cf@huawei.com>
 <20210608102945.3edff79a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <2acd8373-b3dc-4920-1cbe-2b5ae29acb5b@huawei.com>
 <DM8PR12MB54802CA9A47F1585DC3347A5DC369@DM8PR12MB5480.namprd12.prod.outlook.com>
 <d54ae715-8634-c983-1602-8cd8dea2a5e2@huawei.com>
 <DM8PR12MB5480F577E5F02105B8C1FE9BDC369@DM8PR12MB5480.namprd12.prod.outlook.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <acf08577-34c6-bc9e-a788-568b67fa8d2e@huawei.com>
Date:   Wed, 9 Jun 2021 20:30:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <DM8PR12MB5480F577E5F02105B8C1FE9BDC369@DM8PR12MB5480.namprd12.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme720-chm.china.huawei.com (10.1.199.116) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/6/9 19:59, Parav Pandit wrote:
>> From: Yunsheng Lin <linyunsheng@huawei.com>
>> Sent: Wednesday, June 9, 2021 4:35 PM
>>
>> On 2021/6/9 17:38, Parav Pandit wrote:
>>>
>>>> From: Yunsheng Lin <linyunsheng@huawei.com>
>>>> Sent: Wednesday, June 9, 2021 2:46 PM
>>>>
>>> [..]
>>>
>>>>>> Is there any reason why VF use its own devlink instance?
>>>>>
>>>>> Primary use case for VFs is virtual environments where guest isn't
>>>>> trusted, so tying the VF to the main devlink instance, over which
>>>>> guest should have no control is counter productive.
>>>>
>>>> The security is mainly about VF using in container case, right?
>>>> Because VF using in VM, it is different host, it means a different
>>>> devlink instance for VF, so there is no security issue for VF using in VM
>> case?
>>>> But it might not be the case for VF using in container?
>>> Devlink instance has net namespace attached to it controlled using devlink
>> reload command.
>>> So a VF devlink instance can be assigned to a container/process running in a
>> specific net namespace.
>>>
>>> $ ip netns add n1
>>> $ devlink dev reload pci/0000:06:00.4 netns n1
>>>                                      ^^^^^^^^^^^^^
>>>                                      PCI VF/PF/SF.
>>
>> Could we create another devlink instance when the net namespace of
>> devlink port instance is changed? 
> Net namespace of (a) netdevice (b) rdma device (c) devlink instance can be changed.
> Net namespace of devlink port cannot be changed.

Yes, net namespace is changed based on the devlink instance, not
devlink port instance, *right now*.

> 
>> It may seems we need to change the net
>> namespace based on devlink port instance instead of devlink instance.
>> This way container case seems be similiar to the VM case?
> I mostly do not understand the topology you have in mind or if you explained previously I missed the thread.
> In your case what is the flavour of a devlink port?

flavour of the devlink port instance is FLAVOUR_PHYSICAL or
FLAVOUR_VIRTUAL.

The reason I suggest to change the net namespace on devlink port
instance instead of devlink instance is：
I proposed that all the PF and VF in the same ASIC are registered to
the same devlink instance as flavour FLAVOUR_PHYSICAL or FLAVOUR_VIRTUAL
when there are in the same host and in the same net namespace.

If a VF's devlink port instance is unregistered from old devlink
instance in the old net namespace and registered to new devlink
instance in the new net namespace(create a new devlink instance if
needed) when devlink port instance's net namespace is changed, then
the security mentioned by jakub is not a issue any more?

> 
>>
>>>
>>>> Also, there is a "switch_id" concept from jiri's example, which seems
>>>> to be not implemented yet?
>>>
>>> switch_id is present for switch ports in [1] and documented in [2].
>>>
>>> [1] /sys/class/net/representor_netdev/phys_switch_id.
>>> [2]
>> https://www.kernel.org/doc/Documentation/networking/switchdev.txt "
>> Switch ID"
>>
>> Thanks for info.
>> I suppose we could use "switch_id" to indentify a eswitch since "switch_id is
>> present for switch ports"?
>> Where does the "switch_id" of switch port come from? Is it from FW?
>> Or the driver generated it?
>>
>> Is there any rule for "switch_id"? Or is it vendor specific?
>>
>>>
> It should be unique enough, usually generated out of board serial id or other fields such as vendor OUI that makes it fairly unique.
> 
> 

