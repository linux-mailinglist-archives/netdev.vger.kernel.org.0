Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A26592C4240
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 15:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbgKYOiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 09:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729482AbgKYOiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 09:38:01 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBAF5C0613D4;
        Wed, 25 Nov 2020 06:38:00 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id u21so2318689iol.12;
        Wed, 25 Nov 2020 06:38:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+FWS0S6MIFKcLijSc7gkDfW5vqGQ+TSuTXybIpZdRMM=;
        b=XxJuDp1M9GgjnaTupdyln/fjw3NUs/Ni/CQexKbfNFj6xqMp6sei964Bbl3ar/2nqw
         pw5l5mPddjXX6pk7fZkkQ9IG6u2+ASu1EjJqjnjVLnlk3QJ9zEF7aMvaZndsqbvV6uEs
         I4wiSf6dEh/iTByoiMbQwZ47v9XX1YFx+PJNMKbwd4ecdELZUizuUZKJ8Z054GmDgJ6P
         1oG9JEz/lMherLX2XYYLVO3JsXtNvHn9eJLjDqskWsFvPArAJFklR+WwkgiJw0Xr3QOl
         kX5tXXU54+STbCPepodQxMZ5h7jpXuTabQhwdqpdjE92bbENCZj+6BBihZj7T3K16nmg
         PyrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+FWS0S6MIFKcLijSc7gkDfW5vqGQ+TSuTXybIpZdRMM=;
        b=HSdZUw3s+V6p/TYZPMay1xX+6dRKBrF5cv7+tDThB4v2rt2UyIsbO0LQ/amKMxPQ7Y
         ulJiH9ScdcmwByZO6hNBUnQzz3VJCZIp1iAPVICml1YmYY6GqUdPxdMXJo6t3TjDv+2t
         miW98wRsIcbm87pr1HAvFjNVZscz2+PEgu5Gyl5aXpaKuLNKjVNXyrCVH6Kxts7uq7J0
         s83IiskqLFdBDRuIGNoIhwFOkFxcX4B5+EhJaeNd8cAe0/AYkRKKFyrhLcvmte5Y9nkH
         JS8WbU2MIzLp7en3aR9W6+bscvQ72GKkHMSQzrgoCtLPKxeKfio1OivaHJgLv+SpBYNS
         pS2w==
X-Gm-Message-State: AOAM532TmSY9s+4o2JbUOdLcZ0+3Y0mP0ua/dJo9Wp0XqJJzTLtIhjYO
        o2kLowVsdKnxgSzjFnZbzUU=
X-Google-Smtp-Source: ABdhPJzGaeGIOPm+AtI62wEckRRiQ5oECNA4GiOIyluui8NcQ3e4Q9po3VBw98gG8y/9oPHRAS49AQ==
X-Received: by 2002:a02:c546:: with SMTP id g6mr3628348jaj.126.1606315080139;
        Wed, 25 Nov 2020 06:38:00 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:284:8203:54f0:b920:c7b8:6a02:a6c0])
        by smtp.googlemail.com with ESMTPSA id m2sm1445177ilj.24.2020.11.25.06.37.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2020 06:37:59 -0800 (PST)
Subject: Re: [PATCH net-next 00/13] Add mlx5 subfunction support
To:     Parav Pandit <parav@nvidia.com>, Saeed Mahameed <saeed@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20201112192424.2742-1-parav@nvidia.com>
 <20201116145226.27b30b1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <cdd576ebad038a3a9801e7017b7794e061e3ddcc.camel@kernel.org>
 <20201116175804.15db0b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB43229F23C101AFBCD2971534DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201117091120.0c933a4c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20201117184954.GV917484@nvidia.com>
 <20201118181423.28f8090e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <96e59cf0-1423-64af-1da9-bd740b393fa8@gmail.com>
 <29c4d7854faaea6db33136a448a8d2f53d0cfd72.camel@kernel.org>
 <8e6de69c-c979-1f22-067d-24342cfbff52@gmail.com>
 <BY5PR12MB43221CF1FAD99DF931ADE99CDCFA0@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9a5d1d5e-a12c-3cc1-b433-4920fb595fc3@gmail.com>
Date:   Wed, 25 Nov 2020 07:37:58 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB43221CF1FAD99DF931ADE99CDCFA0@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/24/20 11:00 PM, Parav Pandit wrote:
> Hi David,
> 
>> From: David Ahern <dsahern@gmail.com>
>> Sent: Wednesday, November 25, 2020 11:04 AM
>>
>> On 11/18/20 10:57 PM, Saeed Mahameed wrote:
>>>
>>> We are not slicing up any queues, from our HW and FW perspective SF ==
>>> VF literally, a full blown HW slice (Function), with isolated control
>>> and data plane of its own, this is very different from VMDq and more
>>> generic and secure. an SF device is exactly like a VF, doesn't steal
>>> or share any HW resources or control/data path with others. SF is
>>> basically SRIOV done right.
>>
>> What does that mean with respect to mac filtering and ntuple rules?
>>
>> Also, Tx is fairly easy to imagine, but how does hardware know how to direct
>> packets for the Rx path? As an example, consider 2 VMs or containers with the
>> same destination ip both using subfunction devices.
> Since both VM/containers are having same IP, it is better to place them in different L2 domains via vlan, vxlan etc.

ok, so relying on <vlan, dmac> pairs.

> 
>> How does the nic know how to direct the ingress flows to the right queues for
>> the subfunction?
>>
> Rx steering occurs through tc filters via representor netdev of SF.
> Exactly same way as VF representor netdev operation.
> 
> When devlink eswitch port is created as shown in example in cover letter, and also in patch-12, it creates the representor netdevice.
> Below is the snippet of it.
> 
> Add a devlink port of subfunction flavour:
> $ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88
> 
> Configure mac address of the port function:
> $ devlink port function set ens2f0npf0sf88 hw_addr 00:00:00:00:88:88
>                                                 ^^^^^^^^^^^^^^
> This is the representor netdevice. It is created by port add command.
> This name is setup by systemd/udev v245 and higher by utilizing the existing phys_port_name infrastructure already exists for PF and VF representors.

hardware ensures only packets with that dmac are sent to the subfunction
device.

> 
> Now user can add unicast rx tc rule for example,
> 
> $ tc filter add dev ens2f0np0 parent ffff: prio 1 flower dst_mac 00:00:00:00:88:88 action mirred egress redirect dev ens2f0npf0sf88
> 
> I didn't cover this tc example in cover letter, to keep it short.
> But I had a one line description as below in the 'detail' section of cover-letter.
> Hope it helps.
> 
> - A SF supports eswitch representation and tc offload support similar
>   to existing PF and VF representors.
> 
> Now above portion answers, how to forward the packet to subfunction.
> But how to forward to the right rx queue out of multiple rxqueues?
> This is done by the rss configuration done by the user, number of channels from ethtool.
> Just like VF and PF.
> The driver defaults are similar to VF, which user can change via ethtool.
> 

so users can add flow steering or drop rules to SF devices.

thanks,
