Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE5D2B7FC9
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 15:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgKROsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 09:48:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgKROsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 09:48:06 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A80FC0613D4;
        Wed, 18 Nov 2020 06:48:06 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id r18so1340692pgu.6;
        Wed, 18 Nov 2020 06:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XpeXNv2DK2M3hwS0Spytct1KKHhQGCtOUMK4RpnJ4T4=;
        b=sXKRhHCke3eRPk50KGQv6Dm7zUZ2LIT2cvvLaR1REP2SBUzFCa51DORMzw/Dee2EE4
         6tTcCg29G1SfKDr/0kDT44Fg1Scri8gFoR9SOvIhGV+qsdI37gcBuuhfx6HOfD1kZvMt
         8gX18KQ7+xB0tMvNSllHKUl46Uf8L9yzYdEOxUWZrFzrDIQm7hKFVwl/89cV+IozmZ2k
         FKDZ3e4T5v1D1eM2zWAj62BmpJpcW3DyrQ0z6pMZQZFWkXxOODtvt/YwhVOzQzEiMaVs
         +uGH+pAu5jlUWIQ6D4HdtcUpkOrpnAYMliaIt4o9gDQeG+lZBTIl0W4y6f6eDzlsxtyU
         ubsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XpeXNv2DK2M3hwS0Spytct1KKHhQGCtOUMK4RpnJ4T4=;
        b=FqsoLt7BkzHJrJv2JFBryIJUm18FddV9RHpAIJLwUtM/qkGrQ/GAFjlHFXBO+R3gyL
         q5OaJDqE18lgUteVgyg9RxwH/YmcC/jnCofcZyZ84tDAbQnOad0OAr+EIkBRqOX76q3n
         Bnk1cSwv0H/tCahVbyGko7N6QPDYrG+rxameQiyCESlXLmkOyQQ+hH6S1euES4n1fkq3
         uO2j0wrQyQ50LkANzLmLAaE+RRRzI2SpgEM2alAs0KisZH9SNqhWHm94aH6hizrdQGpF
         yef3xEhj4fjzy8hBkyVMM44NJh2E1zJo2Axkt+pCYh3LOtrVX+ZN7gyQUBhaCwWjFZ1T
         O8dg==
X-Gm-Message-State: AOAM5320KbUK5ll9u/O0hjZZLszSDaiImb3+tO7StgAV/+8dNDCMUus6
        0bTu/NlDRqCmL15fIe+vOg4tbkXwWcYM8c9HGAQ=
X-Google-Smtp-Source: ABdhPJzSGjB9BpbeecitjRee4YqDw2HHNxVuU7+x+9SRyoua1EM4g9xUJZCWUVgpFQY106PoNZcvP39Irh4Bvzfi/zA=
X-Received: by 2002:a63:d312:: with SMTP id b18mr8523077pgg.233.1605710885928;
 Wed, 18 Nov 2020 06:48:05 -0800 (PST)
MIME-Version: 1.0
References: <20201118135919.1447-1-ms@dev.tdt.de>
In-Reply-To: <20201118135919.1447-1-ms@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Wed, 18 Nov 2020 06:47:55 -0800
Message-ID: <CAJht_EPB5g5ahHrVCM+K8MZG9u5bmqfjpB9-UptTt+bWqhyHWw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 0/6] net/x25: netdev event handling
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 5:59 AM Martin Schiller <ms@dev.tdt.de> wrote:
>
> ---
> Changes to v2:
> o restructure complete patch-set
> o keep netdev event handling in layer3 (X.25)

But... Won't it be better to handle L2 connections in L2 code?

For example, if we are running X.25 over XOT, we can decide in the XOT
layer whether and when we reconnect in case the TCP connection is
dropped. We can decide how long we wait for responses before we
consider the TCP connection to be dropped.

If we still want "on-demand" connections in certain L2's, we can also
implement it in that L2 without the need to change L3.

Every L2 has its own characteristics. It might be better to let
different L2's handle their connections in their own way. This gives
L2 the flexibility to handle their connections according to their
actual link characteristics.

Letting L3 handle L2 connections also makes L2 code too related to /
coupled with L3 code, which makes the logic complex.

> o add patch to fix lapb_connect_request() for DCE
> o add patch to handle carrier loss correctly in lapb
> o drop patch for x25_neighbour param handling
>   this may need fixes/cleanup and will be resubmitted later.
>
> Changes to v1:
> o fix 'subject_prefix' and 'checkpatch' warnings
>
> ---
>
> Martin Schiller (6):
>   net/x25: handle additional netdev events
>   net/lapb: fix lapb_connect_request() for DCE
>   net/lapb: handle carrier loss correctly
>   net/lapb: fix t1 timer handling for DCE
>   net/x25: fix restart request/confirm handling
>   net/x25: remove x25_kill_by_device()
