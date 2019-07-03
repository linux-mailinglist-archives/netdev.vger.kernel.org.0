Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5448E5E6CC
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 16:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfGCOd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 10:33:59 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36120 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfGCOd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 10:33:59 -0400
Received: by mail-wm1-f66.google.com with SMTP id u8so2667944wmm.1
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 07:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GO/1zqNdNXAtvD/jy5qLG8G7aHQ67FNTnCn9qPOzHx4=;
        b=hdnzjVfuG5rC6ZI1ymDsS+TbHf6ZtKwjC6S0qe5RDPrw/S2KmWO8NnBkM/exGOPm7+
         d21yInLui43DNTvXOUrMqSCv44cVl7qTt8r8T7o7HIM8kkDOz+I77d9SEcCc71fwhuna
         dVlY6EDgezaluh6EIZrl0zH9YAOpXCHhM3ZfmvU4YdWOtA9x/T2vgDhhmfqbYxKmIFdr
         mnVwVFXThqs6ALcG+ZYJNEm7m2P9E7cS5e5EWRSvnI8wgiEI4s4mjIm09xXgZBeOjK+N
         B+EXN7ukGu5UKDPChpPH+O5RjmXeT8hbYeJCsgFOcKFTjsntOYlQ3ODZmIy1oDXIAYu1
         NIxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GO/1zqNdNXAtvD/jy5qLG8G7aHQ67FNTnCn9qPOzHx4=;
        b=kAyD3axazMQHXmfzTaKPcyboZn2HSZgUO5/b6zRa9HrTu9uOx6OqBKTlFDZo+P8bo/
         b9eg2qq+XRzYOiQVsiHGnThJN2OCP6NZFlZE0VrhZprMUl1rfNFjY+QfFWEMky/HP63q
         sZktBnE31vPl0/oDleEK4u/f7djFc1dLck+UeJqf4gpRds0LR5ojFIN5Wzjrucfi8TIc
         VmxaG00HmtBOWqnZ7mmpA+VB0Jjn50Wa9wLRR3YpqS7jo58bIsc1hz9tMcH6EFLOWI/m
         kl+4U+OQIRH1dK84yiLNO6cQcYENDGQ2zQugMrcogBZQQrAdb7pRVOgZ66Z6JSpF8FtT
         pHWw==
X-Gm-Message-State: APjAAAV71cDjozYK9eq70Q7JBS3ZL+KQAVHEFgqHe9ZlPVKgY3xKSv2c
        P9O5QWLSuD2IWecT28XxPFpT1w==
X-Google-Smtp-Source: APXvYqx5CUtpVCGhFdUZ/Htnes7k67veYZQluMWXNJCBmyxc4Mr3lEaTt5RYvBqs6nLS1RTs9V7HBw==
X-Received: by 2002:a1c:6154:: with SMTP id v81mr8158825wmb.92.1562164436084;
        Wed, 03 Jul 2019 07:33:56 -0700 (PDT)
Received: from localhost (ip-213-220-235-213.net.upcbroadband.cz. [213.220.235.213])
        by smtp.gmail.com with ESMTPSA id z126sm3287042wmb.32.2019.07.03.07.33.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 07:33:55 -0700 (PDT)
Date:   Wed, 3 Jul 2019 16:33:54 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour and
 port attribute
Message-ID: <20190703143354.GB2250@nanopsycho>
References: <20190701162650.17854185@cakuba.netronome.com>
 <AM0PR05MB4866085BC8B082EFD5B59DD2D1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190702104711.77618f6a@cakuba.netronome.com>
 <AM0PR05MB4866C19C9E6ED767A44C3064D1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190702164252.6d4fe5e3@cakuba.netronome.com>
 <AM0PR05MB4866F1AF0CF5914B372F0BCCD1FB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190702191536.4de1ac68@cakuba.netronome.com>
 <AM0PR05MB486624D2D9BAD293CD5FB33CD1FB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190703103720.GU2250@nanopsycho>
 <AM0PR05MB4866675A8CB5BDB2890E14BBD1FB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR05MB4866675A8CB5BDB2890E14BBD1FB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 03, 2019 at 03:49:51PM CEST, parav@mellanox.com wrote:
