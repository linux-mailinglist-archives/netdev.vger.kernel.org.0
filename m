Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26229254E90
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 21:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgH0TaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 15:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbgH0TaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 15:30:23 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEF6C061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 12:30:22 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id v8so5944896edl.7
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 12:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V0nv7wQoHFBDfCKea743Tg8u0187UBuuLmeycLCt9IE=;
        b=FrpUZP/youjPCtKM9LqQKI6rWq/hmeX+PYpwaZCE58MOs9aULbEOUD4Iz6rJOV9v86
         kzMmDQCn52Ev45YGSetnAY0Zm7bYPpoVb1ZDDxrGQ7IVOnwAt/v/76ct3LJCAOm0LjYs
         t+lHPbwV5vlIeg3D3P29PjAeS807e1JZrOYtTkXUIScqDeAk1oZKWXnMuL9lQYTsQRg7
         Qs17+Og1AY2RfXqoDXhpDyjUr+UD5+p4KKOtLn3B9ZubRDpXluQW5i2GTfFHaCUFIV6T
         Plx3KsGr4Ctbdrr2snVE0YWdOkp0m/vKoxw1hDKbo4gpWES/+w0F4NRMcoYvSSomc6ny
         X83w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V0nv7wQoHFBDfCKea743Tg8u0187UBuuLmeycLCt9IE=;
        b=XwKVDn/3VMFQ9F0P1fM5MJbZsR5hkqPz9mfcRn2gh2g36EvrQo1CNPGgg1rs0shR1T
         QbBs2aERd32+OX6ZdGrkWMH4ah6Am7vzanNgQ3tcuZyPDCBrLtYP+6Er437CDb7xUJzg
         8iBqUYW4sZe0z/fIIMN5KaTH4xu+yNy8VRfGK52wmc/Qf7pzrL2cGdSQIg0l9Pnxk/b1
         5sPc5i/DyWUXmYUGDz9YpH9cCZJpw2b9lY/MrpTXjrUF0OTrouz6D5Jo8TqJQHnFgoO7
         FXyEKUNe0a3M5mMYOfMx2SNjAZb6y2ml7eGcJg2h9dSHMiq3koyJSJLdByvueZbxgGvh
         CMGw==
X-Gm-Message-State: AOAM5331gFMnxJxpLc7zStk6DZYDxIziBQohVG6b/8jnjGIbIKAXbzFn
        uyhHOQc9XmsySDNNGS1mDA6FdelccDMjV0WLishU6g==
X-Google-Smtp-Source: ABdhPJxrUFTaTtdB3uET/8l/a6XdYU2SNVMC86F8LwhWn6NZzuQLhDwt1HrAbXd+AGqTmGHN1IUW2aCKfRrjVA8PDWU=
X-Received: by 2002:a50:d809:: with SMTP id o9mr20639212edj.12.1598556621415;
 Thu, 27 Aug 2020 12:30:21 -0700 (PDT)
MIME-Version: 1.0
References: <1594676120-5862-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594676120-5862-7-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com> <CA+V-a8tZAp_oTpG2MsdC47TtGP7=oM6CubCnjBoR6UhV4=opNg@mail.gmail.com>
In-Reply-To: <CA+V-a8tZAp_oTpG2MsdC47TtGP7=oM6CubCnjBoR6UhV4=opNg@mail.gmail.com>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Thu, 27 Aug 2020 21:30:10 +0200
Message-ID: <CAMpxmJWv=hTgbMLSVFm=C_5qSpo=BvOByW=B+BEEzTPswXfZzQ@mail.gmail.com>
Subject: Re: [PATCH 6/9] dt-bindings: gpio: renesas,rcar-gpio: Add r8a774e1 support
To:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
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

On Thu, Aug 27, 2020 at 6:40 PM Lad, Prabhakar
<prabhakar.csengg@gmail.com> wrote:
>
> Hi Linus and Bartosz,
>
> On Mon, Jul 13, 2020 at 10:35 PM Lad Prabhakar
> <prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> >
> > Document Renesas RZ/G2H (R8A774E1) GPIO blocks compatibility within the
> > relevant dt-bindings.
> >
> > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > ---
> >  Documentation/devicetree/bindings/gpio/renesas,rcar-gpio.yaml | 1 +
> >  1 file changed, 1 insertion(+)
> >
> Gentle ping.
>
> Cheers,
> Prabhakar

This doesn't apply on top of v5.9-rc1.

Bart
