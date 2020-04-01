Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F25C19B64E
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 21:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732651AbgDATOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 15:14:15 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:37596 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732314AbgDATOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 15:14:14 -0400
Received: by mail-pj1-f67.google.com with SMTP id k3so467510pjj.2
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 12:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wNYVdF5491dP8rMRSZ9Zg0VHFbTIYSk256yUrM73mAw=;
        b=o3klgpKgVeN3pY/ZLaoDGCkpGyHv17CcfbYzgNt1LZpo6ooacRjeKKa8ZRvfhpAmGI
         2Z8GZJpjM9LqGfIrTsqlchGqcKVTaIGzk3IUFGy1WhKEkhPRGq79L8bPmJrStEKmZ+rp
         ARK/hZZvRMSWYOQxvSo1MWeR2KfXL11/Ce+Qxn3RQxq+dX18dtZaneP8u/mg+cC+aVzm
         +k6GcoKHzQefZdC2Ybjp0k9v2xrlHDa5V5rt4+gzLz3/AoumEF4ThJq2vVvpQ4dR8zk5
         FE5r8mAu5RK4t/y9RHJgCy7XtREkcn54LAxG/Yy72rriDZjfG5lvQseQIE0AKLYOQzRU
         bOnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wNYVdF5491dP8rMRSZ9Zg0VHFbTIYSk256yUrM73mAw=;
        b=fHdmg3Z87QSx00lUBmAPtP/lENtCADIupnBY4XpKKgMoe6/aBYux5AksQCzEzD2en/
         XItGnIu4BItILZF08ORis1T41HZt8toznjYhtAUQqZ62pd+ZI/5+miWerkUlOSoLsRbG
         U1dkYPLvOxna7OLOncMrLHOhpHf25N6RbWFjOx8pBT5c26nZgvWZLE4a9P8i0cWb6HuC
         27PxwjPpdlsH69Yy87U8kKNpMOMxVImMqfoaEfkFEHm0340a7QS/30bdWF5uqxRem+/K
         FIcuXBhoRT0/6uWf38Oruo2xl3FG7v2QY420Ymra3tvjDdS2PKohUgAzxROkYVKMR+ro
         5d2A==
X-Gm-Message-State: AGi0PuaDPQ1QxRIo+Sl6lZFfkkQ3d7keI/FnHlQ7sZMrIi/H5YDaXa3k
        ePodrzqZRD/BNsaMW5403i1LFnA4BbzmIMm/3nCWxA==
X-Google-Smtp-Source: APiQypL3wM4eAJZDNhs9q7/dStOCkTeIjs+qlAXGrj4Pz4d9g/PeMkx23sj9tEw/nBoi3d4B5YW7fwy2g0TSsT/TKiQ=
X-Received: by 2002:a17:90a:c08c:: with SMTP id o12mr1413488pjs.27.1585768451078;
 Wed, 01 Apr 2020 12:14:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200311024240.26834-1-elder@linaro.org> <20200401173515.142249-1-ndesaulniers@google.com>
 <3659efd7-4e72-6bff-5657-c1270e8553f4@linaro.org>
In-Reply-To: <3659efd7-4e72-6bff-5657-c1270e8553f4@linaro.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 1 Apr 2020 12:13:59 -0700
Message-ID: <CAKwvOdn7TpsZJ70mRiQARJc9Fy+364PXSAiPnSpc_M9pOaXjGw@mail.gmail.com>
Subject: Re: [PATCH v3] bitfield.h: add FIELD_MAX() and field_max()
To:     Alex Elder <elder@linaro.org>
Cc:     Maxim Kuvyrkov <maxim.kuvyrkov@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 1, 2020 at 11:24 AM Alex Elder <elder@linaro.org> wrote:
>
> On 4/1/20 12:35 PM, Nick Desaulniers wrote:
> >> Define FIELD_MAX(), which supplies the maximum value that can be
> >> represented by a field value.  Define field_max() as well, to go
> >> along with the lower-case forms of the field mask functions.
> >>
> >> Signed-off-by: Alex Elder <elder@linaro.org>
> >> Acked-by: Jakub Kicinski <kuba@kernel.org>
> >> ---
> >> v3: Rebased on latest netdev-next/master.
> >>
> >> David, please take this into net-next as soon as possible.  When the
> >> IPA code was merged the other day this prerequisite patch was not
> >> included, and as a result the IPA driver fails to build.  Thank you.
> >>
> >>   See: https://lkml.org/lkml/2020/3/10/1839
> >>
> >>                                      -Alex
> >
> > In particular, this seems to now have regressed into mainline for the 5.7
> > merge window as reported by Linaro's ToolChain Working Group's CI.
> > Link: https://github.com/ClangBuiltLinux/linux/issues/963
>
> Is the problem you're referring to the result of a build done
> in the midst of a bisect?
>
> The fix for this build error is currently present in the
> torvalds/linux.git master branch:
>     6fcd42242ebc soc: qcom: ipa: kill IPA_RX_BUFFER_ORDER

Is that right? That patch is in mainline, but looks unrelated to what
I'm referring to.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6fcd42242ebcc98ebf1a9a03f5e8cb646277fd78
From my github link above, the issue I'm referring to is a
-Wimplicit-function-declaration warning related to field_max.
6fcd42242ebc doesn't look related.

>
> I may be mistaken, but I believe this is the same problem I discussed
> with Maxim Kuvyrkov this morning.  A different build problem led to
> an automated bisect, which conluded this was the cause because it
> landed somewhere between the initial pull of the IPA code and the fix
> I reference above.

Yes, Maxim runs Linaro's ToolChain Working Group (IIUC, but you work
there, so you probably know better than I do), that's the CI I was
referring to.

I'm more concerned when I see reports of regressions *in mainline*.
The whole point of -next is that warnings reported there get fixed
BEFORE the merge window opens, so that we don't regress mainline.  Or
we drop the patches in -next.
-- 
Thanks,
~Nick Desaulniers
