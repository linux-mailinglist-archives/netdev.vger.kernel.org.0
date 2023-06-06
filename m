Return-Path: <netdev+bounces-8576-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F5FE7249D8
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 19:08:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A78731C20AD8
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:08:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F27701ED44;
	Tue,  6 Jun 2023 17:08:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33DE19915
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 17:08:21 +0000 (UTC)
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEB31736
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 10:08:08 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-565cd2fc9acso69941537b3.0
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 10:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686071287; x=1688663287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ps3cLhUHpkCfOKsEUa2u845C+YEI9NQwNK4sdGRQinA=;
        b=PNNUnw5NKiU9TWKiE/LhUmhaZrFTxDaKEq8U8/KMqm6ny9qVfEtyni3HLG4oreO2WV
         CI1gHZceat7yg0qCnaRGsDIsM/a1/kJXf0Nap7fbD8mhYX9HGv3ZwIY0xsCbTYiFJtZC
         kbfPcr2CO8rbN3zstIS8i2jjATSDMttoPYJOuIwF3EnNuvTmZgyXJI0HDYYWUtcRegno
         2CVa466Fawgd8IUzbMkaoLuXnC1CwjWE4XVHkgN+3x3156DoB5NLXP2XgjzTxTL46lP5
         RMkE1YL+OJbOVT5S0C2myeUJUBBl75mG4CZzp9m82/jX80WaMI5FkRE1N033h9dIYAp2
         Ejrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686071287; x=1688663287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ps3cLhUHpkCfOKsEUa2u845C+YEI9NQwNK4sdGRQinA=;
        b=A0ZYX45w9cFplSmDVYFr0KwmBsV3qJGunMZIYqHGT327N/wRNu7w0+M0JOqswBRtdn
         Jt7QZh5JQLxOo6OhyE5n2mmyPWLBbwGltApBElxh7Kzqo4n/kbrteCJ+HEbG6i7H0/KE
         2g3njKyZUkMkgY6GV8l90MWMV/37FhnCrRxJdA53ENw858VTwXgJ94LV5uvfmTd6IjB2
         jge6JXq8VSatoN6RsZ2nJZdObOHOITLfDPmDKabHvoicyNq20Y19RuVqDNKq8YmePUOp
         jIV6SuRaSfLxdj59qQ+h4oIp4hejtNNDqYH2lJYHV8/JzQjrU712X+/j5IqR/JfE6qUi
         kirQ==
X-Gm-Message-State: AC+VfDzNxze+yV+58pwsrnPqzrko+6NkBrCmMV+98GCGyjuTQRKuy+Ds
	33EqRRFw7EwhL805+5Gmz+p3lGDouGqZuWmRtK6j7g==
X-Google-Smtp-Source: ACHHUZ5Qlf6c8qDMcP633tg1T7ot3M0h/LytqLIMwt/zhrqIHgfoEIziSoFZxMF6DfEovQiupKGBmYv9admL1DJFkAM=
X-Received: by 2002:a0d:d857:0:b0:55d:aff9:975b with SMTP id
 a84-20020a0dd857000000b0055daff9975bmr3999800ywe.12.1686071287490; Tue, 06
 Jun 2023 10:08:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230606131304.4183359-1-edumazet@google.com> <ZH9PB79LUMXLZOPR@corigine.com>
 <CAM0EoMn1veKy2-qX5zcfbx3pcXhiVmBMTcV7JHv6jREuxgrFhw@mail.gmail.com> <CANn89iJU3w-AVvpDMnZcErSKvTAAcCO=rVRdHRaZXGuoA1LyFQ@mail.gmail.com>
In-Reply-To: <CANn89iJU3w-AVvpDMnZcErSKvTAAcCO=rVRdHRaZXGuoA1LyFQ@mail.gmail.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Tue, 6 Jun 2023 13:07:56 -0400
Message-ID: <CAM0EoMnWsM-DXa6yLV7Nd6vxFAA=VcMuE-xR_diNV1EoS7JxbQ@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: act_police: fix sparse errors in tcf_police_dump()
To: Eric Dumazet <edumazet@google.com>
Cc: Simon Horman <simon.horman@corigine.com>, "David S . Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org, 
	eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 6, 2023 at 12:34=E2=80=AFPM Eric Dumazet <edumazet@google.com> =
wrote:
>
> On Tue, Jun 6, 2023 at 6:01=E2=80=AFPM Jamal Hadi Salim <jhs@mojatatu.com=
> wrote:
> >
> > On Tue, Jun 6, 2023 at 11:21=E2=80=AFAM Simon Horman <simon.horman@cori=
gine.com> wrote:
> > >
> > > On Tue, Jun 06, 2023 at 01:13:04PM +0000, Eric Dumazet wrote:
> > > > Fixes following sparse errors:
> > > >
> > > > net/sched/act_police.c:360:28: warning: dereference of noderef expr=
ession
> > > > net/sched/act_police.c:362:45: warning: dereference of noderef expr=
ession
> > > > net/sched/act_police.c:362:45: warning: dereference of noderef expr=
ession
> > > > net/sched/act_police.c:368:28: warning: dereference of noderef expr=
ession
> > > > net/sched/act_police.c:370:45: warning: dereference of noderef expr=
ession
> > > > net/sched/act_police.c:370:45: warning: dereference of noderef expr=
ession
> > > > net/sched/act_police.c:376:45: warning: dereference of noderef expr=
ession
> > > > net/sched/act_police.c:376:45: warning: dereference of noderef expr=
ession
> > > >
> > > > Fixes: d1967e495a8d ("net_sched: act_police: add 2 new attributes t=
o support police 64bit rate and peakrate")
> > > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > >
> > > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> >
> > Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
> >
> > Trivial comment: Eric, for completion, does it make sense to also conve=
rt
> > opt.action =3D police->tcf_action to opt.action =3D p->tcf_action;
> > and moving it after p =3D rcu_dereference_protected()?
> >
>
> Not sure I understand, tcf_action is in police->tcf_action, not in
> p->tcf_action ?
>
> Field is read after spin_lock_bh(&police->tcf_lock); so the current
> code seems fine to me.

Never mind - you are correct.

cheers,
jamal

