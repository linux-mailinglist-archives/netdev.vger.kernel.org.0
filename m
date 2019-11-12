Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F15BF9369
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 15:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfKLOz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 09:55:59 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51496 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbfKLOz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 09:55:59 -0500
Received: by mail-wm1-f66.google.com with SMTP id q70so3538162wme.1
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 06:55:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=5tb4vPw+H7YY5HpWcFSbuKtki5U1MB7kYBKdNWPSgxQ=;
        b=eRbGoS8ULccadGrkxNTdzyM4LEugreo8o4BjzR27BdWQOmvS5sNeODUctnN05Yd3Dt
         tSWHvPKJxq12LuWzCyhSmHnP6HcTgmFhab0iC/pISkXPXvgA7RhNTb5Dq13K/OzZQdW+
         Preucd9f9OL+39E2cHKeulHal6pZxVrdm7UU8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=5tb4vPw+H7YY5HpWcFSbuKtki5U1MB7kYBKdNWPSgxQ=;
        b=BYu/v0YZb7iUiYUQuDbJ4Zo2WP2ZMACFLCQqUc8bZmh0Kf742uVj3kFzEzzkvmNewA
         C48xYjTunsGJRhp4RDHkfSKHEl77fH9jTpICnyVdXO7RmNAWL+Dc1YJokerKszH1HPvv
         +8RdW/evWDoxAPJiCxpY3GeFYOinrrxJBT54ad7kFX4T6OVaMcUC4Ztjn9KucxxETb0I
         Usx5m77NlJCaAdhmvaE1trJiiMjvmB9Zdc1Kaagi5hoG9fl2Payg1zGGxH3a1cWXfMQD
         VxrGRis9muvpCD1uc+1fmGPV4oXuHzqXJJjmwT0n8rvj3yYyTVSKdBssM6+qydLscuN7
         Y5bQ==
X-Gm-Message-State: APjAAAXtRWI3wLJBzwmiBaqB/IUmwwJjpu1X4K2rE8+DYCcn3FJYia92
        k4RPJz7STCFtAD72Uxmkj/oUfg==
X-Google-Smtp-Source: APXvYqwXxwZBYiepT3L1UJNlYDgidJEgahE0xj4A9T3EAUHz6o4DoX54aqztCNoM1sz/fxU7pfD6wQ==
X-Received: by 2002:a1c:f705:: with SMTP id v5mr4144313wmh.82.1573570556398;
        Tue, 12 Nov 2019 06:55:56 -0800 (PST)
Received: from C02YVCJELVCG ([192.19.231.250])
        by smtp.gmail.com with ESMTPSA id p1sm2795048wmc.38.2019.11.12.06.55.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Nov 2019 06:55:55 -0800 (PST)
From:   Andy Gospodarek <andrew.gospodarek@broadcom.com>
X-Google-Original-From: Andy Gospodarek <gospo@broadcom.com>
Date:   Tue, 12 Nov 2019 09:55:42 -0500
To:     Yuval Avnery <yuvalav@mellanox.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        Daniel Jurgens <danielj@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        "andrew.gospodarek@broadcom.com" <andrew.gospodarek@broadcom.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next v2 00/10] devlink subdev
Message-ID: <20191112145542.GA6619@C02YVCJELVCG>
References: <1573229926-30040-1-git-send-email-yuvalav@mellanox.com>
 <20191111100004.683b7320@cakuba>
 <AM6PR05MB5142D5C8B186A50D49D857ABC5740@AM6PR05MB5142.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AM6PR05MB5142D5C8B186A50D49D857ABC5740@AM6PR05MB5142.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 06:46:52PM +0000, Yuval Avnery wrote:
