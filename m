Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE07F2C9ECD
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 11:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbgLAKI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 05:08:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgLAKI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 05:08:26 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3B6C0613D6
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 02:07:40 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id e105so1113828ote.5
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 02:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j5u1oFT+jZgFYkVkNOcd1LpWyzcFNC1bYDu7oq7ej+k=;
        b=mFq5nbkPpBG16+bAtqjhUkkWWlmjAs/Aj2dcd+lTV7Rsv9dM3q17D9mBn5055k7yTP
         N11MN2doGBQxtPSaqXJJSf+uH2eaYdTctGmT7ch0hrHq2aPvCU4JD9OCWoVgcux/9yl0
         pGn+VyzTNlCDlpxPqmPorVVKQNPwjVlAeEguqla/rpMrVoQmpl6iZ97uWSsT1c4a5Aob
         DwCQuNLdtQPIYLp8EIPlTPKbE0kzma1Gy7saUGMzX3GcCkkfOQQPA0823rszMmSGcR43
         uV2HwKI0RX6zWOd0/cJCblkL3IgCWMnH6uiXfoteP/LOjtD8wJi2Nmgy3Hu4iomDldZi
         7pyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j5u1oFT+jZgFYkVkNOcd1LpWyzcFNC1bYDu7oq7ej+k=;
        b=EG7bOstlmjInYQMq+pBMJKPtF8hMmc4pXS7614q2NdjjCgVF9cIqnIfNcTRWW+w67v
         MXtYMhhREmETtONBgHQwF2nCauuKAnvFRQ0TkCKUP3aGX8CVTVkqrOqXH9X5MtHJPauN
         BRUBKnTWi9L8o3FJYRBCVevvPtUkzFCCmipkGCt5uC0JPemPGDQA2sdEGBiZJSAy3gog
         4OjxoHnt7S3aPRivpV9yLhb0keoKklbMG3KIUZaUy2EOTTgzcgI7BGY04ct5OA+mo+x3
         Vj7HGI+5pGsVSLBkcrp7U4lNEUzyHAG+GE0j2nRng2xlp1ypvoMlvVa4dpRQgOWqxefw
         8d6g==
X-Gm-Message-State: AOAM533B/muan/pJHYBH+SzmETyWOhRO9aSppNUjKL53rsmyimyXXHdC
        q6buBsu44uAKLwHochsLWlzpTVEfftGvStc7HCbOr0E0XBg=
X-Google-Smtp-Source: ABdhPJzNIyM0kRpmI+SfOWgMntjKoD103vv5GLk0K1hLOV+wlWbz0qUJZrlAQC/OdItQfw6y7AS98EJxzDbVC1ATCLU=
X-Received: by 2002:a9d:72dc:: with SMTP id d28mr1251495otk.110.1606817259741;
 Tue, 01 Dec 2020 02:07:39 -0800 (PST)
MIME-Version: 1.0
References: <20201122173921.31473-1-ryazanov.s.a@gmail.com> <0863b383-cd6a-1898-3556-bc519e2b0cf4@gmail.com>
In-Reply-To: <0863b383-cd6a-1898-3556-bc519e2b0cf4@gmail.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 1 Dec 2020 13:08:06 +0300
Message-ID: <CAHNKnsQ79LMh7L0GbQ69pTb7BS0zbWPs183NSgoTqVnEvihiKw@mail.gmail.com>
Subject: Re: [PATCH iproute2-next] ip: add IP_LIB_DIR environment variable
To:     David Ahern <dsahern@gmail.com>
Cc:     "list@hauke-m.de:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 8:25 PM David Ahern <dsahern@gmail.com> wrote:
>
> [ sorry, this got lost in the backlog ]

Do not worry. This patch is 1.5 years old :) I keep it in my local
portages, but then I decide that it will be helpful for other
developers too.

