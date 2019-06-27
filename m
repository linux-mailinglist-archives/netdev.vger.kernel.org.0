Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E10C58943
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfF0RsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:48:14 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43423 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbfF0RsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:48:14 -0400
Received: by mail-qk1-f194.google.com with SMTP id m14so2464173qka.10
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 10:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=P2et0OJE+IoV88xr/ln/SEgjBIDStaX2uEFJJ+kOQzY=;
        b=RZryFpJsuiniMjOJU7bTkSTCdkFW3BxvyAuB5EJcSHZ8HPW3NbGKm26EvdgBjuU+7E
         ZTuhlncIGZPA1EFjyQ/VG9ALnmpsYOyNlXiusafH94jEi6I/1ls9yWtftAKj7xB2tdEs
         QUJAb95D2Zv+cl89YpSagFdU5GbkCMl/1HgsRlKdtP70x1gNtNIcTfVqYa+63Smwiy7w
         gKB6Htwumbo08dafUfCu9xY3e6JXNS30VHJN4FyAUnIFH3e5t2OUSzYVDNcpzO4hrW5O
         h0Cci831eg+rJtZDw4kl8bTdC89cjC0luR0R8tM6RfzsOQZ7JSVR6yKu+wMs6ETRLtKB
         2iJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=P2et0OJE+IoV88xr/ln/SEgjBIDStaX2uEFJJ+kOQzY=;
        b=Cnz8CRVSpN9fhRbS/c9Px1Et0RaxIzKOHaK24Goqqd1TgZoRu7iODuk7XRWmRFXUuJ
         xj3olQVa8XTA/FH+4awBlTAKjZsuwYiuRkpZttq/RkpdL7IYUf16IY6T+iy2yCdS9Gt9
         QP/uf/2i+ha455xPKdTOv4M7pm5+zV8aKEfHgYi2ugIEQo9b4hRp5C8oF2QxpVqiR8tC
         D654OZ89ocTJ1wGJ6HWlmSh/rv1/sGCcMAmC2O3vgj91n/8faxMguWth4EZHRyGGobJh
         cR8UXDOBHJl9RJMzGyP+afvj6e41iNPOh4+1beRalCsCedpSRzYihFm3wgV2qQhNle6r
         bxBg==
X-Gm-Message-State: APjAAAXgm2LecPCzYPfqZZYkjpKYDuXmqixzae0+cl7HIBao9mmx3xB7
        FSAI3VidnC46k8MEnDmExZTXBg==
X-Google-Smtp-Source: APXvYqxmRxIn7X6/uKZiMScZoXpsjCN7ns3p99ujN4tW/GkOdaIgebSptAuajIG/QI//Q3Vqmz+gBw==
X-Received: by 2002:a37:9481:: with SMTP id w123mr4435445qkd.319.1561657693405;
        Thu, 27 Jun 2019 10:48:13 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v17sm1355957qtc.23.2019.06.27.10.48.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 10:48:13 -0700 (PDT)
Date:   Thu, 27 Jun 2019 10:48:08 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, dsahern@gmail.com, mlxsw@mellanox.com
Subject: Re: [RFC] longer netdev names proposal
Message-ID: <20190627104808.1404049a@cakuba.netronome.com>
In-Reply-To: <20190627094327.GF2424@nanopsycho>
References: <20190627094327.GF2424@nanopsycho>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Jun 2019 11:43:27 +0200, Jiri Pirko wrote:
> Hi all.
> 
> In the past, there was repeatedly discussed the IFNAMSIZ (16) limit for
> netdevice name length. Now when we have PF and VF representors
> with port names like "pfXvfY", it became quite common to hit this limit:
> 0123456789012345
> enp131s0f1npf0vf6
> enp131s0f1npf0vf22
> 
> Since IFLA_NAME is just a string, I though it might be possible to use
> it to carry longer names as it is. However, the userspace tools, like
> iproute2, are doing checks before print out. So for example in output of
> "ip addr" when IFLA_NAME is longer than IFNAMSIZE, the netdevice is
> completely avoided.
> 
> So here is a proposal that might work:
> 1) Add a new attribute IFLA_NAME_EXT that could carry names longer than
>    IFNAMSIZE, say 64 bytes. The max size should be only defined in kernel,
>    user should be prepared for any string size.
> 2) Add a file in sysfs that would indicate that NAME_EXT is supported by
>    the kernel.
> 3) Udev is going to look for the sysfs indication file. In case when
>    kernel supports long names, it will do rename to longer name, setting
>    IFLA_NAME_EXT. If not, it does what it does now - fail.
> 4) There are two cases that can happen during rename:
>    A) The name is shorter than IFNAMSIZ
>       -> both IFLA_NAME and IFLA_NAME_EXT would contain the same string:  
>          original IFLA_NAME     = eth0
>          original IFLA_NAME_EXT = eth0
>          renamed  IFLA_NAME     = enp5s0f1npf0vf1
>          renamed  IFLA_NAME_EXT = enp5s0f1npf0vf1
>    B) The name is longer tha IFNAMSIZ
>       -> IFLA_NAME would contain the original one, IFLA_NAME_EXT would   
>          contain the new one:
>          original IFLA_NAME     = eth0
>          original IFLA_NAME_EXT = eth0
>          renamed  IFLA_NAME     = eth0
>          renamed  IFLA_NAME_EXT = enp131s0f1npf0vf22

I think B is the only way, A risks duplicate IFLA_NAMEs over ioctl,
right?  And maybe there is some crazy application out there which 
mixes netlink and ioctl.

I guess it's not worse than status quo, given that today renames 
will fail and we will either get truncated names or eth0s..

> This would allow the old tools to work with "eth0" and the new
> tools would work with "enp131s0f1npf0vf22". In sysfs, there would
> be symlink from one name to another.
>       
> Also, there might be a warning added to kernel if someone works
> with IFLA_NAME that the userspace tool should be upgraded.
> 
> Eventually, only IFLA_NAME_EXT is going to be used by everyone.
> 
> I'm aware there are other places where similar new attribute
> would have to be introduced too (ip rule for example).
> I'm not saying this is a simple work.
> 
> Question is what to do with the ioctl api (get ifindex etc). I would
> probably leave it as is and push tools to use rtnetlink instead.
> 
> Any ideas why this would not work? Any ideas how to solve this
> differently?

Since we'd have to update all user space to make use of the new names
I'd be tempted to move to a more structured device identification.

5: enp131s0f1npf0vf6: <BROADCAST,MULTICAST> ...

vs:

5: eth5 (parent enp131s0f1 pf 0 vf 6 peer X*): <BROADCAST,MULTICAST> ...

* ;)

And allow filtering/selection of device based on more attributes than
just name and ifindex.  In practice in container workloads, for example,
the names are already very much insufficient to identify the device.
Refocusing on attributes is probably a big effort and not that practical
for traditional CLI users?  IDK

Anyway, IMHO your scheme is strictly better than status quo.
