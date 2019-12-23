Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCD721299F9
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 19:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfLWSx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 13:53:27 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:34746 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbfLWSx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 13:53:26 -0500
Received: by mail-yw1-f68.google.com with SMTP id b186so7452195ywc.1
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 10:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=osBD8dJGgUhTdeeULOYtmsCBx13VXNvpZz57rJuhm7k=;
        b=oCfsoIjD+GdEJPFTfiIGbbZJWi7tp6H5551kSaBj4IDG65P0Ms7/FYpCkzbu+PN0iE
         cpoh7Gm/6H+YGCWU4FhXI1ubogr4u37Gv9COtlM9pSLWg1hm0fPuHE7sxHGg4YXmeHIl
         Z/9K/oaVFADkyWilU4Up4ZvcraebKBObgU5npOJ4WUaOWsxJUpUnj2G9inUMtSLeYOTa
         ThhnShPrdcqLWfVEr4VfmUi5EDjE3VdAnNd79L4pLMwGRwy68SrZyIZ+x8IGufWoZK0l
         4U6DQhgPb1x964uzXwY808/14c410WDb8Egj9nQhwE8a4A05f4ZOB4O5KyQmdK3lAyvk
         65bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=osBD8dJGgUhTdeeULOYtmsCBx13VXNvpZz57rJuhm7k=;
        b=KcrIbwtGFsiVR0bAa2Vq2RL9U9xyHeYCXhIgMmLXTZBkrsZZdRbtIA6uob3wMjyS9o
         MPAzh+NqE377DNKK/0CUwoGKX5RHoN/3AexX+BWTrej5GjZwfo7BnyMNJQeLKTAqV/LU
         SkjEG/ea7rnz1eBWAWtFr0kq+w7p7boWw3xXcPM0G/+18j9i6OiPp+ZfMMzuj5Imkmx5
         kmTsguzR+zHR+3aS5BBSyUqalS1I8vELSsH2lJKi1LBqcMpi9jeYqIYoCuokUFLYbhkT
         6+40OohDFB/9mHl9Q1cKFAOlT81bkATtIz4J1B/0L8cuA/TLAlzJuvoYbMV4YvnZnEZZ
         SbDA==
X-Gm-Message-State: APjAAAVLBTc6HbEUeaQyuDUeet6bYrZj0AS/6dJPl/AzAwCqKOvtJ+U1
        p9bUjZ37bKmCV3MwT2lCyjzoYkgF
X-Google-Smtp-Source: APXvYqzCC5Qn7LVztg4VmMoxdF4F/SaChnnP/WbRGtkRGvy9lH7xj6+d6PCnBa21b7HckM+lXRHwzA==
X-Received: by 2002:a0d:cad6:: with SMTP id m205mr23652670ywd.348.1577127205336;
        Mon, 23 Dec 2019 10:53:25 -0800 (PST)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id h23sm8238583ywc.105.2019.12.23.10.53.23
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Dec 2019 10:53:24 -0800 (PST)
Received: by mail-yb1-f174.google.com with SMTP id f136so4258359ybg.11
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 10:53:23 -0800 (PST)
X-Received: by 2002:a25:d117:: with SMTP id i23mr16360727ybg.139.1577127203160;
 Mon, 23 Dec 2019 10:53:23 -0800 (PST)
MIME-Version: 1.0
References: <1576885124-14576-1-git-send-email-tom@herbertland.com>
 <1576885124-14576-2-git-send-email-tom@herbertland.com> <CA+FuTSfSFtSZjstCCp4ZdwPMCiHXaskgTqQH0EJYzV4-08t2Eg@mail.gmail.com>
 <CALx6S35o==mvEJ+GOx_tQfi56HVxKFySd+bjNakzwgiuvHnS7Q@mail.gmail.com>
