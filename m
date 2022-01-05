Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A87484E0C
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 07:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234847AbiAEGMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 01:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234814AbiAEGMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 01:12:53 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EBAC061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 22:12:53 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id s4so46249435ljd.5
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 22:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ThhaoEo3tPJOBVEZG3l25kaZXkBQdpwhMcYgiUiUQFE=;
        b=Kw8Kq9kT8CTBoSReGjhK3FmUcYBgUg8D1jZ5goLmq0YcprvQwdGNayVCTHfW1kmCeY
         jbJm85dGJgJUMnhZmwn9dknzPf5TqhJzWtudVCQVm04gKzisedN/IyoStvFzJdLkl/lF
         hLQxt1gFEkirAdNX4VS7CaeN30gh25ZcJy/24=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ThhaoEo3tPJOBVEZG3l25kaZXkBQdpwhMcYgiUiUQFE=;
        b=iss2QP7a1HGQfxfX7qOohie+HkRi33vmEqOiZY1Mmm2nwymHX6qXAtsw9I8zjj64WJ
         A1s7xIN8NUHxQ2asZRrZT/0Eh9qzNMbit+lU/t7xZSGSgW0njv/S66B+5W6rnSApyMl0
         BAG57jNyYy3kfsbEpnhTgr26CEmRryuZBYDs3eZ9SL6G9lWF3A4wHO2xBvfq+iX9vxvC
         4v9E29aoqLHg/HELaVPpotAapcWJ0j9peXLv6r9FMEWJ2Mul+8bexVyjojzwqMFIlcxh
         GCNddBGkqUNx44sWspwLPIft+SjRfElHh8zQm0O5rkarDAsYXAqVIbfjvL6HZSnLiyFb
         N6hQ==
X-Gm-Message-State: AOAM532ajkBXSo/XzI+1YDoNMrT7ctwxwaWa76vK3asDLdTYoxmHcBVX
        IL7i/T3MPjmBaOcOzI8uC2T4OzfANxJMlyrxMAA9x3VX9U+Ypg==
X-Google-Smtp-Source: ABdhPJygvroOMqH3mJsA2L7XSEs530uObRZbCduC72jJEx04eb8hgVJSFQ+0ZblprQjSgNBjM3UD0dY3pKnoUyBluI0=
X-Received: by 2002:a2e:9cd8:: with SMTP id g24mr18949666ljj.509.1641363171369;
 Tue, 04 Jan 2022 22:12:51 -0800 (PST)
MIME-Version: 1.0
References: <20220104064657.2095041-1-dmichail@fungible.com>
 <20220104064657.2095041-3-dmichail@fungible.com> <20220104180959.1291af97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAOkoqZnTv_xc6oB13jdTEK65wbYzyOO1kigmMv7KsJug58bBpA@mail.gmail.com>
In-Reply-To: <CAOkoqZnTv_xc6oB13jdTEK65wbYzyOO1kigmMv7KsJug58bBpA@mail.gmail.com>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Tue, 4 Jan 2022 22:12:35 -0800
Message-ID: <CAOkoqZmom=Yqxq7FkF=3oBrtd+0BenZZMES3nvUxf2b3CCiyfg@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/8] net/fungible: Add service module for
 Fungible drivers
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 4, 2022 at 8:49 PM Dimitris Michailidis
<d.michailidis@fungible.com> wrote:
>
> On Tue, Jan 4, 2022 at 6:10 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Mon,  3 Jan 2022 22:46:51 -0800 Dimitris Michailidis wrote:
> > > Fungible cards have a number of different PCI functions and thus
> > > different drivers, all of which use a common method to initialize and
> > > interact with the device. This commit adds a library module that
> > > collects these common mechanisms. They mainly deal with device
> > > initialization, setting up and destroying queues, and operating an admin
> > > queue. A subset of the FW interface is also included here.
> > >
> > > Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
> >
> > CHECK: Unnecessary parentheses around 'fdev->admin_q->rq_depth > 0'
> > #630: FILE: drivers/net/ethernet/fungible/funcore/fun_dev.c:584:
> > +       if (cq_count < 2 || sq_count < 2 + (fdev->admin_q->rq_depth > 0))
>
> I saw this one but checkpatch misunderstands this expression.
> There are different equivalent expressions that wouldn't have them
> but this one needs them.

What I wrote is probably unclear. By 'them' I meant the parentheses.
