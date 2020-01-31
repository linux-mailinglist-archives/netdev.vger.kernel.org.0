Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7713714F3E8
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 22:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbgAaVmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 16:42:46 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:35734 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbgAaVmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 16:42:46 -0500
Received: by mail-il1-f193.google.com with SMTP id g12so7550398ild.2
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 13:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sgpGtlxt/5Fo9rCEGP1LovXxfU33xVTWmXpF3uOYwks=;
        b=TbA9oWblQNmtsWDJKrjqnMGEiesU33uDTCYNP2+UqXg2+zU2hfJFtDXUCmmXvpPpIp
         xPUFWW+QSpbdx4EEKwtWEKt+9kdWdymYebBCE9TztYMaToyb59sOiLzK41ON++DSmlY5
         IY8cNUkZ/bHtryO9t+fl96DoNWt7RoWvWPaxBK/Vi9gq6ZH5eOxaKr9aVuWdREU7Q+X8
         sicCHCw/B3qeXEMsgzqYj3z6I11paEuvShVI2XL71oHo6F49g7hAgSoQD3yOBPsGi00l
         XXRIWnPQjYvItfyafBKSs3RQKaTDDJ/huvxFkeNmV3yFPQ0DEQXT1esdAXfTUN0/d+X/
         zUtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sgpGtlxt/5Fo9rCEGP1LovXxfU33xVTWmXpF3uOYwks=;
        b=dM4NJ+VoLH5F2EEv+SrKrh9/0F8G4OJkOCI99In9JLZJ4MZ8f/LE2+UctMGurxKF3t
         hGhh+I57NyesPPMc0OjUeL39Nr/IWfrh0rIg8cogFSatmstc9l3zvDHyP9quwp2mTSWD
         q9Gbm+o1Csl5U0X4y47hH3A25E85Lf0qtyWLIQpPMrfF5uo7WSUSu47Ca2qj6Fk8NQ4J
         xheJwZ7/ykY1kJ+6ms26+ZyAtZqxpy9C9xHOpivdiIdwFc2vbXwbKl/XuIsgrIk+hOlI
         Q7e6nAXhc8KVJ4zXK/0BYBNV6P+KSWwUOYcG94GAWs02k1i2SKURhzMzCzz/hYJUXlst
         yRrA==
X-Gm-Message-State: APjAAAUt6XBs6kN7lH561rGvvkQYc85gmbnu7yHrGtMnnyaiA8S+lXEd
        HNK+dZ1oBtYau0xvJsZCCXs2hC7XPTD3GQqIY15WouUE
X-Google-Smtp-Source: APXvYqwqhrYBhu2PF92uyrcE90SDfjRcggAO+kedqSXlsmAOVeRjMonWDQK5ThMZShCRKEkrI5PFJGh9Pg9i0b/8rs4=
X-Received: by 2002:a92:85d2:: with SMTP id f201mr4884204ilh.45.1580506963908;
 Fri, 31 Jan 2020 13:42:43 -0800 (PST)
MIME-Version: 1.0
References: <FC053E80-74C9-4884-92F1-4DBEB5F0C81A@mellanox.com> <CAA93jw6tgQF4XMKN5etJqkO4xvxSFDCn41en7LSJ55gVJeGybQ@mail.gmail.com>
In-Reply-To: <CAA93jw6tgQF4XMKN5etJqkO4xvxSFDCn41en7LSJ55gVJeGybQ@mail.gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Fri, 31 Jan 2020 13:42:33 -0800
Message-ID: <CAA93jw7Lph4+8_CS2zjz0vqB91Vs2vEMbLSc98ExsMdEjeUq=Q@mail.gmail.com>
Subject: Re: [RFC] Hierarchical QoS Hardware Offload (HTB)
To:     Yossi Kuperman <yossiku@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 30, 2020 at 5:47 PM Dave Taht <dave.taht@gmail.com> wrote:
>
> On Thu, Jan 30, 2020 at 8:21 AM Yossi Kuperman <yossiku@mellanox.com> wro=
te:
> >
> > Following is an outline briefly describing our plans towards offloading=
 HTB functionality.