> 
> 
> > -----Original Message-----
> > From: Jakub Kicinski <jakub.kicinski@netronome.com>
> > Sent: Monday, November 11, 2019 10:00 AM
> > To: Yuval Avnery <yuvalav@mellanox.com>; Jiri Pirko <jiri@mellanox.com>
> > Cc: netdev@vger.kernel.org; Saeed Mahameed <saeedm@mellanox.com>;
> > leon@kernel.org; davem@davemloft.net; shuah@kernel.org; Daniel Jurgens
> > <danielj@mellanox.com>; Parav Pandit <parav@mellanox.com>;
> > andrew.gospodarek@broadcom.com; michael.chan@broadcom.com
> > Subject: Re: [PATCH net-next v2 00/10] devlink subdev
> > 
> > On Fri,  8 Nov 2019 18:18:36 +0200, Yuval Avnery wrote:
> > > This patchset introduces devlink subdev.
> > >
> > > Currently, legacy tools do not provide a comprehensive solution that
> > > can be used in both SmartNic and non-SmartNic mode.
> > > Subdev represents a device that exists on the ASIC but is not
> > > necessarily visible to the kernel.
> > >
> > > Using devlink ports is not suitable because:
> > >
> > > 1. Those devices aren't necessarily network devices (such as NVMe devices)
> > >    and doesn’t have E-switch representation. Therefore, there is need for
> > >    more generic representation of PCI VF.
> > > 2. Some attributes are not necessarily pure port attributes
> > >    (number of MSIX vectors)
> > 
> > PCIe attrs will require persistence. Where is that in this design?
> > 
> > Also MSIX vectors are configuration of the devlink port (ASIC side), the only
> > reason you're putting them in subdev is because some of the subdevs don't
> > have a port, muddying up the meaning of things.
> 
> The way I see this, they are both on the ASIC side.
> But port has nothing to do with MSIX so subdev makes more sense.
> 
> > 
> > > 3. It creates a confusing devlink topology, with multiple port flavours
> > >    and indices.
> > >
> > > Subdev will be created along with flavour and attributes.
> > > Some network subdevs may be linked with a devlink port.
> > >
> > > This is also aimed to replace "ip link vf" commands as they are
> > > strongly linked to the PCI topology and allow access only to enabled VFs.
> > > Even though current patchset and example is limited to MAC address of
> > > the VF, this interface will allow to manage PF, VF, mdev in SmartNic
> > > and non SmartNic modes, in unified way for networking and
> > > non-networking devices via devlink instance.
> > >
> > > Use case example:
> > > An example system view of a networking ASIC (aka SmartNIC), can be
> > > seen in below diagram, where devlink eswitch instance and PCI PF
> > > and/or VFs are situated on two different CPU subsystems:
> > >
> > >
> > >       +------------------------------+
> > >       |                              |
> > >       |             HOST             |
> > >       |                              |
> > >       |   +----+-----+-----+-----+   |
> > >       |   | PF | VF0 | VF1 | VF2 |   |
> > >       +---+----+-----------+-----+---+
> > >                  PCI1|
> > >           +---+------------+
> > >               |
> > >      +----------------------------------------+
> > >      |        |         SmartNic              |
> > >      |   +----+-------------------------+     |
> > >      |   |                              |     |
> > >      |   |               NIC            |     |
> > >      |   |                              |     |
> > >      |   +---------------------+--------+     |
> > >      |                         |  PCI2        |
> > >      |         +-----+---------+--+           |
> > >      |               |                        |
> > >      |      +-----+--+--+--------------+      |
> > >      |      |     | PF  |              |      |
> > >      |      |     +-----+              |      |
> > >      |      |      Embedded CPU        |      |
> > >      |      |                          |      |
> > >      |      +--------------------------+      |
> > >      |                                        |
> > >      +----------------------------------------+
> > >
> > > The below diagram shows an example devlink subdev topology where
> > some
> > > subdevs are connected to devlink ports::
> > >
> > >
> > >
> > >             (PF0)    (VF0)    (VF1)           (NVME VF2)
> > >          +--------------------------+         +--------+
> > >          | devlink| devlink| devlink|         | devlink|
> > >          | subdev | subdev | subdev |         | subdev |
> > >          |    0   |    1   |    2   |         |    3   |
> > >          +--------------------------+         +--------+
> > >               |        |        |
> > 
> > What is this NVME VF2 connected to? It's gotta get traffic from somewhere?
> > Frames come in from the uplink, then what?
> 
> The whole point here is that this is not a network device
> So it has nothing to do with the network.
> It is simply a PCI device exposed by the NIC to the host.
> devlink subdev lets us configure attributes for this device.
> 
> > 
> > >               |        |        |
> > >               |        |        |
> > >      +----------------------------------+
> > >      |   | devlink| devlink| devlink|   |
> > >      |   |  port  |  port  |  port  |   |
> > >      |   |    0   |    1   |    2   |   |
> > >      |   +--------------------------+   |
> > >      |                                  |
> > >      |                                  |
> > >      |           E-switch               |
> > >      |                                  |
> > >      |                                  |
> > >      |          +--------+              |
> > >      |          | uplink |              |
> > >      |          | devlink|              |
> > >      |          |  port  |              |
> > >      +----------------------------------+
> > >
> > > Devlink command example:
> > >
> > > A privileged user wants to configure a VF's hw_addr, before the VF is
> > > enabled.
> > >
> > > $ devlink subdev set pci/0000:03:00.0/1 hw_addr 10:22:33:44:55:66
> > >
> > > $ devlink subdev show pci/0000:03:00.0/1
> > > pci/0000:03:00.0/1: flavour pcivf pf 0 vf 0 port_index 1 hw_addr
> > > 10:22:33:44:55:66
> > >
> > > $ devlink subdev show pci/0000:03:00.0/1 -jp {
> > >     "subdev": {
> > >         "pci/0000:03:00.0/1": {
> > >             "flavour": "pcivf",
> > 
> > If the flavour is pcivf what differentiates this (Ethernet) VF from a NVME
> > one?
> > 
> 
> This describes the bus not the device purpose.
> 
> > >             "pf": 0,
> > >             "vf": 0,
> > >             "port_index": 1,
> > >             "hw_addr": "10:22:33:44:55:66"
> > 
> > Since you're messing with the "hw_addr", you should at least provision the
> > uAPI for adding multiple addresses. Intel guys were asking for this long time
> > ago.
> 
> This is the "permanent" address. The one the subdev boots with.
> 
> > 
> > Have you considered implementing some compat code so drivers don't have
> > to implement the legacy ndos if they support subdevs?
> 
> Will consider
> 
> > 
> > >         }
> > >     }
> > > }
> > 
> > Okay, so you added two diagrams. I guess I was naive in thinking that "you
> > thought this all through in detail and have more documentation and design
> > docs internally".
> > 
> > I don't like how unconstrained this is, the only implemented use case is
> > weak. But since you're not seeing this you probably never will, so seems like
> > a waste of time to fight it.
> 
> What am I missing? How would you constrain this?

