Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCD860FB0
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 11:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbfGFJ5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 05:57:44 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:36117 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfGFJ5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 05:57:44 -0400
Received: by mail-ot1-f65.google.com with SMTP id r6so11366478oti.3
        for <netdev@vger.kernel.org>; Sat, 06 Jul 2019 02:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gn3xZbV6ZlIPpwbrnydWHOfv7rLLexeeWox6YhTkMQ4=;
        b=aaVlGhH37aU3LmoMGkUHSJ/r8rcTX/z1pudUYN3DQdgLo4nUmdcTLdqpf0Vk1eoXQA
         SC6vuhvZqQhsEIXKxfcLDWaabFrnh5XiA+MfyPHeByAI1jvp9FQ2PIIgbmkkhfShvR+S
         0LAM6jrzCH9xZhtdEbsmN4GBkQq35m9vVyjQLTcsZqzq4O7Kp/ZhavyyYH4aNLjNzgsz
         uSyvtnyJqQ9izMo3e0Ha3BJnTfGFkYwhqKYqTEyk4Bf55v/rAoQFU0wN3iv4l31YnPJ2
         fUMp3Ku5+IydE6CAyQa6q6oLGiZWPGbJlSRFvOZhjNLFmb//r3QiuAZubud8zLLgJf00
         9PPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gn3xZbV6ZlIPpwbrnydWHOfv7rLLexeeWox6YhTkMQ4=;
        b=dPJfe0syMxOo2WRX0Kqc2Cae2H4uJsGZohLctl88V5MmY+PPjf9NgnV6wnIjHKvwL7
         MsnmAHxoHSaLeN1lnZbY7ukKn0nTBolar4Mk7ou10yn+Tsb58z9YO84L1kWx5GKOmIiH
         jWcEl3h1JL5HFOUdrXxBes0lppGlN0YnNVSrllbc8gxp2z55GjNXOG1glwK4ulIDjOLE
         mQDF1IsmLg+k+L3T1nCS+kMjO+qz1Zc/Q6NDBwJQPIjGhb2Bj7EoD1sbLY7Z5CVYzYWK
         fnP/ZQ9pgUtBpX8ZKEof7y9XBOpv3BP9XnLP0yqLDwY9pqoyi/82omkUc4H/I/0y5Vbm
         5cYA==
X-Gm-Message-State: APjAAAW8b3Q06Jw0pF33VARUCwyQnlDCN/SLKEjUMW13moPUasYlASNY
        vEtO3RLZUr8+3I7B1m3iQ5Ao2peY6sDKA5huZhM=
X-Google-Smtp-Source: APXvYqzzrRmyLftxjcnect8e6dyA1etpgjqLATspbaEMyHeoLg026QpQIfykI1XK0Gqn/oceydd72MsCgradZEakMBw=
X-Received: by 2002:a9d:77c2:: with SMTP id w2mr6322022otl.192.1562407063362;
 Sat, 06 Jul 2019 02:57:43 -0700 (PDT)
MIME-Version: 1.0
References: <ea49f66f73aedcdade979605dab6b2474e2dc4cb.1562145300.git.echaudro@redhat.com>
 <c86151f8-9a16-d2e4-a888-d0836ff3c10a@iogearbox.net>
In-Reply-To: <c86151f8-9a16-d2e4-a888-d0836ff3c10a@iogearbox.net>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Sat, 6 Jul 2019 11:57:32 +0200
Message-ID: <CAJ8uoz0LjXMaVgnf7_UkfRwN2Dx11m1Th5FXyf1vgGWDd5Tswg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] libbpf: add xsk_ring_prod__nb_free() function
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Eelco Chaudron <echaudro@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 5, 2019 at 4:35 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 07/03/2019 02:52 PM, Eelco Chaudron wrote:
> > When an AF_XDP application received X packets, it does not mean X
> > frames can be stuffed into the producer ring. To make it easier for
> > AF_XDP applications this API allows them to check how many frames can
> > be added into the ring.
> >
> > Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>
> The commit log as it is along with the code is a bit too confusing for
> readers. After all you only do a rename below. It would need to additionally
> state that the rename is as per libbpf convention (xyz__ prefix) in order to
> denote that this API is exposed to be used by applications.
>
> Given you are doing this for xsk_prod_nb_free(), should we do the same for
> xsk_cons_nb_avail() as well? Extending XDP sample app would be reasonable
> addition as well in this context.

Sorry for the late reply Eelco. My e-mail filter is apparently not set
up correctly since it does not catch mails where I am on the CC line.
Will fix.

At the same time you are rewording the commit log according to
Daniel's suggestion, could you please also add a line or two
explaining how to use the nb parameter? If you set it to the size of
the ring, you will get the exact amount of slots available, at the
cost of performance (you touch shared state for sure). nb is there to
limit the touching of shared state. The same kind of comment in the
header file would be great too.

Have you found any use of the  xsk_cons_nb_avail() function from your
sample application? If so, let us add it to the public API.

Thanks: Magnus

> > ---
> >
> > v2 -> v3
> >  - Removed cache by pass option
> >
> > v1 -> v2
> >  - Renamed xsk_ring_prod__free() to xsk_ring_prod__nb_free()
> >  - Add caching so it will only touch global state when needed
> >
> >  tools/lib/bpf/xsk.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> > index 82ea71a0f3ec..3411556e04d9 100644
> > --- a/tools/lib/bpf/xsk.h
> > +++ b/tools/lib/bpf/xsk.h
> > @@ -76,7 +76,7 @@ xsk_ring_cons__rx_desc(const struct xsk_ring_cons *rx, __u32 idx)
> >       return &descs[idx & rx->mask];
> >  }
> >
> > -static inline __u32 xsk_prod_nb_free(struct xsk_ring_prod *r, __u32 nb)
> > +static inline __u32 xsk_prod__nb_free(struct xsk_ring_prod *r, __u32 nb)
> >  {
> >       __u32 free_entries = r->cached_cons - r->cached_prod;
> >
> > @@ -110,7 +110,7 @@ static inline __u32 xsk_cons_nb_avail(struct xsk_ring_cons *r, __u32 nb)
> >  static inline size_t xsk_ring_prod__reserve(struct xsk_ring_prod *prod,
> >                                           size_t nb, __u32 *idx)
> >  {
> > -     if (xsk_prod_nb_free(prod, nb) < nb)
> > +     if (xsk_prod__nb_free(prod, nb) < nb)
> >               return 0;
> >
> >       *idx = prod->cached_prod;
> >
>
