Return-Path: <netdev+bounces-2937-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48AF9704A4F
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:18:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4716A1C20DA5
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:18:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A96C19BAF;
	Tue, 16 May 2023 10:18:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F951952D
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 10:18:06 +0000 (UTC)
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E083B4EFF
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 03:17:51 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id d75a77b69052e-3f38a9918d1so1721891cf.1
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 03:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684232271; x=1686824271;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0w8xRFBKjfFrEWgtfdwKVmJmHRTcqBq5ndfrWM2pgAY=;
        b=J/5tQcrdYA76bUYmD4SiX7K1rOX9GgtX6SuXUxsa1KowiNJTXqByJOJWvazOAgY8sw
         0mWnc4b+tlt3KQKIIC9axzm50QSWZjMixtTTfPqQrtVy2qtPx3AWLV2tr/46f5U7pVrQ
         bDivtprH6Gpm3Dop/4ct0ntcBkkw39gFoTxSs/E5oY0EE8cpPv091ftz88s5O9Y+eiwf
         tMZZadgq7BzXs8mThFw+6mx/1GArDCR4w5qIDJtjPFxmoP0Zewt+J70z5CtM1BYuZnFq
         TWRgYg5Uuar/VPnmubbWTGFWU8/L3BY9WF/G9YBZ/UnOc564HatdJkHfgE4GGHqzfKpW
         Xk+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684232271; x=1686824271;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0w8xRFBKjfFrEWgtfdwKVmJmHRTcqBq5ndfrWM2pgAY=;
        b=VYI+X9jrkuE0JBiQ91YkFWHbxNCG/+mYRJmP7iwDZN+6wCmMC93PcrmUaQpBTD/XnW
         47ZU2M1GMNMZBhpwDG+yHCntFMaBJwsufZjxqIvlrK6+j53F7WVCGfT7vgdtFBfWg14k
         4Saqfk89xwS3T5Hag/76XU16n+EHx2gPriI2Ql4WHlDvuJZpENBMhBrTmxTm7PeUAykY
         bZbYCo1uJUZXNnNbr7OTsMP90jP+7xei6OureCCGQ2xQ1KM/Lk+EYqqFpxxQAnSbMFQO
         tNEtsKHhTolw1RxVfmhEGGzmIO5qr5wABUxSTK0uOV/1KneeVYOocj3nk1MFx10qQnor
         /Ukg==
X-Gm-Message-State: AC+VfDzY0Ey6e0k/8LlZaAXGyBFkmwEW/29NIhDIIYzbG4EPVT17rMe4
	1beViOiwM3DGrwJRJxBPk8NVnAouF6LHGv6v+S8OgKsnJ60Y2wu94DY=
X-Google-Smtp-Source: ACHHUZ71U/O1BujdRHlSelFb/T16Uzxgn6pw8asZmp9SQEOa1s5TRbtElK5ODgo7pA0sE3zMHtVkHY0WypHZLN8m3QM=
X-Received: by 2002:a05:622a:19a3:b0:3d4:edfd:8b61 with SMTP id
 u35-20020a05622a19a300b003d4edfd8b61mr284977qtc.0.1684232270746; Tue, 16 May
 2023 03:17:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230515091226.sd2sidyjll64jjay@soft-dev3-1> <CANn89iLDtbQTQEdOgkisHZ28O+cdXKBSKrwubHagA7iVUmKXBg@mail.gmail.com>
 <20230516074533.t5pwat6ld5qqk5ak@soft-dev3-1> <CANn89i+QT3nfE-nN9b6eeyMBp93CVHZYteuH6N9ErKYqF8PA=A@mail.gmail.com>
 <20230516092714.wresm662w54zs226@soft-dev3-1> <CANn89iL83K13OZvKLR41LS-bTjoFtn_1L7PGe6qNxHjzg-zLJQ@mail.gmail.com>
In-Reply-To: <CANn89iL83K13OZvKLR41LS-bTjoFtn_1L7PGe6qNxHjzg-zLJQ@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 16 May 2023 12:17:39 +0200
Message-ID: <CANn89iJrP7RBBnU1nMOLzTk429prxHQU0Qqze=BdRr9+Uyvr2w@mail.gmail.com>
Subject: Re: Performance regression on lan966x when extracting frames
To: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 11:59=E2=80=AFAM Eric Dumazet <edumazet@google.com>=
 wrote:
>
> On Tue, May 16, 2023 at 11:27=E2=80=AFAM Horatiu Vultur
> <horatiu.vultur@microchip.com> wrote:
> >
> > The 05/16/2023 10:04, Eric Dumazet wrote:
> > >
> > > On Tue, May 16, 2023 at 9:45=E2=80=AFAM Horatiu Vultur
> > > <horatiu.vultur@microchip.com> wrote:
> > > >
> > > > The 05/15/2023 14:30, Eric Dumazet wrote:
> > > > >
> > > > > On Mon, May 15, 2023 at 11:12=E2=80=AFAM Horatiu Vultur
> > > > > <horatiu.vultur@microchip.com> wrote:
> > > >
> > > > Hi Eric,
> > > >
> > > > Thanks for looking at this.
> > > >
> > > > > >
> > > > > > Hi,
> > > > > >
> > > > > > I have noticed that on the HEAD of net-next[0] there is a perfo=
rmance drop
> > > > > > for lan966x when extracting frames towards the CPU. Lan966x has=
 a Cortex