In-Reply-To: <CALx6S35o==mvEJ+GOx_tQfi56HVxKFySd+bjNakzwgiuvHnS7Q@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 23 Dec 2019 13:52:46 -0500
X-Gmail-Original-Message-ID: <CA+FuTSd4feUHeTAODKEqt7AXoNgh0sbZYJJXrWg7Tb6GTnDmtA@mail.gmail.com>
Message-ID: <CA+FuTSd4feUHeTAODKEqt7AXoNgh0sbZYJJXrWg7Tb6GTnDmtA@mail.gmail.com>
Subject: Re: [PATCH v6 net-next 1/9] ipeh: Fix destopts and hopopts counters
 on drop
To:     Tom Herbert <tom@herbertland.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Tom Herbert <tom@quantonium.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 11:53 AM Tom Herbert <tom@herbertland.com> wrote:
>
> On Sun, Dec 22, 2019 at 8:21 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Fri, Dec 20, 2019 at 6:39 PM Tom Herbert <tom@herbertland.com> wrote:
> > >
> > > From: Tom Herbert <tom@quantonium.net>
> > >
> > > For destopts, bump IPSTATS_MIB_INHDRERRORS when limit of length
> > > of extension header is exceeded.
> > >
> > > For hop-by-hop options, bump IPSTATS_MIB_INHDRERRORS in same
> > > situations as for when destopts are dropped.
> > >
> > > Signed-off-by: Tom Herbert <tom@herbertland.com>
> > > ---
> > >  net/ipv6/exthdrs.c | 7 ++++++-
> > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
> > > index ab5add0..f605e4e 100644
> > > --- a/net/ipv6/exthdrs.c
> > > +++ b/net/ipv6/exthdrs.c
> > > @@ -288,9 +288,9 @@ static int ipv6_destopt_rcv(struct sk_buff *skb)
> > >         if (!pskb_may_pull(skb, skb_transport_offset(skb) + 8) ||
> > >             !pskb_may_pull(skb, (skb_transport_offset(skb) +
> > >                                  ((skb_transport_header(skb)[1] + 1) << 3)))) {
> > > +fail_and_free:
> > >                 __IP6_INC_STATS(dev_net(dst->dev), idev,
> > >                                 IPSTATS_MIB_INHDRERRORS);
> > > -fail_and_free:
> > >                 kfree_skb(skb);
> > >                 return -1;
> > >         }
> > > @@ -820,8 +820,10 @@ static const struct tlvtype_proc tlvprochopopt_lst[] = {
> > >
> > >  int ipv6_parse_hopopts(struct sk_buff *skb)
> > >  {
> > > +       struct inet6_dev *idev = __in6_dev_get(skb->dev);
> > >         struct inet6_skb_parm *opt = IP6CB(skb);
> > >         struct net *net = dev_net(skb->dev);
> > > +       struct dst_entry *dst = skb_dst(skb);
> > >         int extlen;
> > >
> > >         /*
> > > @@ -834,6 +836,8 @@ int ipv6_parse_hopopts(struct sk_buff *skb)
> > >             !pskb_may_pull(skb, (sizeof(struct ipv6hdr) +
> > >                                  ((skb_transport_header(skb)[1] + 1) << 3)))) {
> > >  fail_and_free:
> > > +               __IP6_INC_STATS(dev_net(dst->dev), idev,
> > > +                               IPSTATS_MIB_INHDRERRORS);
> >
> > ip6_rcv_core, the only caller of ipv6_parse_hopopts, checks
> > skb_valid_dst(skb) before deref. Does this need the same?
>
> Hi Willem,
>
> Actually, it looks like ipv6_parse_hopopts is doing things the right
> way. __IP6_INC_STATS is called from ip6_rcv_core if ipv6_parse_hopopts
> and the net is always taken from skb->dev (not dst) in HBH path. I'll
> fix destopts to do the same.

I don't entirely follow. The above code uses dev_net(dst->dev). Using
local variable net, derived from dev_net(skb->dev), here definitely
sounds good to me, if that's what you meant.
