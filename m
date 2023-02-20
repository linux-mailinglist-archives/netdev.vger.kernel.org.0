Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9DD69D108
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 17:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbjBTQCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 11:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbjBTQCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 11:02:11 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5E01C7F5
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 08:02:09 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id cq23so6247433edb.1
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 08:02:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oz+Lim3vzTctnZVYeEo5Glt4gskbPFNQ6skBkWiNUYw=;
        b=W+vFifNR6W7RlrNrT5hi3unB8vIPhQVragGC4tQZK3vYWudqKytcwsoDCUz2zzjTY0
         NSgNufwdz5sdkcZcsBR+ZeHFptuXlr8FtOk+VP28fZw3lgKicwF09hz0yi3j6nlkSwx7
         hAYjEmqvumR9GL0ieKwsIJtegXYIDw85UY7CeBn2Dl8UNGpblHBhXDQir9fE1yoCKNur
         D4O6h6X50G2TiVQpmp+o43WsxKab+h5ZPxZzMWVyygpwk9emETRMIdBVIsWNoIayh2jL
         D23CMX3sq+nXeKWNTbB2TmH7NMUJv/LFjvjNBoR2jnJZu9TRXLFrxOA2ZI/tn9Y3Z9y3
         R1XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oz+Lim3vzTctnZVYeEo5Glt4gskbPFNQ6skBkWiNUYw=;
        b=lNJrAPSOwDzj57lgl8yo30H8XniAgGPgEpuMj0/6ByOyvj5/43tSbDzfu7PRLGgMIP
         pAzpppcsz3u+qaVjKybPCMbvmJlCkN1yTpw0XEW40DDjqYyf5ZxKIX62/SAND7xatKvP
         GvgP4K4sU055JCcZ5OcK8EudxyGxC5PgRQ9ccxJ1r21HfQxr4O1/TrsUvbhHBZCdTfbK
         u7PzuOVkrumfBdX5xZ2yDQNWq+5CQqkKqDaTU63GwRfExVd1mWIQSOartcFWH0KUMp/R
         3rBJfYkeg0sWLp9DHkU7ZrVOoeY7DXwYbgiO3sy7lSvUP/wEty19qcZ9k/aD/66ejF30
         +aFA==
X-Gm-Message-State: AO0yUKUeaM+sZv1+8BtZlr6cPB+eYKpezwKnwf8SrPDSftCX2W/5vumf
        EU5lsKc7ocGUw/sCVEpAan3QFIHkGZWgn1OT6oRl7CHApcTNZzkO
X-Google-Smtp-Source: AK7set8ABozJjmKX35Lv0ZbWs6f3hWI3f3e5OwLozz3E1ShEfsDjjtekziEAzVlZdthfSB/Mg4OE3gMVoxHLwyc8wxI=
X-Received: by 2002:a17:906:6d07:b0:8af:4963:fb08 with SMTP id
 m7-20020a1709066d0700b008af4963fb08mr4893281ejr.15.1676908927874; Mon, 20 Feb
 2023 08:02:07 -0800 (PST)
MIME-Version: 1.0
References: <20230220150548.2021-1-peti.antal99@gmail.com> <20230220152942.kj7uojbgfcsowfap@skbuf>
In-Reply-To: <20230220152942.kj7uojbgfcsowfap@skbuf>
From:   =?UTF-8?B?UMOpdGVyIEFudGFs?= <peti.antal99@gmail.com>
Date:   Mon, 20 Feb 2023 17:01:57 +0100
Message-ID: <CAHzwrcfpsBpiEsf4b2Y6xEAhno3rNKz6tWuxqRAUb0HyBT6c7Q@mail.gmail.com>
Subject: Re: [PATCH iproute2] man: tc-mqprio: extend prio-tc-queue mapping
 with examples
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ferenc Fejes <fejes@inf.elte.hu>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        =?UTF-8?B?UMOpdGVyIEFudGFs?= <antal.peti99@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

