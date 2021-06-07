Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 824E939D2A3
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 03:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhFGBid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 21:38:33 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7120 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbhFGBic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 21:38:32 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FywrH66jJzYrW0;
        Mon,  7 Jun 2021 09:33:51 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 09:36:39 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Mon, 7 Jun 2021
 09:36:39 +0800
Subject: Re: [RFC net-next 0/8] Introducing subdev bus and devlink extension
To:     Jakub Kicinski <kuba@kernel.org>
CC:     moyufeng <moyufeng@huawei.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Parav Pandit <parav@mellanox.com>,
        Or Gerlitz <gerlitz.or@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "michal.lkml@markovi.net" <michal.lkml@markovi.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "lipeng (Y)" <lipeng321@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        <shenjian15@huawei.com>, "chenhao (DY)" <chenhao288@hisilicon.com>,
        Jiaran Zhang <zhangjiaran@huawei.com>
References: <1551418672-12822-1-git-send-email-parav@mellanox.com>
 <20190301120358.7970f0ad@cakuba.netronome.com>
 <VI1PR0501MB227107F2EB29C7462DEE3637D1710@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <20190304174551.2300b7bc@cakuba.netronome.com>
 <VI1PR0501MB22718228FC8198C068EFC455D1720@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <76785913-b1bf-f126-a41e-14cd0f922100@huawei.com>
 <20210531223711.19359b9a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <7c591bad-75ed-75bc-5dac-e26bdde6e615@huawei.com>
 <20210601143451.4b042a94@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <cf961f69-c559-eaf0-e168-b014779a1519@huawei.com>
 <20210602093440.15dc5713@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <857e7a19-1559-b929-fd15-05e8f38e9d45@huawei.com>
 <20210603105311.27bb0c4d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <c9afecb5-3c0e-6421-ea58-b041d8173636@huawei.com>
 <20210604114109.3a7ada85@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <4e7a41ed-3f4d-d55d-8302-df3bc42dedd4@huawei.com>
Date:   Mon, 7 Jun 2021 09:36:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210604114109.3a7ada85@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme702-chm.china.huawei.com (10.1.199.98) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/6/5 2:41, Jakub Kicinski wrote:
> On Fri, 4 Jun 2021 09:18:04 +0800 Yunsheng Lin wrote:
>>>> Yes, it is confusing, how about using the controler_id to indicate
>>>> different NIC? we can make sure controler_id is unqiue in the same
>>>> host, a controler_id corresponds to a devlink instance, vendor info
>>>> or serial num for the devlink instance can further indicate more info
>>>> to the system user?
>>>>
>>>> pci/controler_id/0000:03:00.0/61  
>>>
>>> What is a "controller id" in concrete terms? Another abstract ID which
>>> may change on every boot?  
>>
>> My initial thinking is a id from a global IDA pool, which indeed may
>> change on every boot.
>>
>> I am not really thinking much deeper about the controller id, just
>> mirroring the bus identifiers for pcie device and ifindex for netdev,
> 
> devlink instance id seems fine, but there's already a controller
> concept in devlink so please steer clear of that naming.
I am not sure if controller concept already existed is reusable for
the devlink instance representing problem for multi-function which
shares common resource in the same ASIC. If not, we do need to pick
up other name.

Another thing I am not really think throught is how is the VF represented
by the devlink instance when VF is passed through to a VM.
I was thinking about VF is represented as devlink port, just like PF(with
different port flavour), and VF devlink port only exist on the same host
as PF(which assumes PF is never passed through to a VM), so it may means
the PF is responsible for creating the devlink port for VF when VF is passed
through to a VM?

Or do we need to create a devlink instance for VF in the VM too when the
VF is passed through to a VM? Or more specificly, does user need to query
or configure devlink info or configuration in a VM? If not, then devlink
instance in VM seems unnecessary?

> 
>> which may change too if the device is pluged into different pci slot
>> on every boot?
> 
> Heh. What is someone reflashes the part to change it's serial number? :)
> pci slot is reasonably stable, as proven by years of experience trying
> to find stable naming for netdevs.

I suppose that requires a booting to take effect and a vendor tool
to reflash the serial number, it seems reasonable the vendor/user will
try their best to not mess the serial number, otherwise service and
maintenance based on serial number will not work?
I was thinking about adding the vendor name besides the serial number
to indicate a devlink instance, to avoid that case that two hw from
different vendor having the same serial number accidentally.

> 
>>>> How about:
>>>> The PF first probed creates the devlink instance? PF probed later can
>>>> connect/register to that devlink instance created by the PF first probed.
>>>> It seems some locking need to ensure the above happens as intended too.
>>>>
>>>> About linking, the PF provide vendor info/serial number(or whatever is
>>>> unqiue between different vendor) of a controller it belong to, if the
>>>> controller does not exist yet, create one and connect/register to that
>>>> devlink instance, otherwise just do the connecting/registering.  
>>>
>>> Sounds about right, but I don't understand why another ID is
>>> necessary. Why not allow devlink instances to have multiple names, 
>>> like we allow aliases for netdevs these days?  
>>
>> We could still allow devlink instances to have multiple names,
>> which seems to be more like devlink tool problem?
>>
>> For example, devlink tool could use the id or the vendor_info/
>> serial_number to indicate a devlink instance according to user's
>> request.
> 
> Typing serial numbers seems pretty painful.
> 
>> Aliase could be allowed too as long as devlink core provide a
>> field and ops to set/get the field mirroring the ifalias for
>> netdevice?
> 
> I don't understand.

I meant we could still allow the user to provide a more meaningful
name to indicate a devlink instance besides the id.

> 
> .
> 