> On 11/22/20 10:39 AM, Sergey Ryazanov wrote:
> > Do not hardcode /usr/lib/ip as a path and allow libraries path
> > configuration in run-time.
> >
> > Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> > ---
> >  ip/ip.c        | 15 +++++++++++++++
> >  ip/ip_common.h |  2 ++
> >  ip/iplink.c    |  5 +----
> >  3 files changed, 18 insertions(+), 4 deletions(-)
> >
> > diff --git a/ip/ip.c b/ip/ip.c
> > index 5e31957f..38600e51 100644
> > --- a/ip/ip.c
> > +++ b/ip/ip.c
> > @@ -25,6 +25,10 @@
> >  #include "color.h"
> >  #include "rt_names.h"
> >
> > +#ifndef LIBDIR
> > +#define LIBDIR "/usr/lib"
> > +#endif
> > +
> >  int preferred_family = AF_UNSPEC;
> >  int human_readable;
> >  int use_iec;
> > @@ -41,6 +45,17 @@ bool do_all;
> >
> >  struct rtnl_handle rth = { .fd = -1 };
> >
> > +const char *get_ip_lib_dir(void)
> > +{
> > +     const char *lib_dir;
> > +
> > +     lib_dir = getenv("IP_LIB_DIR");
> > +     if (!lib_dir)
> > +             lib_dir = LIBDIR "/ip";
> > +
> > +     return lib_dir;
> > +}
> > +
> >  static void usage(void) __attribute__((noreturn));
> >
> >  static void usage(void)
> > diff --git a/ip/ip_common.h b/ip/ip_common.h
> > index d604f755..227eddd3 100644
> > --- a/ip/ip_common.h
> > +++ b/ip/ip_common.h
> > @@ -27,6 +27,8 @@ struct link_filter {
> >       int target_nsid;
> >  };
> >
> > +const char *get_ip_lib_dir(void);
> > +
> >  int get_operstate(const char *name);
> >  int print_linkinfo(struct nlmsghdr *n, void *arg);
> >  int print_addrinfo(struct nlmsghdr *n, void *arg);
> > diff --git a/ip/iplink.c b/ip/iplink.c
> > index d6b766de..4250b2c3 100644
> > --- a/ip/iplink.c
> > +++ b/ip/iplink.c
> > @@ -34,9 +34,6 @@
> >  #include "namespace.h"
> >
> >  #define IPLINK_IOCTL_COMPAT  1
> > -#ifndef LIBDIR
> > -#define LIBDIR "/usr/lib"
> > -#endif
> >
> >  #ifndef GSO_MAX_SIZE
> >  #define GSO_MAX_SIZE         65536
> > @@ -157,7 +154,7 @@ struct link_util *get_link_kind(const char *id)
> >               if (strcmp(l->id, id) == 0)
> >                       return l;
> >
> > -     snprintf(buf, sizeof(buf), LIBDIR "/ip/link_%s.so", id);
> > +     snprintf(buf, sizeof(buf), "%s/link_%s.so", get_ip_lib_dir(), id);
> >       dlh = dlopen(buf, RTLD_LAZY);
> >       if (dlh == NULL) {
> >               /* look in current binary, only open once */
> >
>
> What's the use case for needing this? AIUI this is a legacy feature from
> many years ago.
>
> All of the link files are builtin, so this is only useful for out of
> tree modules. iproute2 should not be supporting such an option, so
> really this code should be ripped out, not updated.

I can not agree with your position. iproute2 is a main management
utility for all network interface types, the kernel design supports
new link protocols (via loadable modules), Netlink explicitly supports
link management extensions, so it was a very reasonable decision to
add the support for new link types to ip-link via loadable plugins.

Loadable ip link plugins support is helpful at the initial project
stage as well as for niche protocols, since such feature allows to
introduce new protocol support without forcing users to rebuild
anything. So, ripping out link plugins will make the life of many
people harder without any obvious benefits for anyone else.

As for the patch, it is intended to make developer life easier by
allowing them to focus on development instead of maintaining a fork of
iproute2 source tree. The patch introduces the same functionality to
override plugins loading directory for ip, as we have in tc for a long
time. Even the environment variable name was selected to be similar to
that is used by tc.

-- 
Sergey
