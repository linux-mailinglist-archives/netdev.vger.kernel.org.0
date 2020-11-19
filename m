Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84BA2B8CDE
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 09:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgKSIJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 03:09:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgKSIJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 03:09:26 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D4AC0613CF;
        Thu, 19 Nov 2020 00:09:26 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id a18so3716557pfl.3;
        Thu, 19 Nov 2020 00:09:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PVVrHpLNgq+kl9A2aIZQl8Ll9b4XaLdyqAsmoMcdYJs=;
        b=Lt9kWa/44LbPO5/cPquY/oD00iPelLttboNoTpKbK9dVAWzH3RYKbgHDaeT6P23ez6
         XYjih+2Wx91QAfzcjVrjNcMRQqyKMzvKWszEcpIYw3l4r6MDSSxf6w+tsg82r209sIyJ
         IEGvTF5hruSESkPBKHd9ynQL4Fw5UaK/5mi3S9/aJHYwNANMhk2Fi5uPGPs8iLd0R+TY
         q/ATxd8/gZwHYIXOpNQW2VZwlEK4lPQJweq4lAc8Om3wvrsXoz6C61JbXMeYgzktl/o9
         a8nEhrjC+UR3qzkMKQRfh1Iig1LdAZBtpa2/9ZrJ0aUI/CPg4/NBgGPjEW6ESCBWn4VG
         ckUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PVVrHpLNgq+kl9A2aIZQl8Ll9b4XaLdyqAsmoMcdYJs=;
        b=J3jxwGkmBeLrQEV//jlt+HblJ9sDFICZWcjgooDpMU9AjR0zkiu+oDjCWOKiiXCDWn
         ui9x8Uouz5ytBCMVbwPm9chL3CfdB0UGF8Rxe57YzdTXGoq2WnKQi/HpoY51dWGyuYaz
         SH6P61RpqQO/GpGDr14zdwF7sESR5ElvopjrrMLYvja6SsonQH6pXkGcFs2756pfcsmA
         wVq+hK/Nq5T1kFjEdGcTXBplu6JQratqtK39gtQkc737nDKDy7mSvbEsnCQeGSNURjc9
         v/vtnCurYwa3PVZj+qjY8Ad8gw1SW5hdv/SVwIaCaUc7RBNiVy9dHf2/NKjbAU0s+oeT
         xvBA==
X-Gm-Message-State: AOAM531GeZ8y825U1ol3AVGFLYFmxyJWV81Jic8Ip3GjXPbkRFPolMfg
        Ou/QRHOBGd19M5jIll9UZp/TtobYlgNcWYtGeR0=
X-Google-Smtp-Source: ABdhPJzMtCi6Lzy+hKBiQ1H0tfPFF0KZ7VqlwVI9VZTJv3bdyDqPXOQ+M26nyyu2U6Ahg5fVxF2kbbfXdJ/XIi3n5Mc=
X-Received: by 2002:a17:90a:4884:: with SMTP id b4mr3128671pjh.198.1605773366305;
 Thu, 19 Nov 2020 00:09:26 -0800 (PST)
MIME-Version: 1.0
References: <20201118135919.1447-1-ms@dev.tdt.de> <CAJht_EPB5g5ahHrVCM+K8MZG9u5bmqfjpB9-UptTt+bWqhyHWw@mail.gmail.com>
 <ae263ce5b1b31bfa763f755bdb3ef962@dev.tdt.de>
In-Reply-To: <ae263ce5b1b31bfa763f755bdb3ef962@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 19 Nov 2020 00:09:15 -0800
Message-ID: <CAJht_EMb5uKo6J7BAaiC9mN-ZcG+xDGc2Q9NC0ybof61vr4m2w@mail.gmail.com>
Subject: Re: [PATCH net-next v3 0/6] net/x25: netdev event handling
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 11:02 PM Martin Schiller <ms@dev.tdt.de> wrote:
>
> On 2020-11-18 15:47, Xie He wrote:
> >
> > But... Won't it be better to handle L2 connections in L2 code?
> >
> > For example, if we are running X.25 over XOT, we can decide in the XOT
> > layer whether and when we reconnect in case the TCP connection is
> > dropped. We can decide how long we wait for responses before we
> > consider the TCP connection to be dropped.
> >
> > If we still want "on-demand" connections in certain L2's, we can also
> > implement it in that L2 without the need to change L3.
> >
> > Every L2 has its own characteristics. It might be better to let
> > different L2's handle their connections in their own way. This gives
> > L2 the flexibility to handle their connections according to their
> > actual link characteristics.
> >
> > Letting L3 handle L2 connections also makes L2 code too related to /
> > coupled with L3 code, which makes the logic complex.
>
> OK, I will give it a try. But we need to keep the possibility to
> initiate and terminate the L2 connection from L3.

OK. Thanks so much!

> In the on demand scenario i mentioned, the L2 should be connected when
> the first L3 logical channel goes up and needs to be disconnected, when
> the last L3 logical channel on an interface is cleared.

I see. Maybe we can do it this way:

When L3 wants to initiate the first L3 connection, it can check
whether the L2 connection is established, and if it is not, it can
instruct L2 to connect. This is the same as what the current code
(before this series) does.

When the last L3 connection is terminated, we can let L3 use the
one-byte header to "suggest" (rather than "instruct") L2 to terminate
the L2 connection. L2 can choose to either terminate the connection or
continue to keep it, based on whether it is in on-demand mode.
