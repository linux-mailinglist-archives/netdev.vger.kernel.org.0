Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0155FD4A4F
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 00:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729441AbfJKW0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 18:26:21 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46193 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729428AbfJKW0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 18:26:20 -0400
Received: by mail-lj1-f195.google.com with SMTP id d1so11217025ljl.13;
        Fri, 11 Oct 2019 15:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xmHIYl25n4y/hTcfXXSO/nQ5G/kQTh9kEzA1dV2zubk=;
        b=nqUsqy5Zv5ik/Zj2UcjOrzceCGDWgwxpQFiWSlsq61+ZupecTO4hNZvtjqbCdkPgXx
         jSscEdEO8jLI/1BG2ec4/rPD2vaD3O0sK8zKqbadz4Jt/TNgYUWaPWdyrUIiDJLAKQhE
         4leI/c1m4aOHU8lFwbAMt99/CgnanpbBC/MrdEkph6cXR0KO9E/tKzCbKJT5G2CFFU1g
         2nQpP19/6JzY/IlC4YDP6UUo+HTUc/ecjKqST1CBxpj5MCHimyq/ijA2lQp/YKl07LKP
         lT3UvJtw1DRs4yNs3aiDG8jLvFmKGKtn5nE4G8N1qecE4wXrgcIv4Nj6Ub4vCWOGhJhT
         0sNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xmHIYl25n4y/hTcfXXSO/nQ5G/kQTh9kEzA1dV2zubk=;
        b=Nve2vuNwtvsCAXRVRSTuYfyM2Elvu14W/t+K+ssDdfHQFdPmqaoNiwwNuvBVdhvedB
         o25cUpRTWcoXQvLMIDZQlWz2GpDOtuslJCGtvq05vnoEJs+QFqcOvPtCqKdeGGo8WnD9
         8Z+8VOq87zHcl0BAACBMgrfyBpJKvKTIkgb1STE6+CsoSrgY3aj3JPXSP05B3wyNUcRn
         7m/YMnREkVCm8QK1BrL7sXcB0rIpBHWN+7UWflZlUDr4uyXCq6QYG9G+yw4edDhpZYcI
         BYop76JrbhyOtU0fESO18NGchKaZlOdRPjUPD6jN9rK1x/J1iyXQUynmX8FjC32xVHCt
         rwoA==
X-Gm-Message-State: APjAAAV9L/VdPjX9KeMpO1+qITUrVbp+TpsGaunKSuN5QLfcmvNNjSsD
        K1oaJgxA84csvUQDRy9telQ5uUMF8IQXONTOybQ=
X-Google-Smtp-Source: APXvYqzhY4BBpDOb1XjrGtrPCztOkL7/vfw1DL4ZNsREHKyaPUxwViQwxlLovrTqj8EB0FcekvYwixhBodl7HEwIJ/c=
X-Received: by 2002:a2e:8852:: with SMTP id z18mr10688944ljj.230.1570832777820;
 Fri, 11 Oct 2019 15:26:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1570292505.git.joe@perches.com> <CAHk-=whOF8heTGz5tfzYUBp_UQQzSWNJ_50M7-ECXkfFRDQWFA@mail.gmail.com>
 <CANiq72kDNT6iPxYYNzY_eb3ddWNUEzgg48pOenEBrJXynxsvoA@mail.gmail.com> <201910111506.45AE850D5@keescook>
In-Reply-To: <201910111506.45AE850D5@keescook>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Sat, 12 Oct 2019 00:26:06 +0200
Message-ID: <CANiq72m9bHQZaOjcTr-266Bdy29HBVc8rOp2+szSnbywroNRhQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] treewide: Add 'fallthrough' pseudo-keyword
To:     Kees Cook <keescook@chromium.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>, linux-sctp@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pavel Machek <pavel@ucw.cz>,
        "Gustavo A . R . Silva" <gustavo@embeddedor.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Shawn Landden <shawn@git.icu>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 12, 2019 at 12:08 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Fri, Oct 11, 2019 at 08:01:42PM +0200, Miguel Ojeda wrote:
> > Hi Linus,
> >
> > On Fri, Oct 11, 2019 at 6:30 PM Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > On Sat, Oct 5, 2019 at 9:46 AM Joe Perches <joe@perches.com> wrote:
> > > >
> > > > Add 'fallthrough' pseudo-keyword to enable the removal of comments
> > > > like '/* fallthrough */'.
> > >
> > > I applied patches 1-3 to my tree just to make it easier for people to
> > > start doing this. Maybe some people want to do the conversion on their
> > > own subsystem rather than with a global script, but even if not, this
> > > looks better as a "prepare for the future" series and I feel that if
> > > we're doing the "fallthrough" thing eventually, the sooner we do the
> > > prepwork the better.
> > >
> > > I'm a tiny bit worried that the actual conversion is just going to
> > > cause lots of pain for the stable people, but I'll not worry about it
> > > _too_ much. If the stable people decide that it's too painful for them
> > > to deal with the comment vs keyword model, they may want to backport
> > > these three patches too.
> >
> > I was waiting for a v2 series to pick it up given we had some pending changes...
>
> Hmpf, looks like it's in torvalds/master now. Miguel, most of the changes
> were related to the commit log, IIRC, so that ship has sailed. :( Can the
> stuff in Documentation/ be improved with a follow-up patch, perhaps?

Linus seems to have applied some of the improvements to the commit
messages, but not those to the content (not sure why, since they were
also easy ones). But no worries, we will do those later :)

Cheers,
Miguel
