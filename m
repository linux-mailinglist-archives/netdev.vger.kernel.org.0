Return-Path: <netdev+bounces-1180-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C3146FC829
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 15:43:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4299B281341
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 13:43:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DACE182D8;
	Tue,  9 May 2023 13:43:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD6E17ACF
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 13:43:02 +0000 (UTC)
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61278135
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 06:42:59 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id d75a77b69052e-3ef34c49cb9so147151cf.1
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 06:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683639778; x=1686231778;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=epQ+kEoiNP0vYoVkh8Qnk5QY30lz6UwRfl2kl6654+Y=;
        b=cEBVDAZUdKxfCrJt475bv96MsdAwZ5TGX+A0W0ypk6tM9f0yxXUQTrHrJFWUSCM3Ns
         p0wAYYjecKDzgGitZytNDRGv7XK0RigtedNeQK/5ZiQtW50CcHpDxgss4CpKEZL2zTbJ
         b5RF3c1ZX33v31gMIFbjEqCZI7SWaMXRY2jvLmpt8X3m613LYJwl0m8yMTjaM+m6NtGp
         dYtJvGLB1PkGUTaONAeg2E7tSOjLQnKaBHKRh+sEeD46gQelCKir1BEeoquJRUsQkL2F
         1JnlajZ0dup0nAYBQ33R4atWFWIXUjmCXbordHKJXa7s0bIs9YXHySbvEUY3wTbsdwD5
         JrZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683639778; x=1686231778;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=epQ+kEoiNP0vYoVkh8Qnk5QY30lz6UwRfl2kl6654+Y=;
        b=it0pt5Fsghds7bKnbXtYfnV6+PQlVHZp/btDwfgP8EROFKmbPzrlf2EB3x4pl4wuCt
         TxB9SyRldowI9ZxBy/xEl4WpvCxoORY8wdvk84JHzBv2moPFIrwR4tt0jF9vRDCLVrMx
         kzzKTa5LwZY0rwOpNb+MqhnLsQGgytlNUie457AiEMGxuk0XSfugQA/A96Pgqp+wDAdm
         bKkf9HP3yvliJgRAp7oTTKbSOXMP5SpxO1v3pDoUVgXrUkHsyjrvl4/Z0C1rTDHP8EIX
         j3jFr+AJ4KyvLW98TseqBZkZKrwQ8qPv5W5U4w4z6fwAvyrQHToY0Xkk0gu/9xJulgV6
         0JEg==
X-Gm-Message-State: AC+VfDxYnjzIw6vBvqWndzDRAY7pKcwpiXr3psmA5tKHG/DzefEOhy2W
	e5LCaJMXyAolCT+6EBa/gSp4yMQhmx5Htjc+VteGvQ==
X-Google-Smtp-Source: ACHHUZ6FUqwfn6pfFTBZj52K21HMd+bzY6W5OzWykDA8qH2iLtjVp284Sg2mSWAqZOvQzHkLSMiV0bIf+YCQcB6ameA=
X-Received: by 2002:a05:622a:1c5:b0:3ee:d8fe:6f5c with SMTP id
 t5-20020a05622a01c500b003eed8fe6f5cmr285892qtw.1.1683639778269; Tue, 09 May
 2023 06:42:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230508222736.13249-1-kuniyu@amazon.com> <df46c00581155a42e132c8896667c39f83828dd7.camel@redhat.com>
In-Reply-To: <df46c00581155a42e132c8896667c39f83828dd7.camel@redhat.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 9 May 2023 15:42:45 +0200
Message-ID: <CANn89i+ZK6+bPQds2fbff=-ojJ=W=czUvrWPyOCTno=qO6yzDQ@mail.gmail.com>
Subject: Re: [PATCH v1 net-next] tcp: Add net.ipv4.tcp_reset_challenge.
To: Paolo Abeni <pabeni@redhat.com>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@kernel.org>, 
	Mubashir Adnan Qureshi <mubashirq@google.com>, Neal Cardwell <ncardwell@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, Jon Zobrist <zob@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 9, 2023 at 3:34=E2=80=AFPM Paolo Abeni <pabeni@redhat.com> wrot=
