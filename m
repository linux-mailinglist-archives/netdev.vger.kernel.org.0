Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3623494CB
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbfFQWJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:09:38 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:43895 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbfFQWJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 18:09:37 -0400
Received: by mail-io1-f67.google.com with SMTP id k20so24892291ios.10
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 15:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VQMh0pQsRIEWtIjwkr6/JazrfaCpcZ1KzLTpGhsYV6E=;
        b=q7LMrA9rEoyYOO18gagsGf0clp6yCZwvn/Ejaiw+C5Jc9fqJ7mlTzmVOk0FhnBrgQo
         2Sg5/lwWPkDJfrLfV2gHnTEjAmLnfw5/JZn/5dEwN7DaffvvNuPvII2iHIISqxzDUQgl
         t0WLfugm/p5KTNfLxFHPJFYqzHtm/6Bq/ONIYzUuDqg3tqq59Sp/oSd31H4rme8zUUg4
         N/3fAwKgV1UEwDqamr6QBHfda460e1SERa5hfqIDMeI1iF9kVacJcowhUAQRSvjTl7aS
         K87wjGsrL9UEmJbwFxuFbjRzn19uqXZdfViPDTIrEO3o8fP3VYYovB3twzjSNT3UIfqz
         Qfjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VQMh0pQsRIEWtIjwkr6/JazrfaCpcZ1KzLTpGhsYV6E=;
        b=YN7lso0AO6WTasTpUMfHmYPhS3TeZbOaHlFVf4zqUEyG3ys7shhPMAdN20Ma1ay8t6
         7JmTNj0rDojp84VBcJL3+II24yxUtHs9qSYpTovYGlvPgldgwTGQ0+TGBdIiAgi3IXzZ
         xH32ruA2SPJE9DjmxcA8g1AKm5eMDqyD220EeqDz90TjmoDE8DhFe1BlJYQx/IhKmm7f
         r38GZu8pHFAD6CDrZS/Xfm/43DWpDAxr1yf5b9qSzXxtvxBwXj09tgy/d0X2+bIoQBUL
         J63HWMD1jPeEmOyRMDlrdgl7zmLfLL4kqUyTDNOEG5rO19CQNSY7gmH+C6cvMrGIzyom
         19Ew==
X-Gm-Message-State: APjAAAXnxAGAXVea3cocyNJ522IuwgUT69/svEQOcpAUQl9AFDCTdlVe
        ZEtAAg1JPpgJhIFAhIgG168uqutzR2qWLnxDXHz1mA==
X-Google-Smtp-Source: APXvYqzcJTIhtiIvUUQcIS+XE6cdiBU9kgyWmWmohyn6VRTrJttQEGcWqPFV0oRM3t1uvwZ37X2dJkTxwpo47m3aJKU=
X-Received: by 2002:a6b:fb10:: with SMTP id h16mr2190680iog.195.1560809377076;
 Mon, 17 Jun 2019 15:09:37 -0700 (PDT)
MIME-Version: 1.0
References: <1560447839-8337-1-git-send-email-john.hurley@netronome.com>
 <1560447839-8337-2-git-send-email-john.hurley@netronome.com>
 <CAM_iQpU0jZhg60-CVEZ9H1N57ga9jPwVt5tF1fM=uP_sj4kmKQ@mail.gmail.com>
 <CAK+XE=mXVW84MXE5bDYyGhK5XrC_q3ECiaj5=WsXFV0FXBk+eA@mail.gmail.com> <CAM_iQpW+bnMG+43cyMJuLYCqEKM4jk5LbxGtsHFOFY=Ha7nZfA@mail.gmail.com>
In-Reply-To: <CAM_iQpW+bnMG+43cyMJuLYCqEKM4jk5LbxGtsHFOFY=Ha7nZfA@mail.gmail.com>
From:   John Hurley <john.hurley@netronome.com>
Date:   Mon, 17 Jun 2019 23:09:26 +0100
Message-ID: <CAK+XE==Yn+HyWUtcNNv-GuG5N1y6_UMxC_9brnorpG3Kz2qFyA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] net: sched: add mpls manipulation actions
 to TC
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 10:18 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Fri, Jun 14, 2019 at 3:56 PM John Hurley <john.hurley@netronome.com> wrote:
> >
> > On Fri, Jun 14, 2019 at 5:59 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Thu, Jun 13, 2019 at 10:44 AM John Hurley <john.hurley@netronome.com> wrote:
> > > > +static inline void tcf_mpls_set_eth_type(struct sk_buff *skb, __be16 ethertype)
> > > > +{
> > > > +       struct ethhdr *hdr = eth_hdr(skb);
> > > > +
> > > > +       skb_postpull_rcsum(skb, &hdr->h_proto, ETH_TLEN);
> > > > +       hdr->h_proto = ethertype;
> > > > +       skb_postpush_rcsum(skb, &hdr->h_proto, ETH_TLEN);
> > >
> > > So you just want to adjust the checksum with the new ->h_proto
> > > value. please use a right csum API, rather than skb_post*_rcsum().
> > >
> >
> > Hi Cong,
> > Yes, I'm trying to maintain the checksum value if checksum complete
> > has been set.
> > The function above pulls the old eth type out of the checksum value
> > (if it is checksum complete), updates the eth type, and pushes the new
> > eth type into the checksum.
> > This passes my tests on the checksum.
> > I couldn't see an appropriate function to do this other than
> > recalculating the whole thing.
> > Maybe I missed something?
>
> I never say it is wrong, I mean to say using a csum API is more
> clear. Please look into checksum API's, there are many options
> for different scenarios, there must be one serves your purpose.
>

Ok, I'll have another look here and see if I can get something more appropriate.
Thanks

> Thanks.
