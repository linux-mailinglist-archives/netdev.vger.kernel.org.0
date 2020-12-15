Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1842DB588
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 22:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728701AbgLOVAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 16:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728233AbgLOVAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 16:00:06 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB71C0617A6;
        Tue, 15 Dec 2020 12:59:25 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id j20so16322861otq.5;
        Tue, 15 Dec 2020 12:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lkgDYxxfqcaS+YFb4xnkeKiz6WYG3v1IyWit0W1gBCU=;
        b=n70CO2yW/IHy1bf4UFZEPxtkYSETUCrBE3DO8CLaXiUuErCWchP+UqLetVG+lBq8qq
         GJtO5IW0oZ/j07qq8WRLLoI/MoCnZUoto/NmpbVKCoMdyJ/OO3nlhxKMbu7Z/z+tjFPr
         JyHedAd0HpwbX5YTyptLOI/oeUpal91eg93VfGydpl1oNuzT3Mwwxnr3MtARAI5uYt/j
         +YIZzt+FR4Hxr1H/N1JqhPVo4hqd2Phzx0OLA5BNsMB9slw34QGZKJNqrNstaogqvQR1
         MCMvDviB3IA+Rueaaw0ydQpJU1FgYgGozvEULVKF1Kuj22Qsn45Ynw4nITacB28jFw+r
         TYIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lkgDYxxfqcaS+YFb4xnkeKiz6WYG3v1IyWit0W1gBCU=;
        b=dootYvuDpKRG+uYeRVAx31d0UzzAaaoK2x0OT1XreZcJM99kU+1Y5UFUIxVh/neMXX
         11N5WBxxnkkoEWWmFvsYaPXBDG4DS+Es04bv4jcaTHUlwT6vnYve0+g5TcN5yHmcnLxl
         Ir1v3i2q+8gXQGK17mcRhl5bu35zUxjC1HiCu4vaQodwL5MI3r4qjZeGrDWwgE+wN29D
         2II9uFXUc3vQtredfUj7YdECvfL0NPy/mmRjHLgpMkV7iuNZlU6qmV+rLUzLq79CszZQ
         3QQ2WN6e8lMWaGW1kjNjeBRuDKN7TPRmoHukORj6CBVtpll9YEzMoZUBl0hLNIusGOUr
         FHrg==
X-Gm-Message-State: AOAM532Omcl1pSz3Dt4aw327tOA7PMO+1bg/chshESrjQKW8mnSQVi7Z
        cjija0Bo4TNRPh+nV9LgxIA=
X-Google-Smtp-Source: ABdhPJxxC/9tyzZDIgqc1J+egE8rP76Z48EMicZE+EuVKXTHdJGV+J1oX+xZgvxfvtLn45sVKjv4Pg==
X-Received: by 2002:a05:6830:15c1:: with SMTP id j1mr24697010otr.211.1608065965223;
        Tue, 15 Dec 2020 12:59:25 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:1f6:1ed:9027:4e75])
        by smtp.googlemail.com with ESMTPSA id i82sm5361267oia.2.2020.12.15.12.59.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 12:59:24 -0800 (PST)
Subject: Re: [net-next v4 00/15] Add mlx5 subfunction support
To:     Parav Pandit <parav@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Netdev <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
References: <20201214214352.198172-1-saeed@kernel.org>
 <CAKgT0UejoduCB6nYFV2atJ4fa4=v9-dsxNh4kNJNTtoHFd1DuQ@mail.gmail.com>
 <BY5PR12MB43221CE397D6310F2B04D9B4DCC60@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f2c1d4c6-2bca-8c9d-a347-e18f44181f7f@gmail.com>
