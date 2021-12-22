Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05BD147D7DB
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 20:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345293AbhLVThx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 14:37:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232808AbhLVThv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 14:37:51 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7323EC061574;
        Wed, 22 Dec 2021 11:37:51 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id q74so9639404ybq.11;
        Wed, 22 Dec 2021 11:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JdkYvs20BpJlttg/sO+h+d7jCfULBOe8+I92ZlF90H0=;
        b=Q1SAHaetYjQ/EOwOdwCaMPzNpCC+yMulPpy3xC4P1n19cq+11tylhwX0k6W8UYmDEB
         qJG3I7vxY3wzMJ9uCaj3zIrN7J93ORZKhnFpqpUaUK0hklS7plLdvDwdhP5WBiwtaYPz
         CyyAkv4ltoO09LoarJUNRgGQW2vpi2PucDuLFLyfrXv2v8WGI2UMC5Oh09LslXPY/cMk
         9kjVER97cD+wAeNdu3Xx2lH2SZeOKDlLO3Upv/1uW3Ya1MvNwgP3UIMZAMN2qILUuiYR
         8gKNpomh6OKHjbCMWpCK1W2kK3fcMXcEf2pPNUpWEhhYc/eADZNhg5E2ZRiSia6njllX
         QVbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JdkYvs20BpJlttg/sO+h+d7jCfULBOe8+I92ZlF90H0=;
        b=WclQ4xllO6XTd1+Yk0uqVyhVcRGCTORLVTO3ayrQfNeLU8iSmjTn56LOQNVyHqYn77
         pkWcqqNSCgV9qZaz/IH54m+/kWsnTpmpciS4TqjoD4d364ZeSakj1nC1Vba5uPJSsHyT
         CrLuiOHU2lsw9viqsBty6pEj+QLFX/qG3YtZVs/eqbUol5FegIDA45T2GM74t9B+ekDb
         XvzQFxde9SQwvA+tw8qfgx9MNDiY+qP90sbB1O63f9cyybdGCuwHEAkkpLZniubzYS1v
         nFV/xHsUdEoez9hFkQgzyL17lokvdObUnBFUeYW2MxUpHMGYf/BT7iwjzeQS3qDCtTkw
         GeWg==
X-Gm-Message-State: AOAM531AJ4Hef8fdw3YeQwTtfyiXMiyt5W/9yBohu9XnBWlpOc5xdV6z
        kNnJx4Eo9jR8ZOaGa8P6GeZCvFp8drGpzGxbwWM=
X-Google-Smtp-Source: ABdhPJzdVT+SQRtJbDPy9fx/RFt9bR29nRb5pHIcRNYiRMiQ6ON6WRwM9HPCPHaWh3ZtBJTxcH+1lkFSG0nAeaKi6ro=
X-Received: by 2002:a25:98c4:: with SMTP id m4mr6431027ybo.613.1640201870647;
 Wed, 22 Dec 2021 11:37:50 -0800 (PST)
MIME-Version: 1.0
References: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20211221094717.16187-3-prabhakar.mahadev-lad.rj@bp.renesas.com> <YcNtMMNKHIgGFZ+V@robh.at.kernel.org>
In-Reply-To: <YcNtMMNKHIgGFZ+V@robh.at.kernel.org>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Wed, 22 Dec 2021 19:37:24 +0000
Message-ID: <CA+V-a8tUyRUaEVhh9_xdHEzYnuYTaj2M6dqqvQGYOgoXOjWxxQ@mail.gmail.com>
Subject: Re: [PATCH 02/16] dt-bindings: arm: renesas: Document SMARC EVK
To:     Rob Herring <robh@kernel.org>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

Thank you for the review.

On Wed, Dec 22, 2021 at 6:23 PM Rob Herring <robh@kernel.org> wrote:
>
> On Tue, Dec 21, 2021 at 09:47:03AM +0000, Lad Prabhakar wrote:
> > From: Biju Das <biju.das.jz@bp.renesas.com>
> >
> > Document Renesas SMARC EVK board which is based on RZ/V2L (R9A07G054)
> > SoC. The SMARC EVK consists of RZ/V2L SoM module and SMARC carrier board,
> > the SoM module sits on top of the carrier board.
> >
> > Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > ---
> >  Documentation/devicetree/bindings/arm/renesas.yaml | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/arm/renesas.yaml b/Documentation/devicetree/bindings/arm/renesas.yaml
> > index 55a5aec418ab..fa435d6fda77 100644
> > --- a/Documentation/devicetree/bindings/arm/renesas.yaml
> > +++ b/Documentation/devicetree/bindings/arm/renesas.yaml
> > @@ -423,6 +423,8 @@ properties:
> >
> >        - description: RZ/V2L (R9A07G054)
> >          items:
> > +          - enum:
> > +              - renesas,smarc-evk # SMARC EVK
>
> This and patch 1 should be combined. Changing the number of compatible
> entries doesn't make sense.
>
Will merge this with patch 1. Is it OK if I include your Ack when merged?

Cheers,
Prabhakar

> >            - enum:
> >                - renesas,r9a07g054l1 # Single Cortex-A55 RZ/V2L
> >                - renesas,r9a07g054l2 # Dual Cortex-A55 RZ/V2L
> > --
> > 2.17.1
> >
> >
