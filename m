Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D92D6AC92E
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 18:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjCFRFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 12:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjCFRFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 12:05:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF91137B41;
        Mon,  6 Mar 2023 09:05:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6945B80EC2;
        Mon,  6 Mar 2023 17:05:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA52C433A1;
        Mon,  6 Mar 2023 17:05:02 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="hUWq6aZA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1678122298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rebf2oGX/Y7xKpUOJU11DVlUHCYfqwTY7506K3ZpIEY=;
        b=hUWq6aZA5z5fsKfpzYLpqIbjvz4Rw/BLq+F0+MXJaNwPYdzPZ1ZL8p1c0eAgEnFrt8X4PV
        gDc5dltPdHjg9qtuDQexpj1bjXMwCgar7wjD1yMNP8swgStikSZ3DI2SIxMykNuLlYvJhe
        9OeabsWU96CHanKsX/rOUBdjmnC6qy4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8dfe2717 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 6 Mar 2023 17:04:58 +0000 (UTC)
Received: by mail-yb1-f169.google.com with SMTP id t4so8824458ybg.11;
        Mon, 06 Mar 2023 09:04:56 -0800 (PST)
X-Gm-Message-State: AO0yUKXib2x7+PiscTli37c55i0o0njhGKBOHCEXsvxaT+6GbN1+XhDg
        9OwPTIfbE8doqfl/ewSIzQ+2O7OOLPMV3VXiUKE=
X-Google-Smtp-Source: AK7set/C+4H5t/AjhOaoRmPlKirlZGinsSeOk1osYZEYcZ7sUkw4WisDsCHHRxbmhkQleYYACwSNmtn05qG4XIfMC+0=
X-Received: by 2002:a25:9b48:0:b0:a8a:a652:2a69 with SMTP id
 u8-20020a259b48000000b00a8aa6522a69mr5258478ybo.10.1678122295337; Mon, 06 Mar
 2023 09:04:55 -0800 (PST)
MIME-Version: 1.0
References: <20230306160651.2016767-1-vernon2gm@gmail.com> <20230306160651.2016767-6-vernon2gm@gmail.com>
 <ZAYXJ2E+JHcp2kD/@yury-laptop> <CAHmME9r_JXNCVVCNxZRQkafA=eOOu5k0+AweRDor3tNu283bdg@mail.gmail.com>
 <ZAYartD+NsF1JxlH@yury-laptop>
In-Reply-To: <ZAYartD+NsF1JxlH@yury-laptop>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 6 Mar 2023 18:04:44 +0100
X-Gmail-Original-Message-ID: <CAHmME9qRicEe7zCFWSfV+aQ4j6sZ3FAJu3fgMUMJJkfBV4AMMw@mail.gmail.com>
Message-ID: <CAHmME9qRicEe7zCFWSfV+aQ4j6sZ3FAJu3fgMUMJJkfBV4AMMw@mail.gmail.com>
Subject: Re: [PATCH 5/5] cpumask: fix comment of cpumask_xxx
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Vernon Yang <vernon2gm@gmail.com>, torvalds@linux-foundation.org,
        tytso@mit.edu, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, andriy.shevchenko@linux.intel.com,
        linux@rasmusvillemoes.dk, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, linux-kernel@vger.kernel.org,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 6, 2023 at 5:54=E2=80=AFPM Yury Norov <yury.norov@gmail.com> wr=
ote:
>
> On Mon, Mar 06, 2023 at 05:44:41PM +0100, Jason A. Donenfeld wrote:
> > On Mon, Mar 6, 2023 at 5:39=E2=80=AFPM Yury Norov <yury.norov@gmail.com=
> wrote:
> > >
> > > On Tue, Mar 07, 2023 at 12:06:51AM +0800, Vernon Yang wrote:
> > > > After commit 596ff4a09b89 ("cpumask: re-introduce constant-sized cp=
umask
> > > > optimizations"), the cpumask size is divided into three different c=
ase,
> > > > so fix comment of cpumask_xxx correctly.
> > > >
> > > > Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
> > > > ---
> > > >  include/linux/cpumask.h | 46 ++++++++++++++++++++-----------------=
----
> > > >  1 file changed, 23 insertions(+), 23 deletions(-)
> > > >
> > > > diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> > > > index 8fbe76607965..248bdb1c50dc 100644
> > > > --- a/include/linux/cpumask.h
> > > > +++ b/include/linux/cpumask.h
> > > > @@ -155,7 +155,7 @@ static __always_inline unsigned int cpumask_che=
ck(unsigned int cpu)
> > > >   * cpumask_first - get the first cpu in a cpumask
> > > >   * @srcp: the cpumask pointer
> > > >   *
> > > > - * Returns >=3D nr_cpu_ids if no cpus set.
> > > > + * Returns >=3D small_cpumask_bits if no cpus set.
> > >
> > > There's no such thing like small_cpumask_bits. Here and everywhere,
> > > nr_cpu_ids must be used.
> > >
> > > Actually, before 596ff4a09b89 nr_cpumask_bits was deprecated, and it
> > > must be like that for all users even now.
> > >
> > > nr_cpumask_bits must be considered as internal cpumask parameter and
> > > never referenced outside of cpumask code.
> >
> > What's the right thing I should do, then, for wireguard's usage and
> > for random.c's usage? It sounds like you object to this patchset, but
> > if the problem is real, it sounds like I should at least fix the two
> > cases I maintain. What's the right check?
>
> Everywhere outside of cpumasks internals use (cpu < nr_cpu_ids) to
> check if the cpu is in a valid range, like:
>
> cpu =3D cpumask_first(cpus);
> if (cpu >=3D nr_cpu_ids)
>         pr_err("There's no cpus");

Oh, okay, so the ones for wireguard and random.c in this series are
correct then? If so, could you give a Reviewed-by:, and then I'll
queue those up in my respective trees.

Jason
