Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 633BE50837
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 12:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbfFXKP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 06:15:28 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:34351 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727730AbfFXKP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 06:15:27 -0400
Received: by mail-oi1-f193.google.com with SMTP id a128so9383802oib.1
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 03:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yHJZvBlbYrBwyc6awHXuPOa0clE2Wfg7RBV2vW+6gWk=;
        b=uHLa9j3oIYEGV+54vUZjDQXIWGqgQD5HbmeF+kHRnx6HIP0JIkV6/2jmI74dbLwLhU
         TyMfcaXFpWga8xsSMd+ZEmdPe7Ug2LrBoQuqucGmu1zecUdFWKWsxgXcYwXcQc/X/CHY
         ksOJww6SiPqJaWr1vahcndoFkk1W90PJ9FhPSY6T8iNMqsMkRYMRlZ07Qk+JjWnFknX0
         tI/O06uTt1rA/9cVuf1taLorRV8WcwGNTIjZ75MZKmNU+TItPHvRiPYN7hV0bIQDFW3W
         QP8H4zSGVyeXBPrIc8ymUWRuJvMejSZTmi6IoyYp8zDUrW63SvrN5MP5NFaK39EWpYFp
         NRPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yHJZvBlbYrBwyc6awHXuPOa0clE2Wfg7RBV2vW+6gWk=;
        b=dMQmtQUeP+lT7fC58aTo70UMviZt0NHj2yozybb3A22D8dj1sTJPEmQ3ySjVASe5fn
         hUqp484I2z5m8g2E6HHzDtUHaj7ARAbNjyRjMO05usAInQDJPRbjDY8t7/BaKIlnQK4W
         az0ym35BT9gQoWYGfrrOMci7O7kdiImYUV/swHajlSJZtjA5BvyaI4LeQJNiW+85Ld2F
         b3N0fggGm2/pWbXh/+/PC01CSTlWGwutpU/ehRCEMa3X58zFtTtZ9bYdu1wWutFUI6bY
         9JE+oUJlV8hn+nrhHLhaRk5oxNyKZTudDPrDEIRTIzRobIeLaXU17hHE8U3QbcLkOrWg
         WM+g==
X-Gm-Message-State: APjAAAWxPHtthpHm1c8oYE9zLwrp29l+Aah0WE9oxjE0Pe4grCUPcmZj
        m4vITV4YJQ5mr6mhuOuY+1S96fNSZEPSljlc+Lc=
X-Google-Smtp-Source: APXvYqyfuemRamkuk4l2uDedYTrvXponb7aZ7ZM2bJSftZypp0lHAdaTWk18LIU2F7xDa6rR+VmLt+HsO5w83+UffKQ=
X-Received: by 2002:aca:4306:: with SMTP id q6mr10519196oia.39.1561371327209;
 Mon, 24 Jun 2019 03:15:27 -0700 (PDT)
MIME-Version: 1.0
References: <49d3ddb42f531618584f60c740d9469e5406e114.1561130674.git.echaudro@redhat.com>
 <CAEf4BzZsmH+4A0dADeXYUDqeEK9N_-PVqzHW_=vPytjEX1hqTA@mail.gmail.com> <1C59E98E-7F4B-4FCA-AB95-68D3819C489C@redhat.com>
In-Reply-To: <1C59E98E-7F4B-4FCA-AB95-68D3819C489C@redhat.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 24 Jun 2019 12:15:16 +0200
Message-ID: <CAJ8uoz2sGGHeKVewwUCUck-S5mbccpDD0yotOs12Ss2ouDrm5A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: add xsk_ring_prod__free() function
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 11:53 AM Eelco Chaudron <echaudro@redhat.com> wrote=
:
>
>
>
> On 21 Jun 2019, at 21:13, Andrii Nakryiko wrote:
>
> > On Fri, Jun 21, 2019 at 8:26 AM Eelco Chaudron <echaudro@redhat.com>
> > wrote:
> >>
> >> When an AF_XDP application received X packets, it does not mean X
> >> frames can be stuffed into the producer ring. To make it easier for
> >> AF_XDP applications this API allows them to check how many frames can
> >> be added into the ring.
> >>
> >> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> >> ---
> >>  tools/lib/bpf/xsk.h | 6 ++++++
> >>  1 file changed, 6 insertions(+)
> >>
> >> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> >> index 82ea71a0f3ec..86f3d485e957 100644
> >> --- a/tools/lib/bpf/xsk.h
> >> +++ b/tools/lib/bpf/xsk.h
> >> @@ -95,6 +95,12 @@ static inline __u32 xsk_prod_nb_free(struct
> >> xsk_ring_prod *r, __u32 nb)
> >>         return r->cached_cons - r->cached_prod;
> >>  }
> >>
> >> +static inline __u32 xsk_ring_prod__free(struct xsk_ring_prod *r)
> >
> > This is a very bad name choice. __free is used for functions that free
> > memory and resources. One function below I see avail is used in the
> > name, why not xsk_ring_prog__avail?
>
> Must agree that free sound like you are freeing entries=E2=80=A6 However,=
 I
> just kept the naming already in the API/file (see above,
> xsk_prod_nb_free()).
> Reading the code there is a difference as xx_avail() means available
> filled entries, where xx_free() means available free entries.
>
> So I could rename it to xsk_ring_prod__nb_free() maybe?

xsk_ring_prod__nb_free() is fine with me. In truth, Andrii's
suggestion is fine too since the number of available entries from the
producer point of view is the number of free entries I can put stuff
in.

Your function is expensive though since it always touches global
state. I think it would be better to expose the xsk_prod_nb_free()
function as is, but with this new name. Then users can say how many
entries they want maximum and avoid touching global state when not
needed. You would also have to change all the functions that use
xsk_prod_nb_free, so it uses you new function. What do you think?

/Magnus

> Forgot to include Magnus in the email, so copied him in, for some
> comments.
>
> >> +{
> >> +       r->cached_cons =3D *r->consumer + r->size;
> >> +       return r->cached_cons - r->cached_prod;
> >> +}
> >> +
> >>  static inline __u32 xsk_cons_nb_avail(struct xsk_ring_cons *r, __u32
> >> nb)
> >>  {
> >>         __u32 entries =3D r->cached_prod - r->cached_cons;
> >> --
> >> 2.20.1
> >>
