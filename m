Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5A341850E
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 00:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhIYW4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 18:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbhIYW4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 18:56:33 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4002C061570
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 15:54:57 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id i4so57510940lfv.4
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 15:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ic4rVGQgYuHffA11ui94cnwsUSQ53Amy40LMCr4XULI=;
        b=HLP3BCrqmorDx02eaJjkrMOKkgz8STuu2nDTU8dOoNUesacWDyEqqYggiOOeEWiYNv
         k4SsmhYaWVMU7WErdHNHE0MOPXZdGApzwxHnvgBaE4+NrFcOvhaRILIqWfG2lkjAIL9E
         VDWnr3rE0nC+LZoFtjRRfs4XT5Tp7UO0OrWuGqc68SaRMq3B/pc1chYPhOe3MG1xKO/N
         f79SI3sGXwaLAX4Zg5WrfP9DwdqlfVvov92GcehGo0yjjplrwhl0J8XDJZGhlFbKSJ4Z
         jBq/OGJdnwp7WgCkfs425VxqoXxmfJLutsAdrygAHAi2c85UTnk3Hk/dw7Eh824k9dJZ
         GEiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ic4rVGQgYuHffA11ui94cnwsUSQ53Amy40LMCr4XULI=;
        b=CZcf8gMpQKMusP5fkQmCBMbpoc8RpwSBWQ9eq1lhSQJl/nGLtooF+gnFcIlSNTvEOw
         cycKHNBJZpHFvC1pP1RCPKQ6fES2etWgHfx0AtqLhDE9Tde8axz8ZB9PDeXhaTRdAMb1
         PVDElauWcvQlQTzlhqrlcBXGf81lnl2OvPvu1uKczFULfan+aOpNZgriZnnJCjQYYhTf
         JVJMXTjpjulP3GxEHaByJs9cruYO2OdfSINRczC6pJCjDw4Rjk8bGjQp6ECDkAhvgVBi
         Hysk+Eq+sNQ/3VEFdo2s/U0rOL8cwoUtXG5/0yazjeJm5wFATOKDh/WqB7zFlY2Oleq7
         oaow==
X-Gm-Message-State: AOAM533cQvyc5HcgPdd9jHB4V1AXb8v9iiroRwOh/DXe0gt1gGERdvVq
        F26KWRreS8XiPJ40Vr5BYX6sWmtzCLgF/5NArWQk3g==
X-Google-Smtp-Source: ABdhPJzjxpwXPX7tdIAnbmcuXe5XRbQ8Wd3EdbhwpqssQngIxzSUJrXH73+ArttLZPm2SN90bEpaxYze+Z7Letf3Kd8=
X-Received: by 2002:a05:6512:3c92:: with SMTP id h18mr16113784lfv.656.1632610496333;
 Sat, 25 Sep 2021 15:54:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210925132311.2040272-1-linus.walleij@linaro.org>
 <20210925132311.2040272-7-linus.walleij@linaro.org> <20210925185625.5arlipvkhqhj2wrm@skbuf>
In-Reply-To: <20210925185625.5arlipvkhqhj2wrm@skbuf>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 26 Sep 2021 00:54:45 +0200
Message-ID: <CACRpkdY0dp7nNCsxOdXsdfbBMO1AK5KfW8SqvuZ0Gmt-QwmqVg@mail.gmail.com>
Subject: Re: [PATCH net-next 6/6 v6] net: dsa: rtl8366: Drop and depromote
 pointless prints
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        DENG Qingfang <dqfext@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 25, 2021 at 8:56 PM Vladimir Oltean <olteanv@gmail.com> wrote:

> > -     dev_info(smi->dev, "add VLAN %d on port %d, %s, %s\n",
> > -              vlan->vid, port, untagged ? "untagged" : "tagged",
> > -              pvid ? " PVID" : "no PVID");
> > -
> > -     if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
> > -             dev_err(smi->dev, "port is DSA or CPU port\n");
> > +     dev_dbg(smi->dev, "add VLAN %d on port %d, %s, %s\n",
> > +             vlan->vid, port, untagged ? "untagged" : "tagged",
> > +             pvid ? " PVID" : "no PVID");
>
> This is better, not going to complain too much, but I mean,
> rtl8366_set_vlan and rtl8366_set_pvid already have debugging prints in
> them, how can you tolerate so many superfluous prints, what do they
> bring useful?

I actually use them ... I suppose one can use ftrace instead
and/or gdb, but I'm one of those die hard printk() debuggers
and I like to follow what happens like that.

When the driver gets mature we can delete most  or all of the
dev_dbg() messages I think.

Yours,
Linus Walleij
