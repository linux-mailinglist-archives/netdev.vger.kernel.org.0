Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8A2523365
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 14:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242782AbiEKMvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 08:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242783AbiEKMvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 08:51:45 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27D9663EC
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 05:51:43 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id l1so2007623qvh.1
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 05:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GsXGnGW71xdRX9TpipcU/BgXrkcWkUlQ6Hr+Y0283Ws=;
        b=SJKkejdOYKhF2vFLREb+t7eLHhIpRD45lCN4nN5wEWJQugUtw0YzSZkfi22MOUqkJv
         8G1C3Qi4HsXBluNkNm4uTJTXoY8utMjoPUF7Kfi6GlVA5k0Vfc6TMSTt3intwDiqUgJb
         HJDfUeNwkOMenrFH4SNbRVVzV7TMh/U0TT5zw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GsXGnGW71xdRX9TpipcU/BgXrkcWkUlQ6Hr+Y0283Ws=;
        b=wxEXXrOFyx6HhT+FRJ1ESqFdUynIau4XwZ+zh4DVHPdFI7S6fw9jKELtOWq1O4w2wq
         cgpe9JO2j/RnZofjDys1EDfgqjfgkWe6wWXPvmErtfiuvbQM2hxqK9+vzEhg9pP3JOm+
         J38AFQ5NVGz0QXGz/LJ7Om+3RATqNfFN53oRlEq4xFKaX2W0vMhrrDcK7k0ek/AwkzxE
         kyP6sSNbaquZmW3mEjB07u4TmRO1iUHsiw9TloWwvngpB0zI+nx9v/ogjl4MpQ8L2fJS
         75zKQzbo0wNVLdWrwLfTCZLDrdgZs8k7z50kuCQLrJRIm9ZL2RxliSgFOpTT8EW1yv9B
         2XjA==
X-Gm-Message-State: AOAM533QeT+Eq/fxkXIx49k3ZDh5pQnOgouG3ml5f5vjUxQzTKnDS2B0
        HB9Hz6MiDjk+uG47GKyZ3e+dZA==
X-Google-Smtp-Source: ABdhPJyRnJ7iURbc5a5x7qz1EEVZLrS8jDAIwKazBun0PBOtERSyijdUXYqUvqXI5wpy65Lj+y2ElQ==
X-Received: by 2002:a0c:a699:0:b0:45a:b237:e066 with SMTP id t25-20020a0ca699000000b0045ab237e066mr22195445qva.49.1652273502923;
        Wed, 11 May 2022 05:51:42 -0700 (PDT)
Received: from meerkat.local (bras-base-mtrlpq5031w-grc-32-216-209-220-127.dsl.bell.ca. [216.209.220.127])
        by smtp.gmail.com with ESMTPSA id h26-20020ac8505a000000b002f39b99f672sm1043718qtm.12.2022.05.11.05.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 05:51:42 -0700 (PDT)
Date:   Wed, 11 May 2022 08:51:40 -0400
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mie@igel.co.jp
Subject: Re: [GIT PULL] virtio: last minute fixup
Message-ID: <20220511125140.ormw47yluv4btiey@meerkat.local>
References: <20220510082351-mutt-send-email-mst@kernel.org>
 <CAHk-=wjPR+bj7P1O=MAQWXp0Mx2hHuNQ1acn6gS+mRo_kbo5Lg@mail.gmail.com>
 <YnrxTMVRtDnGA/EK@dev-arch.thelio-3990X>
 <CAHk-=wgAk3NEJ2PHtb0jXzCUOGytiHLq=rzjkFKfpiuH-SROgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wgAk3NEJ2PHtb0jXzCUOGytiHLq=rzjkFKfpiuH-SROgA@mail.gmail.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 04:50:47PM -0700, Linus Torvalds wrote:
> > For what it's worth, as someone who is frequently tracking down and
> > reporting issues, a link to the mailing list post in the commit message
> > makes it much easier to get these reports into the right hands, as the
> > original posting is going to have all relevant parties in one location
> > and it will usually have all the context necessary to triage the
> > problem.
> 
> Honestly, I think such a thing would be trivial to automate with
> something like just a patch-id lookup, rather than a "Link:".

I'm not sure that's quite reliable, and I'm speaking from experience of
running git-patchwork-bot, which attempts to match commits to patches.
Patch-id has these important disadvantages:

1. git-patch-id can be fragile: if the maintainer changes things like add
   curly braces, rename a variable, or edit a code comment for clarity, the
   patch-id stops matching. This happens routinely with git-patchwork-bot,
   and patchwork uses an even laxer algorithm than git-patch-id. In fact, I
   had to hack git-patchwork-bot to fall back on Link: tags to match by
   message-id to address some of the maintainers' complaints.

2. git-patch-id doesn't include author/date/commit message: which can actually
   be important for establishing provenance and attribution and can confuse
   automation. E.g. an author submits a patch as part of a large series, gets
   told to break it apart, then submits it as part of a different series.
   Automated processes trying to match commits to submissions won't be able to
   tell from which series the commit came from.

Cregit folks (cregit.linuxsources.org) have encountered all of these and I
know from talking to them that they are quite happy to have a way to match
commit provenance to the exact messages in the archives.

> Wouldn't it be cool if you had some webby interface to just go from
> commit SHA1 to patch ID to a lore.kernel.org lookup of where said
> patch was done?

Yes, it's https://cregit.linuxsources.org/ and it's... okay. :) It certainly
doesn't manage to match all commits to patches despite having access to all of
lore.kernel.org archives.

> My argument here really is that "find where this commit was posted" is
> 
>  (a) not generally the most interesting thing
> 
>  (b) doesn't even need that "Link:" line.
> 
> but what *is* interesting, and where the "Link:" line is very useful,
> is finding where the original problem that *caused* that patch to be
> posted in the first place.

I think the disconnect here is that you're approaching this from the
perspective of a human being, while what many want is a dumb and reliable way
to match commits to ML submissions, which will allow improving unattended
automation.

> So that whole "searching is often an option" is true for pretty much
> _any_ Link:, but I think that for the whole "original submission" it's
> so mindless and can be automated that it really doesn't add much real
> value at all.

Believe me, I've tried, and I really, really like having a fool-proof way to
match commits directly to the exact ML submissions. :( Even a 99%-reliable
fuzzy matching algorithm has enough of a failure rate that causes maintainers
to get annoyed -- I have many "git-patchwork-bot missed this commit"
complaints in the queue to prove this.

I think we should simply disambiguate the trailer added by tooling like b4.
Instead of using Link:, it can go back to using Message-Id, which is already
standard with git -- it's trivial for git.kernel.org to link them to
lore.kernel.org.

Before:

    Signed-off-by: Main Tainer <main.tainer@linux.dev>
    Link: https://lore.kernel.org/r/CAHk-=wgAk3NEJ2PHtb0jXzCUOGytiHLq=rzjkFKfpiuH-SROgA@mail.gmail.com

After:

    Signed-off-by: Main Tainer <main.tainer@linux.dev>
    Message-Id: <CAHk-=wgAk3NEJ2PHtb0jXzCUOGytiHLq=rzjkFKfpiuH-SROgA@mail.gmail.com>

This would allow people to still use Link: for things like linking to actual
ML discussions. I know this pollutes commits a bit, but I would argue that
this is a worthwhile trade-off that allows us to improve our automation and
better scale maintainers.

-K
