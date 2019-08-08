Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1B886B81
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 22:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404651AbfHHU2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 16:28:14 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:45275 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404270AbfHHU2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 16:28:14 -0400
Received: by mail-yb1-f195.google.com with SMTP id s41so12467310ybe.12
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 13:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s2Yzt60YPDszgx+1lnxEpubVo4ZoPk+hqH259IqyG+g=;
        b=t6KuCe5b4fmZawV5FrNKydpyKVEZ3usxqyRzOvXVghCncJwUJQkkw8a/CPNhGbsuKv
         EA0zjHWcFtEZ/t6WC157tUSiAdoGuCz3PpiXPpdkeKxak7wCYcIfii+pBZ3hMRysWCiJ
         zT4N00cL/UT2O0PuU/IvZNC8cyFsTVIVDR/sS4qq5vFpbwEAXEmMpZRp+TeMcpOfhWTL
         e9xfAMOUA3vvEzm8heA9Lss1tdQLdpPJFpdlzXtNs/fwh/vO6IEgTEperWjAnPNOYtaK
         t8xoN7iZx94VoUfZu67SCY1TcenxyJD3PFLVQkK65WnztJ3Ih9O+oP31BqiKkp0tO9lT
         7Pvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s2Yzt60YPDszgx+1lnxEpubVo4ZoPk+hqH259IqyG+g=;
        b=DNbk2ClUyP3SihxxqSXnO6widEdGQWOZ+k9mDUd0fjGpZ/ttNn2ncwIeDmtMz0DPhR
         FjmqG/0JV5TNljM+T9EL0nRVVJUNc2XVHXUwxa7aAWefVDmYGdwzgmuQ0JSrgL+ohDYd
         kloeg+Qt9o+L2Ge12a7gvnhMPaWkS48XL8B9W14h11pMAA4peU1Oh9rUUjAYxMd5tMRA
         0B/90BkQynjmpZrpk2OTC1qhxDVCrXBXd2rgXGg6PAxFap7YO3gckmkiQlkHW/CuDX4B
         XjQEZGWOlUIc3td7vXTse2s4hERErtFlcmce0bA3MXMKvNxNdm4NozNdqH9QAm8B1w+F
         HJ2w==
X-Gm-Message-State: APjAAAVjRVEkUK7BTlhD7LZyHU4PXjftXTY0D86i9HiUeBbTl1FoH5Ej
        SoJncWmfKI2uLNCq+NbYGcRP2gxBbKIKVCl4fA==
X-Google-Smtp-Source: APXvYqw8M/gu27s49/+krhVXq+o8dlc3aAqquwxx2I4pNDuJQh1MJ0nKqlmNRZxZc7MJ0xIhvxotXJhAs278wwnKZdI=
X-Received: by 2002:a25:9784:: with SMTP id i4mr12770263ybo.9.1565296093716;
 Thu, 08 Aug 2019 13:28:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190807022509.4214-1-danieltimlee@gmail.com> <20190807022509.4214-5-danieltimlee@gmail.com>
 <1cc16243-ad5a-87f3-7727-31a58599bf04@netronome.com>
In-Reply-To: <1cc16243-ad5a-87f3-7727-31a58599bf04@netronome.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Fri, 9 Aug 2019 05:28:02 +0900
Message-ID: <CAEKGpzgw9sVDBe3n=NAiRC=C4F9Z38i6XAJTfewyo2foUB00kA@mail.gmail.com>
Subject: Re: [v3,4/4] tools: bpftool: add documentation for net attach/detach
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 9, 2019 at 1:48 AM Quentin Monnet
<quentin.monnet@netronome.com> wrote:
>
> 2019-08-07 11:25 UTC+0900 ~ Daniel T. Lee <danieltimlee@gmail.com>
> > Since, new sub-command 'net attach/detach' has been added for
> > attaching XDP program on interface,
> > this commit documents usage and sample output of `net attach/detach`.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> >  .../bpf/bpftool/Documentation/bpftool-net.rst | 51 +++++++++++++++++--
> >  1 file changed, 48 insertions(+), 3 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/Documentation/bpftool-net.rst b/tools/bpf/bpftool/Documentation/bpftool-net.rst
> > index d8e5237a2085..4ad1a380e186 100644
> > --- a/tools/bpf/bpftool/Documentation/bpftool-net.rst
> > +++ b/tools/bpf/bpftool/Documentation/bpftool-net.rst
> > @@ -15,17 +15,22 @@ SYNOPSIS
> >       *OPTIONS* := { [{ **-j** | **--json** }] [{ **-p** | **--pretty** }] }
> >
> >       *COMMANDS* :=
> > -     { **show** | **list** } [ **dev** name ] | **help**
> > +     { **show** | **list** | **attach** | **detach** | **help** }
> >
> >  NET COMMANDS
> >  ============
> >
> > -|    **bpftool** **net { show | list } [ dev name ]**
> > +|    **bpftool** **net { show | list }** [ **dev** *name* ]
> > +|    **bpftool** **net attach** *ATTACH_TYPE* *PROG* **dev** *name* [ **overwrite** ]
> > +|    **bpftool** **net detach** *ATTACH_TYPE* **dev** *name*
>
> Nit: Could we have "name" in capital letters (everywhere in the file),
> to make this file consistent with the formatting used for
> bpftool-prog.rst and bpftool-map.rst?
>

I'll update all "name" with capital "NAME" at next version of patch.

> >  |    **bpftool** **net help**
> > +|
> > +|    *PROG* := { **id** *PROG_ID* | **pinned** *FILE* | **tag** *PROG_TAG* }
> > +|    *ATTACH_TYPE* := { **xdp** | **xdpgeneric** | **xdpdrv** | **xdpoffload** }
> >
> >  DESCRIPTION
> >  ===========
> > -     **bpftool net { show | list } [ dev name ]**
> > +     **bpftool net { show | list }** [ **dev** *name* ]
> >                    List bpf program attachments in the kernel networking subsystem.
> >
> >                    Currently, only device driver xdp attachments and tc filter
> > @@ -47,6 +52,18 @@ DESCRIPTION
> >                    all bpf programs attached to non clsact qdiscs, and finally all
> >                    bpf programs attached to root and clsact qdisc.
> >
> > +     **bpftool** **net attach** *ATTACH_TYPE* *PROG* **dev** *name* [ **overwrite** ]
> > +                  Attach bpf program *PROG* to network interface *name* with
> > +                  type specified by *ATTACH_TYPE*. Previously attached bpf program
> > +                  can be replaced by the command used with **overwrite** option.
> > +                  Currently, *ATTACH_TYPE* only contains XDP programs.
>
> Other nit: "ATTACH_TYPE only contains XDP programs" sounds odd to me.
> Could we maybe phrase this something like: "Currently, only XDP-related
> modes are supported for ATTACH_TYPE"?
>
> Also, could you please provide a brief description of the different
> attach types? In particular, explaining what "xdp" alone stands for
> might be useful.
>

I'll replace the phrase and add brief description about the attach types.

> Thanks,
> Quentin
>
> > +
> > +     **bpftool** **net detach** *ATTACH_TYPE* **dev** *name*
> > +                  Detach bpf program attached to network interface *name* with
> > +                  type specified by *ATTACH_TYPE*. To detach bpf program, same
> > +                  *ATTACH_TYPE* previously used for attach must be specified.
> > +                  Currently, *ATTACH_TYPE* only contains XDP programs.

Thank you for taking your time for the review.
