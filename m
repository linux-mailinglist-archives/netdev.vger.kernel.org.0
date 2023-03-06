Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA546AC8BE
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbjCFQwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjCFQwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 11:52:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DD71FEA;
        Mon,  6 Mar 2023 08:51:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B98AD61001;
        Mon,  6 Mar 2023 16:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB615C433EF;
        Mon,  6 Mar 2023 16:49:57 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="p7OvzPz1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1678121396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l0IN1VirqLiMA24UJjnZzI6umrNwjSsL7ENm7zhRfEY=;
        b=p7OvzPz1NmfKhe6kfIuqjE+THJUupW4DBOjmYlYF+caw15CTip4wmluH9W1Flbbziaghta
        9it828fCf9UjeM+GVJF6yiGH5IwDVBBToxv13m1Gr6Sn6dMmMxa0OIpkUeipfG8xYK/h8c
        VRnTEB0oxbtXms6RWFdtVuaEt9rvUN8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 23ff5f42 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 6 Mar 2023 16:49:55 +0000 (UTC)
Received: by mail-yb1-xb35.google.com with SMTP id v13so8823855ybu.0;
        Mon, 06 Mar 2023 08:49:55 -0800 (PST)
X-Gm-Message-State: AO0yUKWyrk7X+Mwn/2jQjt7u//l5Ze38dvVnboiuEKSYACkwU4OJwD7L
        V0XiCNjvJzx/chpWGkluvioLXrhbarXtiA5d8V4=
X-Google-Smtp-Source: AK7set9CK46/v8qFmWbdZ/4F4SRDr5QbKoIrAv/Wae6SuQP8a65V94c1vPHoCPtLR3gHjN4UILUiQdF7vxmAXeMOPdQ=
X-Received: by 2002:a25:7808:0:b0:a4a:a708:2411 with SMTP id
 t8-20020a257808000000b00a4aa7082411mr6622201ybc.10.1678121092709; Mon, 06 Mar
 2023 08:44:52 -0800 (PST)
MIME-Version: 1.0
References: <20230306160651.2016767-1-vernon2gm@gmail.com> <20230306160651.2016767-6-vernon2gm@gmail.com>
 <ZAYXJ2E+JHcp2kD/@yury-laptop>
In-Reply-To: <ZAYXJ2E+JHcp2kD/@yury-laptop>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 6 Mar 2023 17:44:41 +0100
X-Gmail-Original-Message-ID: <CAHmME9r_JXNCVVCNxZRQkafA=eOOu5k0+AweRDor3tNu283bdg@mail.gmail.com>
Message-ID: <CAHmME9r_JXNCVVCNxZRQkafA=eOOu5k0+AweRDor3tNu283bdg@mail.gmail.com>
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
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 6, 2023 at 5:39=E2=80=AFPM Yury Norov <yury.norov@gmail.com> wr=
ote:
>
> On Tue, Mar 07, 2023 at 12:06:51AM +0800, Vernon Yang wrote:
> > After commit 596ff4a09b89 ("cpumask: re-introduce constant-sized cpumas=
k
> > optimizations"), the cpumask size is divided into three different case,
> > so fix comment of cpumask_xxx correctly.
> >
> > Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
> > ---
> >  include/linux/cpumask.h | 46 ++++++++++++++++++++---------------------
> >  1 file changed, 23 insertions(+), 23 deletions(-)
> >
> > diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> > index 8fbe76607965..248bdb1c50dc 100644
> > --- a/include/linux/cpumask.h
> > +++ b/include/linux/cpumask.h
> > @@ -155,7 +155,7 @@ static __always_inline unsigned int cpumask_check(u=
nsigned int cpu)
> >   * cpumask_first - get the first cpu in a cpumask
> >   * @srcp: the cpumask pointer
> >   *
> > - * Returns >=3D nr_cpu_ids if no cpus set.
> > + * Returns >=3D small_cpumask_bits if no cpus set.
>
> There's no such thing like small_cpumask_bits. Here and everywhere,
> nr_cpu_ids must be used.
>
> Actually, before 596ff4a09b89 nr_cpumask_bits was deprecated, and it
> must be like that for all users even now.
>
> nr_cpumask_bits must be considered as internal cpumask parameter and
> never referenced outside of cpumask code.

What's the right thing I should do, then, for wireguard's usage and
for random.c's usage? It sounds like you object to this patchset, but
if the problem is real, it sounds like I should at least fix the two
cases I maintain. What's the right check?

Jason
