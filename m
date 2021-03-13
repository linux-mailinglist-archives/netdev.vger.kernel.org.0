Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B2133A184
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 22:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234850AbhCMVyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 16:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234796AbhCMVyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 16:54:19 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2C8C061574;
        Sat, 13 Mar 2021 13:54:14 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id m9so29273624ybk.8;
        Sat, 13 Mar 2021 13:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GhwxGEkw8ytL79APFDFDPPxm81DmFU7dhHEQAY8fvks=;
        b=J6v4X2zh9zr/+JhZYu1TO4VzEhA1YsHaSBACt0Sc0eVzhxQLmhXzcEky+Yq2okFras
         3kezJaiqHbGQ9+JnLOOV1yylpNyEBytWs2Wlu5ba8BPh4Jgb3wYLWSDfig/efUSxPVdP
         pY2XlJ+iSz8uErGCVXYSYIbiXjSpODZoh1ImEC8NDLxekhiFdLQEjSYKk82ufvWAfXtu
         GRwnP11EBBdkh+SfdeES9EbW2HsMpV9QULfYwIyLNFoocT7AtCOL7m/D2egI73JDOoAg
         h6xC+KK33ULwBTPvKfQf9fSSUN1pxESIUuI7ZrP6GciuxuNFcgcw/bu1RuX97/k17cWp
         AqSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GhwxGEkw8ytL79APFDFDPPxm81DmFU7dhHEQAY8fvks=;
        b=nXuP6RwCrDwemSoG2Q63tpjdq8MguGN4w+P3rD5G7PyPOEgoy1Q4cN9t8HF3XjCH0E
         cokkUWNT+yYmx2lfM0l+P/bUxp+BZRloACrIiL3pCtFwGVh+AC43oeXQU5xOnoMulXnu
         Wt2c7LagOxOz46SpUlyNiJB55S5//AfvjLyosSprt16Mp0zY2hTcIXrjEPEtL6/bhSjU
         q98lI4mdpDfBEbC76VudGkMoh1mGzregjnnV2ca5hq7Jg8cCce79kUSEQBk+CZuuRtAk
         lEJc6WtlMPbzIUDpx6qtOb2L2GfwN0q61/BKKW0Kzbi6nhDXNqL9WWfFD2nFiQnNPHtK
         SDRg==
X-Gm-Message-State: AOAM532bkT0eAQEDuA9Is+WWYAH+4fLtVgBTHSStDEemuBUaWpUo2G0e
        nXIJX6MAvsHHwwjaEfn6AgpLjQcEVamFB5Rzdjg=
X-Google-Smtp-Source: ABdhPJz1plNkpafFFbtDcDfYgLN5d/wG6nGryBoO1b+5biUSDjCo7b2e1ZYH0okZE90OY9uUx6k/i9EhP2TNXun5m3A=
X-Received: by 2002:a25:ca88:: with SMTP id a130mr27494740ybg.414.1615672454155;
 Sat, 13 Mar 2021 13:54:14 -0800 (PST)
MIME-Version: 1.0
References: <87tupl30kl.fsf@igel.home> <04a7e801-9a55-c926-34ad-3a7665077a4e@microchip.com>
 <87y2euu6lf.fsf@igel.home>
In-Reply-To: <87y2euu6lf.fsf@igel.home>
From:   Emil Renner Berthing <emil.renner.berthing@gmail.com>
Date:   Sat, 13 Mar 2021 22:54:02 +0100
Message-ID: <CANBLGcyteTgQ2BgyesrTycpVqpPeYaiUCTEEp=KmPB0TPqK_LQ@mail.gmail.com>
Subject: Re: macb broken on HiFive Unleashed
To:     Andreas Schwab <schwab@linux-m68k.org>
Cc:     Claudiu.Beznea@microchip.com,
        linux-riscv <linux-riscv@lists.infradead.org>,
        ckeepax@opensource.cirrus.com, andrew@lunn.ch,
        Willy Tarreau <w@1wt.eu>,
        Nicolas Ferre <Nicolas.Ferre@microchip.com>, daniel@0x0f.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        pthombar@cadence.com, Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andreas

On Wed, 10 Mar 2021 at 20:55, Andreas Schwab <schwab@linux-m68k.org> wrote:
> On M=C3=A4r 09 2021, Claudiu.Beznea@microchip.com wrote:
> > I don't have a SiFive HiFive Unleashed to investigate this. Can you che=
ck
> > if reverting commits on macb driver b/w 5.10 and 5.11 solves your issue=
s:
> >
> > git log --oneline v5.10..v5.11 -- drivers/net/ethernet/cadence/
> > 1d0d561ad1d7 net: macb: Correct usage of MACB_CAPS_CLK_HW_CHG flag
> > 1d608d2e0d51 Revert "macb: support the two tx descriptors on at91rm9200=
"
> > 700d566e8171 net: macb: add support for sama7g5 emac interface
> > ec771de654e4 net: macb: add support for sama7g5 gem interface
> > f4de93f03ed8 net: macb: unprepare clocks in case of failure
> > 38493da4e6a8 net: macb: add function to disable all macb clocks
> > daafa1d33cc9 net: macb: add capability to not set the clock rate
> > edac63861db7 net: macb: add userio bits as platform configuration
> > 9e6cad531c9d net: macb: Fix passing zero to 'PTR_ERR'
> > 0012eeb370f8 net: macb: fix NULL dereference due to no pcs_config metho=
d
> > e4e143e26ce8 net: macb: add support for high speed interface
>
> Unfortunately, that didn't help.

Sorry, for being late to test this, but I just compiled and booted
5.11.6 and ethernet works just fine for me:
https://esmil.dk/hfu-5.11.6.txt

As you can see I haven't updated OpenSBI or u-boot in a while, don't
know if that makes a difference. You can fetch the config is used
here:
https://esmil.dk/hfu-5.11.6.config

/Emil
