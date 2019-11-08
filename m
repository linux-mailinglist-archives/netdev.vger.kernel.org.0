Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18AB0F43CF
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 10:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730221AbfKHJqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 04:46:50 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52588 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730573AbfKHJqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 04:46:50 -0500
Received: by mail-wm1-f67.google.com with SMTP id c17so5465063wmk.2
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 01:46:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qBRUcqrHuAkFcWrhiG6W90kEr3iLZdNuck5vTxZOE2I=;
        b=UbF+OC5/QhYL6bxs2u7StcX3ebTL9g9YHKrEP2nwnfBGwg4Fq5bQTYRTJEKFb4XOK+
         UxDBJ6e/zTjvZtYIdn2o87NPPiNE/ZI+rL6T+2rsNY87r0FT1vAjA/pZzFG8U9W1T2+P
         wCgjO3FNoXmgI7d+JVNNvL9kBXgNBvU1q0Hssq55C94jglwM9O8u526fL6qEsOo9lJL0
         ROmCeVJbjOyUg/HBR5AarDeIq5ZgXrkY6uoPieI0K3W5tmAZOpqVreRSXHjP/dVhWNe3
         /3/tyryBAXb8YOpuP2HYYZTlVQZYmNrDc1J7zYdC4mJwctQwwLBT/k1AFAqwbhWqxiiu
         nQeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qBRUcqrHuAkFcWrhiG6W90kEr3iLZdNuck5vTxZOE2I=;
        b=iMcZtQgVCAEKsKj49T7GbHQNU1jxCSwK+vGjWgLX3VeKK6sX30ARR1oeCk4biw8PX5
         ZttcbkJ7H2+We8OLvCM4+wTiAjWcIexRJ4UG//GWiIcHVruB7lCegkXMsDFs3khF86oB
         zK+vuMHTS8CPed7/IM6Ehz0quLQxlXzMK9z1QMNSWwFFRnWqagLaet8qnRd37n5+SkNQ
         KumlahQ/WX2Ff4f1YZtSDK9+EWYELefFQx2vITpmvVx8SIJBYdNR3Mgu5LrnuBcrnfp6
         9zd6vLk6XiqYokycdvjxIXCK53xoE8y9vZ1HQCn6hhdIYLBMeFceVVbduTLYM7ZcUMyl
         1ikw==
X-Gm-Message-State: APjAAAUNlOR9mJBG5FJDL6EvBb5N3IKd/BhyXbZejoYtAUb++lgg4y5a
        xZLxOg1kBpOS7EpMx3hQh0VVrw==
X-Google-Smtp-Source: APXvYqxwQwEMMzdKCCodb94kb+6Ua49RiWNSBUkEAh1vhuZWOkYle1LRVhIrgMYj3SGmQ3ZyiKHs8g==
X-Received: by 2002:a1c:9e58:: with SMTP id h85mr7618811wme.77.1573206407491;
        Fri, 08 Nov 2019 01:46:47 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id r15sm4761749wrc.5.2019.11.08.01.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 01:46:47 -0800 (PST)
Date:   Fri, 8 Nov 2019 10:46:46 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next 12/19] devlink: Introduce mdev port flavour
Message-ID: <20191108094646.GB6990@nanopsycho>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
 <20191107160834.21087-12-parav@mellanox.com>
 <20191107153836.29c09400@cakuba.netronome.com>
 <AM0PR05MB4866963BE7BA1EE0831C9624D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191107201750.6ac54aed@cakuba>
 <AM0PR05MB4866BEC2A2B586AA72BAA9ABD17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191107212024.61926e11@cakuba>
 <AM0PR05MB4866C0798EA5746EE23F2D2BD17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR05MB4866C0798EA5746EE23F2D2BD17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Nov 08, 2019 at 03:31:02AM CET, parav@mellanox.com wrote:
