Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 681102D2420
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 08:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgLHHP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 02:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbgLHHP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 02:15:27 -0500
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7AB6C061793;
        Mon,  7 Dec 2020 23:14:41 -0800 (PST)
Received: by mail-vs1-xe35.google.com with SMTP id h6so9017022vsr.6;
        Mon, 07 Dec 2020 23:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yAIRQpWcPYERyUARIHqLewt4T2ldrkluRV0hMLs/Nc4=;
        b=mu34bA2fFmZad33SuAX47EjeHSxL6w6Lz5RBTKx3M7YqMZGkeSfixtDJRxgzEfhKWB
         CbSXUGK9malduOFSPM5S8/YeJ51BoF3key1kBiDr4L9XT2pRAyCEffONYVBnVlszoArh
         4PlXQJOB0B9Ngjz4GnDZSmHimRjj0uQBmWRDWY7ebcenIEmpMW56xHwPdIW36QLgxRWg
         g9One/SAOCOP56PCCmYEP1+Aiyfh5JhgWeCayPI9kXyi73HPmmLFycUCmyZGQnJ68rmD
         DCsPkUbf/2naZr0r4IBtqdXkPeMhuLyIiTknlMp5Djqhkn71k86pVTQlZclcZeebIOg0
         IpKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yAIRQpWcPYERyUARIHqLewt4T2ldrkluRV0hMLs/Nc4=;
        b=cE51ME5DCKtNanYRhbaeQ5qXvnh1kAXbjAGrpYlLihH6Tv1mghi1FwovyIeuDkmHFq
         hD6OCdrIsPp+hkmKlH+SWKvgrjs/4et25Ejtc8eJwYepyXhNg/uZXEWwrPaxy/IFr/OU
         luc/eqYl9Z8djSiWeJytskboA5XLJkJcZeN0/7xR4o1p+x42L2sEaO3KWBVw7SlHybJ+
         XbeKcRs+NNV9KB4Xn6n5r/FnDw63fSuGniyunPgLLOtlt5w5gUkAak/+W8BivDtZQ/qd
         sCTtia2XODoubOMUKsfTdd+eQBWt759InrEevFbPPONTvULvqb5pXr4b4kJ9O9WDenK/
         quxQ==
X-Gm-Message-State: AOAM530iJoP+fFlxOsng/QEoqr/hXPka+AleSoyaQj6P6T7nml/JaHez
        iEhp5suj2mclLv2Cit2MYEB64WimoRz7YYbIJ1I=
X-Google-Smtp-Source: ABdhPJxkv7hbAYUg1e03/wOpxrW6RdfTu/STxJobIs/eu4fcILUOeE4BOLOIxWTRF/c3PK/OczJbB1Ujm6SCvvaSzwQ=
X-Received: by 2002:a67:f519:: with SMTP id u25mr4232725vsn.39.1607411680771;
 Mon, 07 Dec 2020 23:14:40 -0800 (PST)
MIME-Version: 1.0
References: <20201203185732.9CFA5C433ED@smtp.codeaurora.org>
 <20201204111715.04d5b198@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <87tusxgar5.fsf@codeaurora.org> <CA+ASDXNT+uKLLhTV0Nr-wxGkM16_OkedUyoEwx5FgV3ML9SMsQ@mail.gmail.com>
 <20201207121029.77d48f2c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201207121029.77d48f2c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Emmanuel Grumbach <egrumbach@gmail.com>
