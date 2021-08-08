Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6343E3BDD
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 19:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbhHHRUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 13:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbhHHRUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 13:20:04 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86FE1C061760;
        Sun,  8 Aug 2021 10:19:44 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id k24so8633641vsg.9;
        Sun, 08 Aug 2021 10:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vtiBarJA2O3XYt1tUFE/I5LovrEOojrmK31AlVK6Ol0=;
        b=a/kOWvI/nFqESMGbUxe4awyrXxSG9AUxnJLkwfbc/53URjXKXCluX48sji/6H+xGRd
         go6ijFKp4j0Dx9F3qi9p8TmQHMlAskeJJV/v323S6EjPrEgR2IU7FxoJNQdb6VMXADdD
         x575/rsA2+xNVEsrIBBvOQrl/Yi0Fxz15Xj0RC+mMfKNwcNGSlmb+uzf6te3FedrfZmP
         5ffwidlhwiLn3LWYC+jJz+9GL5T8s/kGftz+7xQTeAjrkCPrwH2ZeBbwZXCMWvErQp4n
         77VtXTH8740S2reUZN9dPLuLv9ebuFTU+Fq17YzJA+BqPfd/+ybuBo7cGMChpfuuKdlE
         vJrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vtiBarJA2O3XYt1tUFE/I5LovrEOojrmK31AlVK6Ol0=;
        b=kOffy/+xBxbFyF0ICDv2qRvvriOl0dyUkPXLzIGV1sOFje2CR73EBLxgJSZCEfR4bp
         eS6mymN18xupINcy2ho0Gdt2JpJZkG/d0iPOZa6AHgF0USQYJRQZ8fKRMRC1C6pZ8+1Z
         1G20AzwsEN3FPnoGJni7EyVKjuPdFqP149sLha/I9NQwzjtDmVEIfd8yWJA2KLFTWYim
         QfOCKWqLG92tESZ9K9TFULBUflWGFVwabg3L10xZrzhFNXq59tLJQa30AhDYrOObDIQa
         xOa2+ujpKsfzvz8uM8RCdT3cVZBGs3ONUpQqjpqSKulquyPD4KHmVVzfbhyJhaR18Dvv
         c5LA==
X-Gm-Message-State: AOAM530DeMAjws9OydGiaak/jKZVHKtQcH8v8vaa+JWssJTBuIoN/GWM
        dDPtRVWp/JDG+iXSzjrj5tUjbomkoAcdNodJjOE=
X-Google-Smtp-Source: ABdhPJxhh2JbB4V5du3GdOf5QgIqy4FLdeN4oyYjSTKkP/oHzfFW7y7jtyugIiNqZVzh0/OJMlCSGT/Yqg+RZhz524s=
X-Received: by 2002:a67:16c1:: with SMTP id 184mr14134320vsw.14.1628443183656;
 Sun, 08 Aug 2021 10:19:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210808122411.10980-1-falakreyaz@gmail.com> <be9121ef-cea7-d3f9-b1cf-edd9e4e1a756@fb.com>
In-Reply-To: <be9121ef-cea7-d3f9-b1cf-edd9e4e1a756@fb.com>
From:   Muhammad Falak Reyaz <falakreyaz@gmail.com>
Date:   Sun, 8 Aug 2021 22:49:32 +0530
Message-ID: <CAOmbKqkYDXvMQntk39Ud-63G3ju+Kti2A8UFNodgJ6y1+4=AeA@mail.gmail.com>
Subject: Re: [PATCH] samples: bpf: xdp1: remove duplicate code to find protocol
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 8, 2021 at 10:23 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 8/8/21 5:24 AM, Muhammad Falak R Wani wrote:
> > The code to find h_vlan_encapsulated_proto is duplicated.
> > Remove the extra block.
> >
> > Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
> > ---
> >   samples/bpf/xdp1_kern.c | 9 ---------
> >   1 file changed, 9 deletions(-)
> >
> > diff --git a/samples/bpf/xdp1_kern.c b/samples/bpf/xdp1_kern.c
> > index 34b64394ed9c..a35e064d7726 100644
> > --- a/samples/bpf/xdp1_kern.c
> > +++ b/samples/bpf/xdp1_kern.c
> > @@ -57,15 +57,6 @@ int xdp_prog1(struct xdp_md *ctx)
> >
> >       h_proto = eth->h_proto;
> >
> > -     if (h_proto == htons(ETH_P_8021Q) || h_proto == htons(ETH_P_8021AD)) {
> > -             struct vlan_hdr *vhdr;
> > -
> > -             vhdr = data + nh_off;
> > -             nh_off += sizeof(struct vlan_hdr);
> > -             if (data + nh_off > data_end)
> > -                     return rc;
> > -             h_proto = vhdr->h_vlan_encapsulated_proto;
>
> No. This is not a duplicate. The h_proto in the above line will be used
> in the below "if" condition.
>
> > -     }
> >       if (h_proto == htons(ETH_P_8021Q) || h_proto == htons(ETH_P_8021AD)) {
> >               struct vlan_hdr *vhdr;
> >
> >
Apologies :(
I now realize, it could be double vlan encapsulated.
Would it make sense to add an explicit comment for newbies like me ?
I can send a patch, if it is okay.

-mfrw
