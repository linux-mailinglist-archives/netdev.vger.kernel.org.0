Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27A7C1414DC
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 00:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730191AbgAQXgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 18:36:44 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43483 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729798AbgAQXgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 18:36:43 -0500
Received: by mail-lj1-f193.google.com with SMTP id a13so28118496ljm.10
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 15:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9Zh/oE42Sc8HgoSMQcMgWAwsUZfB0qAy7Nb87RVTHFo=;
        b=Mjq75rshbskU418JaslGmoJ+pQZoUTWzXnF7eoPhMu7S5S6EYHzkrcJ3vzLUBGNG8G
         ZqpXSpVSyTWQijpbGDyr/CQ2LB6u2BrZuwk6hBXfu8+ol/Mtcrs4UknYFm4bBkFxsKCg
         AUA02QfQIkj38yJcV9kGauMZqudohXXYajcxfWKXMeeP/sQ+L+iKodUHGKIPeBYW2p10
         3Y+oUKlwOAME7X4m3jdkLhTRSneNYMsWCT+sWLZ/kBnfXqRQMvt0mbwGSfrhbhYgkWAE
         /ZLZzZBFYzHo9jCf3pKjTdSKJKtMKbe/AhioAaH76tL9HF/MHuZpwkkmHRddkxGpEyBw
         Snng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9Zh/oE42Sc8HgoSMQcMgWAwsUZfB0qAy7Nb87RVTHFo=;
        b=sj9D3SJ1vmzGfxEmiBY6YTGMH8lic+ddQ1husuTeCcdjhd1rsELMarlplU3Mo1aKNj
         bEASfPDQanZGr5Aa5k+Gm4bsYvtUJid1Vgzdx/DQ6YPyEZ295j1w6JFFFF6sdHra0mMd
         hJrxH1g4pdkdmxzARQ6/uvYx01h8p9A9KrNCaeQCrsTLcF6fGWVMk22Kd9DciX/4zzU4
         dYLBiuPlBLWnj7bL/2ZT4qyo6ygvvgFUlhiGOuYdGAr0RAkrrhCiCv88lY9Sb9UfTrrS
         KcFuihuitaALvDRznl2x8xOi+dO7MvD2CT4dPxGxkpn83/4+3AvpukcbPez9sZVOYeSm
         KUwQ==
X-Gm-Message-State: APjAAAWL5TjanUTMFYUggdYr6fngo1mKcXS+aD281MAm1OYbQtyVJKeA
        eieNd7Zcr6BzwjmJvTYfBjMDJXgf2Zhcx09MCWk1Yg==
X-Google-Smtp-Source: APXvYqztFiRvMWdIi+v1hLgVUE/daA/nTQlvIkBU8suRJMbN8ZZGavw+e5zopSS2ntmTiZaHNZCkRLsJrncliXdr8cY=
X-Received: by 2002:a2e:8016:: with SMTP id j22mr6604689ljg.24.1579304201475;
 Fri, 17 Jan 2020 15:36:41 -0800 (PST)
MIME-Version: 1.0
References: <20200117215642.2029945-1-jeffrey.t.kirsher@intel.com> <693b94d6-eece-9334-4157-69f562836f3a@gmail.com>
In-Reply-To: <693b94d6-eece-9334-4157-69f562836f3a@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 17 Jan 2020 15:36:30 -0800
Message-ID: <CAADnVQ+cnMrDcaGMg4ojawdW_N0Ga1rim2wrFWavbg1FG4GNMA@mail.gmail.com>
Subject: Re: [RFC net-next PATCH] ipv6: New define for reoccurring code
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 17, 2020 at 2:19 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 1/17/20 1:56 PM, Jeff Kirsher wrote:
> > Through out the kernel, sizeof() is used to determine the size of the IPv6
> > address structure, so create a define for the commonly used code.
> >
> > s/sizeof(struct in6_addr)/ipv6_addr_size/g
> >
> > This is just a portion of the instances in the kernel and before cleaning
> > up all the occurrences, wanted to make sure that this was a desired change
> > or if this obfuscates the code.
> >
> > Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > ---
> ...
>
> >  };
> > +#define ipv6_addr_size               sizeof(struct in6_addr)
> >  #endif /* __UAPI_DEF_IN6_ADDR */
> >
> >  #if __UAPI_DEF_SOCKADDR_IN6
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index ef01c5599501..eabf42893b60 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -5053,7 +5053,7 @@ BPF_CALL_4(bpf_lwt_seg6_action, struct sk_buff *, skb,
> >       case SEG6_LOCAL_ACTION_END_X:
> >               if (!seg6_bpf_has_valid_srh(skb))
> >                       return -EBADMSG;
> > -             if (param_len != sizeof(struct in6_addr))
> > +             if (param_len != ipv6_addr_size)
>
> Hmm...
>
> I vote seeing sizeof(struct in6_addr) rather than dealing
> with yet another thing to remember and additional backports conflicts.

+1
I prefer sizeof() as well.
