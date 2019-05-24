Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 111FF29DC5
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 20:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbfEXSLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 14:11:10 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39970 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbfEXSLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 14:11:10 -0400
Received: by mail-qk1-f193.google.com with SMTP id q197so8847170qke.7;
        Fri, 24 May 2019 11:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0dw7iCdrq5/IWGGfeL9OdT+fgaA92v5lwpPh6renQrQ=;
        b=I/9+lATeNTr64jB6Vv4bYFBf5k4otwta7n+Fg/IK+kwTYqShKUA83nUV444/J40MRp
         X5XDEcX4BwLtILlNAUSfEnsZQUYyU8s5Qr7pOoq/XoBNdzUPFvCYFaRByAYbn8VUwzQY
         oXP1T4GuVj2VODxRNiX43O2AaCZU/dlElektvvCketkb1GTguHO1LqOZD64WcYm3kp5b
         8nYp4mDKkQZYJikwkcMIckcXCd24hdWUGJwo64GlLv29F0VqG308vn0DQCjlWNdr3yoH
         aC+c4uTlbtmd7pMZCq6hauBwLCp2yXkgIXC1Q3CYZAtk8Rj0ccnni7C2wbCQGOAKZ2vh
         cpjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0dw7iCdrq5/IWGGfeL9OdT+fgaA92v5lwpPh6renQrQ=;
        b=RDGpvXUw8eNu+yw8Vb9LfxyUf0M8jSnweyHgoqeTKQgoIT7EWu6Wl9oy2B7aZskIF7
         5arSxkOBTT4mMWRCILpr4v0sQ4B1ieT3+PbWNnseJtkLQInsDFafR7aa8gCuOaXZYZlO
         NaaFRKz4lBXfstvJc0USYfsyE7fd+AO4s4xc92v6LMHtmonFgolEbU5WNctUiacytOdc
         u6XRhToFDLRbdZr7Uh2A/D8S4zKqAmV2XVRKXmOsmqEGiNTnYbaAKYShrYYsXQREcmAS
         L0SoB6eifxVwS/vnUVHIC268G96rpiMPzBbA3A5Jm7G4UtDBoXNL+DWSlOsFvg6+tsdN
         zF+A==
X-Gm-Message-State: APjAAAWX43jAdav4vkheP05HLSrMe0BT3UMiK3uJyI+6+jpzXts0Itsl
        iElZyXWMFskiVSSnHYE5gkooisPvpEuZjVue4Vs=
X-Google-Smtp-Source: APXvYqxUwNWbqkf9RyjeSJfWTjghFhqiEU8NecvXdpSbXkW64z6VNZgjiIv2ZEqhC994LNHFj/pO4zfitvF0izujMVw=
X-Received: by 2002:a37:ac11:: with SMTP id e17mr75312434qkm.339.1558721468961;
 Fri, 24 May 2019 11:11:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190523204222.3998365-1-andriin@fb.com> <20190523204222.3998365-13-andriin@fb.com>
 <bf418594-0442-fe89-c86b-11d7e5269047@netronome.com>
In-Reply-To: <bf418594-0442-fe89-c86b-11d7e5269047@netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 24 May 2019 11:10:57 -0700
Message-ID: <CAEf4BzbfvV6HQ-NZQEk0yxNL75JWKC6nHzofOk6BkfO7EPVStQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 12/12] bpftool: update bash-completion w/ new
 c option for btf dump
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 2:15 AM Quentin Monnet
<quentin.monnet@netronome.com> wrote:
>
> 2019-05-23 13:42 UTC-0700 ~ Andrii Nakryiko <andriin@fb.com>
> > Add bash completion for new C btf dump option.
> >
> > Cc: Quentin Monnet <quentin.monnet@netronome.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/bpf/bpftool/bash-completion/bpftool | 25 +++++++++++++++++++----
> >  1 file changed, 21 insertions(+), 4 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
> > index 50e402a5a9c8..5b65e0309d2a 100644
> > --- a/tools/bpf/bpftool/bash-completion/bpftool
> > +++ b/tools/bpf/bpftool/bash-completion/bpftool
> > @@ -638,11 +638,28 @@ _bpftool()
> >                              esac
> >                              return 0
> >                              ;;
> > +                        format)
> > +                            COMPREPLY=( $( compgen -W "c raw" -- "$cur" ) )
> > +                            ;;
> >                          *)
> > -                            if [[ $cword == 6 ]] && [[ ${words[3]} == "map" ]]; then
> > -                                 COMPREPLY+=( $( compgen -W 'key value kv all' -- \
> > -                                     "$cur" ) )
> > -                            fi
> > +                            # emit extra options
> > +                            case ${words[3]} in
> > +                                id|file)
> > +                                    if [[ $cword > 4 ]]; then
>
> Not sure if this "if" is necessary. It seems to me that if $cword is 4
> then we are just after "id" or "file" in the command line, in which case
> we hit previous cases and never reach this point?

Yep, you are right, removed.

>
> Also, reading the completion code I wonder, do we have completion for
> BTF ids? It seems to me that we have nothing proposed to complete
> "bpftool btf dump id <tab>". Any chance to get that in a follow-up patch?

We currently don't have a way to iterate all BTFs in a system (neither
in bpftool, nor in libbpf, AFAICT), but I can do that based on btf_id
field, dumped as part of `bpftool prog list` command. Would that work?
I'll post that as a separate patch.

>
> > +                                        _bpftool_once_attr 'format'
> > +                                    fi
> > +                                    ;;
> > +                                map|prog)
> > +                                    if [[ ${words[3]} == "map" ]] && [[ $cword == 6 ]]; then
> > +                                        COMPREPLY+=( $( compgen -W "key value kv all" -- "$cur" ) )
> > +                                    fi
> > +                                    if [[ $cword > 5 ]]; then
>
> Same remark on the "if", I do not believe it is necessary?

Yep, removed.

>
> > +                                        _bpftool_once_attr 'format'
> > +                                    fi
> > +                                    ;;
> > +                                *)
> > +                                    ;;
> > +                            esac
> >                              return 0
> >                              ;;
> >                      esac
> >
>
