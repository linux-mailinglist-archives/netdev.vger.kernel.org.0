Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464B622544E
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 23:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgGSVoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 17:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgGSVoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 17:44:03 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B657C0619D2
        for <netdev@vger.kernel.org>; Sun, 19 Jul 2020 14:44:03 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id t18so11662779ilh.2
        for <netdev@vger.kernel.org>; Sun, 19 Jul 2020 14:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/XVcnipz9gcgisPuJk+2X78sGGpz9QuL+aPrOtmrLkk=;
        b=fqTLK5/XS13lyySQ8O73k5kQWqVNqdYJCI4dh6r2n+ggxGHSjxtCNQQGbKlr1IB+ue
         uDC5+nqNqsJHnWJmDMnSF2hQG+55VI9WGppn1WS0ON1C6vKeX5eq6GGd1teclUfJ88iS
         TWNrm9Tg9v80yBe0neKdlCTYeUv6uWobcEH+57sqiXqYqMktEpDXHzLQyeV6e8kqmecr
         /9/2JwUbAu2IFciFPKe1GnWrShzYQlAvtdUt5Mugz9JoDUC0oEax1DxnqiAY/3j2TReh
         E5ir7DO8t4i18hk74cPvwz2NC4N5hYPm5zrAlnMuPN5m4SkOgYf0AdTaXxrEQjmducxn
         aazw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/XVcnipz9gcgisPuJk+2X78sGGpz9QuL+aPrOtmrLkk=;
        b=I7uDZyvesIfvZMtBusMFZvR4sUG7Jcll3eRgbjucPfx8CqtdEQdScXNHwVhZ+PkK1/
         qTMBkLnyFeOr3AnoVMfXPx2ylrlDnlDziMDJ7vjnmymat2S8EUkTuD1+RLSC6flZQEAo
         Mx4ShXD1uPxwEiURfZkgt54Nmqq1o6rM6WMLOmVyPrTLSQVE9oHjJtneIqJwlUr6pGV8
         PU/nXOjSmzwoWVbWXHC4F8Lx52+x22HFzc90F5yhlYye+J/ameIouNCf6Yftcod/HVks
         g0TSbibjewSSN6so7n656aBpl3b8pbsfE7fkqjYNqsYeCIJt2kWgruAdQZcFFvdOcY+e
         EWBQ==
X-Gm-Message-State: AOAM531zYUCSooLCmtKZyLqrLg/ALeeE4wv1MKcXtpJVXnZhqkcJ133y
        XOlfoIR7G9Mrb1iRUFplOyPtFlggwXUefFnmPqs=
X-Google-Smtp-Source: ABdhPJxtF0Oz+BPFWjwK9x0rVIxBzn/AGjdpxeRPJzvTPwmK9da8J7IFpI8SO4oppPmKYTIz7T24ea/Or6Mu06m1+Ww=
X-Received: by 2002:a92:aa92:: with SMTP id p18mr20199408ill.199.1595195041108;
 Sun, 19 Jul 2020 14:44:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAFXsbZodM0W87aH=qeZCRDSwyNOAXwF=aO8zf1UpkhwNkSAczA@mail.gmail.com>
 <20200718164239.40ded692@nic.cz> <CAFXsbZoMcOQTY8HE+E359jT6Vsod3LiovTODpjndHKzhTBZcTg@mail.gmail.com>
 <20200718150514.GC1375379@lunn.ch> <20200718172244.59576938@nic.cz>
In-Reply-To: <20200718172244.59576938@nic.cz>
From:   Chris Healy <cphealy@gmail.com>
Date:   Sun, 19 Jul 2020 14:43:49 -0700
Message-ID: <CAFXsbZrHRexg5zAsR1cah4p8HAZVc3tjKdMGKWO6Ha4jXux3QA@mail.gmail.com>
Subject: Re: bug: net: dsa: mv88e6xxx: serdes Unable to communicate on fiber
 with vf610-zii-dev-rev-c
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 18, 2020 at 8:22 AM Marek Behun <marek.behun@nic.cz> wrote:
>
> On Sat, 18 Jul 2020 17:05:14 +0200
> Andrew Lunn <andrew@lunn.ch> wrote:
>
> > > If the traces were broken between the fiber module and the SERDES, I
> > > should not see these counters incrementing.
> >
> > Plus it is reproducible on multiple boards, of different designs.
> >
> > This is somehow specific to the 6390X ports 9 and 10.
> >
> >      Andrew
>
> Hmm.
>
> What about the errata setup?
> It says:
> /* The 6390 copper ports have an errata which require poking magic
>  * values into undocumented hidden registers and then performing a
>  * software reset.
>  */
> But then the port_hidden_write function is called for every port in the
> function mv88e6390_setup_errata, not just for copper ports. Maybe Chris
> should try to not write this hidden register for SerDes ports.

I just disabled the mv88e6390_setup_errata all together and this did
not result in any different behaviour on this broken fiber port.

>
> Marek
