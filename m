Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86446265C13
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 10:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725809AbgIKI5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 04:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbgIKI5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 04:57:44 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69619C061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 01:57:44 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id 195so5898797ybl.9
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 01:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=mPH1Kz+kxljRvAErtvZ786TAgbZSEVBYXaKT9lbt6fY=;
        b=x4+KCCGylZeR3SEr3SL3ae2rupa2JTiOCwGNXsKZ9EFXPwzfidMkxCy80MxYArT1bk
         pBLsAHzJ0TiJ3Sn/5nd6AXdVnSUPy1PLcmNsKVTh4Q7I43/vaGia8Z4aZRvn35ZGSPTM
         Yruuk6tmux6V5j6mj8MfKonLnmMnaP7Ejn2j0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=mPH1Kz+kxljRvAErtvZ786TAgbZSEVBYXaKT9lbt6fY=;
        b=mlmPrifhIJJ2/m3g7d0W/ewVTn+Ae44oI1XGDUudtqOhxopPll95NFNGyY/p8RN/iv
         f4qhScBpkTLDJMcXGMQ0XVLzKyh79YiprntXGH+uB/kQWDSOU4kEp8SikTzota/EJLxp
         1BpWqyQyuDPhsJUVeelmjhyWZR17sFUSeD/H7dwihxNZK6iTPqsB4ViX0JD3MhTbY30n
         M36+l3HN0ePuGfdeaIW9r/2lmulPvIIxJTjz1lDbOjx391l5esFKaljS+WlyVv7jx59K
         VcwcjGFEQjHw5TyIyb7ICE6dkH93e69J49VJ30QowWCdwaERZsZfBVwsn66AKrWsucZD
         wxEg==
X-Gm-Message-State: AOAM532Il8gGeydMSgQUgxAlxjNZfjtCpNddEF3pAK3FawEstR8/gJj/
        ScsYhIIPZ63OA8HI1qqr0VkjRV0SBZdG349963ysSujrlja7uOm4
X-Google-Smtp-Source: ABdhPJymVyf2yviT+zr/ZKNY3yv50TS+ZSysUbC0O1tbYp6UqdIpwM2ofEfv9hOwG0SD9PUaX2GnQonTfMuw5G4xDgQ=
X-Received: by 2002:a5b:2c7:: with SMTP id h7mr1173630ybp.40.1599814661527;
 Fri, 11 Sep 2020 01:57:41 -0700 (PDT)
MIME-Version: 1.0
From:   Marek Majkowski <marek@cloudflare.com>
Date:   Fri, 11 Sep 2020 10:57:30 +0200
Message-ID: <CAJPywTLkPpYdxf7Y-aBWQBQa4KOjuq+KXD6p++EE44vhOti3Fw@mail.gmail.com>
Subject: Cloudflare L4LB - UNIMOG - using XDP and TC cls
To:     network dev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Wragg <dwragg@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I know the community is looking for examples of eBPF usage. David from
Cloudflare wrote a blog post about our Layer 4 Load Balancer called
UNIMOG. It's a long read but goes into many architectural details:

https://blog.cloudflare.com/unimog-cloudflares-edge-load-balancer/

We added the tc cls component to the selftests:

https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/tools/testing/selftests/bpf/progs/test_cls_redirect.c

Cheers,
    Marek
