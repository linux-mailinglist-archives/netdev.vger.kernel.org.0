Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC9627A10F
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 14:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgI0Ms1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 08:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbgI0Ms0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 08:48:26 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ECEAC0613CE;
        Sun, 27 Sep 2020 05:48:26 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id x20so5722065ybs.8;
        Sun, 27 Sep 2020 05:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CFjxhifxWON/DLCUfUkdOBs7RV5AC/hXdvQTfoxTZtI=;
        b=VClCX+X9V94LmGL7DVg6brtHZJE/bObWItqIbyF004J9saTqBphvh219wWPxdtOVty
         KHNChOp69IPedz8ex/a22Pfdh6CLCI+h+NwOyD+qZjxTFKLQN23AfViYsWM9kH+4BmZE
         a0gOd8L3qCwsqKkfS4VZMDzLzF4KLATT5z0/gRIaFyulJTtGo6EYCXcNXlcOrMzQ/Phq
         9YcOahokYcUbwLI1bDktFRVIxqhnlnbG2+F0LGuBE9st4wk5sfnCpS/6MVDMNCbKaGDf
         Tf7jlDfGxOOLw2+Zq6hUMYp5iKqUTx05qDXnYc9lHH2T2t+8AX+Bxki+klPOT5/6XpYb
         s49g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CFjxhifxWON/DLCUfUkdOBs7RV5AC/hXdvQTfoxTZtI=;
        b=BqidLXCPc5qhrivjFG3rqfR+qQbicDeNoXd42io7Zaz1qKZO3/nr4aF5QZpJW2oZ1J
         mnco5Kal2T52FsdjFMGoUPe3Pv9YxZkKAGIBvwTgzx/ONyZ5Nh1Eff+8gAHHSB1Sh94G
         PXkwLBs2xdC/nL/VLFbKbBHndz6KzkTqt/UTKcAT2HqFk2c5jAROMK0xTd6W4y20E3J5
         kQ/Phb9sTzflxnekoZk4KBkpd7HCVZHaTfn9an6rlzko2N4l77+S/G04/YVIlpyBj9pa
         C3doTDMHtnSwbcerVwPKkhgjOY/ucklZrliMciuEPdIYl7y0m4aW0TorWSP0444XoQMB
         hX1Q==
X-Gm-Message-State: AOAM5336YVs2wWPTikyMed+gPAlctlLgedM4BkneKkT9fVybuZVSStzk
        g6VcIi+2WVOqQ1KeJfUck6Nj8GBOavhZTcjTU2g=
X-Google-Smtp-Source: ABdhPJy+FnbdBmS5YtYyeBJgqCp1Zn8O1PUpH6EEfcNZ2eCSmFPx75rboMFmK4ewLWQCRAWFLE/KFx/5QEidkg4HhF0=
X-Received: by 2002:a25:aba1:: with SMTP id v30mr10543564ybi.518.1601210905495;
 Sun, 27 Sep 2020 05:48:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200827153041.27806-1-prabhakar.mahadev-lad.rj@bp.renesas.com> <CA+V-a8tYK4k=NQmmt-jfU6_xuLtZf=GCRMsT1dX30K_3GVBcNw@mail.gmail.com>
In-Reply-To: <CA+V-a8tYK4k=NQmmt-jfU6_xuLtZf=GCRMsT1dX30K_3GVBcNw@mail.gmail.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Sun, 27 Sep 2020 13:47:59 +0100
Message-ID: <CA+V-a8tf29W5e-jnfecvqsQA7AqZCW8YAZbw2hG+6tsxrg4zPg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] dt-bindings: can: document R8A774E1
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, linux-can@vger.kernel.org,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sat, Sep 19, 2020 at 11:29 AM Lad, Prabhakar
<prabhakar.csengg@gmail.com> wrote:
>
> Hi Wolfgang, Marc, David,
>
> On Thu, Aug 27, 2020 at 4:30 PM Lad Prabhakar
> <prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> >
> > Hi All,
> >
> > Both the patches are part of series [1] (patch 18/20, 19/20),
> > rest of the patches have been acked/merged so just sending
> > two patches from the series.
> >
> > [1] https://lkml.org/lkml/2020/7/15/515
> >
> > Cheers,
> > Prabhakar
> >
> > Changes for v2:
> > * Added R8A774E1 to the list of SoCs that can use CANFD through "clkp2".
> > * Added R8A774E1 to the list of SoCs that can use the CANFD clock.
> >
> > Lad Prabhakar (2):
> >   dt-bindings: can: rcar_canfd: Document r8a774e1 support
> >   dt-bindings: can: rcar_can: Document r8a774e1 support
> >
> >  Documentation/devicetree/bindings/net/can/rcar_can.txt   | 5 +++--
> >  Documentation/devicetree/bindings/net/can/rcar_canfd.txt | 5 +++--
> >  2 files changed, 6 insertions(+), 4 deletions(-)
> >
> Could either of you pick these patches please.
>
Gentle ping (patches have been already Acked by the DT maintainers).

Cheers,
Prabhakar