It feels a bit 'unconstrained' to me as well.  As Jakub said you added
some documentation, but the direction of this long-term is not clear.
What seems to happen too often is that we skip creating better infra for
existing devices and create it only for the newest shiniest object.
These changes are what garners the most attention from those who grant
permission to push things upstream (*cough* managers *cough*), but it's
not the right choice in this case.  I'm not sure if that is part of what
bothers Jakub, but it is one thing that bothers me and why this feels
incomplete.

The thing that has been bouncing around in my head about this (and until
I was in front of a good text-based MUA I didn't dare respond) is that
we seem to have an overlap in functionality between what you are
proposing and existing virtual device configuration, but you are
completely ignoring improving upon the existing creation methods.
Whether dealing with a SmartNIC (which I used to describe a NIC with
general purpose processors that could be running Linux and I think you
do, too) or a regular NIC it seems like we should use devlink to create
and configure a variety of devices these could be:

1.  Number of PFs (there are cases where more than 1 PF per uplink port
    is required for command/control of the SmartNIC or where a single
    PCI b/d/f may have many uplink ports that need to be addressed
    separately)
2.  Device-specific SR-IOV VFs visible to server
3.  mdev devices that _may_ have representers on the embedded cores of
    the NIC
4.  Hardware VirtIO-net devices supported
5.  Other non-network devices (storage given as the first example) 
6.  ...

We cannot get rid of the methods for creating hardware VFs via sysfs,
but now that we are seeing lots of different flavors of devices that
might be created we should start by making sure at a minimum we can
create existing hardware devices (VFs) with this devlink interface and
move from there.  Is there a plan to use this interface to create
subdevs that are VFs or just new subdev flavors?  I could start to get
behind an interface like this if the patches showed that devlink would
be the one place where device creation and control could be done for all
types of subdevs, but that isn't clear that it is your direction based
on the patches.

So just to make sure this is clear, what I'm proposing that devlink is
used to create and configure all types of devices that it may be
possible to create, configure, or address from a PF and the starting
place should be standard, hardware VFs.  If that can be done right and
we can address some of the issues with the current implementation (more
than one hw addr is a _great_ example) then adding new flavours for the
server devices and and adding new flavors for SmartNIC-based devices
should be easy and feel natural.

