Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74FE254AEE
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 18:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbgH0QkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 12:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728027AbgH0QkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 12:40:13 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4432BC061264;
        Thu, 27 Aug 2020 09:40:13 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id x2so3289974ybf.12;
        Thu, 27 Aug 2020 09:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WYSs0Dku1zdRA2KBaI0ZluOi6UmY5Y9GrXFeF+fDRFw=;
        b=un7kjnEQ+aqsO+z8jtw8rj5enqEblNxAaBGnKPz5YF1M/H5UYX4IB2itVqzx4F9M+A
         4Iw61Lgg+T2/csniC5jvZ46vzCXwe+6ucpfL//IIr2N4fzxId6yxup8IcTBmIH9J1wxH
         xmgaggsssg9MRIaVUt4/uLPzY6xuiGzR9l3f6wTubw05+rhnAtN3ucwXRVkyO/E+iL2c
         Jv+81bmqvmke2b2srFFNR6de7skjpZkTrzLADYU47UvUFd5kFw73lM1gHC3O60ILOWxW
         I4ZCr2cSWmKOElAxgXNe3UVqleDnJSO5F8AP+wHoBbyarZgklem/skA1eZo7nJRMkMI8
         wO1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WYSs0Dku1zdRA2KBaI0ZluOi6UmY5Y9GrXFeF+fDRFw=;
        b=LknddWT94iGwy0TUuCFh4aLqFIfCjoDmqKnHuHRzAe3mBhxYE3N6pyN+K+hCo1ayhi
         GISOETSch4gSBSmQfx2ezhAqfv72V4vOx4lhUehDRAbgmmhvFg/y39Uwb6xu/HQf/b1W
         Xmmg3a7dXIydDk3QosNJBQrWfhv6K2Ohx4clTluOWNXf72cQcDUwVWjTC0aDV5Xn5Bf/
         g3gA4O29cVgNrnEwz7+5Hm23SFCbqnp9gjo1wlEADOrIQwkLSti03udpArwC96EhBLsP
         Oer5G2WVSiwYQWWUkGaP+Oe+ZAPtoQdQvITRhweqsgwL4NQyP8cpNPtawYeTwiwEHHPh
         TIdA==
X-Gm-Message-State: AOAM530j74d+cEuCNcQqM+Xpqex1b3UPzFhssKPkriQiZ4qFaFR8W1Pm
        FkRB+bTBL1O6UYjXUI11MSyKhNqjiUnx7te1ntZ3ebl1odM=
X-Google-Smtp-Source: ABdhPJxrvVPIJbZVxMNdYQbfcSKbpYNpnY4WH7M5vvvn2G4XY4Uv7BI34VoTls0DSRQbKIiloMf4ZMzXPy4YgYSJnGI=
X-Received: by 2002:a25:2f4d:: with SMTP id v74mr28209467ybv.401.1598546412501;
 Thu, 27 Aug 2020 09:40:12 -0700 (PDT)
MIME-Version: 1.0
References: <1594676120-5862-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594676120-5862-7-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594676120-5862-7-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Thu, 27 Aug 2020 17:39:46 +0100
Message-ID: <CA+V-a8tZAp_oTpG2MsdC47TtGP7=oM6CubCnjBoR6UhV4=opNg@mail.gmail.com>
Subject: Re: [PATCH 6/9] dt-bindings: gpio: renesas,rcar-gpio: Add r8a774e1 support
To:     Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        dmaengine <dmaengine@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus and Bartosz,

On Mon, Jul 13, 2020 at 10:35 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
>
> Document Renesas RZ/G2H (R8A774E1) GPIO blocks compatibility within the
> relevant dt-bindings.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/gpio/renesas,rcar-gpio.yaml | 1 +
>  1 file changed, 1 insertion(+)
>
Gentle ping.

Cheers,
Prabhakar
