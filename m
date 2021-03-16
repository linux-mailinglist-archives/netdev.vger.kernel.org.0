Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6006C33DC30
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 19:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239858AbhCPSIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 14:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239878AbhCPSHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 14:07:15 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB71C0613EF
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 11:04:59 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id u4so21708863ljo.6
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 11:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=eTJysU/UEa1AzE/n1Pn9B9GEUKy0waLP45c1Zaj0GpQ=;
        b=ghrqbXDQ/HTcwSFVWUfPxtIPYNwHJzBy2HgJkRAvLvcF6WppIzEuYszkIo1ko6bd2S
         of9+YZBZu9AfAX7pIzAKnqk/poLdArawPAtDkAGFo6TUMmEXMx1oiRyTh+3g2veCk2TA
         qiQxFZh3+4EURvLDPCtfW9FMf2wAFGYFi6+OskBZyGKgRtE8Rjwggenv1+ecmTpkLLTO
         gGpIMD3SVZ/tNKpqujBWNifbinXeKUTbyS3qmqQhR6wMgE5fKwk8i9X1pXiTt5RNrcnI
         ZtHXW5ZdO301Y7NCnn8xzUHsFZizZWxPX56tPanyAtxiirqARLHE8ioKCFnJnh9Njgl7
         hRRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=eTJysU/UEa1AzE/n1Pn9B9GEUKy0waLP45c1Zaj0GpQ=;
        b=DckBzXlruTtLOiXBO4bCWmkF5t0jJimlbGUEPOFUGVXBde/DQW125WdyLnw1JphNiJ
         4rXuLPdo0RXBgsBzJosGY5QTGIVRbFT634ardtSHGoYlqzk9YQhZ4o6apEuo5LZPmWbi
         8g/rGlQRg/rpOVnFMNqfcrF3Omvo5XPwczFMeISzIlS8/4XvggRgd6dzZ8/qOcdsJaFW
         OftR3hBomnI7Kw2ZSQ8VmG1ZB7K+uU8J5lbASMGwjVXsvAgSn4LAdjqdYNWF0yOgsbhY
         tNc+9NfkVnRqzkf7ECCwopoXYXv66LnPqRcNGsU41/bBH3HAGMaDxqqzukpkPJETifXS
         JEQg==
X-Gm-Message-State: AOAM533l7hTU+PggEFQtEqG5AAnn0lfsH+rBHKpQct/O5EM+MwbSg9R0
        yI7rCmnsdvb1YoljKxLVNUO8ww==
X-Google-Smtp-Source: ABdhPJxipOoFZbPkkd6QM0t3VLnGydlrA+NMGJ0Us4GMRXcIsOPxpldUvTj85tIRJpD7/r/MQfXhKw==
X-Received: by 2002:a2e:a168:: with SMTP id u8mr3399825ljl.330.1615917897654;
        Tue, 16 Mar 2021 11:04:57 -0700 (PDT)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id z10sm3082584lfe.114.2021.03.16.11.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 11:04:57 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net-next 08/12] Documentation: networking: dsa: add paragraph for the LAG offload
In-Reply-To: <20210316112419.1304230-9-olteanv@gmail.com>
References: <20210316112419.1304230-1-olteanv@gmail.com> <20210316112419.1304230-9-olteanv@gmail.com>
Date:   Tue, 16 Mar 2021 19:04:56 +0100
Message-ID: <875z1rotyv.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 13:24, Vladimir Oltean <olteanv@gmail.com> wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> Add a short summary of the methods that a driver writer must implement
> for offloading a link aggregation group, and what is still missing.
>
> Cc: Tobias Waldekranz <tobias@waldekranz.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>

>  Documentation/networking/dsa/dsa.rst | 33 ++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>
> diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
> index af604fe976b3..e8576e81735c 100644
> --- a/Documentation/networking/dsa/dsa.rst
> +++ b/Documentation/networking/dsa/dsa.rst
> @@ -724,6 +724,39 @@ Bridge VLAN filtering
>    function that the driver has to call for each MAC address known to be behind
>    the given port. A switchdev object is used to carry the VID and MDB info.
>  
> +Link aggregation
> +----------------
> +
> +Link aggregation is implemented in the Linux networking stack by the bonding
> +and team drivers, which are modeled as virtual, stackable network interfaces.
> +DSA is capable of offloading a link aggregation group (LAG) to hardware that
> +supports the feature, and supports bridging between physical ports and LAGs,
> +as well as between LAGs. A bonding/team interface which holds multiple physical
> +ports constitutes a logical port, although DSA has no explicit concept of a
> +logical port at the moment. Due to this, events where a LAG joins/leaves a
> +bridge are treated as if all individual physical ports that are members of that
> +LAG join/leave the bridge. Switchdev port attributes (VLAN filtering, STP
> +state, etc) and objects (VLANs, MDB entries) offloaded to a LAG as bridge port
> +are treated similarly: DSA offloads the same switchdev object / port attribute
> +on all members of the LAG. Static bridge FDB entries on a LAG are not yet
> +supported, since the DSA driver API does not have the concept of a logical port
> +ID.
> +
> +- ``port_lag_join``: function invoked when a given switch port is added to a
> +  LAG. The driver may return ``-EOPNOTSUPP``, and in this case, DSA will fall
> +  back to a software implementation where all traffic from this port is sent to
> +  the CPU.
> +- ``port_lag_leave``: function invoked when a given switch port leaves a LAG
> +  and returns to operation as a standalone port.
> +- ``port_lag_change``: function invoked when the link state of any member of
> +  the LAG changes, and the hashing function needs rebalancing to only make use
> +  of the subset of physical LAG member ports that are up.
> +
> +Drivers that benefit from having an ID associated with each offloaded LAG
> +can optionally populate ``ds->num_lag_ids`` from the ``dsa_switch_ops::setup``
> +method. The LAG ID associated with a bonding/team interface can then be
> +retrieved by a DSA switch driver using the ``dsa_lag_id`` function.
> +
>  TODO
>  ====
>  
> -- 
> 2.25.1
