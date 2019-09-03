Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E807A6E11
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 18:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730113AbfICQYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 12:24:35 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:39320 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729692AbfICQYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 12:24:34 -0400
Received: by mail-yw1-f68.google.com with SMTP id n11so6006910ywn.6
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 09:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k4jAl0jr+VDYMLBaKjmvgDuo55wDGIKUx9tH04YBR2I=;
        b=CdMgX2AwL2kucVow2RTckKdKEIqoz6XbtCnoXV9NKo+uOIWq0bEIOqsFwvaaMP+T+q
         eLCJ6bpQ/QfKADI9GVYi/LE0gEmYpghhhnoHdQTwA6FtCAzq+nzZwEcbE+eHBFlHb0lb
         E/txq54bpt1rwcG8M9Gv9AvvY3hwOYje4N46id8W6Yv9rzRIEiAmP3USk+E5bwqhn5RU
         HiHOFDOFC087uQSlbhrwdYh3HntGk4ZvlUFSBpp8HoHog04hfW8iHwigNVdI2FAbB8zS
         Gc/pG5i53Q7U+HUNOsTFFPaJMEYOm/MDsAyxXhiIqjzzJJpi9H+LbsHyr6wo5d7Ik4AW
         CsNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k4jAl0jr+VDYMLBaKjmvgDuo55wDGIKUx9tH04YBR2I=;
        b=bGbHbxim763S+s9oHjzpbsfm4o+Bxun8YckbM3EvuuB+G5g41jiD/rUTNCxrYJPgKA
         EYwJ9Cz3rNXvSyGlFE32OXBzaggzXCFt5TrtfqWLCz6nRND7k/HinduufGKLZ7d5ZPYP
         1UwG75GGrLo7iwD0Vll8tC44daUZMcsRA/Y/fFRSMNu0KHFSc7lm6eag0jSifoLoZ6+I
         8MKv1GU9ZZM1QV2+TCubG6V9oOKST8M0TQNdcEYPQV0C3S1R7hMjWruFgxv2323iAIqv
         +B4+zZUuuR4k+PtWQRiZfojZdpzO+SAklEhn4Ydnivk05hdyO6u2pCbAFaOpfW2bB7PA
         QGZg==
X-Gm-Message-State: APjAAAU1IuooT9n7FHD/MLRPbhqApsVTT+uQSNQNRGO6m6kJ3LBut5RW
        ZMDO77RkhHNEo4MPFtNWGdIDgIIr
X-Google-Smtp-Source: APXvYqwdV7ZriEzV9QO5vwQpP0TDT9juNzph2l6RLQIHg3uyotn/JGeOjW/cNeMFChfGybcDsqaAvg==
X-Received: by 2002:a0d:d891:: with SMTP id a139mr9546656ywe.52.1567527872899;
        Tue, 03 Sep 2019 09:24:32 -0700 (PDT)
Received: from mail-yw1-f50.google.com (mail-yw1-f50.google.com. [209.85.161.50])
        by smtp.gmail.com with ESMTPSA id v8sm405651ywg.91.2019.09.03.09.24.31
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Sep 2019 09:24:31 -0700 (PDT)
Received: by mail-yw1-f50.google.com with SMTP id n69so5984340ywd.12
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 09:24:31 -0700 (PDT)
X-Received: by 2002:a0d:c305:: with SMTP id f5mr23970216ywd.109.1567527871026;
 Tue, 03 Sep 2019 09:24:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190826170724.25ff616f@pixies> <94cd6f4d-09d4-11c0-64f4-bdc544bb3dcb@gmail.com>
 <20190827144218.5b098eac@pixies> <88a3da53-fecc-0d8c-56dc-a4c3b0e11dfd@iogearbox.net>
 <20190829152241.73734206@pixies> <CA+FuTSfVsgNDi7c=GUU8nMg2hWxF2SjCNLXetHeVPdnxAW5K-w@mail.gmail.com>
 <20190903185121.56906d31@pixies>
In-Reply-To: <20190903185121.56906d31@pixies>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 3 Sep 2019 12:23:54 -0400
X-Gmail-Original-Message-ID: <CA+FuTScE=pyopY=3f5E4JGx1zyGqT+XS+8ss13UN4if4TZ2NbA@mail.gmail.com>
Message-ID: <CA+FuTScE=pyopY=3f5E4JGx1zyGqT+XS+8ss13UN4if4TZ2NbA@mail.gmail.com>
Subject: Re: BUG_ON in skb_segment, after bpf_skb_change_proto was applied
To:     Shmulik Ladkani <shmulik@metanetworks.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        eyal@metanetworks.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 3, 2019 at 11:52 AM Shmulik Ladkani
<shmulik@metanetworks.com> wrote:
>
> On Sun, 1 Sep 2019 16:05:48 -0400
> Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
>
> > One quick fix is to disable sg and thus revert to copying in this
> > case. Not ideal, but better than a kernel splat:
> >
> > @@ -3714,6 +3714,9 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
> >         sg = !!(features & NETIF_F_SG);
> >         csum = !!can_checksum_protocol(features, proto);
> >
> > +       if (list_skb && skb_headlen(list_skb) && !list_skb->head_frag)
> > +               sg = false;
> > +
>
> Thanks Willem.
>
> I followed this approach, and further refined it based on the conditions
> that lead to this BUG_ON:
>
>  - existance of frag_list
>  - mangled gso_size (using SKB_GSO_DODGY as a hint)
>  - some frag in the frag_list has a linear part that is NOT head_frag,
>    or length not equal to the requested gso_size
>
> BTW, doing so allowed me to refactor a loop that tests for similar
> conditions in the !(features & NETIF_F_GSO_PARTIAL) case, where an
> attempt to execute partial splitting at the frag_list pointer (see
> 07b26c9454a2 and 43170c4e0ba7).
>
> I've tested this using the reproducer, with various linear skbs in
> the frag_list and different gso_size mangling. All resulting 'segs'
> looked correct. Did not test on a live system yet.
>
> Comments are welcome.
>
> specifically, I would like to know whether we can
>  - better refine the condition where this "sg=false fallback" needs
>    to be applied
>  - consolidate my new 'list_skb && (type & SKB_GSO_DODGY)' case with
>    the existing '!(features & NETIF_F_GSO_PARTIAL)' case

This is a lot more code change. Especially for stable fixes that need
to be backported, a smaller patch is preferable.

My suggestion only tested the first frag_skb length. If a list can be
created where the first frag_skb is head_frag but a later one is not,
it will fail short. I kind of doubt that.

By default skb_gro_receive builds GSO skbs that can be segmented
along the original gso_size boundaries. We have so far only observed
this issue when messing with gso_size.

We can easily refine the test to fall back on to copying only if
skb_headlen(list_skb) != mss. Alternatively, only on SKB_GSO_DODGY is fine, too.

I suggest we stick with the two-liner.
