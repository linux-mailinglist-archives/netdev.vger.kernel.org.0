Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034DA268A26
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 13:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725984AbgINLfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 07:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbgINLaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 07:30:06 -0400
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFC5C06174A;
        Mon, 14 Sep 2020 04:30:05 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id b12so1143366oop.13;
        Mon, 14 Sep 2020 04:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IHo51WPtHcrSuIjkvqKEkR20E8SnHKbY5of3aXU8Wwg=;
        b=s2FNW8gUo4Ok1ljCbNhs8UjPxIyqdTsEDolS/6nxpgW3Jt+jJYQhyFF4unJ6RuYA7p
         sIqLHMmz2IQjn+difqr+CfIdnPy3KEAErlAqHb5dX3Odf8FmqiVcdcp9c9XsNEagh9wu
         j3GssXAy4iHGvNSFuAMr+Z9vQWGUBPkQGxF3rVVaH0iOVMlGY4s5lr0XgujwpalmpHJg
         qYTj8f7jQjfkj6XXFFyDMsLblhRGcdMATAAzcx1Pf7f/+bD6vw3kYHW4lYvYSAls59qv
         iAKBzav1+Sgh92AuhuBWRkXfvoTdz2X7rddU2u4vQ+bwDUBoqJ2hfsu92LIN0K8nNgbE
         C3dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IHo51WPtHcrSuIjkvqKEkR20E8SnHKbY5of3aXU8Wwg=;
        b=MuRRh44u2tYwhduxfP4nEh0MfsaBCJEAIN9tB93U3rqY0OvwKGHzz6hkDVhtcQtifH
         wGaYULhifzpsNNLxvh+fhOueq2l+vzXuT1bAKeRoNK3PXUuscXReHWz77Qb1B+zzfVqt
         828ieVcUo5VTjBxpWlfL9VuhyIvcMh8asG4WliIRfXb5ej5rUvWMbOrG7nj1lZha+hza
         RyP8O9sxCiolQQHmONqIFEWnU6TlowcudM2NsicwJzk/TmE3HBVPojKw6TFOzHvtKUd7
         6REL7dzFjATlzz+tjAqtR0vHU/AHmEjPxpR18DKkN4p9rLijQ2A3OlEB6p5yg3WW2E5K
         JhoA==
X-Gm-Message-State: AOAM5321zpmzXnjpBosoUPDtPxiX//gWd07VOGEnGWFjyjBp/Q+2q7Ef
        LTKyQ5G+uZCRWQklWIqAj60Of022rE6WcrcU0f0=
X-Google-Smtp-Source: ABdhPJyfVIwFTkpMKyOVv+ePSakgff3nevRYR2pTEtP6/5/HT6YWsWTYNx0eRRXKOx0u+maWIdRXTqP9WsTqW4XBcFY=
X-Received: by 2002:a4a:3e13:: with SMTP id t19mr9816013oot.49.1600083005286;
 Mon, 14 Sep 2020 04:30:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200904162154.GA24295@wunner.de> <813edf35-6fcf-c569-aab7-4da654546d9d@iogearbox.net>
 <20200905052403.GA10306@wunner.de> <e8aecc2b-80cb-8ee5-8efe-7ae5c4eafc70@iogearbox.net>
 <CAF90-Whc3HL9x-7TJ7m3tZp10RNmQxFD=wdQUJLCaUajL2RqXg@mail.gmail.com> <8e991436-cb1c-1306-51ac-bb582bfaa8a7@iogearbox.net>
In-Reply-To: <8e991436-cb1c-1306-51ac-bb582bfaa8a7@iogearbox.net>
From:   =?UTF-8?Q?Laura_Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>
Date:   Mon, 14 Sep 2020 13:29:52 +0200
Message-ID: <CAF90-Wh=wzjNtFWRv9bzn=-Dkg-Qc9G_cnyoq0jSypxQQgg3uA@mail.gmail.com>
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Lukas Wunner <lukas@wunner.de>,
        John Fastabend <john.fastabend@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

On Fri, Sep 11, 2020 at 6:28 PM Daniel Borkmann <daniel@iogearbox.net> wrot=
e:
>
> On 9/11/20 9:42 AM, Laura Garc=C3=ADa Li=C3=A9bana wrote:
> > On Tue, Sep 8, 2020 at 2:55 PM Daniel Borkmann <daniel@iogearbox.net> w=
rote:
> >> On 9/5/20 7:24 AM, Lukas Wunner wrote:
> >>> On Fri, Sep 04, 2020 at 11:14:37PM +0200, Daniel Borkmann wrote:
> >>>> On 9/4/20 6:21 PM, Lukas Wunner wrote:
> >> [...]
> >>>> The tc queueing layer which is below is not the tc egress hook; the
> >>>> latter is for filtering/mangling/forwarding or helping the lower tc
> >>>> queueing layer to classify.
> >>>
> >>> People want to apply netfilter rules on egress, so either we need an
> >>> egress hook in the xmit path or we'd have to teach tc to filter and
> >>> mangle based on netfilter rules.  The former seemed more straight-for=
ward
> >>> to me but I'm happy to pursue other directions.
> >>
> >> I would strongly prefer something where nf integrates into existing tc=
 hook,
> >> not only due to the hook reuse which would be better, but also to allo=
w for a
> >> more flexible interaction between tc/BPF use cases and nf, to name one
> >
> > That sounds good but I'm afraid that it would take too much back and
> > forth discussions. We'll really appreciate it if this small patch can
> > be unblocked and then rethink the refactoring of ingress/egress hooks
> > that you commented in another thread.
>
> I'm not sure whether your comment was serious or not, but nope, this need=
s
> to be addressed as mentioned as otherwise this use case would regress. It

This patch doesn't break anything. The tc redirect use case that you
just commented on is the expected behavior and the same will happen
with ingress. To be consistent, in the case that someone requires both
hooks, another tc redirect would be needed in the egress path. If you
mean to bypass the nf egress if tc redirect in ingress is used, that
would lead in a huge security concern.

Please elaborate on where do you see a break in this patch.

> is one thing for you wanting to remove tc / BPF from your application sta=
ck
> as you call it, but not at the cost of breaking others.
>

I'm not intended to remove tc / BPF from my application stack as I'm
not using it and, as I explained in past emails, it can't be used for
my use cases.

In addition, let's review your NACK reasons:

   This reverts the following commits:

     8537f78647c0 ("netfilter: Introduce egress hook")
     5418d3881e1f ("netfilter: Generalize ingress hook")
     b030f194aed2 ("netfilter: Rename ingress hook include file")

   From the discussion in [0], the author's main motivation to add a hook
   in fast path is for an out of tree kernel module, which is a red flag
   to begin with. Other mentioned potential use cases like NAT{64,46}
   is on future extensions w/o concrete code in the tree yet. Revert as
   suggested [1] given the weak justification to add more hooks to critical
   fast-path.

     [0] https://lore.kernel.org/netdev/cover.1583927267.git.lukas@wunner.d=
e/
     [1] https://lore.kernel.org/netdev/20200318.011152.72770718915606186.d=
avem@davemloft.net/


It has been explained already that there are more use cases that
require this hook in nf, not only for future developments or out of
tree modules.

Thank you!
