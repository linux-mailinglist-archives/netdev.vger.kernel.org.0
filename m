Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242BE1D7443
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 11:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgERJnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 05:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgERJnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 05:43:52 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48A7C061A0C;
        Mon, 18 May 2020 02:43:52 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id x23so1869341oic.3;
        Mon, 18 May 2020 02:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/VHy1hHOeueJvHWA+mIj7Qzx/f1KRkhXRlYmq2aNs+s=;
        b=JqgjwmBPXoMBDRhMe/zLRO+0nqJpZo3xtehDSPILE43EMVp7vI1ltfmdts5s0KtCRf
         uIBgtiMhyn/xhEM1Id+681LLJSD/Qj5nLdHpUxWXsbb7BOa3H+n6xY/DSomN53kEeQub
         2m1BwrNVkjIv1TGT49CZlr9mhKPXYG3uK/ZMHmxwbPkZ8Rjwectk1gAHCV7CzzzaCkeR
         gnYSbO8hAulsKvOwAb/5h8C1+Uqji79SPswiZelTUH9Pyz3CDYs1mmuV83v0fcyvwFXS
         axdNbFME8NdzKR7KcRXjqDXEevkA/rrYfd3uFaW9m/S04Vw50TCElWMXIAIJ95KXr57o
         IOvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/VHy1hHOeueJvHWA+mIj7Qzx/f1KRkhXRlYmq2aNs+s=;
        b=IWlXMULj8oD2pE1mrCYA9u8giZ+PIAZERFA64+XrE6EOM5+BoMphDwAYP1C1V1Atw7
         uFbXEziiQJuOz/d4SFvtd14jD76A0hIbG1tOy+S4fPXtgmwczRiQacOUk09FgDJeTmyl
         IolzDXPMuAScxIsm78a82Q6kEzg+frfGhLhZRXFJXMxv0uG+ldQWpEvcEjw9i+UKdAuJ
         51SfgFN6iYW/82HSZIkfXdvbOhBJcas+Ry4QPFv/DziJhh0r8unyupNiVxMeDXPMh3Np
         ZSA5dCP3CSXS3VbLxUNBsp8IoMbtHTZnWm8jPvof+hHISy3v7zmfDl8N/XiM5m5mXzu0
         s6DQ==
X-Gm-Message-State: AOAM5315Z1yJmoHZnOU8Ud6MSjajjvj6xVxGMksMNdqdFj5uNSGT9OcG
        796ssuNFsCMUuAchBOozrG2zl5cbzHLsehK9Hlo=
X-Google-Smtp-Source: ABdhPJyZokWBShBDnXM+nIl04b5W7Or37VItdZLPs5gY9c4zj0/Ms7gEb4Fyihg95NVJWH0uI4VMBKsajlBWzNrAoDg=
X-Received: by 2002:aca:d68f:: with SMTP id n137mr8141794oig.62.1589795032149;
 Mon, 18 May 2020 02:43:52 -0700 (PDT)
MIME-Version: 1.0
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-4-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20200515171031.GB19423@ninjato> <CA+V-a8t6rPs4s8uMCpBQEAUvwsVn7Cte-vX3z2atWRhy_RFLQw@mail.gmail.com>
 <20200518092601.GA3268@ninjato>
In-Reply-To: <20200518092601.GA3268@ninjato>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Mon, 18 May 2020 10:43:26 +0100
Message-ID: <CA+V-a8sTm8YEP2Upu1t6tb6YMpaANFRnnLVW=1TXP2LpVMvrNw@mail.gmail.com>
Subject: Re: [PATCH 03/17] ARM: dts: r8a7742: Add I2C and IIC support
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Jens Axboe <axboe@kernel.dk>, Rob Herring <robh+dt@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-ide@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-i2c@vger.kernel.org,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        linux-watchdog@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wolfram,

On Mon, May 18, 2020 at 10:26 AM Wolfram Sang
<wsa+renesas@sang-engineering.com> wrote:
>
>
> > > However, both versions (with and without automatic transmission) are
> > > described with the same "renesas,iic-r8a7742" compatible. Is it possible
> > > to detect the reduced variant at runtime somehow?
> > >
> > I couldn't find anything the manual that would be useful to detect at runtime.
> >
> > > My concern is that the peculiarity of this SoC might be forgotten if we
> > > describe it like this and ever add "automatic transmissions" somewhen.
> > >
> > Agreed.
>
> Well, I guess reading from a register which is supposed to not be there
> on the modified IP core is too hackish.
>
> Leaves us with a seperate compatible entry for it?
>
Sounds okay to me, how about "renesas,iic-no-dvfs" ? So that this
could be used on all the SoC's which don't support DVFS.

Cheers,
--Prabhakar
