Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD15321A8C
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 15:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhBVOtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 09:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbhBVOti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 09:49:38 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B61C06174A
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 06:48:56 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id l3so14193773oii.2
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 06:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lBvHlu7IJPgPvsjTaDa1rUcrXX/Zr+WNQtMtjBkBoCE=;
        b=MZFFEfw9avUFN3G+7OOVcGtdhp5pkxDgCPBfxJc59t+LM2+14LBo+o0Eqg847zHrcX
         oX5842TDXCoF4fNUXJSTk1kFdX57NzU1mk78ozaT0eOPrUe6a4ZhVu06S4AE6WpMZZ5r
         2an+D/yAYU6e8aM4tHr/XJRtHlhKM8f0a950O8fzNgOklzsU0PBviov4XAKdeX36IjKA
         QcG5TH/SW8j9yMLBSdEQc5C6sN4a3lNQTabhNcdUUiMFglKAd9XHoAPrhw07Vo3Sbdm3
         j2yAGFweYOIFDyuFOk4qSKX7SbqATeYHy2g0T4UCqI4LN3V+8FBOHukBUeSeZw0x3WUH
         tuPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lBvHlu7IJPgPvsjTaDa1rUcrXX/Zr+WNQtMtjBkBoCE=;
        b=WPJl+bOwxALHCj8eFydcrfT6qNxs0XzPUIyfsNtlDutcyqix9Jg+P8JAQtvZyscyMZ
         oaQ9XAT6cMGUXiW96UDkh5BqwplOF5PA39UYk3rMI4PHFHfmrApnbMReyOTut2hYmaYu
         iR0XtHmQHvdlG986SwjhLW1RfmfrrF7ft+7fQXDJL6PSikDFw06E8xqIVFGKvJU+cfFB
         5Xie3F7g/WCHpNTvRUyPhNtDm88zyVYKLrCqAGR+X7q7UHtOS8KVu9tJN7g+YQr+IuNW
         ff8XDxGgE0bAmqTXH4tBtsMLKAZ8icqpq4wW46mzjdjRCppcRs/tyC/EtlMVxHb5xk80
         2pyQ==
X-Gm-Message-State: AOAM533oRSw45uoSuPQCdInzKazoZ0ULa3B5q4JjaYXa9pKwwu1g3DwW
        Qiox8il9BbMoshxZsOZfnp3yp0Ajr/p6pZ0aKA==
X-Google-Smtp-Source: ABdhPJx+lE/QDzH8P9XInTL2x3g1eQFmHqbCTrgfmN5CHariImAwrKo0EQxzI4hOWiYE9o84zHKEuNl5+AY8vdxzdbY=
X-Received: by 2002:aca:da83:: with SMTP id r125mr16349143oig.127.1614005335117;
 Mon, 22 Feb 2021 06:48:55 -0800 (PST)
MIME-Version: 1.0
References: <20210221213355.1241450-1-olteanv@gmail.com> <20210221213355.1241450-11-olteanv@gmail.com>
In-Reply-To: <20210221213355.1241450-11-olteanv@gmail.com>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Mon, 22 Feb 2021 08:48:43 -0600
Message-ID: <CAFSKS=PEvMO2YZCtUvx1BO5U1idQ5Qy3OOfug=xK_bVVXRMF4g@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 10/12] Documentation: networking: dsa: add
 paragraph for the HSR/PRP offload
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 21, 2021 at 3:34 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> Add a short summary of the methods that a driver writer must implement
> for offloading a HSR/PRP network interface.
>
> Cc: George McCollister <george.mccollister@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  Documentation/networking/dsa/dsa.rst | 32 ++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
>
> diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
> index bf82f2aed29a..277045346f3a 100644
> --- a/Documentation/networking/dsa/dsa.rst
> +++ b/Documentation/networking/dsa/dsa.rst
> @@ -760,6 +760,38 @@ to work properly. The operations are detailed below.
>    which MRP PDUs should be trapped to software and which should be autonomously
>    forwarded.
>
> +IEC 62439-3 (HSR/PRP)
> +---------------------
> +
> +The Parallel Redundancy Protocol (PRP) is a network redundancy protocol which
> +works by duplicating and sequence numbering packets through two independent L2
> +networks (which are unaware of the PRP tail tags carried in the packets), and
> +eliminating the duplicates at the receiver. The High-availability Seamless
> +Redundancy (HSR) protocol is similar in concept, except all nodes that carry
> +the redundant traffic are aware of the fact that it is HSR-tagged (because HSR
> +uses a header with an EtherType of 0x892f) and are physically connected in a
> +ring topology. Both HSR and PRP use supervision frames for monitoring the
> +health of the network and for discovering the other nodes.
> +
> +In Linux, both HSR and PRP are implemented in the hsr driver, which
> +instantiates a virtual, stackable network interface with two member ports.
> +The driver only implements the basic roles of DANH (Doubly Attached Node
> +implementing HSR) and DANP (Doubly Attached Node implementing PRP); the roles
> +of RedBox and QuadBox aren't (therefore, bridging a hsr network interface with
> +a physical switch port is not supported).
> +
> +A driver which is able of offloading certain functions of a DANP or DANH should
> +declare the corresponding netdev features as indicated by the documentation at
> +``Documentation/networking/netdev-features.rst``. Additionally, the following
> +methods must be implemented:
> +
> +- ``port_hsr_join``: function invoked when a given switch port is added to a
> +  DANP/DANH. The driver may return ``-EOPNOTSUPP`` and in this case, DSA will
> +  fall back to a software implementation where all traffic from this port is
> +  sent to the CPU.
> +- ``port_hsr_leave``: function invoked when a given switch port leaves a
> +  DANP/DANH and returns to normal operation as a standalone port.
> +
>  TODO
>  ====
>
> --
> 2.25.1
>

Reviewed-by: George McCollister <george.mccollister@gmail.com>
