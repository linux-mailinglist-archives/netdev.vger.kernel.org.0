Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60A225D041
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 15:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfGBNLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 09:11:38 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34193 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfGBNLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 09:11:38 -0400
Received: by mail-lj1-f193.google.com with SMTP id p17so16861223ljg.1
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 06:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7VQYnJeRaUpaFN98cxAYusedIKYgOATGNhqZf+qw9mU=;
        b=ZL9cB1trsj6nxWF843JdW2T4Loalp12aKWnqR9OPkQrXw4WrEDbq7PcarfWEF2vaXw
         bM6bv2V5Zc6g/7uD3c8h/2jvG7QDZPTTCTTyYYxw5Z4UPqaPcSIk4dkjxjzr3t4NrYH2
         ebTv4TorBjdZgOQ6NmaJHAp/C+2JwHVC34dq2hxLRJu0T2x9ynJ055EwrdW5xvZdYTqR
         7KUJoFWPIcY/unc0vtwJpV/wJBZBfY/MHvi33eZPcMwsCIfL/bPMyyeA7zlpnMNonH8z
         ZnjLlYEeRhxMMrnMHGLPjHrAXNIpy2f4k7A3/3FcEiYTF9xAZumwQWs0jeOEWKZW9fYt
         3RLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7VQYnJeRaUpaFN98cxAYusedIKYgOATGNhqZf+qw9mU=;
        b=iPKItufhc7F0XWF3Mrrohl2xLNw88mdqKWEZTopMeAyK4/vdjh8wfz4mw1XcVSveZI
         bCTc+8XLbV7oqxWKjSQ79yoRmIG0v0TRYDZux818VBTW2C7adZqePZBesnbB6WehJmMt
         +iFJbnrUawfjbIsF0Lsx6LZBKnyd7BFzzy5Mf2EVejJX8OhKEGbn3de9vJOnuZK+zw1E
         /se7uhxt/0dqxngR8GlgtCbf5UXAzH/2TJMEMafJ2G+GYJQcp02D52qMVHCjk1XIV4cc
         KR/uIOB4VmCYw8/aDZlDfUYwhgiA7KpyzipwMKs684AiTX4M/R8TBtjbqefTwNHgnkHq
         /UUg==
X-Gm-Message-State: APjAAAXpUOpvuNcmX2o94VZOEJMc6nG629WIXrUd1gHy7KvqP1tYf/St
        cESj8nxy5t9cBD9GMlNcVh7yOkGg0JRUl/7D9ro=
X-Google-Smtp-Source: APXvYqytGgCBRN4vhn8XcMlwch1bbY4k4941KC8j8V0z5F/DTN1qLS6c5+ZkjJxisWPNkSO0vuxQoKBjR7vqP6asrKQ=
X-Received: by 2002:a2e:9dca:: with SMTP id x10mr15829253ljj.17.1562073096625;
 Tue, 02 Jul 2019 06:11:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAGWhr0AOApbf4-4RJHibUaKa8MmOfGS+uH6Rx4x1PQGZXRbCOQ@mail.gmail.com>
 <CAGWhr0Bg3mnaddCg=RexXgUGeP5EyqiU63n_c9NAgyfx-wpJ2Q@mail.gmail.com>
 <CAPpH65x3_adKR5DfBznwg-6k=ZrTE3EZwGcKziiZx6hqcHkgbA@mail.gmail.com> <CAPpH65z28sN67-4mVvcAt_eX7Q=qtK07OpeABi4-BsTxAGs0ag@mail.gmail.com>
In-Reply-To: <CAPpH65z28sN67-4mVvcAt_eX7Q=qtK07OpeABi4-BsTxAGs0ag@mail.gmail.com>
From:   Ji Jianwen <jijianwen@gmail.com>
Date:   Tue, 2 Jul 2019 21:11:25 +0800
Message-ID: <CAGWhr0CmF1Cz0cFE82k=vXCv7-=5Rxd97JcEn173ufU-UbQtxg@mail.gmail.com>
Subject: Re: [iproute2] Can't create ip6 tunnel device
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It works for 'add', but not for 'del'.
ip -6 tunnel del my_ip6ip6 mode ip6ip6 remote 2001:db8:ffff:100::2
local 2001:db8:ffff:100::1 hoplimit 1 tclass 0x0 dev eno1
delete tunnel "eno1" failed: Operation not supported

On Tue, Jul 2, 2019 at 7:18 PM Andrea Claudi <aclaudi@redhat.com> wrote:
>
> On Tue, Jul 2, 2019 at 12:55 PM Andrea Claudi <aclaudi@redhat.com> wrote:
> >
> > On Tue, Jul 2, 2019 at 12:27 PM Ji Jianwen <jijianwen@gmail.com> wrote:
> > >
> > > It seems this issue was introduced by commit below, I am able to run
> > > the command successfully mentioned at previous mail without it.
> > >
> > > commit ba126dcad20e6d0e472586541d78bdd1ac4f1123 (HEAD)
> > > Author: Mahesh Bandewar <maheshb@google.com>
> > > Date:   Thu Jun 6 16:44:26 2019 -0700
> > >
> > >     ip6tunnel: fix 'ip -6 {show|change} dev <name>' cmds
> > >
> >
> > From what I can see, before this commit we have in p->name the tunnel
> > iface name (in Jianwen example, ip6tnl1), while after this p->name
> > contains the iface name specified after "dev".
> > Probably the strlcpy() should be limited to the {show|change} cases?
> >
> > Regards,
> > Andrea
> >
> > > On Tue, Jul 2, 2019 at 2:53 PM Ji Jianwen <jijianwen@gmail.com> wrote:
> > > >
> > > > Hello  there,
> > > >
> > > > I got error when creating ip6 tunnel device on a rhel-8.0.0 system.
> > > >
> > > > Here are the steps to reproduce the issue.
> > > > # # uname -r
> > > > 4.18.0-80.el8.x86_64
> > > > # dnf install -y libcap-devel bison flex git gcc
> > > > # git clone git://git.kernel.org/pub/scm/network/iproute2/iproute2.git
> > > > # cd iproute2  &&  git log --pretty=oneline --abbrev-commit
> > > > d0272f54 (HEAD -> master, origin/master, origin/HEAD) devlink: fix
> > > > libc and kernel headers collision
> > > > ee09370a devlink: fix format string warning for 32bit targets
> > > > 68c46872 ip address: do not set mngtmpaddr option for IPv4 addresses
> > > > e4448b6c ip address: do not set home option for IPv4 addresses
> > > > ....
> > > >
> > > > # ./configure && make && make install
> > > > # ip -6 tunnel add ip6tnl1 mode ip6ip6 remote 2001:db8:ffff:100::2
> > > > local 2001:db8:ffff:100::1 hoplimit 1 tclass 0x0 dev eno1   --->
> > > > please replace eno1 with the network card name of your system
> > > > add tunnel "ip6tnl0" failed: File exists
> > > >
> > > > Please help take a look. Thanks!
> > > >
> > > > Br,
> > > > Jianwen
>
> Jianwen, can you please check if this patch solves your issue?
>
> --- a/ip/ip6tunnel.c
> +++ b/ip/ip6tunnel.c
> @@ -298,7 +298,7 @@ static int parse_args(int argc, char **argv, int
> cmd, struct ip6_tnl_parm2 *p)
>                 p->link = ll_name_to_index(medium);
>                 if (!p->link)
>                         return nodev(medium);
> -               else
> +               else if (cmd != SIOCADDTUNNEL)
>                         strlcpy(p->name, medium, sizeof(p->name));
>         }
>         return 0;
>
> Thanks in advance!