Vladimir Oltean <vladimir.oltean@nxp.com> ezt =C3=ADrta (id=C5=91pont: 2023=
.
febr. 20., H, 16:29):
>
> Hi P=C3=A9ter,
>
> On Mon, Feb 20, 2023 at 04:05:48PM +0100, P=C3=A9ter Antal wrote:
> > The current mqprio manual is not detailed about queue mapping
> > and priorities, this patch adds some examples to it.
> >
> > Suggested-by: Ferenc Fejes <fejes@inf.elte.hu>
> > Signed-off-by: P=C3=A9ter Antal <peti.antal99@gmail.com>
> > ---
>
> I think it's great that you are doing this. However, with all due respect=
,
> this conflicts with the man page restructuring I am already doing for the
> frame preemption work. Do you mind if I fix up some things and I pick you=
r
> patch up, and submit it as part of my series? I have some comments below.

That's all right, thank you for doing this, just please carry my
signoff as co-developer if possible.
I agree with most of your suggestions.

>
> >  man/man8/tc-mqprio.8 | 96 ++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 96 insertions(+)
> >
> > diff --git a/man/man8/tc-mqprio.8 b/man/man8/tc-mqprio.8
> > index 4b9e942e..16ecb9a1 100644
> > --- a/man/man8/tc-mqprio.8
> > +++ b/man/man8/tc-mqprio.8
> > @@ -98,6 +98,7 @@ belong to an application. See kernel and cgroup docum=
entation for details.
> >  .TP
> >  num_tc
> >  Number of traffic classes to use. Up to 16 classes supported.
> > +You cannot have more classes than queues
>
> More impersonal: "There cannot be more traffic classes than TX queues".
>
> >
> >  .TP
> >  map
> > @@ -119,6 +120,8 @@ Set to
> >  to support hardware offload. Set to
> >  .B 0
> >  to configure user specified values in software only.
> > +The default value of this parameter is
> > +.B 1
> >
> >  .TP
> >  mode
> > @@ -146,5 +149,98 @@ max_rate
> >  Maximum value of bandwidth rate limit for a traffic class.
> >
> >
> > +.SH EXAMPLE
> > +
> > +The following example shows how to attach priorities to 4 traffic clas=
ses ("num_tc 4"),
> > +and then how to pair these traffic classes with 4 hardware queues with=
 mqprio,
>
> "with mqprio" is understated I think, this is the mqprio man page
>
> > +with hardware coordination ("hw 1", or does not specified, because 1 i=
s the default value).
>
> Just leave it at that, "hw 1".
>
> > +Traffic class 0 (tc0) is mapped to hardware queue 0 (q0), tc1 is mappe=
d to q1,
> > +tc2 is mapped to q2, and tc3 is mapped q3.
>
> Would prefer saying TC0, TXQ0 etc if you don't mind.
>
> > +
> > +.EX
> > +# tc qdisc add dev eth0 root mqprio \
> > +              num_tc 4 \
> > +              map 0 0 0 0 1 1 1 1 2 2 2 2 3 3 3 3 \
> > +              queues 1@0 1@1 1@2 1@3 \
> > +              hw 1
> > +.EE
> > +
> > +The next example shows how to attach priorities to 3 traffic classes (=
"num_tc 3"),
> > +and how to pair these traffic classes with 4 queues,
> > +without hardware coordination ("hw 0").
> > +Traffic class 0 (tc0) is mapped to hardware queue 0 (q0), tc1 is mappe=
d to q1,
> > +tc2 and is mapped to q2 and q3, where the queue selection between thes=
e
> > +two queues is somewhat randomly decided.
>
> Would rather say that packets are hashed arbitrarily between TXQ3 and
> TXQ4, which have the same scheduling priority.

If I understand it correctly, this depends on the "hw" parameter.
So if the driver handles this (hw 1), then it may prioritize a queue
over another,
even if they have the same priority.

