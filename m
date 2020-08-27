Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE90C2543BA
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 12:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728564AbgH0K3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 06:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727911AbgH0K3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 06:29:05 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A8BC061264;
        Thu, 27 Aug 2020 03:29:04 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id h20so2264757ybj.8;
        Thu, 27 Aug 2020 03:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9p4OFhVWpfoFModMO68JgN4kLUfWn4ZrdXLtONTzats=;
        b=cfWl0T/uduUii6AXuAat69qCUSaqTEdxBOxERMz8xs9hUTeNu4BCzoJcLPwR00qgaV
         e3eVum1dak1LKAu6424cfl806r5wrJQjNM2K8QVrKluzB3jgu6C3boB0V2FEr9rrfxL7
         lIXQPqg7SeiBTIppjggaUv9YEH/mBrPYIKUDHoeO8TO3qeIdPjYyO2uLYq/c0tLtyZgK
         yTMSksf7A3iJiUAafJDVQbjzP3gldibdgWZtol3EGo79vI2HpSRKC9BWaG4o7nGdFQOD
         HB/hCPrmJJLgxvzee4ibdYUvgpLcL+vEmQ0FoV3MwVvx1Psro+P6iikMcwUAL/H1Qp5J
         Xz8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9p4OFhVWpfoFModMO68JgN4kLUfWn4ZrdXLtONTzats=;
        b=qQmoppeR/Hb/vgPdSB9ZJAmNDP/BPZ/frZVFavedzCRF6UVTM3E+xw9r3zY9/WW/mS
         3dTb17GXYSNl3HsyQcj01RJoASsQsnNdFGPctCNs6CQz3JknG3FesM2S4hpj92TLMXKU
         6BuzGoEE34dZB/QLls8ICd2zuj9BJP2X6wp/CEhGJQuB6IOO+lRLijYrdrDEZWvI4EPp
         MLGkK2srGLTy+5dC3QCVmK38Cffd6zhaCEQb+t8pXKZAw7d5uhij0wJXu+brxhNaZm9z
         u20LCMy55n16mGaoaMGYLdAtm3xgVM4Ue/ja2GheLuaF276DmOj0k+6mgxpnmGEKLuB0
         uz0A==
X-Gm-Message-State: AOAM533iQo7THlZdajGH/PrFmrkBVEOACl5BtTPP7g5nwtQTk4aJnrSw
        FX6vPL7FiSFNgvEIVAMHTXV1i/jHuPrMRCnw3+4=
X-Google-Smtp-Source: ABdhPJx324llbhik3pGqUwsEqNwv5W5jnr6M095ctSXSrBgZc/2KENC6v9kVZnh8wCEtOOI2vH7CQaoNO4SKSVMh3Go=
X-Received: by 2002:a25:8149:: with SMTP id j9mr28778381ybm.214.1598524144200;
 Thu, 27 Aug 2020 03:29:04 -0700 (PDT)
MIME-Version: 1.0
References: <1594676120-5862-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594676120-5862-9-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594676120-5862-9-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Thu, 27 Aug 2020 11:28:37 +0100
Message-ID: <CA+V-a8voHnHdmSBmewE3BStksxE4dEM1CtE7KwPZ5dn6PmV_0A@mail.gmail.com>
Subject: Re: [PATCH 8/9] dt-bindings: net: renesas,ravb: Add support for
 r8a774e1 SoC
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        dmaengine <dmaengine@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
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

Hi David,

On Mon, Jul 13, 2020 at 10:36 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
>
> From: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
>
> Document RZ/G2H (R8A774E1) SoC bindings.
>
> Signed-off-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/net/renesas,ravb.txt | 1 +
>  1 file changed, 1 insertion(+)
>
Gentle ping, this patch is not queued up yet at [1].

[1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/log/

Cheers,
Prabhakar
