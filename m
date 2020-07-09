Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 289E721AA65
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 00:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgGIWSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 18:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgGIWSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 18:18:04 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E70CC08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 15:18:04 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id w16so3918617ejj.5
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 15:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uXi67HVDuWkVFa4LhfWcOMwk9O5PdTnj3Aohxb+DD7Y=;
        b=RRk/ZefscGMI/BTeorlFbUOu8cxyiAgCh76g5oe9SGAR7WZKBg6dSQ+cDnLSVejFe1
         tc+KAvekOXH2cCuySBnW5K9PlYlObxytSMG2wl/wH/ObUd2aq1ztXn6EY8H8flT2iSkM
         3Fz4MWwCYBjEUB1JHOlZYc7VNdNbC5l4aYLmCE7z0BJ9moUT31nXDAN6mxoaJwtNCD/y
         1A4JKaYGttmRxmB/04U3nbPtY4W7pLyIsf2QbRtKLDALzt9lUneyCL3UWA+XeQtbwAuo
         QeCKWyONSXkmQe8pQGJ6emk+zITPp3e+ytCNlEdWCfLd91VfSl/xOGvWA3KVsAbqG6GL
         L/Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uXi67HVDuWkVFa4LhfWcOMwk9O5PdTnj3Aohxb+DD7Y=;
        b=pTttlmqKb/ykyGXYRU2fBoKKJhzG5E2sFqWYhwdaVVy6tF7hVhofMv4/e4/lUkg5d6
         GNIQ4vFocd82MC6fqs/LVXlzqwfFAnSGoVWXfmyTFWftuu9w1nACKk+fT+9V/lzcAfqY
         gEqQjQCZ2aerAkwDT2/4QxQUs3pbdakqMX1o+G0yQkb1lU0K1EB+8FvEWj3SYw0ZlOFN
         R7cpBZBppgZo/nH5/ABly5t2xSjorooTwLSFkodeETYqOUHxY8hioetSUdXiLAXeb2KP
         7x7g2Q2MaMKk7LidjNyMjuVmGbMOulhpRU1mPH8Eg3UOn0Jjoaf7UfOVQkKg2g8Rmko8
         2ZUg==
X-Gm-Message-State: AOAM533++xLdNahg8VkVLimazjPq7dHpohG+jbUp1uOlc6VtAJspfGSx
        egHuSAQpHzAhN3ZNRw7qeSU=
X-Google-Smtp-Source: ABdhPJxNQAnYa/2M1w8OxyI8eRmAUgzYyJbFyQqrkMUW240HKG8/u8rO5JiEeXkGt8iEeoG/HTEcbA==
X-Received: by 2002:a17:906:53d4:: with SMTP id p20mr57565061ejo.472.1594333083124;
        Thu, 09 Jul 2020 15:18:03 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id v3sm2992197edj.89.2020.07.09.15.18.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 15:18:02 -0700 (PDT)
Date:   Fri, 10 Jul 2020 01:18:00 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: MDIO Debug Interface
Message-ID: <20200709221800.yqnvepm3p57gfxym@skbuf>
References: <C42DZQLTPHM5.2THDSRK84BI3T@wkz-x280>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C42DZQLTPHM5.2THDSRK84BI3T@wkz-x280>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tobias,

On Thu, Jul 09, 2020 at 10:47:54PM +0200, Tobias Waldekranz wrote:
> Hi netdev,
> 
> TL;DR: Is something like https://github.com/wkz/mdio-tools a good
> idea?
> 
> The kernel does not, as far as I know, have a low-level debug
> interface to MDIO devices. I.e. something equivalent to i2c-dev or
> spi-dev for example. The closest thing I've found are the
> SIOCG/SMIIREG ioctls, but they have several drawbacks:
> 
> 1. "Write register" is not always exactly that. The kernel will try to
>    be extra helpful and do things behind the scenes if it detects a
>    write to the reset bit of a PHY for example.
> 
> 2. Only one op per syscall. This means that is impossible to implement
>    many operations in a safe manner. Something as simple as a
>    read/mask/write cycle can race against an in-kernel driver.
> 
> 3. Addressing is awkward since you don't address the MDIO bus
>    directly, rather "the MDIO bus to which this netdev's PHY is
>    connected". This makes it hard to talk to devices on buses to which
>    no PHYs are connected, the typical case being Ethernet switches.
> 
> The kernel side of mdio-tools, mdio-netlink, tries to address these
> problems by adding a GENL interface with which a user can interact
> with an MDIO bus directly.
> 
> The user sends a program that the mdio-netlink module executes,
> possibly emitting data back to the user. I.e. it implements a very
> simple VM. Read/mask/write operations could be implemented by
> dedicated commands, but when you start looking at more advanced things
> like reading out the VLAN database of a switch you need to state and
> branching.
> 
> FAQ:
> 
> - A VM just for MDIO, that seems ridiculous, no?
> 
>   It does. But if you want to support the complex kinds of operations
>   that I'm looking for, without the kernel module having to be aware
>   of every kind of MDIO device in the world, I haven't found an easier
>   way.
> 
> - Why not use BPF?
> 
>   That could absolutely be one way forward, but the GENL approach was
>   easy to build out-of-tree to prove the idea. Its not obvious how it
>   would work though as BPF programs typically run async on some event
>   (probe hit, packet received etc.) whereas this is a single execution
>   on behalf of a user. So to what would the program be attached? The
>   output path is also not straight forward, but it could be done with
>   perf events i suppose.
> 
> My question is thus; do you think mdio-netlink, or something like it,
> is a candidate for mainline?
> 
> Thank you

I will let the PHY library maintainers comment about implementation
design choices made by mdio-netlink. However, I want to add a big "+1"
from my side for identifying the correct issues in the existing PHY
ioctls and doing something about it. I think the mainline kernel needs
this.
Please be aware that, if your mdio-netlink module, or something
equivalent to it, lands in mainline, QEMU/KVM is going to be one of its
users (for virtualizing an MDIO bus). So this is going to be more than
just for debugging.
And, while we're at it: context switches from a VM to a host are
expensive. And the PHY library polls around 5 MDIO registers per PHY
every second. It would be nice if your mdio-netlink module had some sort
of concept of "poll offload": just do the polling in the kernel side and
notify the user space only of a change.

Thanks,
-Vladimir
