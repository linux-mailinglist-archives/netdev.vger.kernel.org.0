Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 708E561F12
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 14:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731110AbfGHM4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 08:56:47 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:34280 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbfGHM4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 08:56:47 -0400
Received: by mail-oi1-f195.google.com with SMTP id l12so12513836oil.1;
        Mon, 08 Jul 2019 05:56:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XI/RwJW66BJ+bgsS2cJUx1109bAK41jH7oe8lIEoR3I=;
        b=kwna15IX+IpVszJfKdAR2rjyfcky+eS4t06h2M9stIukoQ56wjlxDg1flOQOiKD53+
         HGsFLpDt4yHnTG3Nz7vMjDg+zc07UuzhJQWRzJLiLiz4rz8n32US9sW8adEq2Pyz/sPk
         Q57x2hJ/WtYOFVL8bEspOxqqIOwqO6G9Dbk2T/Nf/83PjYxX6S67XNdsbRwvpPUwmqnV
         A013Hm9znctoGKMRb5So/6vWEAiTYpZywQCn+4J/47gfCxLf6t/afiNIE0vYm83Mr6s7
         xTv/Y4e3+H1LVCRjw4mHyGZ9vRBXNWj6pMoMfuMLEBnFXljAwMVBr30bdUuRjiVPIu6y
         cLTA==
X-Gm-Message-State: APjAAAVCyzdWc6KOai5JKhTxqUop51BCX6dIQpDEnDV7s3vGTL+CSNlj
        RTugodjM0Y7XhZdWvMVDhT0DQs4WKebaZaMVOYM=
X-Google-Smtp-Source: APXvYqxkEKL26Vp7I2CmXjdz3gegpB1Z+1t0zzIcSDhSVTV664nERnqlGdAx7jEkv4px7CKsID4v00kBt4fvNFkiMt4=
X-Received: by 2002:aca:bd43:: with SMTP id n64mr8555849oif.148.1562590606372;
 Mon, 08 Jul 2019 05:56:46 -0700 (PDT)
MIME-Version: 1.0
References: <1560513214-28031-1-git-send-email-fabrizio.castro@bp.renesas.com> <1560513214-28031-3-git-send-email-fabrizio.castro@bp.renesas.com>
In-Reply-To: <1560513214-28031-3-git-send-email-fabrizio.castro@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 8 Jul 2019 14:56:35 +0200
Message-ID: <CAMuHMdWULgX2E2CzEkp1_0_hab6YYk5kuuSdEVEOJN_X9OAKNw@mail.gmail.com>
Subject: Re: [PATCH 2/6] dt-bindings: can: rcar_can: Complete documentation
 for RZ/G2[EM]
To:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Cc:     Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 1:53 PM Fabrizio Castro
<fabrizio.castro@bp.renesas.com> wrote:
> Add missing RZ/G2[EM] CANFD clock specific documentation.
>
> Fixes: 868b7c0f43e6 ("dt-bindings: can: rcar_can: Add r8a774a1 support")
> Fixes: 0c11e7d0f51c ("dt-bindings: can: rcar_can: Add r8a774c0 support")
> Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> Reviewed-by: Chris Paterson <Chris.Paterson2@renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
I.e. applied and queued for v5.4.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
