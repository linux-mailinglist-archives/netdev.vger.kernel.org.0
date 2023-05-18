Return-Path: <netdev+bounces-3695-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A15A3708589
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 18:03:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81EB61C21126
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 16:03:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8D3121CC6;
	Thu, 18 May 2023 16:03:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B824B21092
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 16:03:25 +0000 (UTC)
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5D9110
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 09:03:22 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-561d611668eso24899917b3.0
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 09:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684425801; x=1687017801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kFMUvSLIDQqBOAhTJWNyPBK0yCpEmZz4Rr9wUYgSBLk=;
        b=y/zcXW7Xdbt/i1Elujs/t4VCROuOfh5xM8t/C+CPRIvhmAHKMsXASS+3Omp+iDOUJu
         s/2H3PJNZO6B1erWI0mMHt2FWJiyjdmt7f+AcSCbxmCau0DqGg2duoV7H+4ign/x46pr
         cKTZ3SkVcQs2DRi+cXyHfhqW7/ynScmMR6sZsHQfW8aYxTQpp6I2pO71u/a22+UZpQ1s
         tvKLlh8/3zbWnVaT6tLHgykJXwmziXSOFJrSClHbIxF3ZsF5sh6QIybbQdyM1PXhcXiL
         /3t7uBr6wOiyDaiGPOvBuM7ZiHUz82mBOkOhOCDHvfuTbcAHWy+dDHviJ7uXEAKXTc/x
         UgTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684425801; x=1687017801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kFMUvSLIDQqBOAhTJWNyPBK0yCpEmZz4Rr9wUYgSBLk=;
        b=hEpaAaztZDo5qmrJE8IJmANSg1pv4Jbx+N6N8ArsBSIk5/Ns/OJhuoMZ/BlC0DvBIr
         V9c+VdV7i1Bbv3N2PxkP5D4b4uPa1/qYia/f3b73xZ6qpqkw1AgpEIycJ7h2ZGxgb/r7
         YyXS6crtuNW/T7B51yhwSbn0MJqZUKzPt03WSLrjYiELi7BVkBc55LpemQb4qJ4jbnRO
         tlSl5pUkQE01n9xl+IFVOrOfb6v3+v6m9dqneCXIC0nn6iltk2USnOcLhuq7KBDOpidR
         fbDTzX3Iozs0CoheUL1r3RtooHBHDfnSu2T3nINllnAD5DM5HIkyMZvTi0YD+OnAFUBh
         WuCg==
X-Gm-Message-State: AC+VfDxMdl7tswt9lETHMK3i7U7y/vtSZlOgZaeCO9gWmL4MU5hZSO5G
	FmCL6KzMHpuH+gprabK7VU0dITzRH3AVX/0wE1eXbg==
X-Google-Smtp-Source: ACHHUZ66Lvjbz0wq/6JOvrKIa8YcQvWCah9jJuh8L5MNl7HOgkcoiK4jzb0eXXRMjClLL3Mv+3cibD4a0Suy5HYTK7I=
X-Received: by 2002:a05:7500:140f:b0:105:80c8:bf47 with SMTP id
 v15-20020a057500140f00b0010580c8bf47mr129040gaa.67.1684425800919; Thu, 18 May
 2023 09:03:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517124201.441634-1-imagedong@tencent.com>
 <20230517124201.441634-4-imagedong@tencent.com> <CANn89iKLf=V664AsUYC52h_q-xjEq9xC3KqTq8q+t262T91qVQ@mail.gmail.com>
 <CADxym3a0gmzmD3Vwu_shoJnAHm-xjD5tJRuKwTvAXnVk_H55AA@mail.gmail.com>
 <CADVnQynZ67511+cKF=hyiaLx5-fqPGGmpyJ-5Lk6ge-ivmAf-w@mail.gmail.com> <CADxym3ZiyYK7Vyz05qLv8jOPmNZXXepCsTbZxdkhSQxRx0cdSA@mail.gmail.com>