>
> We should probably clarify what "hardware coordination" means, exactly.
> Without hardware coordination, the device driver is not notified of the
> number of traffic classes and their mapping to TXQs. The device is not
> expected to prioritize between traffic classes without hardware
> coordination.
>
> We should also probably clarify that with hardware coordination, the
> device driver can install a different TXQ configuration than requested,
> and that the default TC to TXQ mapping is:
>
> TC 0: 0 queues @ offset 0
> TC 1: 0 queues @ offset 0
> ...
> TC N: 0 queues @ offset 0
>

First time I see hardware coordination in this manual is the hw parameter,
so I think we should clarify this there.

> Should also probably clarify that there is a default prio:tc map of:
>
> .prio_tc_map =3D { 0, 1, 2, 3, 4, 5, 6, 7, 0, 1, 1, 1, 3, 3, 3, 3 },
>
> hmm... you gave me more work than I was intending to do :)

Sorry about that :)

>
> > +
> > +.EX
> > +# tc qdisc add dev eth0 root mqprio \
> > +              num_tc 3 \
> > +              map 0 0 0 0 1 1 1 1 2 2 2 2 2 2 2 2 \
> > +              queues 1@0 1@1 2@2 \
> > +              hw 0
> > +.EE
> > +
> > +
> > +In both cases from above the priority values from 0 to 3 (prio0-3) are
> > +mapped to tc0, prio4-7 are mapped to tc1, and the
> > +prio8-11 are mapped to tc2 ("map" attribute). The last four priority v=
alues
> > +(prio12-15) are mapped in different ways in the two examples.
> > +They are mapped to tc3 in the first example and mapped to tc2 in the s=
econd example.
> > +The values of these two examples are the following:
> > +
> > + =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=90  =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
> > + =E2=94=82Prio=E2=94=82 tc =E2=94=82 queue =E2=94=82  =E2=94=82Prio=E2=
=94=82 tc =E2=94=82  queue =E2=94=82
> > + =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=A4  =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4
> > + =E2=94=82  0 =E2=94=82  0 =E2=94=82     0 =E2=94=82  =E2=94=82  0 =E2=
=94=82  0 =E2=94=82      0 =E2=94=82
> > + =E2=94=82  1 =E2=94=82  0 =E2=94=82     0 =E2=94=82  =E2=94=82  1 =E2=
=94=82  0 =E2=94=82      0 =E2=94=82
> > + =E2=94=82  2 =E2=94=82  0 =E2=94=82     0 =E2=94=82  =E2=94=82  2 =E2=
=94=82  0 =E2=94=82      0 =E2=94=82
> > + =E2=94=82  3 =E2=94=82  0 =E2=94=82     0 =E2=94=82  =E2=94=82  3 =E2=
=94=82  0 =E2=94=82      0 =E2=94=82
> > + =E2=94=82  4 =E2=94=82  1 =E2=94=82     1 =E2=94=82  =E2=94=82  4 =E2=
=94=82  1 =E2=94=82      1 =E2=94=82
> > + =E2=94=82  5 =E2=94=82  1 =E2=94=82     1 =E2=94=82  =E2=94=82  5 =E2=
=94=82  1 =E2=94=82      1 =E2=94=82
> > + =E2=94=82  6 =E2=94=82  1 =E2=94=82     1 =E2=94=82  =E2=94=82  6 =E2=
=94=82  1 =E2=94=82      1 =E2=94=82
> > + =E2=94=82  7 =E2=94=82  1 =E2=94=82     1 =E2=94=82  =E2=94=82  7 =E2=
=94=82  1 =E2=94=82      1 =E2=94=82
> > + =E2=94=82  8 =E2=94=82  2 =E2=94=82     2 =E2=94=82  =E2=94=82  8 =E2=
=94=82  2 =E2=94=82 2 or 3 =E2=94=82
> > + =E2=94=82  9 =E2=94=82  2 =E2=94=82     2 =E2=94=82  =E2=94=82  9 =E2=
=94=82  2 =E2=94=82 2 or 3 =E2=94=82
> > + =E2=94=82 10 =E2=94=82  2 =E2=94=82     2 =E2=94=82  =E2=94=82 10 =E2=
=94=82  2 =E2=94=82 2 or 3 =E2=94=82
> > + =E2=94=82 11 =E2=94=82  2 =E2=94=82     2 =E2=94=82  =E2=94=82 11 =E2=
=94=82  2 =E2=94=82 2 or 3 =E2=94=82
> > + =E2=94=82 12 =E2=94=82  3 =E2=94=82     3 =E2=94=82  =E2=94=82 12 =E2=
=94=82  2 =E2=94=82 2 or 3 =E2=94=82
> > + =E2=94=82 13 =E2=94=82  3 =E2=94=82     3 =E2=94=82  =E2=94=82 13 =E2=
=94=82  2 =E2=94=82 2 or 3 =E2=94=82
> > + =E2=94=82 14 =E2=94=82  3 =E2=94=82     3 =E2=94=82  =E2=94=82 14 =E2=
=94=82  2 =E2=94=82 2 or 3 =E2=94=82
> > + =E2=94=82 15 =E2=94=82  3 =E2=94=82     3 =E2=94=82  =E2=94=82 15 =E2=
=94=82  2 =E2=94=82 2 or 3 =E2=94=82
> > + =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=98  =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=B4=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
> > +       example1             example2
>
> What would you say if we didn't put the 2 examples side by side, but
> kept them separately? Also, I get the feeling that the verbiage above
> the tables is a bit too much. Having the tables is already good enough.
>
> > +
> > +Another example of queue mapping is the following.
> > +There are 5 traffic classes, and there are 8 hardware queues.
>
> I think for maintainability, the examples should be fairly independent,
> because they might be moved around in the future. This story-like
> "the following example" -> "the next example" -> "another example"
> doesn't really work.
>
> > +.EX
> > +# tc qdisc add dev eth0 root mqprio \
> > +              num_tc 5 \
> > +              map 0 0 0 1 1 1 1 2 2 3 3 4 4 4 4 4 \
> > +              queues 1@0 2@1 1@3 1@4 3@5
>
> The formatting here and everywhere doesn't look very well when viewed
> with "man -l man/man8/tc-mqprio.8". If you look at tc-taprio.8, it uses
> "\\" to render properly. If you don't mind, I'll do that here too.
>
> > +.EE
> > +
> > +The value mapping is the following for this example:
> > +
> > +        =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=90
> > + tc0=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4Queue 0=E2=94=82=E2=
=97=84=E2=94=80=E2=94=80=E2=94=80=E2=94=801@0
> > +        =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=A4
> > +      =E2=94=8C=E2=94=80=E2=94=A4Queue 1=E2=94=82=E2=97=84=E2=94=80=E2=
=94=80=E2=94=80=E2=94=802@1
> > + tc1=E2=94=80=E2=94=80=E2=94=A4 =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4
> > +      =E2=94=94=E2=94=80=E2=94=A4Queue 2=E2=94=82
> > +        =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=A4
> > + tc2=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4Queue 3=E2=94=82=E2=
=97=84=E2=94=80=E2=94=80=E2=94=80=E2=94=801@3
> > +        =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=A4
> > + tc3=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4Queue 4=E2=94=82=E2=
=97=84=E2=94=80=E2=94=80=E2=94=80=E2=94=801@4
> > +        =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=A4
> > +      =E2=94=8C=E2=94=80=E2=94=A4Queue 5=E2=94=82=E2=97=84=E2=94=80=E2=
=94=80=E2=94=80=E2=94=803@5
> > +      =E2=94=82 =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=A4
> > + tc4=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=A4Queue 6=E2=94=82
> > +      =E2=94=82 =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=A4
> > +      =E2=94=94=E2=94=80=E2=94=A4Queue 7=E2=94=82
> > +        =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=98
> > +
> > +
> >  .SH AUTHORS
> >  John Fastabend, <john.r.fastabend@intel.com>
> > --
> > 2.34.1
> >

Best,
Peter