> > > > > > A7 CPU. All the tests are done using iperf3 command like this:
> > > > > > 'iperf3 -c 10.97.10.1 -R'
> > > > > >
> > > > > > So on net-next, I can see the following:
> > > > > > [  5]   0.00-10.01  sec   473 MBytes   396 Mbits/sec  456 sende=
r
> > > > > > And it gets around ~97000 interrupts.
> > > > > >
> > > > > > While going back to the commit[1], I can see the following:
> > > > > > [  5]   0.00-10.02  sec   632 MBytes   529 Mbits/sec   11 sende=
r
> > > > > > And it gets around ~1000 interrupts.
> > > > > >
> > > > > > I have done a little bit of searching and I have noticed that t=
his
> > > > > > commit [2] introduce the regression.
> > > > > > I have tried to revert this commit on net-next and tried again,=
 then I
> > > > > > can see much better results but not exactly the same:
> > > > > > [  5]   0.00-10.01  sec   616 MBytes   516 Mbits/sec    0 sende=
r
> > > > > > And it gets around ~700 interrupts.
> > > > > >
> > > > > > So my question is, was I supposed to change something in lan966=
x driver?
> > > > > > or is there a bug in lan966x driver that pop up because of this=
 change?
> > > > > >
> > > > > > Any advice will be great. Thanks!
> > > > > >
> > > > > > [0] befcc1fce564 ("sfc: fix use-after-free in efx_tc_flower_rec=
ord_encap_match()")
> > > > > > [1] d4671cb96fa3 ("Merge branch 'lan966x-tx-rx-improve'")
> > > > > > [2] 8b43fd3d1d7d ("net: optimize ____napi_schedule() to avoid e=
xtra NET_RX_SOFTIRQ")
> > > > > >
> > > > > >
> > > > >
> > > > > Hmmm... thanks for the report.
> > > > >
> > > > > This seems related to softirq (k)scheduling.
> > > > >
> > > > > Have you tried to apply this recent commit ?
> > > > >
> > > > > Commit-ID:     d15121be7485655129101f3960ae6add40204463
> > > > > Gitweb:        https://git.kernel.org/tip/d15121be7485655129101f3=
960ae6add40204463
> > > > > Author:        Paolo Abeni <pabeni@redhat.com>
> > > > > AuthorDate:    Mon, 08 May 2023 08:17:44 +02:00
> > > > > Committer:     Thomas Gleixner <tglx@linutronix.de>
> > > > > CommitterDate: Tue, 09 May 2023 21:50:27 +02:00
> > > > >
> > > > > Revert "softirq: Let ksoftirqd do its job"
> > > >
> > > > I have tried to apply this patch but the results are the same:
> > > > [  5]   0.00-10.01  sec   478 MBytes   400 Mbits/sec  188 sender
> > > > And it gets just a little bit bigger number of interrupts ~11000
> > > >
> > > > >
> > > > >
> > > > > Alternative would be to try this :
> > > > >
> > > > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > > > index b3c13e0419356b943e90b1f46dd7e035c6ec1a9c..f570a3ca00e7aa0e6=
05178715f90bae17b86f071
> > > > > 100644
> > > > > --- a/net/core/dev.c
> > > > > +++ b/net/core/dev.c
> > > > > @@ -6713,8 +6713,8 @@ static __latent_entropy void
> > > > > net_rx_action(struct softirq_action *h)
> > > > >         list_splice(&list, &sd->poll_list);
> > > > >         if (!list_empty(&sd->poll_list))
> > > > >                 __raise_softirq_irqoff(NET_RX_SOFTIRQ);
> > > > > -       else
> > > > > -               sd->in_net_rx_action =3D false;
> > > > > +
> > > > > +       sd->in_net_rx_action =3D false;
> > > > >
> > > > >         net_rps_action_and_irq_enable(sd);
> > > > >  end:;
> > > >
> > > > I have tried to use also this change with and without the previous =
patch
> > > > but the result is the same:
> > > > [  5]   0.00-10.01  sec   478 MBytes   401 Mbits/sec  256 sender
> > > > And it is the same number of interrupts.
> > > >
> > > > Is something else that I should try?
> > >
> > > High number of interrupts for a saturated receiver seems wrong.
> > > (Unless it is not saturating the cpu ?)
> >
> > The CPU usage seems to be almost at 100%. This is the output of top
> > command:
> > 149   132 root     R     5032   0%  96% iperf3 -c 10.97.10.1 -R
> >  12     2 root     SW       0   0%   3% [ksoftirqd/0]
> > 150   132 root     R     2652   0%   1% top
>
> Strange... There might be some scheduling artifacts in TCP stack for
> your particular workload.
> Perhaps leading to fewer ACK packets being sent, and slowing down the sen=
der.
>
> It is unclear where cpu cycles are eaten. Normally the kernel->user
> copy should be the limiting factor.
>
> Please try
> perf record -a -g sleep 10
> perf report --no-children --stdio
>
>
> I do not see obvious problems with my commit

I suspect the TCP receive queue fills up, holding too many MSS (pages)
at once, and the driver page recycling strategy is defeated.

You could use "ss -temoi"  while iperf3 is running, to look at how big
the receive queue is.

Then you can reduce /proc/sys/net/ipv4/tcp_rmem[2] to limit the number
of pages held by a TCP socket
when its receive queue is not drained fast enough. (and restart iperf3 sess=
ion)

echo "4096 131072 1048576" >/proc/sys/net/ipv4_tcp_rmem

If this changes performance, you might want to adjust RX ring size (or
page_pool capacity), because this driver seems to use 512 slots.

512 slots for standard MTU means that no more than 741376 bytes of
payload should sit in TCP receive queues.

