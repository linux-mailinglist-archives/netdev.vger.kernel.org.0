Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 024BEA07E7
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 18:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfH1Q4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 12:56:08 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:46131 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfH1Q4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 12:56:08 -0400
Received: by mail-io1-f66.google.com with SMTP id x4so831233iog.13;
        Wed, 28 Aug 2019 09:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XtVu0M60DPSYglrLkenpf+d54vTagJwbRonJ20E0bWg=;
        b=NRe6gVsH1hiPZEvMyTsPfY1Gaynom/WWL8OAcvozeLfHb5AuDbhXbphdmdLCORo3Co
         f/fr2taT4+Er7U3cL8XJHonFw9x9v9JgDG8m3QEb6avNsiz1jrBX4jjB1dzy4iXTRgVJ
         gGub6sPjgghf24IqqbMVgvA+pLZK/vvLJWsDJmYK8XE3/MrOKDCCG13VqU/PMTi3bCOw
         PzHsQoLqzN+6/m+ptk6efiSmw5J1vySjeomkYBefVUo/n6F5fSMlf56GwMS0AbH4Y+b/
         +oXc2GTGgHeP4AjQGtos1nOnYyRhIXotNYYHI6n0cPxRhaYBDXugLDfJ+YwkbVXs5aNW
         8ygw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XtVu0M60DPSYglrLkenpf+d54vTagJwbRonJ20E0bWg=;
        b=e6CxBxgp7KxeQIGq4kP+sbFoJjBjSA2U9UFQfXgqO0cZqj4BGK6hVoqNSC7dvoFh7+
         1zMWy8CSsySpO/pWLBzDRGuQUr/oMFx4pXBE1dnTGZYfsZSwyblkfAis31p0ISbjoSSq
         ET7VxYaWYjkbtCKUfkSxskJJmpyOT6BQ6U7eUD+TuDzFDbWTuFNwjh0qEQniER3Zj6Iy
         z/U4Q5QAfbChB6vhiEuaHt2zpU3bUs/TeYIE22ot7uYiBUynqZY1UdnVz/rkpbAIfgBx
         1wpHlRxBkmgTama6PzioOFzWlhoArA1mPv9Fc6mMyZlVW//GOhi/VmrNM7jAxUnwgB0r
         JX+w==
X-Gm-Message-State: APjAAAWRc5+InrukT6PkTRGKjiCep+a/3RShXNdQUQW7+B963NvVT1Nr
        HyUmmjjop52pqmWgVcrM06iLiCLVIKj9nvSQ3aU=
X-Google-Smtp-Source: APXvYqzCIwisJnLrSjzmy94PGFehXocWcHZUcOfh8e9+xHR/TFNN6X1XVnb8d7hd/cDIfozzIRAny1/9btffNA7O4UM=
X-Received: by 2002:a5e:8344:: with SMTP id y4mr5275477iom.213.1567011367110;
 Wed, 28 Aug 2019 09:56:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190822080045.27609-1-olivier.tilmans@nokia-bell-labs.com>
 <CAA93jw5_LN_-zhHh=zZA8r6Zvv1CvA_AikT_rCgWyT8ytQM_rg@mail.gmail.com>
 <20190823125130.4y3kcg6ghewghbxg@nokia-bell-labs.com> <bded966b-5176-69c8-4ac3-70d81d344c22@bobbriscoe.net>
In-Reply-To: <bded966b-5176-69c8-4ac3-70d81d344c22@bobbriscoe.net>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Wed, 28 Aug 2019 09:55:54 -0700
Message-ID: <CAA93jw5R2QWSngdKX5RSvGR5NEvFTH-Sp5__k+EroxkkQkfzcw@mail.gmail.com>
Subject: Re: [PATCH net-next v5] sched: Add dualpi2 qdisc
To:     Bob Briscoe <research@bobbriscoe.net>
Cc:     "Tilmans, Olivier (Nokia - BE/Antwerp)" 
        <olivier.tilmans@nokia-bell-labs.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Olga Albisser <olga@albisser.org>,
        "De Schepper, Koen (Nokia - BE/Antwerp)" 
        <koen.de_schepper@nokia-bell-labs.com>,
        Henrik Steen <henrist@henrist.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 28, 2019 at 7:00 AM Bob Briscoe <research@bobbriscoe.net> wrote=
