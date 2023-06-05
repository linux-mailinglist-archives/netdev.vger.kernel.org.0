Return-Path: <netdev+bounces-8089-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4337D722AA1
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:13:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0A1B1C20C20
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:13:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BA7D1F943;
	Mon,  5 Jun 2023 15:13:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508BF1F19C
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 15:13:45 +0000 (UTC)
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F18BE62
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:13:29 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-5664b14966bso61171917b3.1
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 08:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685978008; x=1688570008;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vQUGxKnevhnJv5/Qf4GFn4pFPQiQfOvK/FpxWFUKahE=;
        b=BC0Prqygxqx2OUnUYwKYXRfTO4H1Mvkj/FwIYPeBhWWoq0YkbYOt2Vhnutb69AYOSI
         jlQPfABNcLsG5wTWNutX+YA9N05CcV/bl87eGA+zIAr5il5LWL9iqHPK156tLIMHkNLK
         /lDShSTm6o3ya5lEHNZsVLxqjufhmqEfFYbT7GrLVrRhuoY1dMrr3j3Vrpisf8WDTgqu
         2mEXQQo9+ynkg0okHGcwOwn5tbhYRzi+NiLrmWA9mYtyI3qLspAeGrRUkNXn3vCatqf9
         tud0hLDc+LccUhA/V2lzu0ufgT4lLzn4BTxpEN3gFmkhiPHed8gSwTt5VB0TOIQ8PzUc
         MP1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685978008; x=1688570008;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vQUGxKnevhnJv5/Qf4GFn4pFPQiQfOvK/FpxWFUKahE=;
        b=ehlLftRhcBtzAM9b625Iry9BFHH6NTOmqjOQLP7ZDVTjeSGviG5NaQna4VTrBcBXZ+
         gD24cIqsydrLqSPvVPg6gK9aZt/4i3b9qZFvjzT2T54gLOGZVo/gKpOphHtgbn15MxRe
         2iF5sS0nMkS/3Flx1bFkPeTFcmlJLa9ui5glsJFWHCbbXWaixAD1EXLhX+pj9jD0atY4
         7iHWQWa9xFcvzQkyLVuC7ONU5aVdrJY6dgnXuqjQv4sibwZvu1fIkgRO8mufGd7HezTl
         Uv4b9/kdbp5Ipjd2VfuLijWK/4EiwuYuzAy5vAqEnm3OwdrjdwG18hJvst4xbc/dhkOf
         reqg==
X-Gm-Message-State: AC+VfDwfBP2eCsUrY6g1mWlBZJah0pYhN0C43EN8oUlQhyXWt4ifUW5B
	zoczZ5a272vK5NAYf98WSSjzhE7eeVIcDGhex/nskw==
X-Google-Smtp-Source: ACHHUZ5/L0m1KGOn/alwYWBDoLLjfhGtC99V57lDMtcFEN0glz7Z0iYy1NuTPXxY59bJ/xe4GkmH7oDV2Si0ns9mXxE=
X-Received: by 2002:a0d:d506:0:b0:565:92db:bf6 with SMTP id
 x6-20020a0dd506000000b0056592db0bf6mr11953961ywd.29.1685978008329; Mon, 05
 Jun 2023 08:13:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517110232.29349-1-jhs@mojatatu.com> <20230517110232.29349-10-jhs@mojatatu.com>
 <ZH21GzZ6HATUuNyX@corigine.com> <CAAFAkD8psofYNvFdKhT48NH-4SF+4j6b=3+L9X9GibuUejFeaQ@mail.gmail.com>
 <ZH3yzbbkoQVSLuFL@corigine.com>
In-Reply-To: <ZH3yzbbkoQVSLuFL@corigine.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Mon, 5 Jun 2023 11:13:17 -0400
Message-ID: <CAM0EoMmpFEW+40TLoxSsC9D9OHd_xMgyuHKw17o22UOHOb_UrA@mail.gmail.com>
Subject: Re: [p4tc-discussions] Re: [PATCH RFC v2 net-next 10/28] p4tc: add
 pipeline create, get, update, delete
To: Simon Horman <simon.horman@corigine.com>
Cc: Jamal Hadi Salim <hadi@mojatatu.com>, netdev@vger.kernel.org, deb.chatterjee@intel.com, 
	tom@sipanda.io, p4tc-discussions@netdevconf.info, Mahesh.Shirshyad@amd.com, 
	Vipin.Jain@amd.com, tomasz.osinski@intel.com, xiyou.wangcong@gmail.com, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	khalidm@nvidia.com, toke@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 5, 2023 at 10:36=E2=80=AFAM Simon Horman <simon.horman@corigine=
.com> wrote:
>
> On Mon, Jun 05, 2023 at 10:32:20AM -0400, Jamal Hadi Salim wrote:
> > On Mon, Jun 5, 2023 at 6:12=E2=80=AFAM Simon Horman via p4tc-discussion=
s
> > <p4tc-discussions@netdevconf.info> wrote:
> > >
> > > On Wed, May 17, 2023 at 07:02:14AM -0400, Jamal Hadi Salim wrote:
> > >
> > > > +static void __tcf_pipeline_init(void)
> > > > +{
> > > > +     int pipeid =3D P4TC_KERNEL_PIPEID;
> > > > +
> > > > +     root_pipeline =3D kzalloc(sizeof(*root_pipeline), GFP_ATOMIC)=
;
> > > > +     if (!root_pipeline) {
> > > > +             pr_err("Unable to register kernel pipeline\n");
> > >
> > > Hi Victor, Pedro, and Jamal,
> > >
> > > a minor nit from my side: in general it is preferred not to to log me=
ssages
> > > for allocation failures, as the mm core does this already.
> > >
> >
> > We debated this one - the justification was we wanted to see more
> > details of what exactly failed since this is invoked earlier in the
> > loading. Thoughts?
>
> Yeah, this is not so clear cut as the glib remark in my previous email im=
plied.
> I guess the question is: what does this extra message give us?
> If it provides value, I don't object to it staying.

The arguement for it is as follows:
let's say post-boot you try to use the root pipeline and it fails, the
logs will indicate that it failed to alloc. In any case, it is one of
those things 6/12, so you could argue both directions so we can remove
it.

cheers,
jamal

