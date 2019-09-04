Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F968A8249
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 14:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729973AbfIDMVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 08:21:15 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:44228 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfIDMVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 08:21:15 -0400
Received: by mail-ot1-f67.google.com with SMTP id 21so12914862otj.11;
        Wed, 04 Sep 2019 05:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rHaqVeFyBPmMJqp0NJ1A/jwQaC3tHW81qREyqlZbtWg=;
        b=a7mDRhy5rSIG0FnoXNs0h8NLoQ+2PLLSFCGdReAkkZdyKO2im6S723BApKIcBX9GaP
         k+p4Y4VNCI8Js+S4ZN+mOYxe2gliNcBcRMFZhkTARY3Zff0zorxcWvgNMWlVMeNPAEkD
         BmCymUYJYlH1kq93rWyjs86Wr7wk/qaP8UBDVok3S4FVtSd7AgSmFEihcae6V9skXVed
         DAe/BO/Db4Fa0dWxt/iwV1ILdCQxsHq6rMZq+MwagiequdCgncm93kjWAgFfjFcYisto
         5rZvIfqOpo9NUZOtfQcbo52RML6tWEAZRk62e93pU145Yv6bcZYwdNd9QYDviL3AOnD1
         C6kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rHaqVeFyBPmMJqp0NJ1A/jwQaC3tHW81qREyqlZbtWg=;
        b=HK//0sBhZaImu3iN1cZOaE5+0flmQ5zP0AOAUljB1nxPGPYBW3pQzcqMV1mZyclN80
         iogtcJHPn4Rl+MahQiNpeYLcTLUEYjszbLp/iFEmaOzxknpl/v0p7O6GtWnDhvzDSMQ3
         DxV5ITBh2KxXHwVgddemXH2RU9oYuYAO2nqwRMZRzkNYOHpMxI6naHtdJkODSbI+GmWb
         tV5MNjMK/1/4PGRxOnH1LrDiC19eqFFJHo1GghUK5k2P4oDWDkU0Ss7Cn8pUMtD+CeL2
         j/Sr3JBp5tuWIpjrIFfGe2Dw7W780iZuRNbY0zhQ3r5wzaQRmXTLNoaYw3ZnlOCKIxWP
         9ZaQ==
X-Gm-Message-State: APjAAAUc4RupTRdBUTcWd3XKMxZHx449gigYqDV+ZT+fApvjg9GU3yp0
        RlaiqEdcur18W7SvOCwKsroNQbvZfkGtDTWm6sYsYNqb
X-Google-Smtp-Source: APXvYqyU0L4uckeWKAFqjUiOJk7jDNi/kZJbekGY4z9+Q7SMYSd7h5WT4LRuUnyw3C12CZXH8omvle2mYNXpl7sA9AQ=
X-Received: by 2002:a9d:4e11:: with SMTP id p17mr5863173otf.192.1567599674208;
 Wed, 04 Sep 2019 05:21:14 -0700 (PDT)
MIME-Version: 1.0
References: <1554792253-27081-1-git-send-email-magnus.karlsson@intel.com>
 <1554792253-27081-3-git-send-email-magnus.karlsson@intel.com>
 <xunyo9007hk9.fsf@redhat.com> <CAJ8uoz2LEun-bjUYQKZdx9NbLBOSRGsZZTWAp10=vhiP7Dms9g@mail.gmail.com>
 <xunyftlc7dn8.fsf@redhat.com> <CAJ8uoz3jhr+VUmtjotW07mnDkYLgOYYO2HpV9hOv3i8B4=Z_CQ@mail.gmail.com>
 <xuny36hc6ypx.fsf@redhat.com>