>
>
>> -----Original Message-----
>> From: Jiri Pirko <jiri@resnulli.us>
>> Sent: Wednesday, July 3, 2019 4:07 PM
>> To: Parav Pandit <parav@mellanox.com>
>> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>; Jiri Pirko
>> <jiri@mellanox.com>; netdev@vger.kernel.org; Saeed Mahameed
>> <saeedm@mellanox.com>; vivien.didelot@gmail.com; andrew@lunn.ch;
>> f.fainelli@gmail.com
>> Subject: Re: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour and
>> port attribute
>> 
>> Wed, Jul 03, 2019 at 06:46:13AM CEST, parav@mellanox.com wrote:
>> >
>> >
>> >> -----Original Message-----
>> >> From: Jakub Kicinski <jakub.kicinski@netronome.com>
>> >> Sent: Wednesday, July 3, 2019 7:46 AM
>> >> To: Parav Pandit <parav@mellanox.com>
>> >> Cc: Jiri Pirko <jiri@mellanox.com>; netdev@vger.kernel.org; Saeed
>> >> Mahameed <saeedm@mellanox.com>
>> >> Subject: Re: [PATCH net-next 1/3] devlink: Introduce PCI PF port
>> >> flavour and port attribute
>> >>
>> >> On Wed, 3 Jul 2019 02:08:39 +0000, Parav Pandit wrote:
>> >> > > If you want to expose some device specific eswitch port ID please
>> >> > > add a new attribute for that.
>> >> > > The fact that that ID may match port_number for your device today
>> >> > > is coincidental.  port_number, and split attributes should not be
>> >> > > exposed for PCI ports.
>> >> >
>> >> > So your concern is non mellanox hw has eswitch but there may not be
>> >> > a unique handle to identify a eswitch port?
>> >>
>> >> That's not a concern, no.  Like any debug attribute it should be optional.
>> >>
>> >> > Or that handle may be wider than 32-bit?
>> >>
>> >> 64 bit would probably be better, yes, although that wasn't my initial
>> >> concern.
>> >>
>> >Why 32-bit is not enough?
>> >
>> >> > And instead of treating port_number as handle, there should be
>> >> > different attribute, is that the ask?
>> >>
>> >> Yes, the ask, as always, is to not abuse existing attributes to carry
>> >> tangentially related information.
>> >
>> >Why it is tangential?
>> >Devlink_port has got a port_number. Depending on flavour this port_number
>> represents a port.
>> >If it is floavour=PHYSICAL, its physical port number.
>> >If it is eswitch pf/vf ports, it represents eswitch port.
>> >
>> >Why you see it only as physical_port_number?
>> 
>> The original intention was like that. See the desc of
>> devlink_port_attrs_set():
>> 
>>  *      @port_number: number of the port that is facing user, for example
>>  *                    the front panel port number
>> 
>> For vf/pf representors, this is not applicable and should be indeed avoided.
>> 
>Physical port number is not applicable but this is useful information that completes the eswitch picture.
>Because eswitch has this termination end point anyway.

Use port_index. That is up to the driver to put whatever value there.


>Instead of inventing some new vendor specific field, I see value in using existing port_number field.
>Will wait for others inputs.
>
>> However, we expose it for DEVLINK_PORT_FLAVOUR_CPU and
>> DEVLINK_PORT_FLAVOUR_DSA. Not sure if it makes sense there either.
>> Ccing Florian, Andrew and Vivien.
>> What do you guys think?
>> 
>> Perhaps we should have:
>> 	if (attrs->flavour == DEVLINK_PORT_FLAVOUR_PHYSICAL &&
>> 	    nla_put_u32(msg, DEVLINK_ATTR_PORT_NUMBER, attrs-
>> >port_number))
>>                 return -EMSGSIZE;
>> in devlink_nl_port_attrs_put()
>
