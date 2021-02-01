Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D92730B201
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 22:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhBAVVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 16:21:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbhBAVVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 16:21:51 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65ECEC061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 13:21:11 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id d2so20611097edz.3
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 13:21:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ux7+WY16xMVegW/shcv7KNHnsJLoKCzt78j3zQZf5sE=;
        b=KxZQ1inykQxjhdraIfR149e0RkNVJAD/+0OVabYG4jkMuYY3Xio+QGzKOoalMfQD50
         lIbyMJxNSjRAExTH5rjNtZGJFyTVv7XyWgtJbT72p1KBOcE0FS2mRhdl6IrmF6JueVdo
         jjL6JSWglTtq2UEZTTJ4M8plcMP2OSTXchyZUc92l/yg5cjc24Q+8KLgB7D4tSG+U7Id
         ht9+7XXCj4tP0E6H9SPHw6/5bSefeLheBuIkG1bfzOcTf3jin1LCF5/8SvzEHQBIvHD/
         x6Zc+FOHDgSTBwO9PQk9wtfhhEBr8KjtUDWnJ89J9hL+X6pwd+lQI8VuUAL5SAzhbb3N
         AqKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ux7+WY16xMVegW/shcv7KNHnsJLoKCzt78j3zQZf5sE=;
        b=Lghmm3886dOTMcI5zp+Rf+5aQ29fFG9EQobWk5U0n5pkXX5AJcR3qgbvO/JN/Vn9yO
         BoXb8LrCJ0aQEe913vqstJyEGvhKquiVeqxRaJgkmpwqZx91fEvhgm33apEw8GwdHY6Y
         86LvdUntF+wWrdv4FiALEXTlycTcky4XlP+uLGVF9ma3Fda7D76GoHxAtqS4mTyJ/GDP
         NJVX3hlKNBPmQBTPrVXWJO8NT0yqjkNTnIwG9xSNqdfs+Qp6KukqEe/7IlX9BEWif8yb
         K9M3VAZ+uZ2gTZ8qKTn2xqJX+f57JsoJ5Uhvus9LC73JsX6kHsSh4U6rm8Cx1kjStpQ5
         Wccg==
X-Gm-Message-State: AOAM530U8aITQv6+NAri96Dqkz8dFLY7luFkDo/jqAyv0wK23NFiY2Yw
        /R/WTCI/sYXS8RgzWVuobxXk1qnvk8GLnbUSFyk=
X-Google-Smtp-Source: ABdhPJxJzdHROUlZ7QvOp06ATiedfLPPTvXJU2itS6iM8rhW2PF7bpNg+PeeR/bYUWJVoU2VPfGGguT53HV+zodR6kc=
X-Received: by 2002:aa7:c9cf:: with SMTP id i15mr20646781edt.296.1612214470195;
 Mon, 01 Feb 2021 13:21:10 -0800 (PST)
MIME-Version: 1.0
References: <1611589557-31012-1-git-send-email-loic.poulain@linaro.org>
 <20210129170129.0a4a682a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMZdPi_6tBkdQn+wakUmeMC+p8N3HStEja5ZfA3K-+x4DcM68g@mail.gmail.com>
 <CAF=yD-+UFHO8nKsB3Z7n-xhoFtXwge2GEZj-2+-7=EETLjYXFA@mail.gmail.com>
 <CAMZdPi_dMBDafAVoHbqwR9RDbtZSJpGd48oCMmL1qAgR+PCFGQ@mail.gmail.com>
 <CAF=yD-KT0nPEV4CphRH3xVJhXqpK=FQHM-3TkK+88ZqA9afeFw@mail.gmail.com> <20210201125504.7646de2a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210201125504.7646de2a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 1 Feb 2021 16:20:33 -0500
Message-ID: <CAF=yD-LHM9PKK9zdrrF2CaW8wufRvhSTzWdU5uUjs3NjiphgOg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: mhi-net: Add de-aggeration support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 3:55 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 1 Feb 2021 13:33:05 -0500 Willem de Bruijn wrote:
> > On Mon, Feb 1, 2021 at 11:41 AM Loic Poulain <loic.poulain@linaro.org> wrote:
> > > On Mon, 1 Feb 2021 at 15:24, Willem de Bruijn wrote:
> > > > What is this path to rmnet, if not the usual xmit path / validate_xmit_skb?
> > >
> > > I mean, not sure what to do exactly here, instead of using
> > > skb_copy_expand to re-aggregate data from the different skbs, Jakub
> > > suggests chaining the skbs instead (via 'frag_list' and 'next' pointer
> > > I assume), and to push this chained skb to net core via netif_rx. In
> > > that case, I assume the de-fragmentation/linearization will happen in
> > > the net core, right? If the transported protocol is rmnet, the packet
> > > is supposed to reach the rmnet_rx_handler at some point, but rmnet
> > > only works with standard/linear skbs.
> >
> > If it has that limitation, the rx_handler should have a check and linearize.
>
> Do you mean it's there or we should add it?

I mean that if rmnet cannot handle non-linear skbs, then
rmnet_rx_handler should linearize to be safe. It should not just rely
on __netif_receive_skb_core passing it only linear packets. That is
fragile.

I suppose the requirement is due to how rmnet_map_deaggregate splits
packets, with bare memcpy + skb_pull. I don't see a linearize call. If
only this path is affected, an skb_linearize could also be limited to
this branch. Or the code converted to handle skb frags and frag_list.

That said, addressing the fragile behavior is somewhat tangential to
the aim of this patch: passing such packets to
__netif_receive_skb_core. Your comment rightly asked about the logic
during allocation failure. If instead the whole packet is just
discarded at that point, I suppose the current approach works.

> > That is simpler than this skb_copy_expand, and as far as I can see no
> > more expensive.
>
> rx_handler is only used by uppers which are 100% SW. I think the right
> path is to fix the upper, rather than add a check to the fastpath, no?

Right. I think we're on the same page. I did not mean linearizing
before calling any rx_handler. Just specific inside this rx_handler
implementation.