> >
> > HTB qdisc allows you to use one physical link to simulate several slowe=
r links. This is done by configuring a hierarchical QoS tree; each tree nod=
e corresponds to a class. Filters are used to classify flows to different c=
lasses. HTB is quite flexible and versatile, but it comes with a cost. HTB =
does not scale and consumes considerable CPU and memory. Our aim is to offl=
oad HTB functionality to hardware and provide the user with the flexibility=
 and the conventional tools offered by TC subsystem, while scaling to thous=
ands of traffic classes and maintaining wire-speed performance.
> >
> > Mellanox hardware can support hierarchical rate-limiting; rate-limiting=
 is done per hardware queue. In our proposed solution, flow classification =
takes place in software. By moving the classification to clsact egress hook=
, which is thread-safe and does not require locking, we avoid the contentio=
n induced by the single qdisc lock. Furthermore, clsact filters are perform=
 before the net-device=E2=80=99s TX queue is selected, allowing the driver =
a chance to translate the class to the appropriate hardware queue. Please n=
ote that the user will need to configure the filters slightly different; ap=
ply them to the clsact rather than to the HTB itself, and set the priority =
to the desired class-id.
> >
> > For example, the following two filters are equivalent:
> >         1. tc filter add dev eth0 parent 1:0 protocol ip flower dst_por=
t 80 classid 1:10
> >         2. tc filter add dev eth0 egress protocol ip flower dst_port 80=
 action skbedit priority 1:10
> >
> > Note: to support the above filter no code changes to the upstream kerne=
l nor to iproute2 package is required.
> >
> > Furthermore, the most concerning aspect of the current HTB implementati=
on is its lack of support for multi-queue. All net-device=E2=80=99s TX queu=
es points to the same HTB instance, resulting in high spin-lock contention.=
 This contention (might) negates the overall performance gains expected by =
introducing the offload in the first place. We should modify HTB to present=
 itself as mq qdisc does. By default, mq qdisc allocates a simple fifo qdis=
c per TX queue exposed by the lower layer device. This is only when hardwar=
e offload is configured, otherwise, HTB behaves as usual. There is no HTB c=
ode along the data-path; the only overhead compared to regular traffic is t=
he classification taking place at clsact. Please note that this design indu=
ces full offload---no fallback to software; it is not trivial to partial of=
fload the hierarchical tree considering borrowing between siblings anyway.
> >
> >
> > To summaries: for each HTB leaf-class the driver will allocate a specia=
l queue and match it with a corresponding net-device TX queue (increase rea=
l_num_tx_queues). A unique fifo qdisc will be attached to any such TX queue=
. Classification will still take place in software, but rather at the clsac=
t egress hook. This way we can scale to thousands of classes while maintain=
ing wire-speed performance and reducing CPU overhead.
> >
> > Any feedback will be much appreciated.
>
> It was of course my hope that fifos would be universally replaced with
> rfc8290 or rfc8033 by now. So moving a software htb +
> net.core.default_qdisc =3D "of anything other than pfifo_fast" to a
> hardware offload with fifos... will be "interesting". Will there be
> features to at least limit the size of the offloaded fifo by packets
> (or preferably, bytes?).

Another hope, in the long run, was that something like this might
prove feasible for more hw offloads.

https://tools.ietf.org/html/draft-morton-tsvwg-cheap-nasty-queueing-01
>
>
>
>
> >
> > Cheers,
> > Kuperman
> >
> >
>
>
> --
> Make Music, Not War
>
> Dave T=C3=A4ht
> CTO, TekLibre, LLC
> http://www.teklibre.com
> Tel: 1-831-435-0729



--=20
Make Music, Not War

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-435-0729
