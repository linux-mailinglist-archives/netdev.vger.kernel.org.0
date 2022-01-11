Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B66348B21A
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 17:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349960AbiAKQ1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 11:27:39 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.82]:44821 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343701AbiAKQ1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 11:27:39 -0500
X-Greylist: delayed 333 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Jan 2022 11:27:38 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1641918095;
    s=strato-dkim-0002; d=fpond.eu;
    h=Subject:References:In-Reply-To:Message-ID:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=WYxOVMJEua/viqwXCpPe8hCmc3c6YDyeIcfa5CvuSnI=;
    b=HYrjPv/UvtkB/Zsi8gVoNrD1nDgs80V54dsmT99QO5Jox/PsskUzjXZZmAmaJQ4O3I
    wreeV2PbOilrqWMDlug8YZrrjTe/p6/n+mMCtpZys9FGny+je1vSkBIhiy5fBFE6qPQ1
    WGzZJ9D2hTPZlI8O78mlYHJwOeGvENxDrjbtZdFMb9twg2rNgNiJmejvuBxAZ7Bp8KGo
    SnyxzeL35crEIvdYTIDTYIdkOttsC1svsAD8HV46tZrNh4l5p5Y5CWgW4YVb4YW1Z5m7
    S9vpwhM8NyBEsklD0F3f+FtvDFaiip68UvaeVoc7fez3Z1NeNe6ubyCwxuGX6ZqdMeR0
    /gVw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73amq+g13rqGzvv3qxio1R8fCv/x28jVM="
X-RZG-CLASS-ID: mo00
Received: from oxapp06-01.back.ox.d0m.de
    by smtp.strato.de (RZmta 47.37.6 AUTH)
    with ESMTPSA id a48ca5y0BGLZHKk
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
    Tue, 11 Jan 2022 17:21:35 +0100 (CET)
Date:   Tue, 11 Jan 2022 17:21:35 +0100 (CET)
From:   Ulrich Hecht <uli@fpond.eu>
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Ulrich Hecht <uli+renesas@fpond.eu>
Cc:     Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Wolfram Sang <wsa@kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net
Message-ID: <607177102.2794009.1641918095844@webmail.strato.com>
In-Reply-To: <CAMuHMdXKuvxnLBRXUgaT=kvvyE4LY9tzM8WiM1J+=4__kY8Stw@mail.gmail.com>
References: <20210924153113.10046-1-uli+renesas@fpond.eu>
 <20210924153113.10046-4-uli+renesas@fpond.eu>
 <CAMuHMdXKuvxnLBRXUgaT=kvvyE4LY9tzM8WiM1J+=4__kY8Stw@mail.gmail.com>
Subject: Re: [PATCH 3/3] arm64: dts: r8a779a0: Add CANFD device node
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.5-Rev33
X-Originating-Client: open-xchange-appsuite
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 10/05/2021 3:20 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> 
>  
> Hi Uli,
> 
> On Fri, Sep 24, 2021 at 5:34 PM Ulrich Hecht <uli+renesas@fpond.eu> wrote:
> > This patch adds CANFD device node for r8a779a0.
> >
> > Based on patch by Kazuya Mizuguchi.
> >
> > Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
> 
> Thanks for your patch!
> 
> > --- a/arch/arm64/boot/dts/renesas/r8a779a0.dtsi
> > +++ b/arch/arm64/boot/dts/renesas/r8a779a0.dtsi
> 
> > @@ -236,6 +243,54 @@
> >                         #interrupt-cells = <2>;
> >                 };
> >
> > +               canfd: can@e6660000 {
> 
> Please preserve sort order (by unit address).

Nothing to preserve there, the file isn't sorted by address. :)

CU
Uli