Date:   Tue, 15 Dec 2020 13:59:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB43221CE397D6310F2B04D9B4DCC60@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/14/20 10:48 PM, Parav Pandit wrote:
> 
>> From: Alexander Duyck <alexander.duyck@gmail.com>
>> Sent: Tuesday, December 15, 2020 7:24 AM
>>
>> On Mon, Dec 14, 2020 at 1:49 PM Saeed Mahameed <saeed@kernel.org>
>> wrote:
>>>
>>> Hi Dave, Jakub, Jason,
>>>
>>
>> Just to clarify a few things for myself. You mention virtualization and SR-IOV
>> in your patch description but you cannot support direct assignment with this
>> correct? 
> Correct. it cannot be directly assigned.
> 
>> The idea here is simply logical partitioning of an existing network
>> interface, correct? 
> No. Idea is to spawn multiple functions from a single PCI device.
> These functions are not born in PCI device and in OS until they are created by user.
> Jason and Saeed explained this in great detail few weeks back in v0 version of the patchset at [1], [2] and [3].
> I better not repeat all of it here again. Please go through it.
> If you may want to read precursor to it, RFC from Jiri at [4] is also explains this in great detail.
> 
>> So this isn't so much a solution for virtualization, but may
>> work better for containers. I view this as an important distinction to make as
>> the first thing that came to mind when I read this was mediated devices
>> which is similar, but focused only on the virtualization case:
>> https://www.kernel.org/doc/html/v5.9/driver-api/vfio-mediated-
>> device.html
>>
> Managing subfunction using medicated device is already ruled out last year at [5] as it is the abuse of the mdev bus for this purpose + has severe limitations of managing the subfunction device.
> We are not going back to it anymore.
> It will be duplicating lot of the plumbing which exists in devlink, netlink, auxiliary bus and more.
>  
>> Rather than calling this a subfunction, would it make more sense to call it
>> something such as a queue set? 
> No, queue is just one way to send and receive data/packets.
> Jason and Saeed explained and discussed  this piece to you and others during v0 few weeks back at [1], [2], [3].
> Please take a look.
> 
>> So in terms of ways to go I would argue this is likely better. However one
>> downside is that we are going to end up seeing each subfunction being
>> different from driver to driver and vendor to vendor which I would argue
>> was also one of the problems with SR-IOV as you end up with a bit of vendor
>> lock-in as a result of this feature since each vendor will be providing a
>> different interface.
>>
> Each and several vendors provided unified interface for managing VFs. i.e.
> (a) enable/disable was via vendor neutral sysfs
> (b) sriov capability exposed via standard pci capability and sysfs
> (c) sriov vf config (mac, vlan, rss, tx rate, spoof check trust) are using vendor agnostic netlink
> Even though the driver's internal implementation largely differs on how trust, spoof, mac, vlan rate etc are enforced.
> 
> So subfunction feature/attribute/functionality will be implemented differently internally in the driver matching vendor's device, for reasonably abstract concept of 'subfunction'.
> 
>>> A Subfunction supports eswitch representation through which it
>>> supports tc offloads. User must configure eswitch to send/receive
>>> packets from/to subfunction port.
>>>
>>> Subfunctions share PCI level resources such as PCI MSI-X IRQs with
>>> their other subfunctions and/or with its parent PCI function.
>>
>> This piece to the architecture for this has me somewhat concerned. If all your
>> resources are shared and 
> All resources are not shared.
> 
>> you are allowing devices to be created
>> incrementally you either have to pre-partition the entire function which
>> usually results in limited resources for your base setup, or free resources
>> from existing interfaces and redistribute them as things change. I would be
>> curious which approach you are taking here? So for example if you hit a
>> certain threshold will you need to reset the port and rebalance the IRQs
>> between the various functions?
> No. Its works bit differently for mlx5 device.
> When base function is started, it started as if it doesn't have any subfunctions.
> When subfunction is instantiated, it spawns new resources in device (hw, fw, memory) depending on how much a function wants.
> 
> For example, PCI PF uses BAR 0, while subfunctions uses BAR 2.
> For IRQs, subfunction instance shares the IRQ with its parent/hosting PCI PF.
> In future, yes, a dedicated IRQs per SF is likely desired.
> Sridhar also talked about limiting number of queues to a subfunction.
> I believe there will be resources/attributes of the function to be controlled.
> devlink already provides rich interface to achieve that using devlink resources [8].
> 
> [..]
> 
>>> $ ip link show
>>> 127: ens2f0np0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state
>> DOWN mode DEFAULT group default qlen 1000
>>>     link/ether 24:8a:07:b3:d1:12 brd ff:ff:ff:ff:ff:ff
>>>     altname enp6s0f0np0
>>> 129: p0sf88: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN
>> mode DEFAULT group default qlen 1000
>>>     link/ether 00:00:00:00:88:88 brd ff:ff:ff:ff:ff:ff>
>>
>> I assume that p0sf88 is supposed to be the newly created subfunction.
>> However I thought the naming was supposed to be the same as what you are
>> referring to in the devlink, or did I miss something?
>>
> I believe you are confused with the representor netdevice of subfuction with devices of subfunction. (netdev, rdma, vdpa etc).
> I suggest that please refer to the diagram in patch_15 in [7] to see the stack, modules, objects.
> Hope below description clarifies a bit.
> There are two netdevices.
> (a) representor netdevice, attached to the devlink port of the eswitch
> (b) netdevice of the SF used by the end application (in your example, this is assigned to container).
>  
> Both netdevice follow obviously a different naming scheme.
> Representor netdevice follows naming scheme well defined in kernel + systemd/udev v245 and higher.
> It is based on phys_port_name sysfs attribute.
> This is same for existing PF and SF representors exist for year+ now. Further used by subfunction.
> 
> For subfunction netdevice (p0s88), system/udev will be extended. I put example based on my few lines of udev rule that reads
> phys_port_name and user supplied sfnum, so that user exactly knows which interface to assign to container.
> 
>>> After use inactivate the function:
>>> $ devlink port function set ens2f0npf0sf88 state inactive
>>>
>>> Now delete the subfunction port:
>>> $ devlink port del ens2f0npf0sf88
>>
>> This seems wrong to me as it breaks the symmetry with the port add
>> command and
> Example of the representor device is only to make life easier for the user.
> Devlink port del command works based on the devlink port index, just like existing devlink port commands (get,set,split,unsplit).
> I explained this in a thread with Sridhar at [6].
> In short devlink port del <bus/device_name/port_index command is just fine.
> Port index is unique handle for the devlink instance that user refers to delete, get, set port and port function attributes post its creation.
> I choose the representor netdev example because it is more intuitive to related to, but port index is equally fine and supported.
> 
>> assumes you have ownership of the interface in the host. I
>> would much prefer to to see the same arguments that were passed to the
>> add command being used to do the teardown as that would allow for the
>> parent function to create the object, assign it to a container namespace, and
>> not need to pull it back in order to destroy it.
> Parent function will not have same netdevice name as that of representor netdevice, because both devices exist in single system for large part of the use cases.
> So port delete command works on the port index.
> Host doesn't need to pull it back to destroy it. It is destroyed via port del command.
> 
> [1] https://lore.kernel.org/netdev/20201112192424.2742-1-parav@nvidia.com/
> [2] https://lore.kernel.org/netdev/421951d99a33d28b91f2b2997409d0c97fa5a98a.camel@kernel.org/
> [3] https://lore.kernel.org/netdev/20201120161659.GE917484@nvidia.com/
> [4] https://lore.kernel.org/netdev/20200501091449.GA25211@nanopsycho.orion/
> [5] https://lore.kernel.org/netdev/20191107160448.20962-1-parav@mellanox.com/
> [6] https://lore.kernel.org/netdev/BY5PR12MB43227784BB34D929CA64E315DCCA0@BY5PR12MB4322.namprd12.prod.outlook.com/
> [7] https://lore.kernel.org/netdev/20201214214352.198172-16-saeed@kernel.org/T/#u
> [8] https://man7.org/linux/man-pages/man8/devlink-resource.8.html
> 

Seems to be a repeated line of questions. You might want to add these
FAQs, responses and references to the subfunction document once this set
gets merged.
