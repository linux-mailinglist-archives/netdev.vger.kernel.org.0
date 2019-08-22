Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24BEF99024
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 12:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731592AbfHVJ61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 05:58:27 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34751 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbfHVJ61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 05:58:27 -0400
Received: by mail-wm1-f65.google.com with SMTP id e8so6725290wme.1
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 02:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=89qp1j0vG8r7k9LWPHrfwOqB56CK9Kz52Ma6ELu+ntU=;
        b=XeejMVuQKifR+vB/IZdxnHUkXo8g/G6JmX1i5sxmn1oCBRRXQ5zR8j7dET2tONljf2
         1AVDVasWSHplYDamp//Eaz9BsQ19s2YPYVSX+oCmdL7uDlWJYrOAL7HPpCyLVU0eq8Ga
         ZWougP/kRhXIXnG7ID7LCMr96F4w5/Uk6XzEwukNcyNn1b2VkTpXRliyxAY0ufyKU2Y7
         ieDeUuqcbMlzU5I3YJ34rXFCT7RTXFtPc8Tv3XKjdCzgwX2EH4umdPj7AfNFygH4E+v0
         +MDWYB81Y2Z5bUfyfoYUui0Pw0wAgI6NN3lBdnT9j/UdGIgKjAYqgkPX/soue3NKmDIw
         GODg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=89qp1j0vG8r7k9LWPHrfwOqB56CK9Kz52Ma6ELu+ntU=;
        b=HfAK37n3iLx/kBcbEHYe6ihend12lSqRT5948OnsBoNZNLm6wlpgtkLbZ9vzONGO1Z
         PvIj53e7rAHPbrFG7JroRbzW/GLPleeEeYu0XE3y9DHyx7nrV5D9f7o5sMHAx1N3Fiv2
         FmMXtKX9NRcJfREyoftEPGmBXMS7bUYIvFpxIGQpRUdSkRZAnokZ4qDeZApIO7NcR/2q
         eUMYoo8sbnBOJ2aHSt1yWH5v/aRENtEiKeTiF6k3ginqHuDj0GSCU8o+fnkxY0gKrOCc
         MR0viUXKuLym/Gm8l/PQN9IBebqGAvbM657XLJwyVqA9MgLvqWxFqqEe5shXoAsGy3qZ
         ZwmQ==
X-Gm-Message-State: APjAAAV6DASCdtfw+ZYJGTFSrjaFXVsTQru9QHo4HVpE5+9TanirzASP
        lHM3opSGxyCxF/CLRAel6loEhg==
X-Google-Smtp-Source: APXvYqxdfWddTv+LwRyjWDMFciHMlomJRHxzOtJdA19Ptodrcj/WstW54OBl74diZxiCFIhujwLPuQ==
X-Received: by 2002:a7b:cbc6:: with SMTP id n6mr5524779wmi.6.1566467904865;
        Thu, 22 Aug 2019 02:58:24 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id i5sm27234820wrn.48.2019.08.22.02.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 02:58:24 -0700 (PDT)
Date:   Thu, 22 Aug 2019 11:58:23 +0200
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
Message-ID: <20190822095823.GB2276@nanopsycho.orion>
References: <20190820111904.75515f58@x1.home>
 <AM0PR05MB486686D3C311F3C61BE0997DD1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190820222051.7aeafb69@x1.home>
 <AM0PR05MB48664CDF05C3D02F9441440DD1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190820225722.237a57d2@x1.home>
 <AM0PR05MB4866AE8FC4AA3CC24B08B326D1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190820232622.164962d3@x1.home>
 <AM0PR05MB4866437FAA63C447CACCD7E5D1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190822092903.GA2276@nanopsycho.orion>
 <AM0PR05MB4866A20F831A5D42E6C79EFED1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR05MB4866A20F831A5D42E6C79EFED1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Aug 22, 2019 at 11:42:13AM CEST, parav@mellanox.com wrote:
