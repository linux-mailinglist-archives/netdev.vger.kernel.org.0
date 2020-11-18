Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35EBB2B838F
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 19:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgKRSD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 13:03:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgKRSD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 13:03:26 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B3BC0613D4;
        Wed, 18 Nov 2020 10:03:26 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id j12so3018188iow.0;
        Wed, 18 Nov 2020 10:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IK1go2P+4Cgotz5tygo8p+NSeUmlZN9jC8qWTM9Dn1s=;
        b=Uqg22v89jOZ30R6x78ltNX31dPyVM8mhi83VVDWmgrJt/nCHKc1EIA4xxN4VVz60Mt
         9h2J83oH1OrXoIlZxROxc5x7HumrTRxKiK6xMTOQ2uw8fgC+0w8MMJ+uFUsCconxt+Mu
         txuy31/+t16jEJU5fMRuQZ69aPbnS5m+n7kvnb2951gfKirpaa0AdURh1FXyOP/jwgl4
         KW/u1zdEEhbkmv1gATp67cYTnuepHy2Ntvha55VeEK1sG9rzGvM2HgRUDaNnVesF7Ypy
         Kw3Zmwi/yHT1yOCKbO7pCEeWCO7/13UeUE0X5cbNcJRtIktgulwccrcf98EdVIVmah7P
         Aq/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IK1go2P+4Cgotz5tygo8p+NSeUmlZN9jC8qWTM9Dn1s=;
        b=cnzojBu49dNJHzg6oxisyYPSQWJlb4VNcbvxnCSDS1pOKY84sO9P8kk/VucKNjmHlO
         Z4eWzLUv/MmiqPwnnsZKWorR0geFp5ljjq0haZTyl4tK2CfM/6HwEFhXe3ConPSabP9s
         cAdtNiwABKglRdKC+c/zjGhiJutawxCfcUXTum9w/xwdkCUB8++4KJXXjALPPE9eSL0M
         pr10qoHyWtHJN4MC9FAakQZF+CbYJ2EcUD0WLwS/X4QuQw6N6N7yupTW0SCruiIZ1pJp
         aJRPvhXHVH5XfjZ/Kdy1+VLkFXMXCsf8KnT+ko3Ll5pqEKeXurVCeeE1r1dKLUmgdMJj
         q+jA==
X-Gm-Message-State: AOAM531vypEvcrK+XBXUod3O6ViuUDI6ovDIi3j9DNe/+bVLyg7cQdk8
        WjoVPFWAHzjjeVMiR47x5Hs=
X-Google-Smtp-Source: ABdhPJy7Sp9Au4ICOjo88CPTzHBDFSyNa1qSn+UlFUfoYRqnXlY1ZH6sWlQHp2jZgT9jzyg+Gaw3TQ==
X-Received: by 2002:a02:7fd0:: with SMTP id r199mr4207593jac.69.1605722605985;
        Wed, 18 Nov 2020 10:03:25 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:284:8203:54f0:cd3a:ec11:4d4f:e8d8])
        by smtp.googlemail.com with ESMTPSA id z9sm13385076iog.3.2020.11.18.10.03.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 10:03:25 -0800 (PST)
Subject: Re: [PATCH net-next 03/13] devlink: Support add and delete devlink
 port
To:     Parav Pandit <parav@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     Jiri Pirko <jiri@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Vu Pham <vuhuong@nvidia.com>
References: <20201112192424.2742-1-parav@nvidia.com>
 <20201112192424.2742-4-parav@nvidia.com>
 <e7b2b21f-b7d0-edd5-1af0-a52e2fc542ce@gmail.com>
 <BY5PR12MB43222AB94ED279AF9B710FF1DCE10@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b34d8427-51c0-0bbd-471e-1af30375c702@gmail.com>
Date:   Wed, 18 Nov 2020 11:03:24 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB43222AB94ED279AF9B710FF1DCE10@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/20 10:02 AM, Parav Pandit wrote:
> 
>> From: David Ahern <dsahern@gmail.com>
>> Sent: Wednesday, November 18, 2020 9:51 PM
>>
>> On 11/12/20 12:24 PM, Parav Pandit wrote:
>>> Extended devlink interface for the user to add and delete port.
>>> Extend devlink to connect user requests to driver to add/delete such
>>> port in the device.
>>>
>>> When driver routines are invoked, devlink instance lock is not held.
>>> This enables driver to perform several devlink objects registration,
>>> unregistration such as (port, health reporter, resource etc) by using
>>> exising devlink APIs.
>>> This also helps to uniformly use the code for port unregistration
>>> during driver unload and during port deletion initiated by user.
>>>
>>> Examples of add, show and delete commands:
>>> $ devlink dev eswitch set pci/0000:06:00.0 mode switchdev
>>>
>>> $ devlink port show
>>> pci/0000:06:00.0/65535: type eth netdev ens2f0np0 flavour physical
>>> port 0 splittable false
>>>
>>> $ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88
>>>
>>> $ devlink port show pci/0000:06:00.0/32768
>>> pci/0000:06:00.0/32768: type eth netdev eth0 flavour pcisf controller 0
>> pfnum 0 sfnum 88 external false splittable false
>>>   function:
>>>     hw_addr 00:00:00:00:88:88 state inactive opstate detached
>>>
>>
>> There has to be limits on the number of sub functions that can be created for
>> a device. How does a user find that limit?
> Yes, this came up internally, but didn't really converged.
> The devlink resource looked too verbose for an average or simple use cases.
> But it may be fine.
> The hurdle I faced with devlink resource is with defining the granularity.
> 
> For example one devlink instance deploys sub functions on multiple pci functions.
> So how to name them? Currently we have controller and PFs in port annotation.
> So resource name as 
> c0pf0_subfunctions -> for controller 0, pf 0 
> c1pf2_subfunctions -> for controller 1, pf 2
> 
> Couldn't convince my self to name it this way.
> 
> Below example looked simpler to use but plumbing doesn’t exist for it.
> 
> $ devlink resource show pci/0000:03:00.0
> pci/0000:03:00.0/1: name max_sfs count 256 controller 0 pf 0
> pci/0000:03:00.0/2: name max_sfs count 100 controller 1 pf 0
> pci/0000:03:00.0/3: name max_sfs count 64 controller 1 pf 1
> 
> $ devlink resource set pci/0000:03:00.0/1 max_sfs 100
> 
> Second option I was considering was use port params which doesn't sound so right as resource.
> 
>>
>> Also, seems like there are hardware constraint at play. e.g., can a user reduce
>> the number of queues used by the physical function to support more sub-
>> functions? If so how does a user programmatically learn about this limitation?
>> e.g., devlink could have support to show resource sizing and configure
>> constraints similar to what mlxsw has.
> Yes, need to figure out its naming. For mlx5 num queues doesn't have relation to subfunctions.
> But PCI resource has relation and this is something we want to do in future, as you said may be using devlink resource.
> 

With Connectx-4 Lx for example the netdev can have at most 63 queues
leaving 96 cpu servers a bit short - as an example of the limited number
of queues that a nic can handle (or currently exposes to the OS not sure
which). If I create a subfunction for ethernet traffic, how many queues
are allocated to it by default, is it managed via ethtool like the pf
and is there an impact to the resources used by / available to the
primary device?
