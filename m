Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCFC23E0705
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 19:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239977AbhHDR5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 13:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238270AbhHDR5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 13:57:51 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA64C0613D5;
        Wed,  4 Aug 2021 10:57:38 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id h9so4995798ejs.4;
        Wed, 04 Aug 2021 10:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hv6OJITDeCO1wZKdd4Bk2dI2GTNw+Rm7uJdsjk0rDgo=;
        b=nd+v3KM//dHdWrDKhud6dJZMizCqe82AyFfUAXfbklC67SZ7SkQbHka2kvZPF5O32c
         f4lHUhq+MWmpzIaNWXad8zZN6ZOSl6wMM+dl1Q9k/hnTey2CQA/7+QAGKl9rQuPp5PWA
         j0qzWiuL0f2FHlXU5Vbmo5qfzsRvwgZBWIByFBWq1dpqKxPcPyQQYsr11ru0XGg/gpT0
         +2Qh1hNfG2oaJNNGWi3a9ZKeugrzDM/qb/85g0ZDzC21xkDOQ6a/FSVPjAjsXMuvY9HI
         MmKtbEkQJI8/IiSdVeDdIMceK3KM4BgLoKjOq8N5Oy64CrVE+sNseSnLJn5k2vW89kOe
         0S5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hv6OJITDeCO1wZKdd4Bk2dI2GTNw+Rm7uJdsjk0rDgo=;
        b=TifzWw2HpePdKANokA9yxjrNNt0WbHiGyjArChmH2eSTozXTzhX0sIl4OKBmKEgY55
         Lh2JinWzYg7VbRCMIdXqzqlN2awOwGhQpBQHUIEu5qYC3HBtliHIX6xfHYCNFGjUUpDb
         s5cmGZkw74Ns3lDoh3Ade4mEc4Fsk7cle6CLD7csddMHowqN+/CJhCDECSd8YBMjOAw6
         eqIxOTjnB9RMxi0QimQRTAho2pFbuj9IYK5NEf5u4C2Tt14j8AckBXOB1peZD/6T/MQG
         jWc7I5uPWqR7FXjE2f3lDsBR2XHQvxFNSsAV8w61zovn0esI51I491c1QXFwguis41oi
         Q+6w==
X-Gm-Message-State: AOAM532rzqmlkywxtE0T38wrAV1MDjSdl5Lho/cNOo0NF13/mHuR85e+
        2/tRGxbb/eRRhvgn/4IQzI9mlZR0TYoTzQdujGw=
X-Google-Smtp-Source: ABdhPJxL85OILSymzCbF8NDSlvJ1b433gAjux2RGQTx2bblBUjdzk7XlKWDFXRV8lHl1rJS2FWnEEZ36hxhVx5ij48g=
X-Received: by 2002:a17:906:fc0b:: with SMTP id ov11mr417955ejb.238.1628099857243;
 Wed, 04 Aug 2021 10:57:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210731005632.13228-1-matthew.cover@stackpath.com> <20210731152523.22syukzew6c7njjh@apollo.localdomain>
In-Reply-To: <20210731152523.22syukzew6c7njjh@apollo.localdomain>
From:   Matt Cover <werekraken@gmail.com>
Date:   Wed, 4 Aug 2021 10:57:25 -0700
Message-ID: <CAGyo_hp2Uunp0_McN3J8MjSeF593thwiODfUaiE-u_NXArEDPg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] samples/bpf: xdp_redirect_cpu: Add mprog-disable
 to optstring.
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthew Cover <matthew.cover@stackpath.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 31, 2021 at 8:25 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Sat, Jul 31, 2021 at 06:26:32AM IST, Matthew Cover wrote:
> > Commit ce4dade7f12a ("samples/bpf: xdp_redirect_cpu: Load a eBPF program
> > on cpumap") added the following option, but missed adding it to optstring:
> > - mprog-disable: disable loading XDP program on cpumap entries
> >
> > Add the missing option character.
> >
>
> I made some changes in this area in [0], since the support was primarily to do
> redirection from the cpumap prog, so by default we don't install anything now
> and only do so if a redirection interface is specified (and use devmap instead).
> So this option won't be used anyway going forward (since we don't install a
> dummy XDP_PASS program anymore) if it gets accepted.
>
> [0]: https://lore.kernel.org/bpf/20210728165552.435050-1-memxor@gmail.com
>
> PS: I can restore it again if this is something really used beyond redirecting
> to another device (i.e. with custom BPF programs). Any feedback would be helpful.

Hey Kartikeya. I happened to be looking through this code to get a
feel for using CPUMAP for custom steering (e.g. RSS on encapsulated
packets) in XDP and noticed the missing option character. Figured it
was worth doing a quick patch and test.

Unfortunately, I'm not able to say much on your changes as I'm still
getting familiarized with this code. It looks like your submission is
in need of a rebase; v3 has been marked "Changes Requested" in
patchwork [0]. As I see things, It'd be good to get this fix in there
for now, whether or not the code is removed later.

[0]:https://patchwork.kernel.org/project/netdevbpf/patch/20210728165552.435050-9-memxor@gmail.com/

>
> > Fixes: ce4dade7f12a ("samples/bpf: xdp_redirect_cpu: Load a eBPF program on cpumap")
> > Signed-off-by: Matthew Cover <matthew.cover@stackpath.com>
> > ---
> >  samples/bpf/xdp_redirect_cpu_user.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
> > index d3ecdc1..9e225c9 100644
> > --- a/samples/bpf/xdp_redirect_cpu_user.c
> > +++ b/samples/bpf/xdp_redirect_cpu_user.c
> > @@ -841,7 +841,7 @@ int main(int argc, char **argv)
> >       memset(cpu, 0, n_cpus * sizeof(int));
> >
> >       /* Parse commands line args */
> > -     while ((opt = getopt_long(argc, argv, "hSd:s:p:q:c:xzFf:e:r:m:",
> > +     while ((opt = getopt_long(argc, argv, "hSd:s:p:q:c:xzFf:e:r:m:n",
> >                                 long_options, &longindex)) != -1) {
> >               switch (opt) {
> >               case 'd':
> > --
> > 1.8.3.1
> >
>
> --
> Kartikeya
