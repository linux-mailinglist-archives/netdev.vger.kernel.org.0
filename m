Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56FA124E2A4
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 23:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgHUVZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 17:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgHUVZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 17:25:33 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B0AC061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 14:25:32 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t4so2604341iln.1
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 14:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sjR6W31pNh3oP45UZXNb6LyOH2vGpIvPSaw5J9K7Q8k=;
        b=eeVF5igjMsaIje2ME9LuVW32oCkQc+sJlCUy6pHPLx/FwRQE551oTt27m09i7h6qbo
         og8H9FOYgF9mMp827knSxdLd7b1vK1itRhYbuUAxWyNmDUeEKMgLbSNksmzQWHexWkyK
         jmkBf3bhOQuGEkWxDuiCgVaynbqKsDX4F6MKXAe1FAUwsQXh6QsD3DqRsuGjnumLRLRf
         jUN27u1ke2lAwHi4r/d+3CeuPMttboMIMWaNTPp+jdhNvIFVZ7Zd9ooH6RzD0+/rbkmJ
         5yZwXpISgU9MCMXU3kOZrD0Ezf+Reor6S+yRX/hIqOHeYu7D8ZegyaGkzTguuMC/w0Fc
         HQkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sjR6W31pNh3oP45UZXNb6LyOH2vGpIvPSaw5J9K7Q8k=;
        b=juhm5BOVMJZ62NMsMS3qVuQ+0OElsGHnY4ZqGc4riy9yJH4810xd5QqAEqUaASg+iX
         W33D0HrzIWTuOcf3lt784lf0aSa8985XQN6lPtonpnUmpYEk0c4ySpBWpVviaDk0coL7
         8W48WEgxBH2ywGrZwjlE7vxg/Ruc9YAXYVax0f4AHK4xuFhtg8shARoiHHa70+Ya1qYi
         43Rf7rBCIXmodztkpwNWwllc8sjwfBvlwi01n8i/Hs6icmNOEXYyGG2l3LuuGNODvgwS
         FiWPzQn9D4Tg/geXt8nFkNPwBsGDEEpTsVn7uu70y2cXzwZxyou7eLG3BFEINs9qo+lz
         6XiQ==
X-Gm-Message-State: AOAM532kWqqNYoETtXu8JSLGhED2kIhsnzG/rO0Q/OaZoWmHuHVVvbYo
        p6xVi2qSUV/x7K1juN7vdRnrKmw6c2Rn3ujIJAkiog==
X-Google-Smtp-Source: ABdhPJw0W12OGCWoqTsXWMQk8t5XwgonRuaJqBzQFXWNrZrp7bcETRUlsto25hAHWG1Iu5vfsF2SCgwJ3H4RI9618Z4=
X-Received: by 2002:a92:35da:: with SMTP id c87mr3740162ilf.61.1598045131858;
 Fri, 21 Aug 2020 14:25:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200819005123.1867051-1-maheshb@google.com> <20200821.140323.1479263590085016926.davem@davemloft.net>
In-Reply-To: <20200821.140323.1479263590085016926.davem@davemloft.net>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Fri, 21 Aug 2020 14:25:20 -0700
Message-ID: <CANP3RGc+N4O-eUAHr+mOsQ740aExW7zzbmh8V7Wb54d3teB+hQ@mail.gmail.com>
Subject: Re: [PATCH next] net: add option to not create fall-back tunnels in
 root-ns as well
To:     David Miller <davem@davemloft.net>
Cc:     Mahesh Bandewar <maheshb@google.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, mahesh@bandewar.net,
        jianyang@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > not create fallback tunnels for non-default namespaces") to create
> > fall-back only in root-ns. This patch enhances that behavior to provide
> > option not to create fallback tunnels in root-ns as well. Since modules
> > that create fallback tunnels could be built-in and setting the sysctl
> > value after booting is pointless, so added a config option which defaults
> > to zero (to preserve backward compatibility) but also takes values "1" and
> > "2" which don't create fallback tunnels in non-root namespaces
> > only and no-where respectively.
> >
> > Signed-off-by: Mahesh Bandewar <maheshb@google.com>
>  ...
> > +config SYSCTL_FB_TUNNEL
>  ...
> > -int sysctl_fb_tunnels_only_for_init_net __read_mostly = 0;
> > +int sysctl_fb_tunnels_only_for_init_net __read_mostly = CONFIG_SYSCTL_FB_TUNNEL;
>
> I can't allow this.  This requires a kernel rebuild when none is
> really necessary.  You're also forcing distributions to make a choice
> they have no place making at all.
>
> You have two ways to handle this situation already:
>
> 1) Kernel command line
>
> 2) initrd
>
> I'm not allowing to add a third.  And if I had, then that sets
> precedence and others will want to do this as well for their
> favorite sysctl that has implications as soon as modules get
> loaded.

I don't think initrd works for things built into the kernel,
since it runs too late - after kernel init is done.
So only the kernel command line method is viable.

If no kernel command line option is specified, should the default
be to maintain compatibility, or do you think it's okay to make
the default be no extra interfaces?  They can AFAICT always be added
manually via 'ip link add' netlink commands.
