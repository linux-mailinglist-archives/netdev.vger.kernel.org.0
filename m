Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9473DEEEC
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 15:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236065AbhHCNQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 09:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236039AbhHCNQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 09:16:08 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3386C06175F
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 06:15:57 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id z4so25312702wrv.11
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 06:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NMmJvbT6y6/0DRoW6BuzSc4j72Jw0EMJid8wQ9MezpI=;
        b=HyXfk/oNAwdEVV5YcgQEc2/wIcNL/qVwtMiNW9fCB3sgS42dfh7BlH5RoFhtUjCoHs
         czZgTSGa7mVBDUrZbSf4DedgFzT8UAUct0np9jeeSzsrU+0jUi0+gmvJuD7BUBMfHOfB
         otA55Ta5X+dKpc57SvFJYHvgzCd4myFh6mxNOk0e2/H6JsSZmYlBiA5i/oirTwK+Lno1
         SpLimJwe4in17VaFYkFA7BBk4ugkECn8+5Fqr2lZD3hEUsXjN0ykSAe+nD94wMjhEz+D
         wxk/ZOpZu/cUYFnCtBu77RXY+V7mJmc4q/AFZNdk6odIYbIDiBKkeAc+xv5XBJvbn5YH
         eWFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NMmJvbT6y6/0DRoW6BuzSc4j72Jw0EMJid8wQ9MezpI=;
        b=SN3JPwk/SPl8ofPm5XUL9WhHctqDbcIGy55D6AmCHJtns8gQE0EoGF5Ba2EXFtC+Ma
         E52C//QnwjK5lQ8F0iiv0dWl4oHDRrI6RmltQzpoxOUwVIuwlMVWL16qEZexdETzxraU
         yViEd9wEEl3UNb1uJTA+d4IIEkEpi3hbvcGcscuOT0261u/wz4p3WC4DObaLVNBLizzD
         a2WJm6UKaWgvSipwnwgHsYVnW6XO2U37R0q8nwCsYGuYKT7i6aNm4lT0lJn2Pi13OGAm
         wfF7VSVtAnfLii1WjXq9a1gA+U4Ltt88O03ICvlcBoZlyoJ/gFJbPXM+RDEV5xA4HSI1
         JU2w==
X-Gm-Message-State: AOAM532UZOzzgwDt9HVtA6g/aSPwApE7VoZzzYh8i9xogm1m89Hs0Pdr
        7v2pxoR7186t8mu3i2ujTlyYjlSrMN8cLe0epHaitF3gyHU=
X-Google-Smtp-Source: ABdhPJxxFeVPy982FeioCAZGTb5E5KrC0UxbVG8DOLlyESxioZKNDm3P4PgmWsC47RcAVTcKSfsR4vbjrJijcshWxVs=
X-Received: by 2002:a5d:6845:: with SMTP id o5mr8227431wrw.5.1627996556456;
 Tue, 03 Aug 2021 06:15:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAN6UTaw7Rtoz4q-AsDjKbTm7_sU8BrTAmuMp8-wr6FzaxDMe2Q@mail.gmail.com>
 <20210803085032.8834-1-michael@walle.cc>
In-Reply-To: <20210803085032.8834-1-michael@walle.cc>
From:   Leandro Coutinho <lescoutinhovr@gmail.com>
Date:   Tue, 3 Aug 2021 10:15:44 -0300
Message-ID: <CAN6UTawJCj0O-oXSwGoVxjii9JTJ484UKXZzYnqPW1L7JB=jJA@mail.gmail.com>
Subject: Re: net: intel/e1000e/netdev.c __ew32_prepare parameter not used?
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 3, 2021 at 5:50 AM Michael Walle <michael@walle.cc> wrote:
>
> Hi,
>
> > It seems the parameter `*hw` is not used.
> > Although I didn't find where `FWSM` is defined.
> >
> > Should it be removed? Or is the parameter really needed?
> >
> > static void __ew32_prepare(struct e1000_hw *hw)
> > {
> >     s32 i = E1000_ICH_FWSM_PCIM2PCI_COUNT;
> >
> >     while ((er32(FWSM) & E1000_ICH_FWSM_PCIM2PCI) && --i)
> >         udelay(50);
> > }
>
> If you have a look at the definition of er32() (which is a macro and
> is defined in e1000.h, you'll see that the hw parameter is used
> there without being a parameter of the macro itself. Thus if you'd
> rename the parameter you'd get a build error.Not really the best
> code to look at when you want to learn coding, because that's an
> example how not to do things, IMHO.
>
> -michael

Thank you very much Michael! =)

er32 is defined as:
#define er32(reg)   __er32(hw, E1000_##reg)

That's why I didn't find any definition for `FWSM` ... because of the
token concatenation https://gcc.gnu.org/onlinedocs/cpp/Concatenation.html

I think this way it would be more clear:
#define er32(hw, reg)   __er32(hw, reg)

I don't know if they did it that way just to avoid typing, or if there is some
other reason.

That is one advantage of Rust: macros have an ! at the end, eg: println!
So you can easily distinguish macros from functions.
