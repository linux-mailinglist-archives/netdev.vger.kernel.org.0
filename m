Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9EB51FD4C8
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 20:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgFQSpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 14:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726835AbgFQSpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 14:45:40 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5871DC06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 11:45:40 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id y13so1767904ybj.10
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 11:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4pZmyXJHr6ifK2DLcd6CDe6QoYrIzbZSyUCx9aCtPrY=;
        b=SImV2UT+G86yn8tZGL/a5iXI5ovKkWA9GSRJhFxy7NThgc0B4x1FSt+mWJHUTuj+w5
         2HWHwF2EgOzA8FOyK+FqEphbcx+jSUaHNpkAW5fVo+ihRlPyjSSK7rPtTUySedTRfGQf
         ANEn1n3Ws29WWoY3+4kj3ZcNYda8N231IDjPbAMNjQlVpIVhRW0gJ7ZidSmhSJtre4HB
         ZWKy5O5TB2whZu4cev4pqTWOGM8iYeN3kAm63WjW//4vkQsd0qJQ4XGqni0oKGO0HVjG
         yS7lRjPVXSplyxXmm0W9yMVj+tbTb/yrW6kQiBazjj8w9ANvhVKWsHz6/WDMqZlcfXFw
         htUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4pZmyXJHr6ifK2DLcd6CDe6QoYrIzbZSyUCx9aCtPrY=;
        b=KVcUdro2D4ueo1yXo38V21d2xVbfHp77u66UDr0xcpOGdIDJhuO8FVo/m1I2wmtIn4
         tC9QLU1pRrD7cYnIHq7zBCVwEEA7etks64eUsqe9NEFGK7ys2k4aOJTzg/OehrgtIu7G
         TXK5tvakURP2SYQ0Bm6C9ow+9O+3FgMhVi2oe8xcPo43CO4RLGcaZsL62rAc6pZ3qVVk
         dfbvMVyaSIRHIAPd1tBDvVWEi2hzp9F+iGbNInwxRBxzagFhjtO8ObkrNLSn4KAuztGQ
         B/+9bRb4am1/tVxhlYdJ/f72+VFA2kum7vHQabOnnu4kZjAP7U9IIi8zGCNmVVMBdVxC
         XeoA==
X-Gm-Message-State: AOAM532N7sXXYl70i7+q1ZPayoQwu2fCuDJNSvDHiXoj81AHKrBFMBEs
        rWwxyEtP9otPNQkyMnMYw24lFSdyzn66qGMYHQRixQ==
X-Google-Smtp-Source: ABdhPJz891hfVF9Scuny4wvDZUIutF3y59n9ZWE3SUCkhMOvXqRoloEBVFZk6Xzl8LHxmLQWoxY9ynqQAgPojphFRrk=
X-Received: by 2002:a25:ec0d:: with SMTP id j13mr412267ybh.364.1592419539363;
 Wed, 17 Jun 2020 11:45:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200617184403.48837-1-edumazet@google.com>
In-Reply-To: <20200617184403.48837-1-edumazet@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 17 Jun 2020 11:45:28 -0700
Message-ID: <CANn89i+Qcp=hBx63nEYMc-qCSzycvPiaiSNVPDDG+j=rQXAr5w@mail.gmail.com>
Subject: Re: [PATCH net-next 1/5] net: tso: double TSO_HEADER_SIZE value
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 11:44 AM Eric Dumazet <edumazet@google.com> wrote:
>
> Transport header size could be 60 bytes, and network header
> size can also be 60 bytes. Add the Ethernet header and we
> are above 128 bytes.
>
> Since drivers using net/core/tso.c usually allocates
> one DMA coherent piece of memory per TX queue, this patch
> might cause issues if a driver was using too many slots.
>
> For 1024 slots, we would need 256 KB of physically
> contiguous memory instead of 128 KB.
>
> Alternative fix would be to add checks in the fast path,
> but this involves more work in all drivers using net/core/tso.c.
>
> Fixes: f9cbe9a556af ("net: define the TSO header size in net/tso.h")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>
>

Please disregard this patch, I will send a patch series, sorry for the noise.
