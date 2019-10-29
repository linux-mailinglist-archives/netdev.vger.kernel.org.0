Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51E2DE8DA6
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 18:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390384AbfJ2RIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 13:08:15 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45696 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731599AbfJ2RIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 13:08:15 -0400
Received: by mail-pg1-f194.google.com with SMTP id r1so9985485pgj.12
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 10:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ZfA2zVe0l1PwZ0mmyfvGo2F5TQ1DfYfhQZ9VtVxgNOE=;
        b=wOrh4R3TnMeMB+AjYkA8bkcgXRnBjaklUuPM6+ma9LbUqJlwITqqBRBp0BXRZWmjWO
         Dex2JI3mJ68B49XAoZ+uP0Ro/6y+ILU2MBiHvi8D5gMpjLJ3QjcOobnulfwjdoMcLgPY
         AX8qNIPNoJAKUARXRjGoBoztNUsHtY0WJCrVsJl3pbGd7U4udBWY2xWK62t+bIvLfrUj
         NOk6yTSAryY9nf9pXESaC/rK8s3qgyV09xbGM0vuXU4wrxrLBL4VP57ZMOfDUPsy80pL
         qz7Ahqe/A3xVsCFmjn5Ig4c0RcElEblYO5/p6qbPiXW3sQgIT7IQ6r8ud/V1qirD4Gax
         fAeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ZfA2zVe0l1PwZ0mmyfvGo2F5TQ1DfYfhQZ9VtVxgNOE=;
        b=G2wO1wzjNahYRDhCPmSVwaG29I1w430Ea+2Utdmw4avF8f040sgJDPzKxxa3L8/YCI
         cJ0NiZBMbtBdafOl7O213B7Pq7wJGyfTT02fEcESxPNOSX4p22wlUwnjDoJx171Zb1UG
         pSVkoX+vDaMUXG+U+fsClNiLKi8Mg9h7tfaiz/3iheMS8fOHZBsAbVkaKEyXZ0A6Khax
         qc5UqKFr88OuDLZ6qBadVtc1oiAOJJSWp20hhAckur4yfWhSKk5tFJ0S5p1zz7CkPYzD
         48/TLx88gAxxksaBYE0SOClQxYhm06NhbOJNhDNSOzITQB/wtpTody6WYNauvbikg/2/
         YCbg==
X-Gm-Message-State: APjAAAXhLXNNWYiM5xCwD/oMFCeIPOQEGKU+4c29GyG0vvMYRBJVk5Eg
        hHZ36qfSnNwDUsQxO2auCOYssw==
X-Google-Smtp-Source: APXvYqznu+dqe9KNJkaD1QaIKNP63RYiVNLozoeTPsP3CBlefqwjWj4FSgE0+uNTy/aei6uJGQKMIQ==
X-Received: by 2002:a17:90a:348c:: with SMTP id p12mr1289225pjb.105.1572368894478;
        Tue, 29 Oct 2019 10:08:14 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id r185sm14566081pfr.68.2019.10.29.10.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 10:08:14 -0700 (PDT)
Date:   Tue, 29 Oct 2019 10:08:10 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andy Gospodarek <andrew.gospodarek@broadcom.com>
Cc:     Yuval Avnery <yuvalav@mellanox.com>, Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        Daniel Jurgens <danielj@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next 0/9] devlink vdev
Message-ID: <20191029100810.66b1695a@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191025145808.GA20298@C02YVCJELVCG.dhcp.broadcom.net>
References: <1571766190-23943-1-git-send-email-yuvalav@mellanox.com>
        <20191023120046.0f53b744@cakuba.netronome.com>
        <20191023192512.GA2414@nanopsycho>
        <20191023151409.75676835@cakuba.hsd1.ca.comcast.net>
        <9f3974a1-95e9-a482-3dcd-0b23246d9ab7@mellanox.com>
        <20191023195141.48775df1@cakuba.hsd1.ca.comcast.net>
        <20191025145808.GA20298@C02YVCJELVCG.dhcp.broadcom.net>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Oct 2019 10:58:08 -0400, Andy Gospodarek wrote:
> Thanks, Jakub, I'm happy to chime in based on our deployment experience.
> We definitely understand the desire to be able to configure properties
> of devices on the SmartNIC (the kind with general purpose cores not the
> kind with only flow offload) from the server side.

Thanks!

> In addition to addressing NVMe devices, I'd also like to be be able to
> create virtual or real serial ports as well as there is an interest in
> *sometimes* being able to gain direct access to the SmartNIC console not
> just a shell via ssh.  So my point is that there are multiple use-cases.

Shelling into a NIC is the ultimate API backdoor. IMO we should try to
avoid that as much as possible.

> Arm are also _extremely_ interested in developing a method to enable
> some form of SmartNIC discovery method and while lots of ideas have been
> thrown around, discovery via devlink is a reasonable option.  So while
> doing all this will be much more work than simply handling this case
> where we set the peer or local MAC for a vdev, I think it will be worth
> it to make this more usable for all^W more types of devices.  I also
> agree that not everything on the other side of the wire should be a
> port. 
> 
> So if we agree that addressing this device as a PCIe device then it
> feels like we would be better served to query device capabilities and
> depending on what capabilities exist we would be able to configure
> properties for those.  In an ideal world, I could query a device using
> devlink ('devlink info'?) and it would show me different devices that
> are available for configuration on the SmartNIC and would also give me a
> way to address them.  So while I like the idea of being able to address
> and set parameters as shown in patch 05 of this series, I would like to
> see a bit more flexibility to define what type of device is available
> and how it might be configured.

We shall see how this develops. For now sounds pretty high level.
If the NIC needs to expose many "devices" that are independently
controlled we should probably look at re-using the standard device
model and not reinvent the wheel. 
If we need to configure particular aspects and resource allocation, 
we can add dedicated APIs as needed.

What I definitely want to avoid is adding a catch-all API with unclear
semantics which will become the SmartNIC dumping ground.

> So if we took the devlink info command as an example (whether its the
> proper place for this or not), it could look _like_ this:
> 
> $ devlink dev info pci/0000:03:00.0
> pci/0000:03:00.0:
>   driver foo
>   serial_number 8675309
>   versions:
> [...]
>   capabilities:
>       storage 0
>       console 1
>       mdev 1024
>       [something else] [limit]
> 
> (Additionally rather than putting this as part of 'info' the device
> capabilities and limits could be part of the 'resource' section and
> frankly may make more sense if this is part of that.)
> 
> and then those capabilities would be something that could be set using the
> 'vdev' or whatever-it-is-named interface:
> 
> # devlink vdev show pci/0000:03:00.0
> pci/0000:03:00.0/console/0: speed 115200 device /dev/ttySNIC0

The speed in this console example makes no sense to me.

The patches as they stand are about the peer side/other side of the
port. So which side of the serial device is the speed set on? One can
just read the speed from /dev/ttySNIC0. And link that serial device to
the appropriate parent via sysfs. This is pure wheel reinvention.

> pci/0000:03:00.0/mdev/0: hw_addr 02:00:00:00:00:00
> [...]
> pci/0000:03:00.0/mdev/1023: hw_addr 02:00:00:00:03:ff
> 
> # devlink vdev set pci/0000:03:00.0/mdev/0 hw_addr 00:22:33:44:55:00
> 
> Since these Arm/RISC-V based SmartNICs are going to be used in a variety
> of different ways and will have a variety of different personalities
> (not just different SKUs that vendors will offer but different ways in
> which these will be deployed), I think it's critical that we consider
> more than just the mdev/representer case from the start.