:
>
> Olivier, Dave,
>
> On 23/08/2019 13:59, Tilmans, Olivier (Nokia - BE/Antwerp) wrote:
>
> as best as I can
> tell (but could be wrong) the NQB idea wants to put something into the
> l4s fast queue? Or is NQB supposed to
> be a third queue?
>
> NQB is not supported in this release of the code. But FYI, it's not for a=
 third queue.

At the time of my code review of dualpi I had not gone back to review
the NQB draft fully.

> We can add support for NQB in the future, by expanding the
> dualpi2_skb_classify() function. This is however out of scope at the
> moment as NQB is not yet adopted by the TSV WG. I'd guess we may want mor=
e

> than just the NQB DSCP codepoint in the L queue, which then warrant
> another way to classify traffic, e.g., using tc filter hints.

Yes, you'll find find folk are fans of being able to put tc (and ebpf)
filters in front of various qdiscs for classification, logging, and/or
dropping behavior.

A fairly typical stanza is here:
https://github.com/torvalds/linux/blob/master/net/sched/sch_sfq.c#L171
to line 193.

> The IETF adopted the NQB draft at the meeting just passed in July, but th=
e draft has not yet been updated to reflect that: https://tools.ietf.org/ht=
ml/draft-white-tsvwg-nqb-02

Hmmm... no. I think oliver's statement was correct.

NQB was put into the "call for adoption into tsvwg" state (
https://mailarchive.ietf.org/arch/msg/tsvwg/fjyYQgU9xQCNalwPO7v9-al6mGk
) in the tsvwg aug 21st, which
doesn't mean "adopted by the ietf", either. In response to that call
several folk did put in (rather pithy),
comments on the current state of the NQB idea and internet draft, starting =
here:

https://mailarchive.ietf.org/arch/msg/tsvwg/hZGjm899t87YZl9JJUOWQq4KBsk

For those here that are not familiar with IETF processes (and there
are many!) there are "internet drafts" that may or may not become
working group items, that if they become accepted by the working group
may or may not evolve to become actual RFCs.  Unlike lkml usage where
we use RFC in its original meaning as a mere request for comments,
there are several classes of IETF RFC - standards track, experimental,
and informational - whenever they are adopted and published by the
ietf.

There are RFCs for how they do RFCs, and BCPs and other TLAs, and if
you really want to know more about how the ietf processes actually
work, please contact me off list. Anyway...

Much of the experimental L4S architecture itself (of which NQB MAY
become part, and dualpi/tcpprague/etc are) is presently an accepted
tsvwg wg item with a list of 11 problems on the bug database here (
https://trac.ietf.org/trac/tsvwg/report/1?sort=3Dticket&asc=3D1&page=3D1 ).
IMHO it's not currently near last call for standardization as a set of
experimental RFCs.

L4S takes advantage of several RFCs that have
indeed been published as experimental, notably, RFC8311, which too few
have read as yet.

While using up ECT1 in the L4S code as an identifier and not as a
congestion indicator is very controversial for me (
https://lwn.net/Articles/783673/ ), AND I'd rather it not be baked
into the linux api for dualpi should this identifier not be chosen by
the wg (thus my suggestion of a mask or lookup table)...

... I also dearly would like both sides of this code - dualpi and tcp
prague - in a simultaneously testable and high quality state. Without
that, many core ideas in dualpi cannot be tested, nor objectively
evaluated against other tcps and qdiscs using rfc3168 behavior along
the path. Multiple experimental ideas in RFC8311 (such as those in
section 4.3) have also not been re-evaluated in any context.

Is the known to work reference codebase for "tcp prague" still 3.19 based?

> The draft requests 0x2A (decimal 42) as the DSCP but, until the IETF conv=
erges on a specific DSCP for NQB, I believe we should not code in a default=
 classifier anyway.
>
>
>
> Bob
>
> --
> ________________________________________________________________
> Bob Briscoe                               http://bobbriscoe.net/



--

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-205-9740
