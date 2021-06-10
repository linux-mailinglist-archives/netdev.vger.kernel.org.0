Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA6B3A24CA
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 08:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhFJGyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 02:54:55 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:5474 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhFJGyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 02:54:52 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G0vjl4gffzZcBD;
        Thu, 10 Jun 2021 14:50:03 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 14:52:54 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Thu, 10 Jun
 2021 14:52:54 +0800
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
 <2acd8373-b3dc-4920-1cbe-2b5ae29acb5b@huawei.com>
 <20210609094036.7557bd83@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <7a682524-a4f8-7460-e75d-4446bb44ea44@huawei.com>
Date:   Thu, 10 Jun 2021 14:52:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210609094036.7557bd83@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme710-chm.china.huawei.com (10.1.199.106) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/6/10 0:40, Jakub Kicinski wrote:
> On Wed, 9 Jun 2021 17:16:06 +0800 Yunsheng Lin wrote:
>> On 2021/6/9 1:29, Jakub Kicinski wrote:
>>> On Tue, 8 Jun 2021 20:10:37 +0800 Yunsheng Lin wrote:  
>>>> Afer discussion with Parav in other thread, I undersood it was the current
>>>> practice, but I am not sure I understand why it is current *best* practice.
>>>>
>>>> If we allow all PF of a ASCI to register to the same devlink instance, does
>>>> it not make sense that all VF under one PF also register to the same devlink
>>>> instance that it's PF is registering to when they are in the same host?
>>>>
>>>> For eswitch legacy mode, whether VF and PF are the same host or not, the VF
>>>> can also provide the serial number of a ASIC to register to the devlink instance,
>>>> if that devlink instance does not exist yet, just create that devlink instance
>>>> according to the serial number, just like PF does.
>>>>
>>>> For eswitch DEVLINK_ESWITCH_MODE_SWITCHDEV mode, the flavour type for devlink
>>>> port instance representing the netdev of VF function is FLAVOUR_VIRTUAL, the
>>>> flavour type for devlink port instance representing the representor netdev of
>>>> VF is FLAVOUR_PCI_VF, which are different type, so they can register to the same
>>>> devlink instance even when both of the devlink port instance is in the same host?
>>>>
>>>> Is there any reason why VF use its own devlink instance?  
>>>
>>> Primary use case for VFs is virtual environments where guest isn't
>>> trusted, so tying the VF to the main devlink instance, over which guest
>>> should have no control is counter productive.  
>>
>> The security is mainly about VF using in container case, right?
>> Because VF using in VM, it is different host, it means a different devlink
>> instance for VF, so there is no security issue for VF using in VM case?
>> But it might not be the case for VF using in container?
> 
> How do you differentiate from the device perspective VF being assigned
> to the host vs VM? Presumably PFs and VFs have a similar API to talk to
> the FW, if VF can "join" the devlink instance of the PF that'd suggest
> to me it has access to privileged FW commands.

I was thinking info/param/health that is specfic to a VF is only registered
to the devlink port instance of that VF, same for resource that is specific
to PF. And it seems the param is already able to registered based on devlink
instance(devlink_params_register()) or based on devlink port instance(
devlink_port_params_register()).

Only PF will register privileged common resource based on devlink instance,
we may need to ensure only one PF register the privileged common resource
(maybe the PF probed first do the the privileged common resource registering,
I am not sure how to ensure that or implement it yet).

When user access the common resource in devlink instance, I think it is ok
to pass it through one of the PF(suppose all PF is in the same privilege
level)?

When user access the resource in devlink port instance of PHYSICAL/VIRTUAL,
the access is through the specific function(PF/VF) corresponds to that devlink
port instance?

When user access the resource in devlink port instance of PCI_PF/PCI_VF/PCI_SF,
the access is through the function where the eswitch is located?

so if a devlink instance only have devlink port instance of VF, that devlink
instance has not privileged common resource registered, so the user is not
able to access the privileged common resource?

If the PF and VF is in the same host and in the same net namespace, I suppose
it is ok to have the PF and VF to share the same devlink instance with the
privileged common resource registered?

> 
>> Also I read about the devlink disscusion betwwen you and jiri in [1]:
>> "I think we agree that all objects of an ASIC should be under one
>> devlink instance, the question remains whether both ends of the pipe
>> for PCI devices (subdevs or not) should appear under ports or does the
>> "far end" (from ASICs perspective)/"host end" get its own category."
>>
>> I am not sure if there is already any conclusion about the latter part
>> (I did not find the conclusion in that thread)?
>>
>> "far end" (from ASICs perspective)/"host end" means PF/VF, right?
>> Which seems to correspond to port flavor of FLAVOUR_PHYSICAL and
>> FLAVOUR_VIRTUAL if we try to represent PF/VF using devlink port
>> instance?
> 
> No, no, PHYSICAL is a physical port on the adapter, like an SFP port.
> There wasn't any conclusion to that discussion. Mellanox views devlink
> ports as eswitch ports, I view them as device ports which is hard to
> reconcile.

