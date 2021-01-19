Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2043F2FB8DC
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 15:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395009AbhASNzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 08:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392006AbhASL4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 06:56:53 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDBCC061574
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 03:56:12 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id 6so12170527wri.3
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 03:56:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dTev6Jut5EwvEBVedaHAvH07h4moUecc8bEA4soj/18=;
        b=fOFWuQZF0kwzB33sDtQac/bfxEOE+0OG1lMF0pAICw7eIPTjjh7U9srRQlaI81ueQM
         9abby61/Bzcx/dtsshvPjggPLJTlLGsZOEBj5QGA7KY03wB67JvLgQCuYV0V6/CwFpD5
         4dhgbpi0Jvd49ud1T/ZaUFo4GF2k/eSwhoB5DkjvHCA+8dFkJ4sZ4bnRXIjYnr9F37fU
         ttBLcWkHYVisTuLcszcnNwfFBHZseU70UB27zSzHSMrpIp2ZN/CygzmKdo1dVnQt2epN
         WuJbqoHfXIBRFTPlMBtEan9wGRvtSvZnyd5Y6TmlkuS/QbNCv6ZlxJWRINSebYqvXx4T
         Q6sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dTev6Jut5EwvEBVedaHAvH07h4moUecc8bEA4soj/18=;
        b=MHZWCbd0ilCmVmRb3JPA8KMb01ZbEy6yDXUBNyBW3DsDuc0gklrGHbZqXe8Yktd0dk
         iTXHvlrWyJvJf9Go1N79PV4eI/ql/EuaYqX1FImwWa2vy3dAOSlYDjH9K2fGgHV6jAm6
         WzsgmUVW3U6wNjLqGmlrchtPrk137ody3Edh4sFrbnZ2qQBPEnLY14CtGTDQgRvdt7A1
         2XWXShzzkbxNlR1edE+2ADHZQbr7noPVBS8tUz84Wld2SCWR4ixf1ozr8BYlxM0KGUbc
         OkEMDciq+GCItdYYG/cGFJfhXWoUPcpIFLfNVkI+1uQ43F8+4KBI+CA7YdT4zrLosZbr
         L9fg==
X-Gm-Message-State: AOAM530mizIxSlPPBs8aH8voIXZoXaDHLT5DJZG0hC+FPrx0wSuNr160
        H0PeLZwx1cC8FLRIldyVO6Vn1A==
X-Google-Smtp-Source: ABdhPJzyyqzI7l2Qg0rUVdztlA0cJ5jqgZHZG2L3AT25cGSwnGgE7snGNnkKEY8P8MRVvJmA2rNqrg==
X-Received: by 2002:adf:ef8b:: with SMTP id d11mr4124063wro.156.1611057371172;
        Tue, 19 Jan 2021 03:56:11 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id l12sm4382411wmj.9.2021.01.19.03.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 03:56:10 -0800 (PST)
Date:   Tue, 19 Jan 2021 12:56:10 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210119115610.GZ3565223@nanopsycho.orion>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <X/+nVtRrC2lconET@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/+nVtRrC2lconET@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 14, 2021 at 03:07:18AM CET, andrew@lunn.ch wrote:
>> $ devlink lc provision netdevsim/netdevsim10 lc 0 type card4ports
>> $ devlink lc
>> netdevsim/netdevsim10:
>>   lc 0 state provisioned type card4ports
>>     supported_types:
>>        card1port card2ports card4ports
>>   lc 1 state unprovisioned
>>     supported_types:
>>        card1port card2ports card4ports
>
>Hi Jiri
>
>> # Now activate the line card using debugfs. That emulates plug-in event
>> # on real hardware:
>> $ echo "Y"> /sys/kernel/debug/netdevsim/netdevsim10/linecards/0/active
>> $ ip link show eni10nl0p1
>> 165: eni10nl0p1: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
>>     link/ether 7e:2d:05:93:d3:d1 brd ff:ff:ff:ff:ff:ff
>> # The carrier is UP now.
>
>What is missing from the devlink lc view is what line card is actually
>in the slot. Say if i provision for a card4port, but actually insert a
>card2port. It would be nice to have something like:

I checked, our hw does not support that. Only provides info that
linecard activation was/wasn't successful.


>
> $ devlink lc
> netdevsim/netdevsim10:
>   lc 0 state provisioned type card4ports
>     supported_types:
>        card1port card2ports card4ports
>     inserted_type:
>        card2ports;
>   lc 1 state unprovisioned
>     supported_types:
>        card1port card2ports card4ports
>     inserted_type:
>        None
>
>I assume if i prevision for card4ports but actually install a
>card2ports, all the interfaces stay down?
>
>Maybe
>
>> $ echo "Y"> /sys/kernel/debug/netdevsim/netdevsim10/linecards/0/active
>
>should actually be
>    echo "card2ports" > /sys/kernel/debug/netdevsim/netdevsim10/linecards/0/active
>
>so you can emulate somebody putting the wrong card in the slot?
>
>    Andrew
