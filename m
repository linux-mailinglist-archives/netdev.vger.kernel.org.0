Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2123752347F
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 15:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243977AbiEKNlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 09:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244065AbiEKNlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 09:41:19 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809A169283;
        Wed, 11 May 2022 06:41:15 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KywzV4X1vz4xVP;
        Wed, 11 May 2022 23:41:10 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1652276471;
        bh=vEOI3XTsaBJEwMmKwOJuGXvPCXkgzyvATD8nzGoiPwk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=RQdbtKH40fvudPGia+31Rz17OTRZJVD0hi6NxK819HG/TDwUTeLFxOiHPPArIIQTu
         7PAxhZhTSa3L5c55LdD9mXQyOYdnRROB2tlAymjEDPrnwVpzeIdvUNY1sqcrD1a0BF
         RyZCt321zJTGqAI3b+qWLFBv/gB8roPW72j+MJf3Z+TmMQPPYrAp/pI1+XmN9heYFq
         fvrnyB99ikQEClAW9Ued7zthbWJgvCRsuX3xp93fh5La9LdDZTylJIeUkad7VYrowN
         y6SGgNbbxOf7xvjJmmHlcJoNOmcoTCbi57fpscMYTx+TEAjNGJ1plcAMrd8fzy00SQ
         7pofjvVnsyVtw==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mie@igel.co.jp
Subject: Re: [GIT PULL] virtio: last minute fixup
In-Reply-To: <20220511125140.ormw47yluv4btiey@meerkat.local>
References: <20220510082351-mutt-send-email-mst@kernel.org>
 <CAHk-=wjPR+bj7P1O=MAQWXp0Mx2hHuNQ1acn6gS+mRo_kbo5Lg@mail.gmail.com>
 <YnrxTMVRtDnGA/EK@dev-arch.thelio-3990X>
 <CAHk-=wgAk3NEJ2PHtb0jXzCUOGytiHLq=rzjkFKfpiuH-SROgA@mail.gmail.com>
 <20220511125140.ormw47yluv4btiey@meerkat.local>
Date:   Wed, 11 May 2022 23:40:59 +1000
Message-ID: <87a6bo89w4.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Konstantin Ryabitsev <konstantin@linuxfoundation.org> writes:
...
>
> I think we should simply disambiguate the trailer added by tooling like b4.
> Instead of using Link:, it can go back to using Message-Id, which is already
> standard with git -- it's trivial for git.kernel.org to link them to
> lore.kernel.org.

But my mailer, editor and terminal don't know what to do with a Message-Id.

Whereas they can all open an https link.

Making people paste message ids into lore to see the original submission
is not a win. People make enough fun of us already for still using email
to submit patches, let's not make their job any easier :)

> Before:
>
>     Signed-off-by: Main Tainer <main.tainer@linux.dev>
>     Link: https://lore.kernel.org/r/CAHk-=wgAk3NEJ2PHtb0jXzCUOGytiHLq=rzjkFKfpiuH-SROgA@mail.gmail.com
>
> After:
>
>     Signed-off-by: Main Tainer <main.tainer@linux.dev>
>     Message-Id: <CAHk-=wgAk3NEJ2PHtb0jXzCUOGytiHLq=rzjkFKfpiuH-SROgA@mail.gmail.com>
>
> This would allow people to still use Link: for things like linking to actual
> ML discussions. I know this pollutes commits a bit, but I would argue that
> this is a worthwhile trade-off that allows us to improve our automation and
> better scale maintainers.

I went back through the history and I'm pretty sure that the original use
for "Link:" was to link to the original submission, done by tip-bot
starting back in 2011:

  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f994d99cf140dbb637e49882891c89b3fd84becd

Prior to that there were no "Link:" tags, only "BugLink:".

But if people want to reclaim "Link:" for generic links then fine, but
let's still use a https link, just give it a different name.
eg. "PatchLink:", or "Submitted:" etc.

cheers
