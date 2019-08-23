Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD7E9A9C7
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 10:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390170AbfHWIM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 04:12:27 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43430 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389656AbfHWIM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 04:12:26 -0400
Received: by mail-wr1-f65.google.com with SMTP id y8so7769411wrn.10
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 01:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dKj/pD83MW4Pwxebhi9+UdQxS6vGNLOrj+wRbneIIsA=;
        b=sOo8m/8ifD3Tcw0q8fjWKdMg1ikZywMq2grx9867izD43F/7EXuUPEbKq4YjTbvJbZ
         Y9DiykDJMuK59f1t4WLf1XiGAzY3s6XbomiQFGHLwU4mv2/DPL9DKv3rbW+mULjW6JtT
         l2MHQReOjqFxcQ1iSygfxV14fx8VU7AUoipzzS9kYRPsUH9FCfZj4xOhAi8dMBhqEngn
         bTq7UHrF5IlZeQ0Q1YZIXMuHtmS1PUnMR1oi6V6j9ORXBCxHRrXkOxtAJU+1ogL/8aiP
         CmE9ruE8ifosgqNsa4lU9NHO6t7i1I4KGIaQR21IPmpsHaBOTRVlQ61E8RXeKZjQyhax
         kOkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dKj/pD83MW4Pwxebhi9+UdQxS6vGNLOrj+wRbneIIsA=;
        b=hybNcQQ+Fg6sh2/ndApCoziUfegqcDibIEojXAMpeOVd+ffYOdZGMm/TN+VR99jaLb
         MUI1HjPO37uujl8ZUrCvGCfUkbheSWRi1fKbcRysg+wJKiZe1Z8PaYFKokuTS07O5nwN
         R7wYcmf60n/SLg8jXREATGIVczLKLXAwprXorVzSv0abcQuJAblCKMnLeQt9+2SkxEmc
         LmA2Fx6qMYmpDg8h0A6aSR1nTlesuA5o+y0eDXzJYjRAzKvTLNwnA4eN1ko9Um5lAUAB
         ItSfreBUqv/GCkgpH5E/0o7njjRHWgUeJLD+XpsGW5zXLU6VpZYJh8Yrg7uFQUXmAL7+
         j+vw==
X-Gm-Message-State: APjAAAWsVhzXX5YmeO/9MhsJdscAK4zpoAOX/Cv3266z8WMArApl3tug
        czO396MmwL6Fmyyrj2PhrJfZIA==
X-Google-Smtp-Source: APXvYqy6etfjVEnGJ8bO7A2sQvlUY7W/D5fzLORlmdyb4FJgRpPwJPE1Vnv48uAB5OBr5UjYXhaNTQ==
X-Received: by 2002:a5d:408c:: with SMTP id o12mr3355309wrp.176.1566547942916;
        Fri, 23 Aug 2019 01:12:22 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id h8sm1927467wrq.49.2019.08.23.01.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2019 01:12:22 -0700 (PDT)
Date:   Fri, 23 Aug 2019 10:12:21 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cjia <cjia@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
Message-ID: <20190823081221.GG2276@nanopsycho.orion>
References: <20190820225722.237a57d2@x1.home>
 <AM0PR05MB4866AE8FC4AA3CC24B08B326D1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190820232622.164962d3@x1.home>
 <AM0PR05MB4866437FAA63C447CACCD7E5D1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190822092903.GA2276@nanopsycho.orion>
 <AM0PR05MB4866A20F831A5D42E6C79EFED1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190822095823.GB2276@nanopsycho.orion>
 <AM0PR05MB4866144FD76C302D04DA04B9D1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190822121936.GC2276@nanopsycho.orion>
 <AM0PR05MB4866F9650CF73FC671972127D1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR05MB4866F9650CF73FC671972127D1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Aug 22, 2019 at 03:33:30PM CEST, parav@mellanox.com wrote:
