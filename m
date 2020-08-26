Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1145D25383C
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 21:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgHZTXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 15:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgHZTXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 15:23:38 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72718C061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 12:23:38 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id p185so811461vsp.8
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 12:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iyyYPu1TyRB+PxLn3S1ZKF9XzB1ZH38Ql96IDmcLeM0=;
        b=GH7o0Oc9o86TCXdo1ZTlmJq2uy60ZHlschlG1OyNTJy9k04Kpv1TKqyQPKwSTWgOFJ
         iCiOD3D6PYHL3+8jkrHEI/EI3ROuhrhmpQ0h+KXGVGE8gMZk+xmPdEOkDUARc7KzOQ+D
         aa9Q2dslcjdUXpWpI6mUloOPLllKljPdYGZ5mTs8+lsLSqjF6uoGwrCvQCAtjnadS0O2
         yE2lsnpafS4ZTs5p1WipFGx8ZNfxOUY+gYeaaWKcHr9IyNixPe8OGtICBnjVBZN9v6pX
         rTncjBJoxr5BPhsL5p16XuAc3DmNbNaH/etTPBRTjHMVxs+Nh2ftEwyJWL3xebAYuacJ
         9Rrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iyyYPu1TyRB+PxLn3S1ZKF9XzB1ZH38Ql96IDmcLeM0=;
        b=qjzSU2HtLUgvey5ckr+I4rbFP/m6dURVRdjzYpcKt2ZYTcYSIMEarpkr1zBwW7/u0z
         3KEaBrSzm3jSLiujCvj25eV+WNnWKlAbCRMCkHldkcpFEOELwGi+2fnYTgTYnFnhKbgY
         truij/gtNQFWKyWUvzzWt1cr/79X3KVvkNz40oFgjXURnsgFNLaF57jZgTV/OZGLNWHv
         ggzzWWcsjfvU7cGuiZsPj+f8ETduZO5ZGAewL+2AAEMUk9ZqeLKJXUPv440SRCHPwIcv
         dxwl43IDxVjYkNEv5Us3lcjUExlnjK5P2hpNyWdpgfMo/dCYB+Qr0JISy34Dtd8h3Vbs
         90gQ==
X-Gm-Message-State: AOAM532sjjWb5jcWGxkl8AwXMdXdLp8GliuMKo7jweZNvnjnBXlXtDd+
        ejJrRfCSQyOLwpq5195qdOCIpKpuHgzpFVmiFBU=
X-Google-Smtp-Source: ABdhPJyFIUoWozYEg4W7Zc/Tatsx4n2FzNYoW1rA5lI3sjwXsho8uiiVeEQ6QKoFXETV7F/sznPbGMKN97Wm5LSY95I=
X-Received: by 2002:a67:ef8f:: with SMTP id r15mr8014041vsp.43.1598469817707;
 Wed, 26 Aug 2020 12:23:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200825050636.14153-1-xiangxia.m.yue@gmail.com> <20200825050636.14153-4-xiangxia.m.yue@gmail.com>
In-Reply-To: <20200825050636.14153-4-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Wed, 26 Aug 2020 12:23:26 -0700
Message-ID: <CAOrHB_C=Gx_Z=jpxWQfM20zcJnq2XZ9Kfx-oC-8_zDGrBc4Onw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 3/3] net: openvswitch: remove unnused keep_flows
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        ovs dev <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 10:08 PM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> keep_flows was introduced by [1], which used as flag to delete flows or not.
> When rehashing or expanding the table instance, we will not flush the flows.
> Now don't use it anymore, remove it.
>
> [1] - https://github.com/openvswitch/ovs/commit/acd051f1761569205827dc9b037e15568a8d59f8
> Cc: Pravin B Shelar <pshelar@ovn.org>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>

This patch looks good. But its fixing memory leak, I guess the patch
that removed dependedcy on keep_flows is in net-next. so we are good.

Acked-by: Pravin B Shelar <pshelar@ovn.org>
