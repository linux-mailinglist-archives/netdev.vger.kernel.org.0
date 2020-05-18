Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED45E1D735A
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 10:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgERI7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 04:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgERI7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 04:59:24 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02EAC061A0C;
        Mon, 18 May 2020 01:59:24 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id l6so2485574oic.9;
        Mon, 18 May 2020 01:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LYV5EXh8n5rFl/NTMi7Ga5qcFteCzV/5Bynz9/j/gws=;
        b=JUwzz0rrL4NlaPHDGnOL5OqO9C4s6vqDx6DD7xWQcMzu0te7kTNTmH3ttNmPdTU1Ad
         1YCOXlK95i1Wkry3f946HZmHLu4pIxHK1m0dFLdhBbXiV4mOgqLY7uht6OjBH5jcdLni
         s0oVIEc+rGoTG4C0ARpq7T5ZydTTubYgGXaoSuTXL5IiVDsr+5Mw6/N5DVKpLCJYy+6I
         J3xSSiyMSb4BVy7fCBzvEb0om2pF1v91PQpcbGrYyhfmwKlZT8MzpukS3lwdyNhBBBGf
         FGYV0MtyHMOPQtoHXB3qIUwEngtXD6dR2O6h0R4JyqiNPNtFc0uuSQ95r8ntCOCpEX9o
         5DMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LYV5EXh8n5rFl/NTMi7Ga5qcFteCzV/5Bynz9/j/gws=;
        b=Q5HX5Cpgxqvwn9PUCedBcLK1VJ6AcHLaYv18RTZTuLjybFaY+Hm2vdc/wMMGW+0Qku
         FXfP1j1DGdEOH/D+K+PqnlQW9pdKgCtLRmM4XoZtl3QGE0c/3FgEWOPGbEiVfxnR7kh3
         zpcPfZyblXh3Vj3M7LI/eRymM9kdCzawiC5HJHhNSDXrBoxfW8IJtk27jBlK5Im3vIf4
         WPn2wlWt6BG3YkzhQ4bZHEUE4U8RvTGp7+kr2EMdp7NidKEBm/mMg6Yvp8iQp53/6Utf
         3Vyxm+TuIFEX3vv+URLwAkVFN8V/w5OeyxJjLt7DgMYxxVJnS02VU3k6iD/o7w/ZboS/
         GULg==
X-Gm-Message-State: AOAM532erRGuLLUQQHDzmWnq5ldlBSaRWBnQ39LcGoodIpsWucDbVVoV
        Cil4pZH0gyp04P2nEEUx91L1PnOnY6rftWP50Sc=
X-Google-Smtp-Source: ABdhPJwuIyJOLz2e50Yb4QdqqIwLF4pHQVzO5AcIThkrk7hdw9v+MTXkyCY4cka5nwu5504APsj8MpP7w418Dex33Y4=
X-Received: by 2002:aca:f550:: with SMTP id t77mr9597289oih.8.1589792364142;
 Mon, 18 May 2020 01:59:24 -0700 (PDT)
MIME-Version: 1.0
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-4-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com> <20200515171031.GB19423@ninjato>
In-Reply-To: <20200515171031.GB19423@ninjato>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Mon, 18 May 2020 09:58:57 +0100
Message-ID: <CA+V-a8t6rPs4s8uMCpBQEAUvwsVn7Cte-vX3z2atWRhy_RFLQw@mail.gmail.com>
Subject: Re: [PATCH 03/17] ARM: dts: r8a7742: Add I2C and IIC support
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
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

Thank for the review.

On Fri, May 15, 2020 at 6:10 PM Wolfram Sang
<wsa+renesas@sang-engineering.com> wrote:
>
> On Fri, May 15, 2020 at 04:08:43PM +0100, Lad Prabhakar wrote:
> > Add the I2C[0-3] and IIC[0-3] devices nodes to the R8A7742 device tree.
> >
> > Automatic transmission for PMIC control is not available on IIC3 hence
> > compatible string "renesas,rcar-gen2-iic" and "renesas,rmobile-iic" is
> > not added to iic3 node.
>
> Makes sense.
>
> However, both versions (with and without automatic transmission) are
> described with the same "renesas,iic-r8a7742" compatible. Is it possible
> to detect the reduced variant at runtime somehow?
>
I couldn't find anything the manual that would be useful to detect at runtime.

> My concern is that the peculiarity of this SoC might be forgotten if we
> describe it like this and ever add "automatic transmissions" somewhen.
>
Agreed.

Cheers,
--Prabhakar
