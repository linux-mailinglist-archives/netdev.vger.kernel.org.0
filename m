Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35BE9270D78
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 13:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbgISLKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 07:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbgISLKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 07:10:37 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06367C0613CE;
        Sat, 19 Sep 2020 04:10:36 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id j76so471803ybg.3;
        Sat, 19 Sep 2020 04:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oSKiRKyUWoQSftUDXcJrCu9pwlvBOoEx/VC+0sM+BVw=;
        b=dh/TvrqS/DyPGQWixmwNWhpF06+/Mj/iCI1ohjpH294TpemWM6vl2H0h088WGz8NPW
         R2PBl53rQuQwBONzrTUj984gz2mNRqSzh8XjzeRjGO9c0ubQXa/uUcLPD2MM+dplnOpE
         UMjEThv8d3hQFfInp1gxOPUO8cEkcm5SjvjyY34w2D+neVa8pgsk6WConEHd2mTfdy9U
         luJ7nYSbbQKhEZqODAhPfrsjvV8HDenEtq8k2l9Kd0gs4ir8WrFghO6Gp6x9M5gnoB1s
         zPKhzeaoL8ShrSFe5AwP2VjZueZYt+rwuRhBWQ5267fKyCMQ6FlcCP5I/4hbLzhtz55v
         ot5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oSKiRKyUWoQSftUDXcJrCu9pwlvBOoEx/VC+0sM+BVw=;
        b=XfGuxmImPA749PK7f6bziAUwuW4OnobMpthBn+/20Pssr8wzkRsKFNr+ETlhUZiC9W
         WSUD1vJq3WVB2A4Jmbx4OKUcMfY8bcw6fpVxUU+BtiqCIwTaYGDde2FNnzX7Q1RDWfss
         x5MMV6ZcT7t08mCmO7Vw1Wa170kHQe+2th551F4I/axKdpqldhUO8qH8SjiKWYuQ8DKp
         QfRljkd3vgRH/efgRA+UC4mpFIKmzWHM0/5DEPngVabgAujTrG6LXV2xQLmo7KLgo03I
         ohVK3EKTVo06k11BAEJhd4NyzHOLrDrYnOm5AfDTCXIitz8zzNAaJI21NLvViRwh89cl
         XgYA==
X-Gm-Message-State: AOAM531et9aZILh4Fn3k/Fzjhh+htyPRESZNXlni22htwv+urltRzcrY
        ycoFeUu6zCxoSWVA4H17/2IjvzfXV2YV3POtylM=
X-Google-Smtp-Source: ABdhPJy4rSARUd8GZNwmfFZdBgZDMQF9IpVcsP5v3P2pt2pZf6Jwz8qtdWIXPaKAgsN223Tv2yVLuiUQ2NZjvmW+5FM=
X-Received: by 2002:a25:6849:: with SMTP id d70mr27870018ybc.395.1600513836167;
 Sat, 19 Sep 2020 04:10:36 -0700 (PDT)
MIME-Version: 1.0
References: <1594676120-5862-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594676120-5862-9-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com> <CA+V-a8voHnHdmSBmewE3BStksxE4dEM1CtE7KwPZ5dn6PmV_0A@mail.gmail.com>
In-Reply-To: <CA+V-a8voHnHdmSBmewE3BStksxE4dEM1CtE7KwPZ5dn6PmV_0A@mail.gmail.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Sat, 19 Sep 2020 12:10:10 +0100
Message-ID: <CA+V-a8tYYvmwE156i_0DnToT+Ep_0SbZWnN4gXpvc_md50Knvw@mail.gmail.com>
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Thu, Aug 27, 2020 at 11:28 AM Lad, Prabhakar
<prabhakar.csengg@gmail.com> wrote:
>
> Hi David,
>
> On Mon, Jul 13, 2020 at 10:36 PM Lad Prabhakar
> <prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> >
> > From: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> >
> > Document RZ/G2H (R8A774E1) SoC bindings.
> >
> > Signed-off-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > ---
> >  Documentation/devicetree/bindings/net/renesas,ravb.txt | 1 +
> >  1 file changed, 1 insertion(+)
> >
> Gentle ping, this patch is not queued up yet at [1].
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/log/
>
Could you please pick this patch.

Cheers,
Prabhakar
