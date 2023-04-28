Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B48E6F1FAC
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 22:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346536AbjD1Uvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 16:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjD1Uvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 16:51:51 -0400
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9501B1730;
        Fri, 28 Apr 2023 13:51:50 -0700 (PDT)
Received: by mail-vk1-xa2c.google.com with SMTP id 71dfb90a1353d-44048c2de4cso96323e0c.0;
        Fri, 28 Apr 2023 13:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682715109; x=1685307109;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NaPWwpWZRrxUM9EmqOn9yUGNj1HPshDqgyuGWKM4D8M=;
        b=QV3anU/hfdqwn8Ter5D4Kt4lUNTR7tvOljz3tGSBWtPuDE/+huWXAa/ZeXl2z7incp
         W9DLJp0mRkOrdtlozlXxDtsIduZfSv80S15hMgV40FxnaTaaVdgZTcuxnSRGm1wKvHLw
         NhwVXCP3nIo/bkbahgQGw+LhSjbme4S6IMm7covhk6kN5a10DSFad3O/svCf5TxOaBYs
         6QjfZUiPMdP/F50DdmRZAw6Squc3SO+ETFtXr62lnIA6ANA54I3f7p0Qv7oj2uLOyC8L
         riuVhZ0FkYMh9zggKrlf8kc9D3vVOv+plvOeShY3PAg2tverPptNauShQl1f33pjoxMk
         ywqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682715109; x=1685307109;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NaPWwpWZRrxUM9EmqOn9yUGNj1HPshDqgyuGWKM4D8M=;
        b=Reb7/ERagWxeNpwiP7FLkut/r8gkxuumV6t8+qTy+NoTQSX8QCGRYqtMkkImrwnKJb
         WS/3euJx0nTYS+XATFoZL7iOd8q71Aijyof2VFENIUkBxyZMNJn0/CErkuh5p8XZRuPj
         nMrfBUrR2Cbib63By+o5NISvoh1bfBj1rqRLFh2FTSd9mFsjajXgV57aQhvDGMzr1RaW
         WApDE+ow+iNDF34PfC9FgJJ5hdi2nxfN28UNSVZrwZVTZdUo96dtxog1ETmSJGk1MdEl
         PWl/NfCGJD5fBp2hYs8jmM49N4gcTJkl3Pm1C87zsvledw6LBEbrrawmftL4mIIdCMSP
         PvoQ==
X-Gm-Message-State: AC+VfDyzmBKFHbfq9XNFIMwWJRP7gWjZj/j2mdEAI2IDcdlbNasTjhB5
        0ZF+BkQXMyONMlaB7jRYU6YIx69dOKUEzR+7dYMw17F6YrM=
X-Google-Smtp-Source: ACHHUZ4pXlTjzAZdqMH2q1JuOvEmI/cAq2Vcc+InHxWaIT6ye1h28IFFR7CNUBh7U3ggSV6fnK819NPsrJwKTX9xkvU=
X-Received: by 2002:a1f:ed87:0:b0:440:8697:1ae1 with SMTP id
 l129-20020a1fed87000000b0044086971ae1mr2778202vkh.1.1682715109570; Fri, 28
 Apr 2023 13:51:49 -0700 (PDT)
MIME-Version: 1.0
References: <20221001112058.22387-1-j.witteveen@gmail.com> <87v8orpkda.fsf@meer.lwn.net>
In-Reply-To: <87v8orpkda.fsf@meer.lwn.net>
From:   Jouke Witteveen <j.witteveen@gmail.com>
Date:   Fri, 28 Apr 2023 22:51:38 +0200
Message-ID: <CAJ2ouaz8BpQzLxwfeW8ZLMfdfoR7NVdSDHJDFGQbpbjA2A=pbg@mail.gmail.com>
Subject: Re: [PATCH] Documentation: update urls to Linux Foundation wiki
To:     netdev@vger.kernel.org, linux-doc@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 9:08=E2=80=AFPM Jonathan Corbet <corbet@lwn.net> wr=
ote:
>
> Jouke Witteveen <j.witteveen@gmail.com> writes:
>
> > The redirects from the old urls stopped working recently.
> >
> > Signed-off-by: Jouke Witteveen <j.witteveen@gmail.com>
>
> I see the LF has done its annual web-site replacement; I have no idea
> why they are so enamored with breaking URLs...
>
> Anyway, This is networking documentation, so it should go to the folks
> at netdev [CC'd] rather than me.
>
> >  Documentation/networking/bridge.rst                           | 2 +-
> >  Documentation/networking/dccp.rst                             | 4 ++--
> >  .../networking/device_drivers/ethernet/intel/ice.rst          | 2 +-
> >  Documentation/networking/generic_netlink.rst                  | 2 +-
> >  MAINTAINERS                                                   | 2 +-
> >  net/ipv4/Kconfig                                              | 2 +-
> >  net/sched/Kconfig                                             | 2 +-
> >  7 files changed, 8 insertions(+), 8 deletions(-)

Parts of this patch have been applied by now after being sent in by
others. I believe the rest still makes sense to apply. Shall I rebase
the patch and send it again? Or was there a reason for it to be left
behind half a year ago?

> > diff --git a/Documentation/networking/bridge.rst b/Documentation/networ=
king/bridge.rst
> > index 4aef9cddde2f..c859f3c1636e 100644
> > --- a/Documentation/networking/bridge.rst
> > +++ b/Documentation/networking/bridge.rst
> > @@ -8,7 +8,7 @@ In order to use the Ethernet bridging functionality, yo=
u'll need the
> >  userspace tools.
> >
> >  Documentation for Linux bridging is on:
> > -   http://www.linuxfoundation.org/collaborate/workgroups/networking/br=
idge
> > +   https://wiki.linuxfoundation.org/networking/bridge
>
> So this page is full of encouraging stuff like:
>
> > The code is updated as part of the 2.4 and 2.6 kernels available at
> > kernel.org.
>
> ...and tells us about an encouraging prototype implementation in 2.6.18.
> I'd apply the patch because working URLs are better than broken ones,
> but I also question the value of this material at all in 2022... there
> should be better documents to link to at this point?

I don't know of any and indeed this patch only exists because working
URLs are better than broken ones.

>
> Thanks,
>
> jon

Regards,
- Jouke
