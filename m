Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C61814E6DF
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 02:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbgAaBsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 20:48:11 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:37870 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbgAaBsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 20:48:11 -0500
Received: by mail-io1-f68.google.com with SMTP id k24so6401122ioc.4
        for <netdev@vger.kernel.org>; Thu, 30 Jan 2020 17:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=J7ih43DYxXFb9m7jGqTQYIcRSjX1o4Mvb8stlrbMOB4=;
        b=maw38d7+uo8+kLl5EbaBlwSBgtkG59QMHaj6N2oXvgDJzXw6Ta1KQu/wGVB5VoY/jh
         YxxD2Uy5gz3O5Jdv3LxR7WiZw6+i7FMukfutqh26usFeNe/iqHD1Af6BpJadeWhIyz6e
         RVvsG5aoGJyNtP+8uWH2CVJ7HH67CVU3KDVMR88dnf1Mh8jqWF30O9o0PA8G4o5RNz5M
         Pqio37oTSsMhhR02P4aQfjy1wZmfFuKCV8OvdaxQVAyX+RjX7lFCLGS0B6o2K0cxCeDB
         vFq+/XDtA3dlgYvpT6P6cSHijEEZwTh4oygPbg29G00s4sZPu51rU0RebGht2kfr5Z81
         zf4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=J7ih43DYxXFb9m7jGqTQYIcRSjX1o4Mvb8stlrbMOB4=;
        b=DMRwCt55+5tLNhl3+5nhOxKTae51zzICnqkJGH4xDY3Jot/Wyzp81jpi/5BCtV228G
         IZNme/Ro1nbV0jOZG+Pd3qHS/uYZKSjMacVaQOCz2wvYCRp/qOP451qkLv1THS6IKYrp
         8YV0LPbXZ/WNlGVficlA685VomW6rZKrdckIXeZg8TfA4xmmJl8cJVShOH2TJYVnUhSJ
         8+c/PmYGEOKJELolg/5Y8DP2RTWWzNYilJPKLo43yTEqJzS7PD0WdFKZbZtlqL0mrJbY
         LKVULBemSYDMDmbnVJ310b0MOPVHxju5A3UfWlVupNXMOnYIG/MJyzNtEOKo9BuGP6bk
         DMmA==
X-Gm-Message-State: APjAAAW5pFSv2kykhNM7wxnRIkDNg6e3Gz1tnyUfOLwHNVFbjZkAfPRg
        mTNAFT6lxveRzgieGdBSAMF+VXg5c5i/X26RLCA=
X-Google-Smtp-Source: APXvYqw/f/pzTgYSH7LSnBsOJyGOf8YoMFwj/mDFCKbuJNSX4zR8qfuUdW7HHcqsbJqCUT6xLr05mrcVn+SnYgSnvdw=
X-Received: by 2002:a02:c773:: with SMTP id k19mr6255231jao.61.1580435290699;
 Thu, 30 Jan 2020 17:48:10 -0800 (PST)
MIME-Version: 1.0
References: <FC053E80-74C9-4884-92F1-4DBEB5F0C81A@mellanox.com>
In-Reply-To: <FC053E80-74C9-4884-92F1-4DBEB5F0C81A@mellanox.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Thu, 30 Jan 2020 17:47:59 -0800
Message-ID: <CAA93jw6tgQF4XMKN5etJqkO4xvxSFDCn41en7LSJ55gVJeGybQ@mail.gmail.com>
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

On Thu, Jan 30, 2020 at 8:21 AM Yossi Kuperman <yossiku@mellanox.com> wrote=
:
>
> Following is an outline briefly describing our plans towards offloading H=
TB functionality.
>
> HTB qdisc allows you to use one physical link to simulate several slower =
links. This is done by configuring a hierarchical QoS tree; each tree node =
corresponds to a class. Filters are used to classify flows to different cla=
sses. HTB is quite flexible and versatile, but it comes with a cost. HTB do=
es not scale and consumes considerable CPU and memory. Our aim is to offloa=
d HTB functionality to hardware and provide the user with the flexibility a=
nd the conventional tools offered by TC subsystem, while scaling to thousan=
ds of traffic classes and maintaining wire-speed performance.
>
> Mellanox hardware can support hierarchical rate-limiting; rate-limiting i=
s done per hardware queue. In our proposed solution, flow classification ta=
kes place in software. By moving the classification to clsact egress hook, =
which is thread-safe and does not require locking, we avoid the contention =
induced by the single qdisc lock. Furthermore, clsact filters are perform b=
efore the net-device=E2=80=99s TX queue is selected, allowing the driver a =
chance to translate the class to the appropriate hardware queue. Please not=
e that the user will need to configure the filters slightly different; appl=
y them to the clsact rather than to the HTB itself, and set the priority to=
 the desired class-id.
>
> For example, the following two filters are equivalent:
>         1. tc filter add dev eth0 parent 1:0 protocol ip flower dst_port =
80 classid 1:10
>         2. tc filter add dev eth0 egress protocol ip flower dst_port 80 a=
ction skbedit priority 1:10
>
> Note: to support the above filter no code changes to the upstream kernel =
nor to iproute2 package is required.
>
> Furthermore, the most concerning aspect of the current HTB implementation=
 is its lack of support for multi-queue. All net-device=E2=80=99s TX queues=
 points to the same HTB instance, resulting in high spin-lock contention. T=
his contention (might) negates the overall performance gains expected by in=
troducing the offload in the first place. We should modify HTB to present i=
tself as mq qdisc does. By default, mq qdisc allocates a simple fifo qdisc =
per TX queue exposed by the lower layer device. This is only when hardware =
offload is configured, otherwise, HTB behaves as usual. There is no HTB cod=
e along the data-path; the only overhead compared to regular traffic is the=
 classification taking place at clsact. Please note that this design induce=
s full offload---no fallback to software; it is not trivial to partial offl=
oad the hierarchical tree considering borrowing between siblings anyway.
>
>
> To summaries: for each HTB leaf-class the driver will allocate a special =
queue and match it with a corresponding net-device TX queue (increase real_=
num_tx_queues). A unique fifo qdisc will be attached to any such TX queue. =
Classification will still take place in software, but rather at the clsact =
egress hook. This way we can scale to thousands of classes while maintainin=
g wire-speed performance and reducing CPU overhead.
>
> Any feedback will be much appreciated.

It was of course my hope that fifos would be universally replaced with
rfc8290 or rfc8033 by now. So moving a software htb +
net.core.default_qdisc =3D "of anything other than pfifo_fast" to a
hardware offload with fifos... will be "interesting". Will there be
features to at least limit the size of the offloaded fifo by packets
(or preferably, bytes?).




>
> Cheers,
> Kuperman
>
>


--=20
Make Music, Not War

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-435-0729