In-Reply-To: <xuny36hc6ypx.fsf@redhat.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 4 Sep 2019 14:21:02 +0200
Message-ID: <CAJ8uoz3nCVoOBeiryeH-WYSqg4540vfcG7LJCF+uGGWdpf5eTQ@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] libbpf: remove dependency on barrier.h in xsk.h
To:     Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 4, 2019 at 2:19 PM Yauheni Kaliuta
<yauheni.kaliuta@redhat.com> wrote:
>
> Hi, Magnus!
>
> >>>>> On Wed, 4 Sep 2019 12:25:13 +0200, Magnus Karlsson  wrote:
>  > On Wed, Sep 4, 2019 at 8:56 AM Yauheni Kaliuta
>  > <yauheni.kaliuta@redhat.com> wrote:
>  >>
>  >> Hi, Magnus!
>  >>
>  >> >>>>> On Wed, 4 Sep 2019 08:39:24 +0200, Magnus Karlsson  wrote:
>  >>
>  >> > On Wed, Sep 4, 2019 at 7:32 AM Yauheni Kaliuta
>  >> > <yauheni.kaliuta@redhat.com> wrote:
>  >> >>
>  >> >> Hi, Magnus!
>  >> >>
>  >> >> >>>>> On Tue,  9 Apr 2019 08:44:13 +0200, Magnus Karlsson  wrote:
>  >> >>
>  >> >> > The use of smp_rmb() and smp_wmb() creates a Linux header dependency
>  >> >> > on barrier.h that is uneccessary in most parts. This patch implements
>  >> >> > the two small defines that are needed from barrier.h. As a bonus, the
>  >> >> > new implementations are faster than the default ones as they default
>  >> >> > to sfence and lfence for x86, while we only need a compiler barrier in
>  >> >> > our case. Just as it is when the same ring access code is compiled in
>  >> >> > the kernel.
>  >> >>
>  >> >> > Fixes: 1cad07884239 ("libbpf: add support for using AF_XDP sockets")
>  >> >> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
>  >> >> > ---
>  >> >> >  tools/lib/bpf/xsk.h | 19 +++++++++++++++++--
>  >> >> >  1 file changed, 17 insertions(+), 2 deletions(-)
>  >> >>
>  >> >> > diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
>  >> >> > index 3638147..317b44f 100644
>  >> >> > --- a/tools/lib/bpf/xsk.h
>  >> >> > +++ b/tools/lib/bpf/xsk.h
>  >> >> > @@ -39,6 +39,21 @@ DEFINE_XSK_RING(xsk_ring_cons);
>  >> >> >  struct xsk_umem;
>  >> >> >  struct xsk_socket;
>  >> >>
>  >> >> > +#if !defined bpf_smp_rmb && !defined bpf_smp_wmb
>  >> >> > +# if defined(__i386__) || defined(__x86_64__)
>  >> >> > +#  define bpf_smp_rmb() asm volatile("" : : : "memory")
>  >> >> > +#  define bpf_smp_wmb() asm volatile("" : : : "memory")
>  >> >> > +# elif defined(__aarch64__)
>  >> >> > +#  define bpf_smp_rmb() asm volatile("dmb ishld" : : : "memory")
>  >> >> > +#  define bpf_smp_wmb() asm volatile("dmb ishst" : : : "memory")
>  >> >> > +# elif defined(__arm__)
>  >> >> > +#  define bpf_smp_rmb() asm volatile("dmb ish" : : : "memory")
>  >> >> > +#  define bpf_smp_wmb() asm volatile("dmb ishst" : : : "memory")
>  >> >> > +# else
>  >> >> > +#  error Architecture not supported by the XDP socket code in libbpf.
>  >> >> > +# endif
>  >> >> > +#endif
>  >> >> > +
>  >> >>
>  >> >> What about other architectures then?
>  >>
>  >> > AF_XDP has not been tested on anything else, as far as I
>  >> > know. But contributions that extend it to more archs are
>  >> > very welcome.
>  >>
>  >> Well, I'll may be try to fetch something from barrier.h's
>  >> (since I cannot consider myself as a specialist in the area),
>  >> but at the moment the patch breaks the build on that arches.
>
>  > Do you have a specific architecture in mind and do you have
>  > some board/server (of that architecture) you could test AF_XDP
>  > on?
>
> I do care about s390 and ppc64 and I can run tests for them.

Perfect!. Thanks.

/Magnus

>
> [...]
>
> --
> WBR,
> Yauheni Kaliuta