In-Reply-To: <CADxym3ZiyYK7Vyz05qLv8jOPmNZXXepCsTbZxdkhSQxRx0cdSA@mail.gmail.com>
From: Neal Cardwell <ncardwell@google.com>
Date: Thu, 18 May 2023 12:03:04 -0400
Message-ID: <CADVnQy=JQkVGRsbL0u=-oZSpdaFBpz907yX24p3uUu2pMhUjGg@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] net: tcp: handle window shrink properly
To: Menglong Dong <menglong8.dong@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>, kuba@kernel.org, davem@davemloft.net, 
	pabeni@redhat.com, dsahern@kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Menglong Dong <imagedong@tencent.com>, 
	Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 10:12=E2=80=AFAM Menglong Dong <menglong8.dong@gmai=
l.com> wrote:
>
> On Thu, May 18, 2023 at 9:40=E2=80=AFPM Neal Cardwell <ncardwell@google.c=
om> wrote:
> >
> > On Wed, May 17, 2023 at 10:35=E2=80=AFPM Menglong Dong <menglong8.dong@=
gmail.com> wrote:
> > >
> > > On Wed, May 17, 2023 at 10:47=E2=80=AFPM Eric Dumazet <edumazet@googl=
e.com> wrote:
> > > >
> > > > On Wed, May 17, 2023 at 2:42=E2=80=AFPM <menglong8.dong@gmail.com> =
wrote:
> > > > >
> > > > > From: Menglong Dong <imagedong@tencent.com>
> > > > >
> > > > > Window shrink is not allowed and also not handled for now, but it=
's
> > > > > needed in some case.
> > > > >
> > > > > In the origin logic, 0 probe is triggered only when there is no a=
ny
> > > > > data in the retrans queue and the receive window can't hold the d=
ata
> > > > > of the 1th packet in the send queue.
> > > > >
> > > > > Now, let's change it and trigger the 0 probe in such cases:
> > > > >
> > > > > - if the retrans queue has data and the 1th packet in it is not w=
ithin
> > > > > the receive window
> > > > > - no data in the retrans queue and the 1th packet in the send que=
ue is
> > > > > out of the end of the receive window
> > > >
> > > > Sorry, I do not understand.
> > > >
> > > > Please provide packetdrill tests for new behavior like that.
> > > >
> > >
> > > Yes. The problem can be reproduced easily.
> > >
> > > 1. choose a server machine, decrease it's tcp_mem with:
> > >     echo '1024 1500 2048' > /proc/sys/net/ipv4/tcp_mem
> > > 2. call listen() and accept() on a port, such as 8888. We call
> > >     accept() looply and without call recv() to make the data stay
> > >     in the receive queue.
> > > 3. choose a client machine, and create 100 TCP connection
> > >     to the 8888 port of the server. Then, every connection sends
> > >     data about 1M.
> > > 4. we can see that some of the connection enter the 0-probe
> > >     state, but some of them keep retrans again and again. As
> > >     the server is up to the tcp_mem[2] and skb is dropped before
> > >     the recv_buf full and the connection enter 0-probe state.
> > >     Finially, some of these connection will timeout and break.
> > >
> > > With this series, all the 100 connections will enter 0-probe
> > > status and connection break won't happen. And the data
> > > trans will recover if we increase tcp_mem or call 'recv()'
> > > on the sockets in the server.
> > >
> > > > Also, such fundamental change would need IETF discussion first.
> > > > We do not want linux to cause network collapses just because billio=
ns
> > > > of devices send more zero probes.
> > >
> > > I think it maybe a good idea to make the connection enter
> > > 0-probe, rather than drop the skb silently. What 0-probe
> > > meaning is to wait for space available when the buffer of the
> > > receive queue is full. And maybe we can also use 0-probe
> > > when the "buffer" of "TCP protocol" (which means tcp_mem)
> > > is full?
> > >
> > > Am I right?
> > >
> > > Thanks!
> > > Menglong Dong
> >
> > Thanks for describing the scenario in more detail. (Some kind of
> > packetdrill script or other program to reproduce this issue would be
> > nice, too, as Eric noted.)
> >
> > You mention in step (4.) above that some of the connections keep
> > retransmitting again and again. Are those connections receiving any
> > ACKs in response to their retransmissions? Perhaps they are receiving
> > dupacks?
>
> Actually, these packets are dropped without any reply, even dupacks.
> skb will be dropped directly when tcp_try_rmem_schedule()
> fails in tcp_data_queue(). That's reasonable, as it's
> useless to reply a ack to the sender, which will cause the sender
> fast retrans the packet, because we are out of memory now, and
> retrans can't solve the problem.

