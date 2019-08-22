Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45F7398F55
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 11:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733216AbfHVJ3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 05:29:09 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34094 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732223AbfHVJ3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 05:29:06 -0400
Received: by mail-wr1-f67.google.com with SMTP id s18so4737414wrn.1
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 02:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zvZLQm2eReId0SwTyMH9VzRmlkdF2ZdYygKx0uvmAk0=;
        b=SGase5XAZFg+vTPEPlwvJlx1ym/QLLzp1ud2bXoCHajj5R7wkWDyAY3NQMyW+Fa8yk
         5TCCIETKfD2hpQpyh+tifopk6nxKPmvbjcRFK1Q7HOAQ+XMIoCYUknmm3EkeolqTHsYm
         XAE3JtkBJqI9/xyF2u/s0xTJHog+xjFhwlQXOcq63WrxnWnwQa4o79tGYuP2qbab4mpY
         MubhtDyP2NTE032vF1BczpQQZSJyrKtJMU1BNyw6BjHvG5FaU42RbjCvzhaH9EzhrSHk
         wkT+7neXomFGGvJMp9BtLhrT5LxpJ/FZKToD9fFKKkk3H9rvhMw06d5uDNaJUDrRpjEF
         7gUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zvZLQm2eReId0SwTyMH9VzRmlkdF2ZdYygKx0uvmAk0=;
        b=eqnZW/e2egz6RXY/KOjIiQrpx/ex72mtojvTnoX1whZI8XMeIQoPYsCQxNYL7oc6BE
         zPXDTrjfKQaDLZNDEXzr4XDjd2py19rLt+pZ2bdR+vn35zdSCWUuGl9oWyY6iBfmqW47
         /ZN2uG6MfxC8uMztFHsQSS3wNeo4X8kkcIBSkpKl8ph23r5ZgW+K5KEIo7CX1H8s/YE9
         GO3InFBV2Udem73sHrl9pFIGxsJvGiWt3d3UwCZrjZii2Ass2COltj++w0EaIVLdMkID
         yb4HOQRwl0tD3uidUpk7kVTddiXp7KS1Ys+xuH9pVHLOit9+QpTKtF6pvWWqpdlUH64Q
         RW+A==
X-Gm-Message-State: APjAAAWddJs+QU+dz9ey5FzurdiNVY2PTlM3sqhuT7XToItRO2X7bKIW
        5VFFdbO2bOBdEFuD9fKi2ZTjsQ==
X-Google-Smtp-Source: APXvYqy3MiZfh5jTT4YN2SGl9rGBNzJSpnL2EizF5M0c7ozx13iyKmQrwYFgp8g2hjvLpKPNCjxyIA==
X-Received: by 2002:adf:f641:: with SMTP id x1mr7145810wrp.179.1566466145132;
        Thu, 22 Aug 2019 02:29:05 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id t19sm4383224wmi.29.2019.08.22.02.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 02:29:04 -0700 (PDT)
Date:   Thu, 22 Aug 2019 11:29:03 +0200
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
Message-ID: <20190822092903.GA2276@nanopsycho.orion>
References: <AM0PR05MB4866148ABA3C4E48E73E95FCD1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <AM0PR05MB48668B6221E477A873688CDBD1AB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190820111904.75515f58@x1.home>
 <AM0PR05MB486686D3C311F3C61BE0997DD1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190820222051.7aeafb69@x1.home>
 <AM0PR05MB48664CDF05C3D02F9441440DD1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190820225722.237a57d2@x1.home>
 <AM0PR05MB4866AE8FC4AA3CC24B08B326D1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190820232622.164962d3@x1.home>
 <AM0PR05MB4866437FAA63C447CACCD7E5D1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR05MB4866437FAA63C447CACCD7E5D1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Aug 21, 2019 at 08:23:17AM CEST, parav@mellanox.com wrote:
>
>
>> -----Original Message-----
>> From: Alex Williamson <alex.williamson@redhat.com>
>> Sent: Wednesday, August 21, 2019 10:56 AM
>> To: Parav Pandit <parav@mellanox.com>
>> Cc: Jiri Pirko <jiri@mellanox.com>; David S . Miller <davem@davemloft.net>;
>> Kirti Wankhede <kwankhede@nvidia.com>; Cornelia Huck
>> <cohuck@redhat.com>; kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>> cjia <cjia@nvidia.com>; netdev@vger.kernel.org
>> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>> 
>> > > > > Just an example of the alias, not proposing how it's set.  In
>> > > > > fact, proposing that the user does not set it, mdev-core
>> > > > > provides one
>> > > automatically.
>> > > > >
>> > > > > > > Since there seems to be some prefix overhead, as I ask about
>> > > > > > > above in how many characters we actually have to work with
>> > > > > > > in IFNAMESZ, maybe we start with 8 characters (matching your
>> > > > > > > "index" namespace) and expand as necessary for disambiguation.
>> > > > > > > If we can eliminate overhead in IFNAMESZ, let's start with 12.
>> > > > > > > Thanks,
>> > > > > > >
>> > > > > > If user is going to choose the alias, why does it have to be limited to
>> sha1?
>> > > > > > Or you just told it as an example?
>> > > > > >
>> > > > > > It can be an alpha-numeric string.
>> > > > >
>> > > > > No, I'm proposing a different solution where mdev-core creates
>> > > > > an alias based on an abbreviated sha1.  The user does not provide the
>> alias.
>> > > > >
>> > > > > > Instead of mdev imposing number of characters on the alias, it
>> > > > > > should be best
>> > > > > left to the user.
>> > > > > > Because in future if netdev improves on the naming scheme,
>> > > > > > mdev will be
>> > > > > limiting it, which is not right.
>> > > > > > So not restricting alias size seems right to me.
>> > > > > > User configuring mdev for networking devices in a given kernel
>> > > > > > knows what
>> > > > > user is doing.
>> > > > > > So user can choose alias name size as it finds suitable.
>> > > > >
>> > > > > That's not what I'm proposing, please read again.  Thanks,
>> > > >
>> > > > I understood your point. But mdev doesn't know how user is going
>> > > > to use
>> > > udev/systemd to name the netdev.
>> > > > So even if mdev chose to pick 12 characters, it could result in collision.
>> > > > Hence the proposal to provide the alias by the user, as user know
>> > > > the best
>> > > policy for its use case in the environment its using.
>> > > > So 12 character sha1 method will still work by user.
>> > >
>> > > Haven't you already provided examples where certain drivers or
>> > > subsystems have unique netdev prefixes?  If mdev provides a unique
>> > > alias within the subsystem, couldn't we simply define a netdev
>> > > prefix for the mdev subsystem and avoid all other collisions?  I'm
>> > > not in favor of the user providing both a uuid and an
>> > > alias/instance.  Thanks,
>> > >
>> > For a given prefix, say ens2f0, can two UUID->sha1 first 9 characters have
>> collision?
>> 
>> I think it would be a mistake to waste so many chars on a prefix, but 9
>> characters of sha1 likely wouldn't have a collision before we have 10s of
>> thousands of devices.  Thanks,
>> 
>> Alex
>
>Jiri, Dave,
>Are you ok with it for devlink/netdev part?
>Mdev core will create an alias from a UUID.
>
>This will be supplied during devlink port attr set such as,
>
>devlink_port_attrs_mdev_set(struct devlink_port *port, const char *mdev_alias);
>
>This alias is used to generate representor netdev's phys_port_name.
>This alias from the mdev device's sysfs will be used by the udev/systemd to generate predicable netdev's name.
>Example: enm<mdev_alias_first_12_chars>

What happens in unlikely case of 2 UUIDs collide?


>I took Ethernet mdev as an example.
>New prefix 'm' stands for mediated device.
>Remaining 12 characters are first 12 chars of the mdev alias.

Does this resolve the identification of devlink port representor? I
assume you want to use the same 12(or so) chars, don't you?