I suppose eswitch ports only exist when DEVLINK_ESWITCH_MODE_SWITCHDEV
mode is enabled, right? Does "Mellanox views devlink ports as eswitch
ports" means mlx driver will not create any devlink port instance when
DEVLINK_ESWITCH_MODE_LEGACY mode is enabled?
It does not seems to be the case any more, because the PF is registered
as a devlink port instance of FLAVOUR_PHYSICAL and VF is registered as
a devlink port instance of FLAVOUR__VIRTUAL in mlx5e_devlink_port_register(),
unless mlx5e_devlink_port_register() is only called in SWITCHDEV mode too.

From discussion in other thread with parav in [1], it seems:
1. Whenever there is a pcie function(PF/VF, maybe SF too?), there is a
   devlink instance corresponds to that pcie function.
2. Whenever there is a netdev(netdev of PF/VF, or representor netdev), there
   is a devlink port instance corresponds to that netdev.

It seems we only need to change (1) to enable "all objects of an ASIC
should be under one devlink instance" as below:
Whenever there is a ASIC(or switch), there is a devlink instance
corresponds to that ASIC(or switch)?

I am not sure I understand what it means by "device ports"? netdev? or
"physical port on the adapter, like an SFP port"? or "pcie function like
PF/VF"? Let's suppose it is in MODE_LEGACY mode.

1. https://patchwork.kernel.org/project/netdevbpf/patch/20210603111901.9888-1-parav@nvidia.com/#24231633

> 
>> It seems the conclusion is very important to our disscusion in this
>> thread, as we are trying to represent PF/VF as devlink port instance
>> in this thread(at least that is what I think, hns3 does not support
>> eswitch SWITCHDEV mode yet).
>>
>> Also, there is a "switch_id" concept from jiri's example, which seems
>> to be not implemented yet?
>> pci/0000:05:00.0/10000: type eth netdev enp5s0npf0s0 flavour pci_pf pf 0 subport 0 switch_id 00154d130d2f
>>
>> 1. https://lore.kernel.org/netdev/20190304164007.7cef8af9@cakuba.netronome.com/t/
>>
>>>> I am not sure I understand what does it mean by "devlink instances with
>>>> multiple names"?
>>>>
>>>> Does that mean whenever a devlink port instance is registered to a devlink
>>>> instance, that devlink instance get a new name according to the PCI device
>>>> which the just registered devlink port instance corresponds to?  
>>>
>>> Not devlink port, new PCI device. Multiple ports may reside on the same
>>> PCI function, some ports don't have a function (e.g. Ethernet ports).  
>>
>> Multiple ports on the same mainly PCI function means subfunction from mlx,
>> right?
> 
> Not necessarily, there are older devices out there (older NFPs, mlx4)
> which have one PF which is logically divided by the driver to service
> multiple ports.
> 
>> “some ports don't have a function (e.g. Ethernet ports)” does not seem
>> exist yet? For now devlink port instance of FLAVOUR_PHYSICAL represents
>> both PF and Ethernet ports?
> 
> It does. I think Mellanox cards are incapable of divorcing PFs from
> Ethernet ports, but the NFP driver represents the Ethernet port/SFP 
> as one netdev and devlink port (PHYSICAL) and the host port by another
> netdev and devlink port (PCI_PF). Which allows forwarding frames between
> PFs and between Ethernet ports directly (again, something not supported
> efficiently by simpler cards, but supported by NFPs).

If "Whenever there is a netdev(netdev of PF/VF, or representor netdev),
there is a devlink port instance corresponds to that netdev." rule apply
to the above case, as there is one netdev for PF and one netdev for Ethernet
port, then we have two devlink port instance too, one for netdev of PF, one
for the netdev of Ethernet port, which is different from Mellanox having one
netdev for both PF and Ethernet port，hence one devlink port for both PF and
Ethernet port.

It seems it is needed to clarify the FLAVOUR_PHYSICAL and FLAVOUR_PCI_PF
maybe having different semantic between NFP and Mellanox?

we might need to add another flavour type to indicate the netdev of PF,
if FLAVOUR_PHYSICAL indicates netdev of Ethernet port(if that netdev
exists) and FLAVOUR_PCI_PF indicates representor netdev of PF, as the
comment in definiation of flavour type:

	DEVLINK_PORT_FLAVOUR_PHYSICAL, /* Any kind of a port physically
					* facing the user.
					*/

	DEVLINK_PORT_FLAVOUR_PCI_PF, /* Represents eswitch port for
				      * the PCI PF. It is an internal
				      * port that faces the PCI PF.
				      */

> 
> .
> 

