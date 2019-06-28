Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57B6059839
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 12:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfF1KOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 06:14:32 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:39109 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbfF1KOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 06:14:32 -0400
Received: by mail-oi1-f195.google.com with SMTP id m202so3872985oig.6
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 03:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HS6l2mvOx3M5tZnavsaRGyrhC++E8StAQDAuSIyZM7I=;
        b=JySljVN5W7kAWQhIKprX4269QapVWm/Cr0E7LLbcx8TrTqsqJsHg91lABqJVRTyvIz
         yRyHPb3jqJDAhSt9FnoBoYFqTpLMyxZzJo4HqXlSMeLg4j3hjbLLPO2XACGOSpRMpVG+
         d4CEflqzrcFgmL7SUk1ubujMDWev1GlNPXrE+9J0F4j4B5UXMMB4fntWgx6UBi6dd9v6
         +QXAEohfMFfOEeTJyDHygETIMUvOlVZcNBJgG3c6s46Q82w8iAv3luVu5sJP+H6mDZEg
         Aa5ODwRKYAryujXvD563xjZeE6iAnqbBIzXZF+EdJ0OQn9+SzbQiiKT1WUlakkYHQvow
         BZeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HS6l2mvOx3M5tZnavsaRGyrhC++E8StAQDAuSIyZM7I=;
        b=sxo5EHzMg6mT2H+UBCxqSL1+Q97FqOsuewJgdK/3MR0cPyWPK/p7cnB2iUd4AIlJZ5
         cAcV+xKfVcXnMUXQnmNI0lGvNsRNSIHdckxD8riodHSeUtczcA1yRtPTXq//l91wmjxk
         EwfcHTwzIGbPfdivB4hZpcUBPYS5A7crkEVT+yTvrxytOy9x/dD9dvbRDQCJvvVwl5TI
         +yMa78KSPi+xZWQfLftLur6lti7BsYp8+ePOGzLLf7lOsP3yNPv7XZKOiehK82+5wjkv
         7xUu/VjQWZnF75GJp4jwiLdQOh2eoPxqRfFxSif+dGaod5+rYebOO0ZpP6SIfgPWOH3s
         SINw==
X-Gm-Message-State: APjAAAV4X22vQUpXQ3a3WDVTitkoGi/nMSs9vC5pN9s7dy2hvID+mvJH
        cCK1/IItddUYQeep0SjqorcwwHxe2OeQiK/9qwiJ8mA5
X-Google-Smtp-Source: APXvYqzhBPw/47Mt4qqMdqa5VuLzUbAOjCm2BeYvEtZOZjP2AzZ11yEE5VYLrHMFYUlw3SZFbYGPueSHJpWuHVrnhsU=
X-Received: by 2002:a05:6808:8c2:: with SMTP id k2mr1166818oij.98.1561716871000;
 Fri, 28 Jun 2019 03:14:31 -0700 (PDT)
MIME-Version: 1.0
References: <d4692ea57ba7a3fe33549fc6222fb8aea5a4225e.1561537968.git.echaudro@redhat.com>
In-Reply-To: <d4692ea57ba7a3fe33549fc6222fb8aea5a4225e.1561537968.git.echaudro@redhat.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 28 Jun 2019 12:14:20 +0200
Message-ID: <CAJ8uoz3BoLiM04WW=91wYryrVBqj5GDsL5mvDaAyBAv-6MNbsQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] libbpf: add xsk_ring_prod__nb_free() function
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 10:33 AM Eelco Chaudron <echaudro@redhat.com> wrote:
>
> When an AF_XDP application received X packets, it does not mean X
> frames can be stuffed into the producer ring. To make it easier for
> AF_XDP applications this API allows them to check how many frames can
> be added into the ring.
>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---
>
> v1 -> v2
>  - Renamed xsk_ring_prod__free() to xsk_ring_prod__nb_free()
>  - Add caching so it will only touch global state when needed
>
>  tools/lib/bpf/xsk.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> index 82ea71a0f3ec..6acb81102346 100644
> --- a/tools/lib/bpf/xsk.h
> +++ b/tools/lib/bpf/xsk.h
> @@ -76,11 +76,11 @@ xsk_ring_cons__rx_desc(const struct xsk_ring_cons *rx, __u32 idx)
>         return &descs[idx & rx->mask];
>  }
>
> -static inline __u32 xsk_prod_nb_free(struct xsk_ring_prod *r, __u32 nb)
> +static inline __u32 xsk_prod__nb_free(struct xsk_ring_prod *r, __u32 nb)
>  {
>         __u32 free_entries = r->cached_cons - r->cached_prod;
>
> -       if (free_entries >= nb)
> +       if (free_entries >= nb && nb != 0)
>                 return free_entries;

Thanks Eelco for the patch. Is the test nb != 0 introduced here so
that the function will continue with the refresh from the global state
when nb is set to 0? If so, could a user not instead just set the nb
parameter to the size of the ring? This would always trigger a
refresh, except when the number of free entries is equal to the size
of the ring, but then we do not need the refresh anyway. This would
eliminate the nb != 0 test that you introduced from the fast path.

/Magnus

>         /* Refresh the local tail pointer.
> @@ -110,7 +110,7 @@ static inline __u32 xsk_cons_nb_avail(struct xsk_ring_cons *r, __u32 nb)
>  static inline size_t xsk_ring_prod__reserve(struct xsk_ring_prod *prod,
>                                             size_t nb, __u32 *idx)
>  {
> -       if (xsk_prod_nb_free(prod, nb) < nb)
> +       if (xsk_prod__nb_free(prod, nb) < nb)
>                 return 0;
>
>         *idx = prod->cached_prod;
> --
> 2.20.1
>