>
>
>> -----Original Message-----
>> From: Jiri Pirko <jiri@resnulli.us>
>> Sent: Thursday, August 22, 2019 2:59 PM
>> To: Parav Pandit <parav@mellanox.com>
>> Cc: Alex Williamson <alex.williamson@redhat.com>; Jiri Pirko
>> <jiri@mellanox.com>; David S . Miller <davem@davemloft.net>; Kirti
>> Wankhede <kwankhede@nvidia.com>; Cornelia Huck <cohuck@redhat.com>;
>> kvm@vger.kernel.org; linux-kernel@vger.kernel.org; cjia <cjia@nvidia.com>;
>> netdev@vger.kernel.org
>> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>> 
>> Wed, Aug 21, 2019 at 08:23:17AM CEST, parav@mellanox.com wrote:
>> >
>> >
>> >> -----Original Message-----
>> >> From: Alex Williamson <alex.williamson@redhat.com>
>> >> Sent: Wednesday, August 21, 2019 10:56 AM
>> >> To: Parav Pandit <parav@mellanox.com>
>> >> Cc: Jiri Pirko <jiri@mellanox.com>; David S . Miller
>> >> <davem@davemloft.net>; Kirti Wankhede <kwankhede@nvidia.com>;
>> >> Cornelia Huck <cohuck@redhat.com>; kvm@vger.kernel.org;
>> >> linux-kernel@vger.kernel.org; cjia <cjia@nvidia.com>;
>> >> netdev@vger.kernel.org
>> >> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>> >>
>> >> > > > > Just an example of the alias, not proposing how it's set.  In
>> >> > > > > fact, proposing that the user does not set it, mdev-core
>> >> > > > > provides one
>> >> > > automatically.
>> >> > > > >
>> >> > > > > > > Since there seems to be some prefix overhead, as I ask
>> >> > > > > > > about above in how many characters we actually have to
>> >> > > > > > > work with in IFNAMESZ, maybe we start with 8 characters
>> >> > > > > > > (matching your "index" namespace) and expand as necessary for
>> disambiguation.
>> >> > > > > > > If we can eliminate overhead in IFNAMESZ, let's start with 12.
>> >> > > > > > > Thanks,
>> >> > > > > > >
>> >> > > > > > If user is going to choose the alias, why does it have to
>> >> > > > > > be limited to
>> >> sha1?
>> >> > > > > > Or you just told it as an example?
>> >> > > > > >
>> >> > > > > > It can be an alpha-numeric string.
>> >> > > > >
>> >> > > > > No, I'm proposing a different solution where mdev-core
>> >> > > > > creates an alias based on an abbreviated sha1.  The user does
>> >> > > > > not provide the
>> >> alias.
>> >> > > > >
>> >> > > > > > Instead of mdev imposing number of characters on the alias,
>> >> > > > > > it should be best
>> >> > > > > left to the user.
>> >> > > > > > Because in future if netdev improves on the naming scheme,
>> >> > > > > > mdev will be
>> >> > > > > limiting it, which is not right.
>> >> > > > > > So not restricting alias size seems right to me.
>> >> > > > > > User configuring mdev for networking devices in a given
>> >> > > > > > kernel knows what
>> >> > > > > user is doing.
>> >> > > > > > So user can choose alias name size as it finds suitable.
>> >> > > > >
>> >> > > > > That's not what I'm proposing, please read again.  Thanks,
>> >> > > >
>> >> > > > I understood your point. But mdev doesn't know how user is
>> >> > > > going to use
>> >> > > udev/systemd to name the netdev.
>> >> > > > So even if mdev chose to pick 12 characters, it could result in collision.
>> >> > > > Hence the proposal to provide the alias by the user, as user
>> >> > > > know the best
>> >> > > policy for its use case in the environment its using.
>> >> > > > So 12 character sha1 method will still work by user.
>> >> > >
>> >> > > Haven't you already provided examples where certain drivers or
>> >> > > subsystems have unique netdev prefixes?  If mdev provides a
>> >> > > unique alias within the subsystem, couldn't we simply define a
>> >> > > netdev prefix for the mdev subsystem and avoid all other
>> >> > > collisions?  I'm not in favor of the user providing both a uuid
>> >> > > and an alias/instance.  Thanks,
>> >> > >
>> >> > For a given prefix, say ens2f0, can two UUID->sha1 first 9
>> >> > characters have
>> >> collision?
>> >>
>> >> I think it would be a mistake to waste so many chars on a prefix, but
>> >> 9 characters of sha1 likely wouldn't have a collision before we have
>> >> 10s of thousands of devices.  Thanks,
>> >>
>> >> Alex
>> >
>> >Jiri, Dave,
>> >Are you ok with it for devlink/netdev part?
>> >Mdev core will create an alias from a UUID.
>> >
>> >This will be supplied during devlink port attr set such as,
>> >
>> >devlink_port_attrs_mdev_set(struct devlink_port *port, const char
>> >*mdev_alias);
>> >
>> >This alias is used to generate representor netdev's phys_port_name.
>> >This alias from the mdev device's sysfs will be used by the udev/systemd to
>> generate predicable netdev's name.
>> >Example: enm<mdev_alias_first_12_chars>
>> 
>> What happens in unlikely case of 2 UUIDs collide?
>> 
>Since users sees two devices with same phys_port_name, user should destroy recently created mdev and recreate mdev with different UUID?

Driver should make sure phys port name wont collide, in this case that
it does not provide 2 same attrs for 2 different ports.
Hmm, so the order of creation matters. That is not good.

>> 
>> >I took Ethernet mdev as an example.
>> >New prefix 'm' stands for mediated device.
>> >Remaining 12 characters are first 12 chars of the mdev alias.
>> 
>> Does this resolve the identification of devlink port representor? 
>Not sure if I understood your question correctly, attemping to answer below.
>phys_port_name of devlink port is defined by the first 12 characters of mdev alias.
>> I assume you want to use the same 12(or so) chars, don't you?
>Mdev's netdev will also use the same mdev alias from the sysfs to rename netdev name from ethX to enm<mdev_alias>, where en=Etherenet, m=mdev.
>
>So yes, same 12 characters are use for mdev's netdev and mdev devlink port's phys_port_name.
>
>Is that what are you asking?

Yes. Then you have 3 chars to handle the rest of the name (pci, pf)...