>
>
>> -----Original Message-----
>> From: Jiri Pirko <jiri@resnulli.us>
>> Sent: Thursday, August 22, 2019 5:50 PM
>> To: Parav Pandit <parav@mellanox.com>
>> Cc: Alex Williamson <alex.williamson@redhat.com>; Jiri Pirko
>> <jiri@mellanox.com>; David S . Miller <davem@davemloft.net>; Kirti
>> Wankhede <kwankhede@nvidia.com>; Cornelia Huck <cohuck@redhat.com>;
>> kvm@vger.kernel.org; linux-kernel@vger.kernel.org; cjia <cjia@nvidia.com>;
>> netdev@vger.kernel.org
>> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>> 
>> Thu, Aug 22, 2019 at 12:04:02PM CEST, parav@mellanox.com wrote:
>> >
>> >
>> >> -----Original Message-----
>> >> From: Jiri Pirko <jiri@resnulli.us>
>> >> Sent: Thursday, August 22, 2019 3:28 PM
>> >> To: Parav Pandit <parav@mellanox.com>
>> >> Cc: Alex Williamson <alex.williamson@redhat.com>; Jiri Pirko
>> >> <jiri@mellanox.com>; David S . Miller <davem@davemloft.net>; Kirti
>> >> Wankhede <kwankhede@nvidia.com>; Cornelia Huck
>> <cohuck@redhat.com>;
>> >> kvm@vger.kernel.org; linux-kernel@vger.kernel.org; cjia
>> >> <cjia@nvidia.com>; netdev@vger.kernel.org
>> >> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>> >>
>> >> Thu, Aug 22, 2019 at 11:42:13AM CEST, parav@mellanox.com wrote:
>> >> >
>> >> >
>> >> >> -----Original Message-----
>> >> >> From: Jiri Pirko <jiri@resnulli.us>
>> >> >> Sent: Thursday, August 22, 2019 2:59 PM
>> >> >> To: Parav Pandit <parav@mellanox.com>
>> >> >> Cc: Alex Williamson <alex.williamson@redhat.com>; Jiri Pirko
>> >> >> <jiri@mellanox.com>; David S . Miller <davem@davemloft.net>; Kirti
>> >> >> Wankhede <kwankhede@nvidia.com>; Cornelia Huck
>> >> <cohuck@redhat.com>;
>> >> >> kvm@vger.kernel.org; linux-kernel@vger.kernel.org; cjia
>> >> >> <cjia@nvidia.com>; netdev@vger.kernel.org
>> >> >> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>> >> >>
>> >> >> Wed, Aug 21, 2019 at 08:23:17AM CEST, parav@mellanox.com wrote:
>> >> >> >
>> >> >> >
>> >> >> >> -----Original Message-----
>> >> >> >> From: Alex Williamson <alex.williamson@redhat.com>
>> >> >> >> Sent: Wednesday, August 21, 2019 10:56 AM
>> >> >> >> To: Parav Pandit <parav@mellanox.com>
>> >> >> >> Cc: Jiri Pirko <jiri@mellanox.com>; David S . Miller
>> >> >> >> <davem@davemloft.net>; Kirti Wankhede <kwankhede@nvidia.com>;
>> >> >> >> Cornelia Huck <cohuck@redhat.com>; kvm@vger.kernel.org;
>> >> >> >> linux-kernel@vger.kernel.org; cjia <cjia@nvidia.com>;
>> >> >> >> netdev@vger.kernel.org
>> >> >> >> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>> >> >> >>
>> >> >> >> > > > > Just an example of the alias, not proposing how it's set.
>> >> >> >> > > > > In fact, proposing that the user does not set it,
>> >> >> >> > > > > mdev-core provides one
>> >> >> >> > > automatically.
>> >> >> >> > > > >
>> >> >> >> > > > > > > Since there seems to be some prefix overhead, as I
>> >> >> >> > > > > > > ask about above in how many characters we actually
>> >> >> >> > > > > > > have to work with in IFNAMESZ, maybe we start with
>> >> >> >> > > > > > > 8 characters (matching your "index" namespace) and
>> >> >> >> > > > > > > expand as necessary for
>> >> >> disambiguation.
>> >> >> >> > > > > > > If we can eliminate overhead in IFNAMESZ, let's start with
>> 12.
>> >> >> >> > > > > > > Thanks,
>> >> >> >> > > > > > >
>> >> >> >> > > > > > If user is going to choose the alias, why does it
>> >> >> >> > > > > > have to be limited to
>> >> >> >> sha1?
>> >> >> >> > > > > > Or you just told it as an example?
>> >> >> >> > > > > >
>> >> >> >> > > > > > It can be an alpha-numeric string.
>> >> >> >> > > > >
>> >> >> >> > > > > No, I'm proposing a different solution where mdev-core
>> >> >> >> > > > > creates an alias based on an abbreviated sha1.  The
>> >> >> >> > > > > user does not provide the
>> >> >> >> alias.
>> >> >> >> > > > >
>> >> >> >> > > > > > Instead of mdev imposing number of characters on the
>> >> >> >> > > > > > alias, it should be best
>> >> >> >> > > > > left to the user.
>> >> >> >> > > > > > Because in future if netdev improves on the naming
>> >> >> >> > > > > > scheme, mdev will be
>> >> >> >> > > > > limiting it, which is not right.
>> >> >> >> > > > > > So not restricting alias size seems right to me.
>> >> >> >> > > > > > User configuring mdev for networking devices in a
>> >> >> >> > > > > > given kernel knows what
>> >> >> >> > > > > user is doing.
>> >> >> >> > > > > > So user can choose alias name size as it finds suitable.
>> >> >> >> > > > >
>> >> >> >> > > > > That's not what I'm proposing, please read again.
>> >> >> >> > > > > Thanks,
>> >> >> >> > > >
>> >> >> >> > > > I understood your point. But mdev doesn't know how user
>> >> >> >> > > > is going to use
>> >> >> >> > > udev/systemd to name the netdev.
>> >> >> >> > > > So even if mdev chose to pick 12 characters, it could
>> >> >> >> > > > result in
>> >> collision.
>> >> >> >> > > > Hence the proposal to provide the alias by the user, as
>> >> >> >> > > > user know the best
>> >> >> >> > > policy for its use case in the environment its using.
>> >> >> >> > > > So 12 character sha1 method will still work by user.
>> >> >> >> > >
>> >> >> >> > > Haven't you already provided examples where certain drivers
>> >> >> >> > > or subsystems have unique netdev prefixes?  If mdev
>> >> >> >> > > provides a unique alias within the subsystem, couldn't we
>> >> >> >> > > simply define a netdev prefix for the mdev subsystem and
>> >> >> >> > > avoid all other collisions?  I'm not in favor of the user
>> >> >> >> > > providing both a uuid and an alias/instance.  Thanks,
>> >> >> >> > >
>> >> >> >> > For a given prefix, say ens2f0, can two UUID->sha1 first 9
>> >> >> >> > characters have
>> >> >> >> collision?
>> >> >> >>
>> >> >> >> I think it would be a mistake to waste so many chars on a
>> >> >> >> prefix, but
>> >> >> >> 9 characters of sha1 likely wouldn't have a collision before we
>> >> >> >> have 10s of thousands of devices.  Thanks,
>> >> >> >>
>> >> >> >> Alex
>> >> >> >
>> >> >> >Jiri, Dave,
>> >> >> >Are you ok with it for devlink/netdev part?
>> >> >> >Mdev core will create an alias from a UUID.
>> >> >> >
>> >> >> >This will be supplied during devlink port attr set such as,
>> >> >> >
>> >> >> >devlink_port_attrs_mdev_set(struct devlink_port *port, const char
>> >> >> >*mdev_alias);
>> >> >> >
>> >> >> >This alias is used to generate representor netdev's phys_port_name.
>> >> >> >This alias from the mdev device's sysfs will be used by the
>> >> >> >udev/systemd to
>> >> >> generate predicable netdev's name.
>> >> >> >Example: enm<mdev_alias_first_12_chars>
>> >> >>
>> >> >> What happens in unlikely case of 2 UUIDs collide?
>> >> >>
>> >> >Since users sees two devices with same phys_port_name, user should
>> >> >destroy
>> >> recently created mdev and recreate mdev with different UUID?
>> >>
>> >> Driver should make sure phys port name wont collide,
>> >So when mdev creation is initiated, mdev core calculates the alias and if there
>> is any other mdev with same alias exist, it returns -EEXIST error before
>> progressing further.
>> >This way user will get to know upfront in event of collision before the mdev
>> device gets created.
>> >How about that?
>> 
>> Sounds fine to me. Now the question is how many chars do we want to have.
>> 
>12 characters from Alex's suggestion similar to git?

Ok.

>
>> >
>> >
>> >> in this case that it does
>> >> not provide 2 same attrs for 2 different ports.
>> >> Hmm, so the order of creation matters. That is not good.
>> >>
>> >> >>
>> >> >> >I took Ethernet mdev as an example.
>> >> >> >New prefix 'm' stands for mediated device.
>> >> >> >Remaining 12 characters are first 12 chars of the mdev alias.
>> >> >>
>> >> >> Does this resolve the identification of devlink port representor?
>> >> >Not sure if I understood your question correctly, attemping to answer
>> below.
>> >> >phys_port_name of devlink port is defined by the first 12 characters
>> >> >of mdev
>> >> alias.
>> >> >> I assume you want to use the same 12(or so) chars, don't you?
>> >> >Mdev's netdev will also use the same mdev alias from the sysfs to
>> >> >rename
>> >> netdev name from ethX to enm<mdev_alias>, where en=Etherenet,
>> m=mdev.
>> >> >
>> >> >So yes, same 12 characters are use for mdev's netdev and mdev
>> >> >devlink port's
>> >> phys_port_name.
>> >> >
>> >> >Is that what are you asking?
>> >>
>> >> Yes. Then you have 3 chars to handle the rest of the name (pci, pf)...
