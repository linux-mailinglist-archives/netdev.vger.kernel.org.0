Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD70B99326
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 14:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387484AbfHVMTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 08:19:42 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43992 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732092AbfHVMTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 08:19:41 -0400
Received: by mail-wr1-f66.google.com with SMTP id y8so5191641wrn.10
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 05:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=23esRf+qutJ/4Zjmjr2DsaAEcc0FSRnxzzaj4f2NFxA=;
        b=hJut2qKEkjWlJMyeu6kEMusHO5uh0ABejYZzWvr2BXiCgsjRFTUrTFacrJYZcExTLV
         sOvP/iIp+Vr13p3aJDJBRcvSp0MpCUybvRA6ZdEAmNgp0ZK32Ob9xip9D5MdXqLkr1+x
         9rHe4mK9NNQrh3kYKR2u1St3mWeUnR7NmXYMtGcWhAF3MFJUghzrHCkz9qJNhkxPfl7y
         3V0ooz+UKYBIBgvPpPtUWYa6JdxpGEourKYm5Bn0QFO3CMRpDxTqMz46zDnSOGi5vbqd
         xCVBlQLw3qHQ5EFKGf8cKxWSTPzyxxUxV4CZmOoSyOwmUusjTXM9aSmkAPWs/EqCkLt4
         8tiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=23esRf+qutJ/4Zjmjr2DsaAEcc0FSRnxzzaj4f2NFxA=;
        b=r7xrPXAA7k3LvUFOtaArtppvOBA6n6Kjnx+keU7LC8bd40H5NxvcteymFmwOURZN3/
         TZDSp4XV/qRG21QlenQ5B9qZTqVCaoNt4T9wG1s17wzJYOW0ct1m6Ht2djWX3tRqmM8J
         /CMT53e6I1WtjY9rSHzv0yf2rfhd+HVqrhPEq4rAJAxsoc2xSrixtAoA9LOlUXE2JXIm
         DQfamllxY3tyxIMdF49hMw1XX/5ANWnhYubcWLAqApH/FOiEfGVaSFieXvUrBTYDKl3M
         lh6VUndtQFkR5rX7UVaKk85IwSidxzzsV2Zn/2w2JmgC9RTLKIU1jjAX+BC5SteVKzDA
         Yr4Q==
X-Gm-Message-State: APjAAAXYJkOeCiM2PpxBfHFAXlJd0g+2Nlxnnc30nQRbTDNiClFLn0q6
        nzv5pwj/vBGQL8rbHPZDkImpcQ==
X-Google-Smtp-Source: APXvYqz/DpUn+PnTGTXshmgqhmY60Kw+P7T4S7qlIEEW4/LuqC77g22f4ieCvJdEAJh0fO42JfSnRw==
X-Received: by 2002:adf:e708:: with SMTP id c8mr47467734wrm.25.1566476378070;
        Thu, 22 Aug 2019 05:19:38 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id l14sm38643774wrn.42.2019.08.22.05.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 05:19:37 -0700 (PDT)
Date:   Thu, 22 Aug 2019 14:19:36 +0200
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
Message-ID: <20190822121936.GC2276@nanopsycho.orion>
References: <20190820222051.7aeafb69@x1.home>
 <AM0PR05MB48664CDF05C3D02F9441440DD1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190820225722.237a57d2@x1.home>
 <AM0PR05MB4866AE8FC4AA3CC24B08B326D1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190820232622.164962d3@x1.home>
 <AM0PR05MB4866437FAA63C447CACCD7E5D1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190822092903.GA2276@nanopsycho.orion>
 <AM0PR05MB4866A20F831A5D42E6C79EFED1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190822095823.GB2276@nanopsycho.orion>
 <AM0PR05MB4866144FD76C302D04DA04B9D1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR05MB4866144FD76C302D04DA04B9D1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Aug 22, 2019 at 12:04:02PM CEST, parav@mellanox.com wrote:
>
>
>> -----Original Message-----
>> From: Jiri Pirko <jiri@resnulli.us>
>> Sent: Thursday, August 22, 2019 3:28 PM
>> To: Parav Pandit <parav@mellanox.com>
>> Cc: Alex Williamson <alex.williamson@redhat.com>; Jiri Pirko
>> <jiri@mellanox.com>; David S . Miller <davem@davemloft.net>; Kirti
>> Wankhede <kwankhede@nvidia.com>; Cornelia Huck <cohuck@redhat.com>;
>> kvm@vger.kernel.org; linux-kernel@vger.kernel.org; cjia <cjia@nvidia.com>;
>> netdev@vger.kernel.org
>> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>> 
>> Thu, Aug 22, 2019 at 11:42:13AM CEST, parav@mellanox.com wrote:
>> >
>> >
>> >> -----Original Message-----
>> >> From: Jiri Pirko <jiri@resnulli.us>
>> >> Sent: Thursday, August 22, 2019 2:59 PM
>> >> To: Parav Pandit <parav@mellanox.com>
>> >> Cc: Alex Williamson <alex.williamson@redhat.com>; Jiri Pirko
>> >> <jiri@mellanox.com>; David S . Miller <davem@davemloft.net>; Kirti
>> >> Wankhede <kwankhede@nvidia.com>; Cornelia Huck
>> <cohuck@redhat.com>;
>> >> kvm@vger.kernel.org; linux-kernel@vger.kernel.org; cjia
>> >> <cjia@nvidia.com>; netdev@vger.kernel.org
>> >> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>> >>
>> >> Wed, Aug 21, 2019 at 08:23:17AM CEST, parav@mellanox.com wrote:
>> >> >
>> >> >
>> >> >> -----Original Message-----
>> >> >> From: Alex Williamson <alex.williamson@redhat.com>
>> >> >> Sent: Wednesday, August 21, 2019 10:56 AM
>> >> >> To: Parav Pandit <parav@mellanox.com>
>> >> >> Cc: Jiri Pirko <jiri@mellanox.com>; David S . Miller
>> >> >> <davem@davemloft.net>; Kirti Wankhede <kwankhede@nvidia.com>;
>> >> >> Cornelia Huck <cohuck@redhat.com>; kvm@vger.kernel.org;
>> >> >> linux-kernel@vger.kernel.org; cjia <cjia@nvidia.com>;
>> >> >> netdev@vger.kernel.org
>> >> >> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>> >> >>
>> >> >> > > > > Just an example of the alias, not proposing how it's set.
>> >> >> > > > > In fact, proposing that the user does not set it,
>> >> >> > > > > mdev-core provides one
>> >> >> > > automatically.
>> >> >> > > > >
>> >> >> > > > > > > Since there seems to be some prefix overhead, as I ask
>> >> >> > > > > > > about above in how many characters we actually have to
>> >> >> > > > > > > work with in IFNAMESZ, maybe we start with 8
>> >> >> > > > > > > characters (matching your "index" namespace) and
>> >> >> > > > > > > expand as necessary for
>> >> disambiguation.
>> >> >> > > > > > > If we can eliminate overhead in IFNAMESZ, let's start with 12.
>> >> >> > > > > > > Thanks,
>> >> >> > > > > > >
>> >> >> > > > > > If user is going to choose the alias, why does it have
>> >> >> > > > > > to be limited to
>> >> >> sha1?
>> >> >> > > > > > Or you just told it as an example?
>> >> >> > > > > >
>> >> >> > > > > > It can be an alpha-numeric string.
>> >> >> > > > >
>> >> >> > > > > No, I'm proposing a different solution where mdev-core
>> >> >> > > > > creates an alias based on an abbreviated sha1.  The user
>> >> >> > > > > does not provide the
>> >> >> alias.
>> >> >> > > > >
>> >> >> > > > > > Instead of mdev imposing number of characters on the
>> >> >> > > > > > alias, it should be best
>> >> >> > > > > left to the user.
>> >> >> > > > > > Because in future if netdev improves on the naming
>> >> >> > > > > > scheme, mdev will be
>> >> >> > > > > limiting it, which is not right.
>> >> >> > > > > > So not restricting alias size seems right to me.
>> >> >> > > > > > User configuring mdev for networking devices in a given
>> >> >> > > > > > kernel knows what
>> >> >> > > > > user is doing.
>> >> >> > > > > > So user can choose alias name size as it finds suitable.
>> >> >> > > > >
>> >> >> > > > > That's not what I'm proposing, please read again.  Thanks,
>> >> >> > > >
>> >> >> > > > I understood your point. But mdev doesn't know how user is
>> >> >> > > > going to use
>> >> >> > > udev/systemd to name the netdev.
>> >> >> > > > So even if mdev chose to pick 12 characters, it could result in
>> collision.
>> >> >> > > > Hence the proposal to provide the alias by the user, as user
>> >> >> > > > know the best
>> >> >> > > policy for its use case in the environment its using.
>> >> >> > > > So 12 character sha1 method will still work by user.
>> >> >> > >
>> >> >> > > Haven't you already provided examples where certain drivers or
>> >> >> > > subsystems have unique netdev prefixes?  If mdev provides a
>> >> >> > > unique alias within the subsystem, couldn't we simply define a
>> >> >> > > netdev prefix for the mdev subsystem and avoid all other
>> >> >> > > collisions?  I'm not in favor of the user providing both a
>> >> >> > > uuid and an alias/instance.  Thanks,
>> >> >> > >
>> >> >> > For a given prefix, say ens2f0, can two UUID->sha1 first 9
>> >> >> > characters have
>> >> >> collision?
>> >> >>
>> >> >> I think it would be a mistake to waste so many chars on a prefix,
>> >> >> but
>> >> >> 9 characters of sha1 likely wouldn't have a collision before we
>> >> >> have 10s of thousands of devices.  Thanks,
>> >> >>
>> >> >> Alex
>> >> >
>> >> >Jiri, Dave,
>> >> >Are you ok with it for devlink/netdev part?
>> >> >Mdev core will create an alias from a UUID.
>> >> >
>> >> >This will be supplied during devlink port attr set such as,
>> >> >
>> >> >devlink_port_attrs_mdev_set(struct devlink_port *port, const char
>> >> >*mdev_alias);
>> >> >
>> >> >This alias is used to generate representor netdev's phys_port_name.
>> >> >This alias from the mdev device's sysfs will be used by the
>> >> >udev/systemd to
>> >> generate predicable netdev's name.
>> >> >Example: enm<mdev_alias_first_12_chars>
>> >>
>> >> What happens in unlikely case of 2 UUIDs collide?
>> >>
>> >Since users sees two devices with same phys_port_name, user should destroy
>> recently created mdev and recreate mdev with different UUID?
>> 
>> Driver should make sure phys port name wont collide, 
>So when mdev creation is initiated, mdev core calculates the alias and if there is any other mdev with same alias exist, it returns -EEXIST error before progressing further.
>This way user will get to know upfront in event of collision before the mdev device gets created.
>How about that?

Sounds fine to me. Now the question is how many chars do we want to
have.

>
>
>> in this case that it does
>> not provide 2 same attrs for 2 different ports.
>> Hmm, so the order of creation matters. That is not good.
>> 
>> >>
>> >> >I took Ethernet mdev as an example.
>> >> >New prefix 'm' stands for mediated device.
>> >> >Remaining 12 characters are first 12 chars of the mdev alias.
>> >>
>> >> Does this resolve the identification of devlink port representor?
>> >Not sure if I understood your question correctly, attemping to answer below.
>> >phys_port_name of devlink port is defined by the first 12 characters of mdev
>> alias.
>> >> I assume you want to use the same 12(or so) chars, don't you?
>> >Mdev's netdev will also use the same mdev alias from the sysfs to rename
>> netdev name from ethX to enm<mdev_alias>, where en=Etherenet, m=mdev.
>> >
>> >So yes, same 12 characters are use for mdev's netdev and mdev devlink port's
>> phys_port_name.
>> >
>> >Is that what are you asking?
>> 
>> Yes. Then you have 3 chars to handle the rest of the name (pci, pf)...