Date:   Tue, 8 Dec 2020 09:14:29 +0200
Message-ID: <CANUX_P2MhdZNCoMsvaQNVO4x7hmuzxdGH_4MwWON4i9abAZRPg@mail.gmail.com>
Subject: Re: pull-request: wireless-drivers-next-2020-12-03
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 7, 2020 at 10:14 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 7 Dec 2020 11:35:53 -0800 Brian Norris wrote:
> > On Mon, Dec 7, 2020 at 2:42 AM Kalle Valo <kvalo@codeaurora.org> wrote:
> > > Jakub Kicinski <kuba@kernel.org> writes:
> > > > On Thu,  3 Dec 2020 18:57:32 +0000 (UTC) Kalle Valo wrote:
> > > > There's also a patch which looks like it renames a module parameter.
> > > > Module parameters are considered uAPI.
> > >
> > > Ah, I have been actually wondering that if they are part of user space
> > > API or not, good to know that they are. I'll keep an eye of this in the
> > > future so that we are not breaking the uAPI with module parameter
> > > changes.
> >
> > Is there some reference for this rule (e.g., dictate from on high; or
> > some explanation of reasons)? Or limitations on it? Because as-is,
> > this sounds like one could never drop a module parameter, or remove
> > obsolete features.
>
> TBH its one of those "widely accepted truth" in networking which was
> probably discussed before I started compiling kernels so I don't know
> the full background. But it seems pretty self-evident even without
> knowing the casus that made us institute the rule.
>
> Module parameters are certainly userspace ABI, since user space can
> control them either when loading the module or via sysfs.
>
> > It also suggests that debug-related knobs (which
> > can benefit from some amount of flexibility over time) should go
> > exclusively in debugfs (where ABI guarantees are explicitly not made),
> > even at the expense of usability (dropping a line into
> > /etc/modprobe.d/ is hard to beat).
>
> Indeed, debugfs seems more appropriate.

I don't think that a module parameter and a debugfs knob are
technically equivalent and the only difference would be whether it is
considered ABI or not. The usability of a module parameter is hard to
beat as Brian said, but I think the difference goes beyond usability
~= ease of use. A debugfs hook can't be available at the very start of
the module. You first have to register your debugfs knobs to the
parent dir. And if you want your parent dir to belong to the subsystem
you register to, then you first need to register to the subsystem
which means that a fair amount of code has been running already. A
debugfs hook won't allow you to parametrize this piece of code.

>
> > That's not to say I totally disagree with the original claim, but I'm
> > just interested in knowing precisely what it means.
> >
> > And to put a precise spin on this: what would this rule say about the following?
> >
> > http://git.kernel.org/linus/f06021a18fcf8d8a1e79c5e0a8ec4eb2b038e153
> > iwlwifi: remove lar_disable module parameter
> >
> > Should that parameter have never been introduced in the first place,
> > never be removed, or something else? I think I've seen this sort of
> > pattern before, where features get phased in over time, with module
> > parameters as either escape hatches or as opt-in mechanisms.
> > Eventually, they stabilize, and there's no need (or sometimes, it's
> > actively harmful) to keep the knob around.
> >
> > Or the one that might (?) be in question here:
> > fc3ac64a3a28 rtw88: decide lps deep mode from firmware feature.
> >
> > The original module parameter was useful for enabling new power-saving
> > features, because the driver didn't yet know which chip(s)/firmware(s)
> > were stable with which power features. Now, the driver has learned how
> > to figure out the optimal power settings, so it's dropping the old
> > param and adding an "escape hatch", in case there are problems.
> >
> > I'd say this one is a bit more subtle than the lar_disable example,
> > but I'm still not sure that really qualifies as a "user-visible"
> > change.
>
> If I'm reading this right the pattern seems to be that module
> parameters are used as chicken bits. It's an interesting problem,
> I'm not sure this use case was discussed. My concern would be that
> there is no guarantee users will in fact report the new feature
> fails for them, and therefore grow to depend on the chicken bits.
>
> Since updating software is so much easier than re-etching silicon
> I'd personally not use chicken bits in software, especially with
> growing adoption of staggered update roll outs. Otherwise I'd think
> debugfs is indeed a better place for them.

In this specific case, having put the lar_disable functionality under
debugfs would have meant that the user would have had to:
1) Load the driver
2) write the debugfs hook
3) take the interface down
4) take the interface up

to make the configuration take effect which is hard because typically
the user doesn't control the interface directly but it is controlled
by the wpa_supplicant.
Don't get me wrong, I'm not saying the choice made for this module
parameter was right or wrong, I don't even want to get into that
discussion, I'm just saying that debugfs is not an infra that allows
you to do what you'd do with a module parameter.
In a sense, I guess I'm having the same discussion with our System
guys for whom module parameter = registry key in windows :)
