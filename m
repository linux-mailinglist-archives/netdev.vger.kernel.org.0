Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF1F1929BB
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 14:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbgCYNd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 09:33:27 -0400
Received: from mail-qk1-f173.google.com ([209.85.222.173]:34205 "EHLO
        mail-qk1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbgCYNd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 09:33:27 -0400
Received: by mail-qk1-f173.google.com with SMTP id i6so2506132qke.1
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 06:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tlapnet.cz; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kprv2m0+xH6rw6KMPHdQkJlrvY3jozE/Ui8LMp4/cxU=;
        b=AuD8Fe5X60A4FBfq0yINhuH4fVh8O9zOuAVn4ixMyBOKfVhSpyh8BSa05qbIzGsBEs
         jbWWQ41wozVfcdT5yh4S4BHKXlz9z7t9UOAuaEvvR51wKcRFoTo1wSfkl+AJqkMT3lVW
         BJa81gR0B3pMqaLV7WN4DaAunEyhEwAuQTG08HAKU40vFMJtbbV9e0nwXlsFFYH0sNDA
         1JVaiNCH0M45ggqjG8jBTIJYqD4vDWC+smw4e0PtuP9SotT32IqS4tmh/FicqQ791GME
         4znc1/rtKO/vcjV97kwlad431nZHnSBWK4+kYHjr80/mTFFxzMALkPjTjuxQ/gj+ndOi
         migg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kprv2m0+xH6rw6KMPHdQkJlrvY3jozE/Ui8LMp4/cxU=;
        b=ZD3O6K5dlVhNb8yXkRZRDPO0pL8Rg8QJm03fswzNv04JBsY3HlY2e6/qw8gholUqiC
         2rMjQxsidzmtFmpGJWhFg9UGibWzP6JoX2fNHNBaS9QzrgJoMptG7S1IKjqyegj+cNNR
         uy+xhqeHbP7S5FUksy4pu8WxrYTbal3ERTOMSYrKLczf9LaNIWSZ1qTRenqehlTwHO6r
         eCGxtqnb4xNg2wxtXkFQZME89fnhNdoPB53mYMMnpZ5RRiPqarbVg8n8RNkiwbbbe6sL
         ElBYe64lTiLbyEzhjfyLFOdCz+JvZJqMe5Kkvpi5uBQL7D+EWelUjn/EZdV2XgOdQ1Wr
         KWfg==
X-Gm-Message-State: ANhLgQ18p/VrWyJUEJDnPA7EOmb1O0VSfFfz6e62VR0SCu1YI6MS7mDl
        q/iElyU83YbWQfF2yvzz5537aeiSpXf3k1XvP7rAPA==
X-Google-Smtp-Source: ADFU+vtUmRcpCaZhN/lUsx95//G2YmdM1GOs6nu9QG/5L1ZMzvYQ0R/30Kt3PSkycA7cM9YjMd3q8WqxVI29uhQfUlA=
X-Received: by 2002:a05:620a:109c:: with SMTP id g28mr2849398qkk.409.1585143205314;
 Wed, 25 Mar 2020 06:33:25 -0700 (PDT)
MIME-Version: 1.0
References: <CANxWus8WiqQZBZF9aWF_wc-57OJcEb-MoPS5zup+JFY_oLwHGA@mail.gmail.com>
 <CAM_iQpUPvcyxoW9=z4pY6rMfeAJNAbh21km4fUTSredm1rP+0Q@mail.gmail.com>
 <CANxWus9HZhN=K5oFH-qSO43vJ39Yn9YhyviNm5DLkWVnkoSeQQ@mail.gmail.com>
 <CAM_iQpWaK9t7patdFaS_BCdckM-nuocv7m1eiGwbO-jdLVNBMw@mail.gmail.com> <CANxWus9yWwUq9YKE=d5T-6UutewFO01XFnvn=KHcevUmz27W0A@mail.gmail.com>
In-Reply-To: <CANxWus9yWwUq9YKE=d5T-6UutewFO01XFnvn=KHcevUmz27W0A@mail.gmail.com>
From:   =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Date:   Wed, 25 Mar 2020 14:33:13 +0100
Message-ID: <CANxWus_xL7ztXZpLcc+eMCyysgokHnnAD_vwS0jDEz=Pr-VqXw@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 12:27 PM V=C3=A1clav Zindulka
<vaclav.zindulka@tlapnet.cz> wrote:
> > > > > My testing setup consists of approx. 18k tc class rules and appro=
x.
> > > > > 13k tc qdisc rules and was altered only with different interface =
name....
> > > >
> > > > Please share you tc configurations (tc -s -d qd show dev ..., tc
> > > > -s -d filter show dev...).
> > >
> > > I've placed whole reproducers into repository. Do you need exports of=
 rules too?
> > >
> > > > Also, it would be great if you can provide a minimal reproducer.
> > >
> > > I'm afraid that minor reproducer won't cause the problem. This was
> > > happening mostly on servers with large tc rule setups. I was trying t=
o
> > > create small reproducer for nftables developer many times without
> > > success. I can try to create reproducer as small as possible, but it
> > > may still consist of thousands of rules.
> >
> > Yeah, this problem is probably TC specific, as we clean up from
> > the top qdisc down to each class and each filter.
>
> As I mentioned earlier, this happens even with specific deletion of
> smaller number of rules. Yet I don't oppose it may be caused by tc.
> Just inability to process any packets is strange and I'm not sure it
> is pure tc problem.
>
> > Can you try to reproduce the number of TC classes, for example,
> > down to half, to see if the problem is gone? This could confirm
> > whether it is related to the number of TC classes/filters.
>
> Sure. I'll try to reduce the size of tc rule set and test the problem fur=
ther.

I've tested it. Delay shortens and extends according to number of
rules to delete.

with approx. 3500 rules it took 2364ms
with approx. 7000 rules it took 5526ms
with approx. 14000 rules it took 11641ms
with approx. 18000 rules it took 13302ms
with approx. 31000 rules it took 22880ms

Do you want me to test it with ifb interface too?
