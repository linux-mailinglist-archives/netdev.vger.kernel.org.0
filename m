Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 705B6A4B86
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 22:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbfIAUG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 16:06:29 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:45938 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfIAUG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 16:06:28 -0400
Received: by mail-yw1-f66.google.com with SMTP id n69so4116117ywd.12
        for <netdev@vger.kernel.org>; Sun, 01 Sep 2019 13:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gfSNoy+Z45rbsOIpKQh4x/nE2e4rix2MvMV1bB+s1xA=;
        b=pQXRGTBM3bgC/dZ5mxzrv/fpcOr322ON1b6FoMcIs8aEEktx4uYmvcE+McNwU2+He7
         fvky5BMWk65LNrR/V4dWwEPDGIerI+Gqffjd9rzAZItY/jhEXE5T0UKDguF3MjlMv1ch
         E/0Kq38u25aY3tFF6z2MnFbtWic/nryhnkN9L1q4qLa1BIAVseRKdy8WnJYu2z8rBV4/
         Tlo6Cp4fH4qhNF+0HSEXqPQtNLY9QbahWm5wj7ZwuWjcpu3l8vE9bXbVW8A7iK+K4jY8
         heWQoTP0G1L2Ir1fCkt9a3ZDhNUdZ+QWfnKiLAOkMFGSlRWHxCUi8+1mytMtCTLhrYMZ
         7Dng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gfSNoy+Z45rbsOIpKQh4x/nE2e4rix2MvMV1bB+s1xA=;
        b=be9LEWZ3/jrTjkrMZf4LGM7QGB17q0YBbHlTGH79uIZiPBWsKNB1UrjCNDy2cEpZwl
         ymzBgins7xHELpiCQupkQHsUL1e9Me7GUUJlyitMjZLsOfVVDyJeQhjBt1pvZwHygWTD
         RbyJNEMGk2Xqhe4rHchV6vmi1aZV7kcFgeZF1kYxSESJF2+KjATjuYbPuVypqaWGmVbv
         tUtSb99tK3fkPsMvpoVbQiUHPZIezURiSsMW0nrpEEnmXOxHiF6DuZ1QF1Q/8ThQIVZ/
         GKNBQrfda9oKUk2LWIvN0QRFih4b7DKvV3t+fFjAgCmZ1THWoeCpaa/+TvQO9NX3LNEn
         W9Hw==
X-Gm-Message-State: APjAAAVcLyVJHpq3ca5nNPi2yYQamG9ONyUEg4lbRf4TpJLlP2Yk69zW
        FGIwiZKQYUwIElQeVFIHy7oihXtv
X-Google-Smtp-Source: APXvYqwIjzcghYtx/qhbXft6UD7VOADUrf2xid18Ox7dRWQiWIhuU+pzV0AJpDSZDBGz+aT0iJ0kcw==
X-Received: by 2002:a0d:e502:: with SMTP id o2mr18020594ywe.33.1567368386673;
        Sun, 01 Sep 2019 13:06:26 -0700 (PDT)
Received: from mail-yw1-f46.google.com (mail-yw1-f46.google.com. [209.85.161.46])
        by smtp.gmail.com with ESMTPSA id e12sm2506843ywe.85.2019.09.01.13.06.25
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Sep 2019 13:06:25 -0700 (PDT)
Received: by mail-yw1-f46.google.com with SMTP id 129so3503407ywb.8
        for <netdev@vger.kernel.org>; Sun, 01 Sep 2019 13:06:25 -0700 (PDT)
X-Received: by 2002:a81:2849:: with SMTP id o70mr13985443ywo.389.1567368384613;
 Sun, 01 Sep 2019 13:06:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190826170724.25ff616f@pixies> <94cd6f4d-09d4-11c0-64f4-bdc544bb3dcb@gmail.com>
 <20190827144218.5b098eac@pixies> <88a3da53-fecc-0d8c-56dc-a4c3b0e11dfd@iogearbox.net>
 <20190829152241.73734206@pixies>
In-Reply-To: <20190829152241.73734206@pixies>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 1 Sep 2019 16:05:48 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfVsgNDi7c=GUU8nMg2hWxF2SjCNLXetHeVPdnxAW5K-w@mail.gmail.com>
Message-ID: <CA+FuTSfVsgNDi7c=GUU8nMg2hWxF2SjCNLXetHeVPdnxAW5K-w@mail.gmail.com>
Subject: Re: BUG_ON in skb_segment, after bpf_skb_change_proto was applied
To:     Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Shmulik Ladkani <shmulik@metanetworks.com>,
        eyal@metanetworks.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 29, 2019 at 8:22 AM Shmulik Ladkani
<shmulik.ladkani@gmail.com> wrote:
>
> On Tue, 27 Aug 2019 14:10:35 +0200
> Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> > Given first point above wrt hitting rarely, it would be good to first get a
> > better understanding for writing a reproducer. Back then Yonghong added one
> > to the BPF kernel test suite [0], so it would be desirable to extend it for
> > the case you're hitting. Given NAT64 use-case is needed and used by multiple
> > parties, we should try to (fully) fix it generically.
> >
>
> Thanks Daniel.
>
> Managed to write a reproducer which mimics the skb we see on prodction,
> that hits the exact same BUG_ON.
>
> Submitted as a separate RFC PATCH to bpf-next.

Thanks for the reproducer.

One quick fix is to disable sg and thus revert to copying in this
case. Not ideal, but better than a kernel splat:

@@ -3714,6 +3714,9 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
        sg = !!(features & NETIF_F_SG);
        csum = !!can_checksum_protocol(features, proto);

+       if (list_skb && skb_headlen(list_skb) && !list_skb->head_frag)
+               sg = false;
+

It could perhaps be refined to avoid in the special case where
skb_headlen(list_skb) == len and nskb aligned to start of list_skb.
And needs looking into effect on GSO_BY_FRAGS.

I also looked into trying to convert a kmalloc'ed skb->head into a
headfrag. But even if possible, that conversion is non-trivial and
easy to have bugs of its own.

@@ -3849,8 +3885,8 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
                                if (!skb_headlen(list_skb)) {
                                        BUG_ON(!nfrags);
                                } else {
-                                       BUG_ON(!list_skb->head_frag);
-
+                                       BUG_ON(!list_skb->head_frag &&
+
!skb_to_headfrag(list_skb, GFP_ATOMIC));
