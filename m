Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8468E307108
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 09:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhA1IP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 03:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbhA1IPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 03:15:18 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC630C06174A
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 00:14:37 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id m1so554502wml.2
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 00:14:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ac93zZlUCHX7Z4vtPpMw3ZX3VPi+K7AAkY8pNfBVGLY=;
        b=nzjx/aevRf9XSVzj/KVBNRf5CVrd0iHOfdQSxu3uaaDy4J2vSzvRCICkJo2b3ozOhr
         3Llf7LEQM7p5WOrUKJTaZUu3XwZ7z5KEnb14LwXI6r89swMcKf9BZ4f/Uaar3vbM9Aye
         t/PwxYbPS0w9L0vw+IxX72ddYxE88c+FCmUqgfSfgG83DPPSJY1JXKOi6IAkiRYJG2bt
         HbofuU+vqO3A6e5r6YkVUlH/KPwGYExX9spckc87B3HRV3DQg7nqZdChrNqIk9wJlfhk
         sfo+Eam6sHNerkvomyhMHMOMI+2jWR2oDxf6rVXcjtVDJoNNkSOjRdHGgUX+3BXRCiGn
         dVoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ac93zZlUCHX7Z4vtPpMw3ZX3VPi+K7AAkY8pNfBVGLY=;
        b=mVhhXMekIScrQZKWJh79XPvzOIWaKha+ximuZc3FZHAaSGnP8N80gqFjgKN9/Fs/wC
         N7/giiHoiixsCUbEP60YNI5UxezY85U6ceEWRjB3/gDrMtjP/lVee6Nb5zwDZTTkfv78
         2Opz9HvtedFUGAUViSBE56/kZT9pmzVyg4nKP0+r/wSqorhS4RGlA1FYaRdRWdiIzyiW
         2a3HPN8N+/j0Fj10gTeexDbKUtX1vPeoODlx/zrnzd1ZEvSbQKof12pvn52MfTpiTZtg
         q6B6pCBazRVRts0Yw13sWDhjF6zrx7G0TUItipKk/2gT2x+bTjGZcCGtu87Dmcr3wwBU
         E87A==
X-Gm-Message-State: AOAM530wqr8+248uMfEgD/R7UQDRETGe7tM6dOb/TFZY0AMgKzDavpmP
        NeiVRMTDGcfJ5EitbNn0kU0aqx1zkNEXeR6ey/U=
X-Google-Smtp-Source: ABdhPJwaxrHjjv+M+VyimXxROXnQwqe+VMoZLefetA1p9WWHq8GsE8nm49a6ttsNTq3kgkYkEicfPg==
X-Received: by 2002:a7b:c7c8:: with SMTP id z8mr7467264wmk.72.1611821676536;
        Thu, 28 Jan 2021 00:14:36 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id l84sm5215188wmf.17.2021.01.28.00.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 00:14:35 -0800 (PST)
Date:   Thu, 28 Jan 2021 09:14:34 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, davem@davemloft.net,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com,
        vadimp@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210128081434.GV3565223@nanopsycho.orion>
References: <YAg2ngUQIty8U36l@lunn.ch>
 <20210120154158.206b8752@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210121153224.GE3565223@nanopsycho.orion>
 <971e9eff-0b71-8ff9-d72c-aebe73cab599@gmail.com>
 <20210122072814.GG3565223@nanopsycho.orion>
 <YArdeNwXb9v55o/Z@lunn.ch>
 <20210126113326.GO3565223@nanopsycho.orion>
 <YBAfeESYudCENZ2e@lunn.ch>
 <20210127075753.GP3565223@nanopsycho.orion>
 <YBF1SmecdzLOgSIl@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBF1SmecdzLOgSIl@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 27, 2021 at 03:14:34PM CET, andrew@lunn.ch wrote:
>> >There are Linux standard APIs for controlling the power to devices,
>> >the regulator API. So i assume mlxreg-pm will make use of that. There
>> >are also standard APIs for thermal management, which again, mlxreg-pm
>> >should be using. The regulator API allows you to find regulators by
>> >name. So just define a sensible naming convention, and the switch
>> >driver can lookup the regulator, and turn it on/off as needed.
>> 
>> 
>> I don't think it would apply. The thing is, i2c driver has a channel to
>> the linecard eeprom, from where it can read info about the linecard. The
>> i2c driver also knows when the linecard is plugged in, unlike mlxsw.
>> It acts as a standalone driver. Mlxsw has no way to directly find if the
>> card was plugged in (unpowered) and which type it is.
>> 
>> Not sure how to "embed" it. I don't think any existing API could help.
>> Basicall mlxsw would have to register a callback to the i2c driver
>> called every time card is inserted to do auto-provision.
>> Now consider a case when there are multiple instances of the ASIC on the
>> system. How to assemble a relationship between mlxsw instance and i2c
>> driver instance?
>
>You have that knowledge already, otherwise you cannot solve this

No I don't have it. I'm not sure why do you say so. The mlxsw and i2c
driver act independently.


>problem at all. The switch is an PCIe device right? So when the bus is
>enumerated, the driver loads. How do you bind the i2c driver to the
>i2c bus? You cannot enumerate i2c, so you must have some hard coded
>knowledge somewhere? You just need to get that knowledge into the
>mlxsw driver so it can bind its internal i2c client driver to the i2c

There is no internal i2c client driver for this.


>bus. That way you avoid user space, i guess maybe udev rules, or some
>daemon monitoring propriety /sys files?
>
>> But again, auto-provision is only one usecase. Manual provisioning is
>> needed anyway. And that is exactly what my patchset is aiming to
>> introduce. Auto-provision can be added when/if needed later on.
>
>I still don't actually get this use case. Why would i want to manually
>provision?

Because user might want to see the system with all netdevices, configure
them, change the linecard if they got broken and all config, like
bridge, tc, etc will stay on the netdevices. Again, this is the same we
do for split port. This is important requirement, user don't want to see
netdevices come and go when he is plugging/unplugging cables. Linecards
are the same in this matter. Basically is is a "splitter module",
replacing the "splitter cable"


>
>	Andrew
