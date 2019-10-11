Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E305D471B
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 20:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbfJKSB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 14:01:56 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43449 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728470AbfJKSB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 14:01:56 -0400
Received: by mail-lj1-f194.google.com with SMTP id n14so10660766ljj.10;
        Fri, 11 Oct 2019 11:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XdwB9h96v+QYkQDX1YxlxUnsWei52osLfl6yOYfRoHI=;
        b=JJwL/lGc98fPjNXsuW37YtyQjKr2sKYZbyZQItyXwRkcSDHCY0bEjaJUb4XAw7+LON
         qFFPDarzJYA7aRj8S6Djg/uZTdTXdMY3gfsOCo/GcKE8PW0x+nv+jQ4r+CPO0Ke/pLgy
         nmq3toEYyZahWAs1fJiHI4KEuu0q2AY121irp7lN2HLtM8mMZ+i+D3GcXZwMjpyVJ8rM
         Fl1Jw1fbcOx263yXpePcJpyelaLm8L566qTnPFvR3hckhejYUY056kZEU4XRMODPTfT7
         OpGwELASV8jP2Iw9XeI2rX2HYHJ+5DhvRHAf4/0q6Q/mEIgKdePdesCb341qDj+3AgQz
         Y87w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XdwB9h96v+QYkQDX1YxlxUnsWei52osLfl6yOYfRoHI=;
        b=CovoiUvqVzcI0epHgHlnC5k0YM02Yn9gyM66lyzcr4/9odK3v13gWlIA14UisloCxW
         81tZrHoaXN3lPnNTiGAnUX2g5ER3XnDxys1wXHG91D9htA7cLR3OE7RgGQgQGWqriFgK
         08o0adHz9KpveJkWIenLxcjWOyPM3WDRB93J8dJ9xD0dnAFMPlpcSZ6+yWUNBjFnpB6r
         RChdAaO7pZGvy/jSYMmt9mX3tmsi8HjhQ5ieMoySYniIHZ+bb69IeuEDoK9P2lR8Hkl5
         8+yu8vCkcuPI6tZ9JGjc6V6jvHywzUJ7GnC7fkDnk5BDE2fV7ou5pAiZt4aOwC/8uAdQ
         cdlg==
X-Gm-Message-State: APjAAAVHdUYxXDXuct+lY60fsRqyu3BAzUWLdkNs/X22071NtuUAVSls
        Zlx7Z+EhWNndag+/KF4KqHF2U5oIS6uCOY1F/AM=
X-Google-Smtp-Source: APXvYqwVaUA7oCBc5xvpj+PQwfoY/MvmAjkR7fClTPBR5s5J1pMVup7ak5TL4SFSjd2aW7dmhjgX6bC/i/jADMqPYd4=
X-Received: by 2002:a2e:3a19:: with SMTP id h25mr10164297lja.129.1570816913446;
 Fri, 11 Oct 2019 11:01:53 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1570292505.git.joe@perches.com> <CAHk-=whOF8heTGz5tfzYUBp_UQQzSWNJ_50M7-ECXkfFRDQWFA@mail.gmail.com>
In-Reply-To: <CAHk-=whOF8heTGz5tfzYUBp_UQQzSWNJ_50M7-ECXkfFRDQWFA@mail.gmail.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Fri, 11 Oct 2019 20:01:42 +0200
Message-ID: <CANiq72kDNT6iPxYYNzY_eb3ddWNUEzgg48pOenEBrJXynxsvoA@mail.gmail.com>
Subject: Re: [PATCH 0/4] treewide: Add 'fallthrough' pseudo-keyword
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Joe Perches <joe@perches.com>, linux-sctp@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
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

Hi Linus,

On Fri, Oct 11, 2019 at 6:30 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sat, Oct 5, 2019 at 9:46 AM Joe Perches <joe@perches.com> wrote:
> >
> > Add 'fallthrough' pseudo-keyword to enable the removal of comments
> > like '/* fallthrough */'.
>
> I applied patches 1-3 to my tree just to make it easier for people to
> start doing this. Maybe some people want to do the conversion on their
> own subsystem rather than with a global script, but even if not, this
> looks better as a "prepare for the future" series and I feel that if
> we're doing the "fallthrough" thing eventually, the sooner we do the
> prepwork the better.
>
> I'm a tiny bit worried that the actual conversion is just going to
> cause lots of pain for the stable people, but I'll not worry about it
> _too_ much. If the stable people decide that it's too painful for them
> to deal with the comment vs keyword model, they may want to backport
> these three patches too.

I was waiting for a v2 series to pick it up given we had some pending changes...

Cheers,
Miguel
