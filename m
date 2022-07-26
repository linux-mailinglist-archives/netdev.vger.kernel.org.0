Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D585581BF4
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 00:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239614AbiGZWFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 18:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiGZWFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 18:05:35 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B688FD11A;
        Tue, 26 Jul 2022 15:05:33 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id e15so19289646edj.2;
        Tue, 26 Jul 2022 15:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eQt6/BLDfWWoSEvNSqGD+0elD2uRjzfpfOppU3TGo8Y=;
        b=i/8GQGGCMNRAPffqp6/BlozDKMEpjmjhBbqc5gDRq4i/u14B83GmAsSqZ03F6mh8wI
         uh5QOq8S2veK4Tf/0u4sl7xMXaSwZEz1XZSaVui+eVxvNtGOeF3H0dYhiJ4sbQnkY1JS
         75VAknKS82mUkxDjBmqp1tS4vZKTw79Me9KoNs0DZo+IEyI3QdgB7INIhD+SrUH8Msv0
         izxL2UJqsg9ibXzrvoyNLWijKlJmsvkSICy1Bdzjke5N8pqlipjBYMpvE6leVb53CEQc
         NQj+XLMRpMXWYpbekaibZX07kV0RTHITPFJBHDTGkRJhUDnw6r6+zsS8A3DO0vWv4sC2
         RLJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eQt6/BLDfWWoSEvNSqGD+0elD2uRjzfpfOppU3TGo8Y=;
        b=b6RTAkAAkrOj0Fryia1VFg/TiEYuFnVBIf+7m8poG472HbZ2LUS44ucP4DctZCCjFp
         TIVi5ZVFBJ0QGUb1LnHe12VChrGGruRIdjPZAZVxkGx2nZSnarO/znC0/G09Rh+2wP2h
         eotjE9yU7Q3LdV8xmz2Jsbkv5mtQK0dPItmJJ3Ctgnt0pt7pK+WuSjhG82KjVsEZNZok
         Fh6vk7UMfkZgm+cYMpEblIccRfueL9jIto6qeqtUhrwZiXfVAiw/Rt9iv5JOb3kFgdth
         /sNNPTbN5zu14Y+S5EPcXYjkAGCxFiyq/WaDChnNAqhWT1u7KwRgKFMhE5AzlaHQMPnR
         bwiA==
X-Gm-Message-State: AJIora/WnCSMo4eAsR+/K5VpQtB7GHrVUb4oCtIkwHMCi7lv+lofb8jc
        M7LHF3eBfuieM87F1+MKQRw9290w06HyrvJ0HGE=
X-Google-Smtp-Source: AGRyM1sm7m7c6x9uLm36/c49v1qQ8S0NMAKm+pPDKtz5n0rkLowtN7RSJbgIthQckShS5A1Bgttwh+SbY7pngcYNb2I=
X-Received: by 2002:a05:6402:5412:b0:435:5997:ccb5 with SMTP id
 ev18-20020a056402541200b004355997ccb5mr19303029edb.167.1658873130692; Tue, 26
 Jul 2022 15:05:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220722205400.847019-1-luiz.dentz@gmail.com> <20220722165510.191fad93@kernel.org>
 <CABBYNZLj2z_81p=q0iSxEBgVW_L3dw8UKGwQKOEDj9fgDLYJ0g@mail.gmail.com>
 <20220722171919.04493224@kernel.org> <CABBYNZJ5-yPzxd0mo4E+wXuEwo1my+iaiW8YOwYP05Uhmtd98Q@mail.gmail.com>
 <20220722175003.5d4ba0e0@kernel.org>
In-Reply-To: <20220722175003.5d4ba0e0@kernel.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 26 Jul 2022 15:05:17 -0700
Message-ID: <CABBYNZ+74ndrzdx=4dGLE6oQbZ2w6SGnUGeS0OSqH6EnND4qJw@mail.gmail.com>
Subject: Re: pull request: bluetooth-next 2022-07-22
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Fri, Jul 22, 2022 at 5:50 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 22 Jul 2022 17:25:57 -0700 Luiz Augusto von Dentz wrote:
> > > > Crap, let me fix them.
> > >
> > > Do you mean i should hold off with pushing or you'll follow up?
> >
> > Ive just fixup the original patch that introduced it, btw how do you
> > run sparse to capture such errors?
>
> We run builds with W=1 C=1 in the CI and then diff the outputs.
> That's pretty noisy so we have a regex which counts number of
> warnings per file, that makes it possible to locate the exact new
> warning. At least most of the time...

Hmm, is there any way to trigger net CI, either that or we need to
duplicate the same test under our CI to avoid these last minute
findings when we are attempting to merge something.

> > > > Yep, that happens when I rebase on top of net-next so I would have to
> > > > redo all the Signed-off-by lines if the patches were originally
> > > > applied by Marcel, at least I don't know of any option to keep the
> > > > original committer while rebasing?
> > >
> > > I think the most common way is to avoid rebasing. Do you rebase to get
> > > rid of revised patches or such?
> >
> > So we don't need to rebase?
>
> No, not usually. After we pull from you, you should pull back from us
> (git pull --ff-only $net-or-net-next depending on the tree you
> targeted), and that's it. The only patches that go into your tree then
> are bluetooth patches, everything else is fed via pulling back from us.
>
> > There were some patches already applied via bluetooth.git so at least
> > I do it to remove them
>
> Normally you'd not apply bluetooth fixes to bluetooth-next, apply
> them to bluetooth and send us a PR. Then once a week we'll merge
> net (containing your fixes) into net-next, at which point you can
> send a bluetooth-next PR and get the fixes into bluetooth-next.
> FWIW from our perspective there's no limit on how often you send PRs.

Are you saying we should be using merge commits instead of rebase then?

> Alternatively you could apply the fixes into bluetooth and then
> merge bluetooth into bluetooth-next. If you never rebase either tree,
> git will be able to figure out that it's the same commit hash even if
> it makes it to the tree twice (once thru direct merge and once via
> net). That said, I believe Linus does not like cross tree merges, i.e.
> merges which are not fast forwards to the downstream tree. So it's
> better to take the long road via bt ->  net -> net-next -> bt-next.

Well I got the impression that merge commits shall be avoided, but
rebase overwrites the committer, so the two option seem to have
drawbacks, well we can just resign on rebase as well provided git
doesn't duplicate Signed-off-by if I use something like exec="git
commit -s --amend".

> > and any possible conflicts if there were
> > changes introduced to the bluetooth directories that can eventually
> > come from some other tree.
>
> Conflicts are not a worry, just let us know in the PR description how
> to resolve them.

Not really following, how can we anticipate a merge conflict if we
don't rebase? With merge strategy it seem that the one pulling needs
to resolve the conflicts rather than the submitter which I think would
lead to bad interaction between subsystems, expect if we do a merge
[-> resolve conflict] -> pull request -> [resolve conflicts ->] merge
which sounds a little too complicated since we have to resolve
conflicts in both directions.

In my opinion rebase strategy is cleaner and is what we recommend for
possible clones of bluetooth-next and bluetooth trees including CI so
possible conflicts are fixed in place rather on the time the trees are
merged.

-- 
Luiz Augusto von Dentz
