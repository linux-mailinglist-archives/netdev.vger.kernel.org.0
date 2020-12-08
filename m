Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1652F2D2E58
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 16:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730026AbgLHPeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 10:34:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729943AbgLHPeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 10:34:20 -0500
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8148AC061793;
        Tue,  8 Dec 2020 07:33:40 -0800 (PST)
Received: by mail-vs1-xe41.google.com with SMTP id q10so9692026vsr.13;
        Tue, 08 Dec 2020 07:33:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SJx7BqX/ixE/fzei6WxsOLNMaFjc9YlcOOhXGl/ihUs=;
        b=JHA2VKifBEKYyWCObgMBJHLB0bchyzTYIPLsLCliJVqROh4kdnI7Jkt84VNfoKIp21
         DNrpXSQxhe8EMuB46biHFaV480yj+NWjvB4vxXUo399TAaCJl9G99Q+tlg133jaYo1/Q
         oMIBCYb+R/MJDek4qaJhGI28VZTmDbBU68uj80AIwzYcBIl4Kxwm94wLJoFaywmqPoTd
         ZI7oK4oEU7GtACbNgPyibjRTS10FKU6RqL0W+Qh0GVGtxV3QNF7gINSoddqSBgz/8Dma
         /Vyt+hhuovmbIDFVNI1ABB9SaNqcMUfFTWedoMJVwsPwxR/pe5+8pSfMSZ9JPRO2WJkY
         +8Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SJx7BqX/ixE/fzei6WxsOLNMaFjc9YlcOOhXGl/ihUs=;
        b=uUYc8/3uYqtx8CGI/rECa8MbKfKLzhC/FXdIls6tHAClWa6UNJbugvyL4HjPQHzJQM
         9nHCO1WX8qqU7X36xfmsvgtRtxSuBYBnJmAJ1yl/gtrt6v+RvK1HdLXnM3J/gaEY1AGw
         T2eriXdDvjSLsF+3fIephLeu7hu5g4pirumfomYRjtanNVf8cHvjVk6HLBfYhh9td5Lv
         gPGPnQWbNeXYBJ79L0Nt2oJCYu5GipE6y7Q0p+eQG5OvdToQkvN6QhJdLgARLc0V0enL
         FgLYySkLcJ1U7U5UOM9DMQfgo9Cz8wYiWsidvVpJ5vZyTDAtt6chQOUXpQ3iHR7KjlI0
         dy7w==
X-Gm-Message-State: AOAM5303UFFzI7aCekPk9E/OO1O4R04Sh89K5aauzCzrvyDS23uHnYIu
        J5+FNNzkwnOpGxFwGfdBb24Rdr0bSqOwcEB8CzI=
X-Google-Smtp-Source: ABdhPJwm6JaxYxU+kXvZGSDy5QBUoMLJJbDJuUUsoIWBGoXj5yHSW5A/VlIkFXPsmWtaRwMWM9D0QuFgB3G8bV/IDlE=
X-Received: by 2002:a67:e43:: with SMTP id 64mr16580301vso.40.1607441619668;
 Tue, 08 Dec 2020 07:33:39 -0800 (PST)
MIME-Version: 1.0
References: <20201205152814.7867-1-TheSven73@gmail.com>
In-Reply-To: <20201205152814.7867-1-TheSven73@gmail.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Tue, 8 Dec 2020 10:33:28 -0500
Message-ID: <CAGngYiXdJ=oLe+A034wGL_rjtjSnEw7DhSJ3sE7M9PAAjkZMTQ@mail.gmail.com>
Subject: Re: [PATCH net v1 1/2] net: dsa: microchip: fix devicetree parsing of
 cpu node
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Helmut Grohne <helmut.grohne@intenta.de>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew, Jakub,

On Sat, Dec 5, 2020 at 10:28 AM Sven Van Asbroeck <thesven73@gmail.com> wrote:
>
> From: Sven Van Asbroeck <thesven73@gmail.com>
>
> On the ksz8795, if the devicetree contains a cpu node,
> devicetree parsing fails and the whole driver errors out.
>
> Fix the devicetree parsing code by making it use the
> correct number of ports.
>
> Fixes: 912aae27c6af ("net: dsa: microchip: really look for phy-mode in port nodes")
> Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # ksz8795
> Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
> ---

Any chance that this patch could still get merged?
I believe this will work fine on both ksz8795 and ksz9477, even though num_ports
is defined differently, because:

ksz8795:
/* set the real number of ports */
dev->ds->num_ports = dev->port_cnt + 1;
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/dsa/microchip/ksz8795.c?h=v5.10-rc7#n1266

ksz9477:
/* set the real number of ports */
dev->ds->num_ports = dev->port_cnt;
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/dsa/microchip/ksz9477.c?h=v5.10-rc7#n1585

Would it be possible to merge this into net, so users get working cpu nodes?
I don't think this will prevent you from harmonizing port_cnt in net-next.
