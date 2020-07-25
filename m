Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4BF22D872
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 17:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgGYP1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 11:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726870AbgGYP1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 11:27:01 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA0C1C08C5C0
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 08:27:00 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id a8so9067384edy.1
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 08:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ues538pCA0/NgJbJ7tqMNRXEjSVqrPobSKjiAa2xt3E=;
        b=HKYUs9NkB9Fe1wEzbw9SLZRcS8zWBK3nu21P1eM4JHBYvaeOJuqOYVdOCnGKlRjuyN
         OmbT9Q+29XQJZxk634dyd9DEWWddfJGz4sELx4tWLfUGUKQBDPd1xdnVjDHg4fFUeueu
         Gs+pwDg7yoiWlNRekc8Z8pLPJeexOYjbczYxKJgC+cNaOo4CJDfXAzPz+v8aliQx5WA+
         ptckXUsDq5OkJrsQoeM/LzB9+OYL5bqR3n7HWpztRgGEqqwA0ruddAPd5VJPTkjGxq7H
         nF5byspZzPvpnQ4cRHszmJP/L752XsSkcBqtRJzAht8DJJn4TtbVmWpJVzTaszj0kwfn
         FOAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ues538pCA0/NgJbJ7tqMNRXEjSVqrPobSKjiAa2xt3E=;
        b=XCkVct+0EQ9WME1aL1H+7H9hqPrwVaIb0vo8/6X3pqiHaEkTpoeDwYvg/MyQDClZQb
         tn955QG06uKlO1cP8GED4n57qC61n8AJF4xw6KDRxJZaXpekJbnR15dm2BcZtTrSzsVz
         qxBHkEcwTsjp91lP9DTzglJ/HsrxN+fDvGYdrXzn7c+Yeg/F39S5W9i1Dy6tYFf/4Cam
         FoB19S87e7rRhPwTddrYHH7RgSInv6ewTHnB7bcXo8MfxnhgxbvU8wll9StajTHHm2c7
         0SgOKoNefMD4vRaqHnQMHT7jJTeG8AAgbw3agMq9fqdRhflDG3PBpDbuHnZAqWPw1Mg1
         OaKA==
X-Gm-Message-State: AOAM5309DUNWdJgZ3CrxdEUh+tjTRxOxGRTn/yikjftYt5WUz5ESY7cu
        QV6+NB8PdUAbo7qPJOcs+cv4Djn19V1I90szCq0=
X-Google-Smtp-Source: ABdhPJzxyq4drnlzSun53/AyX/5/WnUPc2bZ8fV7KmUN31goYIrNqcAPECNRiWnquv/2k4KZzErnyUQ1uxwE3Z7KX6c=
X-Received: by 2002:a50:ee07:: with SMTP id g7mr14184982eds.320.1595690819324;
 Sat, 25 Jul 2020 08:26:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200725064936.GB125759@manjaro> <20200725125433.igpkdwd26dxesxno@lion.mk-sys.cz>
In-Reply-To: <20200725125433.igpkdwd26dxesxno@lion.mk-sys.cz>
From:   =?UTF-8?B?2LnZhNmKINmF2K3ZhdivINis2KjYp9ix?= 
        <alimjalnasrawy@gmail.com>
Date:   Sat, 25 Jul 2020 18:26:47 +0300
Message-ID: <CAO+QWJye0VXXZs0NevHV5eGJL_JgzLPGGKAGx9yP3OnZVHOF1g@mail.gmail.com>
Subject: Re: ethtool 5.7: --change commands fail
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 25, 2020 at 3:54 PM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Sat, Jul 25, 2020 at 09:49:36AM +0300, Ali MJ Al-Nasrawy wrote:
> > ethtool: v5.7
> > kernel: v5.4.52
> > driver: r8169 + libphy
> >
> > Starting from v5.7, all ethtool --change commands fail to apply and
> > show the following error message:
> >
> > $ ethtool -s ens5 autoneg off
> > netlink error: No such file or directory
> > Cannot set new settings: No such file or directory
> >   not setting autoneg
> >
> > 'git bisect' points to:
> > 8bb9a04 (ethtool.c: Report transceiver correctly)
> >
> > After debugging I found that this commit sets deprecated.transceiver
> > and then do_ioctl_slinksettings() checks for it and returns -1.
> > errno is thus invalid and the the error message is bogus.
> >
> > With debugging enabled:
> >
> > $ ethtool --debug 0xffff -s ens5 autoneg off
> > sending genetlink packet (32 bytes):
> >     msg length 32 genl-ctrl
> >     CTRL_CMD_GETFAMILY
> >         CTRL_ATTR_FAMILY_NAME = "ethtool"
> > <message dump/>
> > received genetlink packet (52 bytes):
> >     msg length 52 error errno=-2
> > <message dump/>
> > netlink error: No such file or directory
> > offending message:
> >     ETHTOOL_MSG_LINKINFO_SET
> >         ETHTOOL_A_LINKINFO_PORT = 101
> > Cannot set new settings: No such file or directory
> >   not setting autoneg
>
> Kernel 5.4.x does not support ethtool netlink so that we fall back to
> ioctl. While we want to report transceiver in "ethtool <dev>" output, we
> must not pass the value retrieved from kernel back to kernel when
> "ethtool -s <dev> ..." command is executed.
>
> Does the patch below help in your setup?

Yes, it fixed the issue. Thank you.

Ali

>
> Michal
>
>
> diff --git a/ethtool.c b/ethtool.c
> index d37c223dcc04..1b99ac91dcbf 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -2906,6 +2906,8 @@ static int do_sset(struct cmd_context *ctx)
>                 struct ethtool_link_usettings *link_usettings;
>
>                 link_usettings = do_ioctl_glinksettings(ctx);
> +               memset(&link_usettings->deprecated, 0,
> +                      sizeof(link_usettings->deprecated));
>                 if (link_usettings == NULL)
>                         link_usettings = do_ioctl_gset(ctx);
>                 if (link_usettings == NULL) {
