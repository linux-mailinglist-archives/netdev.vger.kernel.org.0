Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E763220CA
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 21:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbhBVUZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 15:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbhBVUZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 15:25:50 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6974C061574
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 12:25:09 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id r17so4992766ejy.13
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 12:25:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Yadl5yKlSzqROfXwE2OwoRo8+nA1jpozacnCMy+l1YA=;
        b=UEuHzds9SspWehUzMxx3NUUzi8x2B65z6OiTdY5cRxwm4AzjImQKGSTCF7cDklsZdv
         n2nuuQ6SsYJ2+gkzdKDuE8c/E0tU0TEvuK76nHQ0pjpRe/K8IzTDFRwOfusLs/goGWZc
         jr3qNR+SPq0OBJA/APimB2vRnnY46uNs2ly3+I/RDwCYMQ1WtifzHiilnwoasI6DSNmi
         J7iXqZ52nWjzDuOwp5qA9hsxKtIz9KdqlmShwyt5138qQJHs1m/jhOG2qx2FcYTDs15Y
         Vd8gWjeQRkiRGU5MVB0vee0EbvATO6XtuteYQUvqGwIvm4GNkZGoQ8Goo+/ofcJ0YgOL
         +Xrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yadl5yKlSzqROfXwE2OwoRo8+nA1jpozacnCMy+l1YA=;
        b=I1XBDZS5zWnKYwBaRNkrQPde1W5DE+OfRr+tKJg3KvP9ioaeD9u7Zlg1dqAj/8d59p
         QuTkyYCDfyKnYz6sXpcwDSsQCzeunQdn5G6ND0YcAEEwdqTj9TTJ3hoP4767IhqidRMj
         aYTeo0om3KpDZizbVR20TuMQIPXZ5DDDWCvemQakUflXWb7fYiOGmFRBkua3a8zxJe83
         C/2lG10VoTHfpBeRgPhUzy/aHoXEKYDdRzN5Via3pRKPQ+41zTzwnhP267XjKqkxEft2
         i+7l6USG08TVeOUYh/HWMREyQYiUaWvRHfwj2lnyYxA3QtiANAFci58VuNRDaXWpsr2w
         f8Dw==
X-Gm-Message-State: AOAM531+LeENjFiO4yQe9PeR4IPMK+x1OzrTA/7FqE90Ui2pwyx4BCgP
        2KCRZsYLT+1n7thjRAPvwhg=
X-Google-Smtp-Source: ABdhPJz3nPiEP1dUKBTUGJgtl4JS7tIujFUHXZDOav4BIkxex9aTPMWw0W7TE2b26nJGDrzyPe3vHQ==
X-Received: by 2002:a17:906:71c7:: with SMTP id i7mr14734100ejk.401.1614025508547;
        Mon, 22 Feb 2021 12:25:08 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id ke26sm9064990ejc.69.2021.02.22.12.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 12:25:08 -0800 (PST)
Date:   Mon, 22 Feb 2021 22:25:06 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH net-next 09/12] Documentation: networking: dsa: add
 paragraph for the MRP offload
Message-ID: <20210222202506.27qp2ltdkgmqgmec@skbuf>
References: <20210221213355.1241450-1-olteanv@gmail.com>
 <20210221213355.1241450-10-olteanv@gmail.com>
 <20210222194626.srj7wwafyzfc355t@soft-dev3.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222194626.srj7wwafyzfc355t@soft-dev3.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Horatiu,

On Mon, Feb 22, 2021 at 08:46:26PM +0100, Horatiu Vultur wrote:
> > - Why does ocelot support a single MRP ring if all it does is trap the
> >   MRP PDUs to the CPU? What is stopping it from supporting more than
> >   one ring?
>
> So the HW can support to run multiple rings. But to have an initial
> basic implementation I have decided to support only one ring. So
> basically is just a limitation in the driver.

What should change in the current sw_backup implementation such that
multiple rings are supported?

> > - Why is listening for SWITCHDEV_OBJ_ID_MRP necessary at all, since it
> >   does nothing related to hardware configuration?
>
> It is listening because it needs to know which ports are part of the
> ring. In case you have multiple rings and do forwarding in HW you need
> to know which ports are part of which ring. Also in case a MRP frame
> will come on a port which is not part of the ring then that frame should
> be flooded.

If I understand correctly, you just said below that this is not
applicable to the current implementation because it is simplistic enough
that it doesn't care what ring role does the application use, because it
doesn't attempt to do any forwarding of MRP PDUs at all. If all that
there is to do for a port with sw_backup is to add a trapping rule per
port (rule which is already added per port), then what extra logic is
there to add for the second MRP instance on a different set of 2 ports?

> > - Why is ocelot_mrp_del_vcap called from both ocelot_mrp_del and from
> >   ocelot_mrp_del_ring_role?
>
> To clean after itself. Lets say a user creates a node and sets it up.
> Then when she decides to delete the node, what should happen? Should it
> first disable the node and then do the cleaning or just do the cleaning?
> This userspace application[1] does the second option but I didn't want
> to implement the driver to be specific to this application so I have put
> the call in both places.

I was actually thinking that the bridge could clean up after itself and
delete the SWITCHDEV_OBJ_ID_RING_ROLE_MRP object.

> > - Why does ocelot not look at the MRM/MRC ring role at all, and it traps
> >   all MRP PDUs to the CPU, even those which it could forward as an MRC?
> >   I understood from your commit d8ea7ff3995e ("net: mscc: ocelot: Add
> >   support for MRP") description that the hardware should be able of
> >   forwarding the Test PDUs as a client, however it is obviously not
> >   doing that.
>
> It doesn't look at the role because it doesn't care. Because in both
> cases is looking at the sw_backup because it doesn't support any role
> completely. Maybe comment was misleading but I have put it under
> 'current limitations' meaning that the HW can do that but the driver
> doesn't take advantage of that yet. The same applies to multiple rings
> support.
>
> The idea is to remove these limitations in the next patches and
> to be able to remove these limitations then the driver will look also
> at the role.
>
> [1] https://github.com/microchip-ung/mrp

By the way, how can Ocelot trap some PDUs to the CPU but forward others?
Doesn't it need to parse the MRP TLVs in order to determine whether they
are Test packets or something else?