e:
>
> On Mon, 2023-05-08 at 15:27 -0700, Kuniyuki Iwashima wrote:
> > Our Network Load Balancer (NLB) [0] consists of multiple nodes with uni=
que
> > IP addresses.  These nodes forward TCP flows from clients to backend
> > targets by modifying the destination IP address.  NLB offers an option =
[1]
> > to preserve the client's source IP address and port when routing packet=
s
> > to backend targets.
> >
> > When a client connects to two different NLB nodes, they may select the =
same
> > backend target.  If the client uses the same source IP and port, the tw=
o
> > flows at the backend side will have the same 4-tuple.
> >
> >                          +---------------+
> >             1st flow     |  NLB Node #1  |   src: 10.0.0.215:60000
> >          +------------>  |   10.0.3.4    |  +------------+
> >          |               |    :10000     |               |
> >          +               +---------------+               v
> >   +------------+                                   +------------+
> >   |   Client   |                                   |   Target   |
> >   | 10.0.0.215 |                                   | 10.0.3.249 |
> >   |   :60000   |                                   |   :10000   |
> >   +------------+                                   +------------+
> >          +               +---------------+               ^
> >          |               |  NLB Node #2  |               |
> >          +------------>  |   10.0.4.62   |  +------------+
> >             2nd flow     |    :10000     |   src: 10.0.0.215:60000
> >                          +---------------+
> >
> > The kernel responds to the SYN of the 2nd flow with Challenge ACK.  In =
this
> > situation, there are multiple valid reply paths, but the flows behind N=
LB
> > are tracked to ensure symmetric routing [2].  So, the Challenge ACK is
> > routed back to the 2nd NLB node.
> >
> > The 2nd NLB node forwards the Challenge ACK to the client, but the clie=
nt
> > sees it as an invalid response to SYN in tcp_rcv_synsent_state_process(=
)
> > and finally sends RST in tcp_v[46]_do_rcv() based on the sequence numbe=
r
> > by tcp_v[46]_send_reset().  The RST effectively closes the first connec=
tion
> > on the target, and a retransmitted SYN successfully establishes the 2nd
> > connection.
> >
> >   On client:
> >   10.0.0.215.60000 > 10.0.3.4.10000: Flags [S], seq 772948343  ... via =
NLB Node #1
> >   10.0.3.4.10000 > 10.0.0.215.60000: Flags [S.], seq 3739044674, ack 77=
2948344
> >   10.0.0.215.60000 > 10.0.3.4.10000: Flags [.], ack 3739044675
> >
> >   10.0.0.215.60000 > 10.0.4.62.10000: Flags [S], seq 248180743 ... via =
NLB Node #2
> >   10.0.4.62.10000 > 10.0.0.215.60000: Flags [.], ack 772948344 ... Inva=
lid Challenge ACK
> >   10.0.0.215.60000 > 10.0.4.62.10000: Flags [R], seq 772948344 ... RST =
w/ correct seq #
> >   10.0.0.215.60000 > 10.0.4.62.10000: Flags [S], seq 248180743
> >   10.0.4.62.10000 > 10.0.0.215.60000: Flags [S.], seq 4160908213, ack 2=
48180744
> >   10.0.0.215.60000 > 10.0.4.62.10000: Flags [.], ack 4160908214
> >
> >   On target:
> >   10.0.0.215.60000 > 10.0.3.249.10000: Flags [S], seq 772948343 ... via=
 NLB Node #1
> >   10.0.3.249.10000 > 10.0.0.215.60000: Flags [S.], seq 3739044674, ack =
772948344
> >   10.0.0.215.60000 > 10.0.3.249.10000: Flags [.], ack 3739044675
> >
> >   10.0.0.215.60000 > 10.0.3.249.10000: Flags [S], seq 248180743 ... via=
 NLB Node #2
> >   10.0.3.249.10000 > 10.0.0.215.60000: Flags [.], ack 772948344 ... For=
warded to 2nd flow
> >   10.0.0.215.60000 > 10.0.3.249.10000: Flags [R], seq 772948344 ... Clo=
se the 1st connection
> >   10.0.0.215.60000 > 10.0.3.249.10000: Flags [S], seq 248180743
> >   10.0.3.249.10000 > 10.0.0.215.60000: Flags [S.], seq 4160908213, ack =
248180744
> >   10.0.0.215.60000 > 10.0.3.249.10000: Flags [.], ack 4160908214
> >
> > The first connection is still alive from the client's point of view.  W=
hen
> > the client sends data over the first connection, the target responds wi=
th
> > Challenge ACK.  The Challenge ACK is routed back to the 1st connection,=
 and
> > the client responds with Dup ACK, and the target responds to the Dup AC=
K
> > with Challenge ACK, and this continues.
> >
> >   On client:
> >   10.0.0.215.60000 > 10.0.3.4.10000: Flags [P.], seq 772948344:77294834=
9, ack 3739044675, length 5
> >   10.0.3.4.10000 > 10.0.0.215.60000: Flags [.], ack 248180744, length 0=
  ... Challenge ACK
> >   10.0.0.215.60000 > 10.0.3.4.10000: Flags [.], ack 3739044675, length =
0 ... Dup ACK
> >   10.0.3.4.10000 > 10.0.0.215.60000: Flags [.], ack 248180744, length 0=
  ... Challenge ACK
> >   ...
> >
> > In RFC 5961, Challenge ACK assumes that it will be routed back via an
> > asymmetric path to the peer of the established connection.  However, in
> > a situation where multiple valid reply paths are tracked, Challenge ACK
> > gives a hint to snipe another connection and also triggers the Challeng=
e
> > ACK Dup ACK war on the connection.
> >
> > A new sysctl knob, net.ipv4.tcp_reset_challenge, allows us to respond t=
o
> > invalid packets described in RFC 5961 with RST and keep the established
> > socket open.
>
> I did not double check with the RFC, but the above looks like a knob to
> enable a protocol violation.
>
> I'm wondering if the same results could be obtained with a BPF program
> instead?
>
> IMHO we should avoid adding system wide knobs for such specific use-
> case, especially when the controlled behaviour is against the spec.
>

Agreed, this patch looks quite suspect to me.

We will then add many more knobs for other similar situations.

Network Load Balancers can be tricky to implement right.

We should not have to tweak many TCP stacks just because of one implementat=
ion.

Maglev (one of the load balancers used at Google) never asked for a
modification of a TCP stack.

I think such a change would need IETF discussion and approval first.