I'm not sure I see the problem. If retransmits can't solve the
problem, then why are you proposing that data senders keep
retransmitting forever (via 0-window-probes) in this kind of scenario?

A single dupack without SACK blocks will not cause the sender to fast
retransmit. (Only 3 dupacks would trigger fast retransmit.)

Three or more dupacks without SACK blocks will cause the sender to
fast retransmit the segment above SND.UNA once if the sender doesn't
have SACK support. But in this case AFAICT fast-retransmitting once is
a fine strategy, since the sender should keep retrying transmits (with
backoff) until the receiver potentially has memory available to
receive the packet.

>
> > If so, then perhaps we could solve this problem without
> > depending on a violation of the TCP spec (which says the receive
> > window should not be retracted) in the following way: when a data
> > sender suffers a retransmission timeout, and retransmits the first
> > unacknowledged segment, and receives a dupack for SND.UNA instead of
> > an ACK covering the RTO-retransmitted segment, then the data sender
> > should estimate that the receiver doesn't have enough memory to buffer
> > the retransmitted packet. In that case, the data sender should enter
> > the 0-probe state and repeatedly set the ICSK_TIME_PROBE0 timer to
> > call tcp_probe_timer().
> >
> > Basically we could try to enhance the sender-side logic to try to
> > distinguish between two kinds of problems:
> >
> > (a) Repeated data packet loss caused by congestion, routing problems,
> > or connectivity problems. In this case, the data sender uses
> > ICSK_TIME_RETRANS and tcp_retransmit_timer(), and backs off and only
> > retries sysctl_tcp_retries2 times before timing out the connection
> >
> > (b) A receiver that is repeatedly sending dupacks but not ACKing
> > retransmitted data because it doesn't have any memory. In this case,
> > the data sender uses ICSK_TIME_PROBE0 and tcp_probe_timer(), and backs
> > off but keeps retrying as long as the data sender receives ACKs.
> >
>
> I'm not sure if this is an ideal method, as it may be not rigorous
> to conclude that the receiver is oom with dupacks. A packet can
> loss can also cause multi dupacks.

When a data sender suffers an RTO and retransmits a single data
packet, it would be very rare for the data sender to receive multiple
pure dupacks without SACKs. This would only happen in the rare case
where (a) the connection did not have SACK enabled, and (b) there was
a hole in the received sequence space and there were still packets in
flight when the (spurioius) RTO fired.

But if we want to be paranoid, then this new response could be written
to only trigger if SACK is enabled (the vast, vast majority of cases).
If SACK is enabled, and an RTO of a data packet starting at sequence
S1 results in the receiver sending only a dupack for S1 without SACK
blocks, then this clearly shows the issue is not packet loss but
suggests a receiver unable to buffer the given data packet, AFAICT.

thanks,
neal

>
> Thanks!
> Menglong Dong
>
> > AFAICT that would be another way to reach the happy state you mention:
> > "all the 100 connections will enter 0-probe status and connection
> > break won't happen", and we could reach that state without violating
> > the TCP protocol spec and without requiring changes on the receiver
> > side (so that this fix could help in scenarios where the
> > memory-constrained receiver is an older stack without special new
> > behavior).
> >
> > Eric, Yuchung, Menglong: do you think something like that would work?
> >
> > neal

