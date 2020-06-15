Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C0F1F9DBD
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 18:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731081AbgFOQnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 12:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729966AbgFOQnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 12:43:40 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4F1C061A0E;
        Mon, 15 Jun 2020 09:43:40 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id s28so9948232edw.11;
        Mon, 15 Jun 2020 09:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oyT+oaCixBA4yYiORCGTCzo1YRefkC2Hhdiu35oXchw=;
        b=uwBTrdQ4Fs2qjPJGHF4R23KudXr/MtxX697gkgsbVpqFYXExINyGrzgp0cnNsT9fmO
         0tqay9KLqH1QxOyKU3twUX5w2yMwNazY5dRQIgHnUTyY21HYQxxMhepCIq+nKInoJmDB
         nrhKEYWYZKMB1iJWO8eCx2q+paLu7gxk/ATCfFh0EJhAOnPBeIBfxDnNySS3BUCY/w9/
         Wxr11er7Rg4cSOzdN6+M0OX8eIcGINK0qkZ8KQzEl7TO0HaBW97LAKapZwbG3+4m2PTJ
         9REsPR7KX5hMwkiSRk9uxELBapmZ/aRINZk1k3JpaAyvWmvDH9N4A7sIOAgoi6zZT8Tf
         eGcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oyT+oaCixBA4yYiORCGTCzo1YRefkC2Hhdiu35oXchw=;
        b=gGTlhppI0YPO7o/CIvuggMDL+JNoWgeLgAgOABCXOODMadjF1196PiYANGLEPiMPRe
         qGkW6DXUTIcvpYCFQRFTy+xFqChpw8AZks7q2Jz+9EznT7rbNJbPrUvh4mwYxj1HjukX
         t6dv12E4B5q/r2ygn/R5C3YrrGWXI7kijexdjqtiU1ciWNUEbzXn4ScmPJC5R4H27/Kz
         RCVgEDWI/A+xOIyIJsKpCGvNtiTKh9ccev4pK7LVHZBD02Y1xc5gDPzJ/4Gpl9384Ebo
         ana38VkXL/UBAn+4sRAkJJWjPbpjne+c7/TuCwnavnHK6KFpnzcUweWux27hrbgoR2FM
         083g==
X-Gm-Message-State: AOAM531Y95H9gRY/HE82DXTCZMumKXVXQhYAULFxqjUvGfw4BZ7QoBjE
        q0GNbzHIjVN1JtxVJzv9OCUirrGigR+FCimaB57NFg==
X-Google-Smtp-Source: ABdhPJwfOC6j/e8SYravQLvdsInJRQC66KvwEhEcmijWYyEzHfhkMO9cuBcG/TjGdI0GpRnFQYBsjQn3xj5jpSSJe1U=
X-Received: by 2002:aa7:dc50:: with SMTP id g16mr25558402edu.318.1592239419021;
 Mon, 15 Jun 2020 09:43:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200613220753.948166-1-olteanv@gmail.com> <20200615093710.2d5e931e@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200615093710.2d5e931e@kicinski-fedora-PC1C0HJN>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 15 Jun 2020 19:43:28 +0300
Message-ID: <CA+h21hqaew3Msah507Q=C82aBzboJyy1PqOVKpMEfMqYdnO5cg@mail.gmail.com>
Subject: Re: [PATCH net] MAINTAINERS: merge entries for felix and ocelot drivers
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Jun 2020 at 19:37, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun, 14 Jun 2020 01:07:53 +0300 Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > The ocelot switchdev driver also provides a set of library functions for
> > the felix DSA driver, which in practice means that most of the patches
> > will be of interest to both groups of driver maintainers.
> >
> > So, as also suggested in the discussion here, let's merge the 2 entries
> > into a single larger one:
> > https://www.spinics.net/lists/netdev/msg657412.html
> >
> > Note that the entry has been renamed into "OCELOT SWITCH" since neither
> > Vitesse nor Microsemi exist any longer as company names, instead they
> > are now named Microchip (which again might be subject to change in the
> > future), so use the device family name instead.
> >
> > Suggested-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> Looks like checkpatch is unhappy about the order of files?
>
> WARNING: Misordered MAINTAINERS entry - list file patterns in alphabetic order
> #58: FILE: MAINTAINERS:12308:
> +F:     include/soc/mscc/ocelot*
> +F:     drivers/net/ethernet/mscc/
>
> WARNING: Misordered MAINTAINERS entry - list file patterns in alphabetic order
> #59: FILE: MAINTAINERS:12309:
> +F:     drivers/net/ethernet/mscc/
> +F:     drivers/net/dsa/ocelot/*
>
> total: 0 errors, 2 warnings, 0 checks, 46 lines checked

Thanks for checking, Jakub. I sent a v2 now.

-Vladimir
