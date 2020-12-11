Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E394C2D7B3D
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 17:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389489AbgLKQo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 11:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389638AbgLKQoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 11:44:54 -0500
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCDB2C0613D3
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 08:44:13 -0800 (PST)
Received: by mail-qt1-x842.google.com with SMTP id n12so1192648qti.7
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 08:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JaCgIaxZt5qGiuVOU9D6xIGTlUYaqtMCwE3txKP7awU=;
        b=td3eW1+SgAsfcCxGtw/z/Kl+GI4TOIvOqYxNWmPDwi4LYU54CMGPPIlvuzaLVPk1qH
         f4xmHG0sYHBrTxYxl73m0R+mKExrRtdc5Ug0F+EP99MT2xk83Po6s4+mvr3rDEto6Cgd
         HlKyDxrSD/fHGERgDvnQ7F4jZNN+upheF6qXME+/UlJS4bQbdm13e+3BBpd88uHzuTGX
         qkgXoKBjsKJPdHVOpGVAR/CbVy3xFommSpShuroaWqbLy9lTMkC3sW6HXKFhQNNbT+ew
         x5O7ZzQdgRIAtPbgxq6DJ3u8a2rPUL7ukvBfuZfEkAhQ/R+FJL1nbO8opBcn7dZvlYwn
         7/rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JaCgIaxZt5qGiuVOU9D6xIGTlUYaqtMCwE3txKP7awU=;
        b=jGHg1eKO+awtuCN3Rfj8RZbIMgbeZFEWpYSPDhVTVt0v4exhf4+9v7rWdTbABlkMkz
         FhIjZWUi3z8+luQ5HS1T2QfKZOFWfKQhggkCxjSwLPQ6K2npiAug4EWBTIpNay1FUQu4
         nxfK2lsFKSdAMgWaHbeGwbjrKIFLHf8RLJS2SJKjPDDm3zm2v0/gVvlbM/z4M6z0Y8i1
         7/V07HCC89sRYIB5dIkG32SKEr4BQsAh8l54HnBp2Hax/c2DKS8P/7uBMNcOxXMTEdsz
         w9T6ApQqyB//G7ci1EuE+oUXgk3Dh9DqwGKhAdDk6nfmHi/hktZ8lAKsuereoJhiS+91
         H+eg==
X-Gm-Message-State: AOAM532wvxVa9Z2A75qP4QhC6yqWBBseqR1KpzLFCMzaseM7kWRmQpRE
        hsX7k29xrN9xMqdXXA56YzzYtpSu13C3CdlxvI1aPw==
X-Google-Smtp-Source: ABdhPJwdA+iwF8gspJxjbGsMDqg1oWn5W//aN4MqVnoabtKDGdbelz2puvx5OvnuprZKKrWiYvlZcbWqeFAIYf5e2eE=
X-Received: by 2002:a05:622a:18d:: with SMTP id s13mr16777768qtw.306.1607705052628;
 Fri, 11 Dec 2020 08:44:12 -0800 (PST)
MIME-Version: 1.0
References: <20201211144147.26023-1-mw@semihalf.com> <20201211154220.GX1551@shell.armlinux.org.uk>
In-Reply-To: <20201211154220.GX1551@shell.armlinux.org.uk>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Fri, 11 Dec 2020 17:44:01 +0100
Message-ID: <CAPv3WKePL4sR=RCgzcOmn8hy8mC7pqVnRWsVWCXL_SEm1mhEQQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add mvpp2 driver entry
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mcroce@microsoft.com,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pt., 11 gru 2020 o 16:42 Russell King - ARM Linux admin
<linux@armlinux.org.uk> napisa=C5=82(a):
>
> On Fri, Dec 11, 2020 at 03:41:47PM +0100, Marcin Wojtas wrote:
> > Since its creation Marvell NIC driver for Armada 375/7k8k and
> > CN913x SoC families mvpp2 has been lacking an entry in MAINTAINERS,
> > which sometimes lead to unhandled bugs that persisted
> > across several kernel releases.
>
> Can you add me for this driver as well please?
> Thanks.

Sure, I'll repost with this addition.

Marcin

>
> >
> > Signed-off-by: Marcin Wojtas <mw@semihalf.com>
> > ---
> >  MAINTAINERS | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 6f474153dbec..db88abf11db2 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -10513,6 +10513,13 @@ L:   netdev@vger.kernel.org
> >  S:   Maintained
> >  F:   drivers/net/ethernet/marvell/mvneta.*
> >
> > +MARVELL MVPP2 ETHERNET DRIVER
> > +M:   Marcin Wojtas <mw@semihalf.com>
> > +L:   netdev@vger.kernel.org
> > +S:   Maintained
> > +F:   Documentation/devicetree/bindings/net/marvell-pp2.txt
> > +F:   drivers/net/ethernet/marvell/mvpp2/
> > +
> >  MARVELL MWIFIEX WIRELESS DRIVER
> >  M:   Amitkumar Karwar <amitkarwar@gmail.com>
> >  M:   Ganapathi Bhat <ganapathi.bhat@nxp.com>
> > --
> > 2.29.0
> >
> >
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
