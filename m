Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357D83A0F79
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 11:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237919AbhFIJSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 05:18:06 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:5349 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234061AbhFIJSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 05:18:05 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G0LwJ1WGjz6tlt;
        Wed,  9 Jun 2021 17:12:16 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 17:16:07 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Wed, 9 Jun 2021
 17:16:07 +0800
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
        Jiaran Zhang <zhangjiaran@huawei.com>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <1551418672-12822-1-git-send-email-parav@mellanox.com>
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
 <4e7a41ed-3f4d-d55d-8302-df3bc42dedd4@huawei.com>
 <20210607124643.1bb1c6a1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <530ff54c-3cee-0eb6-30b0-b607826f68cf@huawei.com>
 <20210608102945.3edff79a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <2acd8373-b3dc-4920-1cbe-2b5ae29acb5b@huawei.com>
Date:   Wed, 9 Jun 2021 17:16:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210608102945.3edff79a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme704-chm.china.huawei.com (10.1.199.100) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/6/9 1:29, Jakub Kicinski wrote:
> On Tue, 8 Jun 2021 20:10:37 +0800 Yunsheng Lin wrote:
>>>> I am not sure if controller concept already existed is reusable for
>>>> the devlink instance representing problem for multi-function which
>>>> shares common resource in the same ASIC. If not, we do need to pick
>>>> up other name.
>>>>
>>>> Another thing I am not really think throught is how is the VF represented
>>>> by the devlink instance when VF is passed through to a VM.
>>>> I was thinking about VF is represented as devlink port, just like PF(with
>>>> different port flavour), and VF devlink port only exist on the same host
>>>> as PF(which assumes PF is never passed through to a VM), so it may means
>>>> the PF is responsible for creating the devlink port for VF when VF is passed
>>>> through to a VM?
>>>>
>>>> Or do we need to create a devlink instance for VF in the VM too when the
>>>> VF is passed through to a VM? Or more specificly, does user need to query
>>>> or configure devlink info or configuration in a VM? If not, then devlink
>>>> instance in VM seems unnecessary?  
>>>
>>> I believe the current best practice is to create a devlink instance for
>>> the VF with a devlink port of type "virtual". Such instance represents
>>> a "virtualized" view of the device.  
>>
>> Afer discussion with Parav in other thread, I undersood it was the current
>> practice, but I am not sure I understand why it is current *best* practice.
>>
>> If we allow all PF of a ASCI to register to the same devlink instance, does
>> it not make sense that all VF under one PF also register to the same devlink
>> instance that it's PF is registering to when they are in the same host?
>>
>> For eswitch legacy mode, whether VF and PF are the same host or not, the VF
>> can also provide the serial number of a ASIC to register to the devlink instance,
>> if that devlink instance does not exist yet, just create that devlink instance
>> according to the serial number, just like PF does.
>>
>> For eswitch DEVLINK_ESWITCH_MODE_SWITCHDEV mode, the flavour type for devlink
>> port instance representing the netdev of VF function is FLAVOUR_VIRTUAL, the
>> flavour type for devlink port instance representing the representor netdev of
>> VF is FLAVOUR_PCI_VF, which are different type, so they can register to the same
>> devlink instance even when both of the devlink port instance is in the same host?
>>
>> Is there any reason why VF use its own devlink instance?
> 
> Primary use case for VFs is virtual environments where guest isn't
> trusted, so tying the VF to the main devlink instance, over which guest
> should have no control is counter productive.

The security is mainly about VF using in container case, right?
Because VF using in VM, it is different host, it means a different devlink
instance for VF, so there is no security issue for VF using in VM case?
But it might not be the case for VF using in container?

Also I read about the devlink disscusion betwwen you and jiri in [1]:
"I think we agree that all objects of an ASIC should be under one
devlink instance, the question remains whether both ends of the pipe
for PCI devices (subdevs or not) should appear under ports or does the
"far end" (from ASICs perspective)/"host end" get its own category."

I am not sure if there is already any conclusion about the latter part
(I did not find the conclusion in that thread)?

"far end" (from ASICs perspective)/"host end" means PF/VF, right?
Which seems to correspond to port flavor of FLAVOUR_PHYSICAL and
FLAVOUR_VIRTUAL if we try to represent PF/VF using devlink port
instance?

It seems the conclusion is very important to our disscusion in this
thread, as we are trying to represent PF/VF as devlink port instance
in this thread(at least that is what I think, hns3 does not support
eswitch SWITCHDEV mode yet).

Also, there is a "switch_id" concept from jiri's example, which seems
to be not implemented yet?
pci/0000:05:00.0/10000: type eth netdev enp5s0npf0s0 flavour pci_pf pf 0 subport 0 switch_id 00154d130d2f

1. https://lore.kernel.org/netdev/20190304164007.7cef8af9@cakuba.netronome.com/t/

> 
>>>> I meant we could still allow the user to provide a more meaningful
>>>> name to indicate a devlink instance besides the id.  
>>>
>>> To clarify/summarize my statement above serial number may be a useful
>>> addition but PCI device names should IMHO remain the primary
>>> identifiers, even if it means devlink instances with multiple names.  
>>
>> I am not sure I understand what does it mean by "devlink instances with
>> multiple names"?
>>
>> Does that mean whenever a devlink port instance is registered to a devlink
>> instance, that devlink instance get a new name according to the PCI device
>> which the just registered devlink port instance corresponds to?
> 
> Not devlink port, new PCI device. Multiple ports may reside on the same
> PCI function, some ports don't have a function (e.g. Ethernet ports).

Multiple ports on the same mainly PCI function means subfunction from mlx,
right?

“some ports don't have a function (e.g. Ethernet ports)” does not seem
exist yet? For now devlink port instance of FLAVOUR_PHYSICAL represents
both PF and Ethernet ports?

> 
> .
> 