>
>
>> -----Original Message-----
>> From: Jakub Kicinski <jakub.kicinski@netronome.com>
>> Sent: Thursday, November 7, 2019 8:20 PM
>> To: Parav Pandit <parav@mellanox.com>
>> Cc: alex.williamson@redhat.com; davem@davemloft.net;
>> kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
>> <saeedm@mellanox.com>; kwankhede@nvidia.com; leon@kernel.org;
>> cohuck@redhat.com; Jiri Pirko <jiri@mellanox.com>; linux-
>> rdma@vger.kernel.org
>> Subject: Re: [PATCH net-next 12/19] devlink: Introduce mdev port flavour
>> 
>> On Fri, 8 Nov 2019 01:44:53 +0000, Parav Pandit wrote:
>> > > I'm talking about netlink attributes. I'm not suggesting to sprintf
>> > > it all into the phys_port_name.
>> > >
>> > I didn't follow your comment. For devlink port show command output you
>> > said,
>> >
>> > "Surely those devices are anchored in on of the PF (or possibly VFs)
>> > that should be exposed here from the start."
>> > So I was trying to explain why we don't expose PF/VF detail in the
>> > port attributes which contains
>> > (a) flavour
>> > (b) netdev representor (name derived from phys_port_name)
>> > (c) mdev alias
>> >
>> > Can you please describe which netlink attribute I missed?
>> 
>> Identification of the PCI device. The PCI devices are not linked to devlink
>> ports, so the sysfs hierarchy (a) is irrelevant, (b) may not be visible in multi-
>> host (or SmartNIC).
>>
>
>It's the unique mdev device alias. It is not right to attach to the PCI device.
>Mdev is bus in itself where devices are identified uniquely. So an alias suffice that identity.

Wait a sec. For mdev, what you say is correct. But here we talk about
devlink_port which is representing this mdev. And this devlink_port is
very similar to VF devlink_port. It is bound to specific PF (in case of
mdev it could be PF-VF).


>
>> > > > > > Signed-off-by: Parav Pandit <parav@mellanox.com>
>> > > > >
>> > > > > > @@ -6649,6 +6678,9 @@ static int
>> > > > > __devlink_port_phys_port_name_get(struct devlink_port
>> > > > > *devlink_port,
>> > > > > >  		n = snprintf(name, len, "pf%uvf%u",
>> > > > > >  			     attrs->pci_vf.pf, attrs->pci_vf.vf);
>> > > > > >  		break;
>> > > > > > +	case DEVLINK_PORT_FLAVOUR_MDEV:
>> > > > > > +		n = snprintf(name, len, "p%s", attrs-
>> >mdev.mdev_alias);
>> > > > >
>> > > > > Didn't you say m$alias in the cover letter? Not p$alias?
>> > > > >
>> > > > In cover letter I described the naming scheme for the netdevice of
>> > > > the mdev device (not the representor). Representor follows current
>> > > > unique phys_port_name method.
>> > >
>> > > So we're reusing the letter that normal ports use?
>> > >
>> > I initially had 'm' as prefix to make it easy to recognize as mdev's port,
>> instead of 'p', but during internal review Jiri's input was to just use 'p'.
>> 
>> Let's way for Jiri to weigh in then.
>
>Yeah.
>I remember his point was to not confuse the <en><m> prefix in the persistent device name with 'm' prefix in phys_port_name.
>Hence, his input was just 'p'.

Not sure what are you referring to. Udev places "n" in front of whatever
string we construct here, so the namespace is entirely in our hands.


>
>> 
>> > > Why does it matter to name the virtualized device? In case of other
>> > > reprs its the repr that has the canonical name, in case of
>> > > containers and VMs they will not care at all what hypervisor identifier
>> the device has.
>> > >
>> > Well, many orchestration framework probably won't care of what name is
>> picked up.
>> > And such name will likely get renamed to eth0 in VM or container.
>> > Unlike vxlan, macvlan interfaces, user explicitly specify the netdevice name,
>> and when newlink() netlink command completes with success, user know the
>> device to use.
>> > If we don't have persistent name for mdev, if a random name ethX is
>> picked up, user needs refer to sysfs device hierarchy to know its netdev.
>> > Its super easy to do refer that, but having persistent name based out of
>> alias makes things aligned like naming device on PCI bus.
>> > This way devices can be used without VM/container use cases too, for
>> example user is interested in only 4 or 8 mdev devices in system and its
>> setup is done through systemd.service.
