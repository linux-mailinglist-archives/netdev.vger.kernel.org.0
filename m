Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3CC270D04
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 12:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgISK3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 06:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbgISK3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 06:29:44 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AF3C0613CE;
        Sat, 19 Sep 2020 03:29:44 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id a2so6334111ybj.2;
        Sat, 19 Sep 2020 03:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bgc4Ern0Y0Q1ekxGlfi+TnuTO0VX/iOSAV2OpCNNyMs=;
        b=nccB+YiePPbuyj+5ZX/P31lqlS0RkmlZUl3LaCjZdI/rJQhi8FvjABo6zKrvRlGtVH
         ObwKkLGgsWjaTRkFTW4Ka9/AlTwD0Y7Z4azpfWs0wDSW2dthCqcXSAoOZdmons9tFnmS
         9aZOW6MBh1NcLh7mDp5MpZx2AB+od4LLmN+om2ITGbq0Ghro/lP+JQfWFnYwDaESGky5
         jFVto0WOOwCMOCBhJxxkezxgM27lOv6XdxzYYJH8vO8K0w59pEqWc49fqmOUXpe/VGUF
         jlH+6d94QbtNFAPS2ggNV7Qc2hdh5ALtvI9gLqNBQCO61OTz6fRyBnLkH4h/LRX4yWrw
         8W4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bgc4Ern0Y0Q1ekxGlfi+TnuTO0VX/iOSAV2OpCNNyMs=;
        b=f2Ebt2b2q7QuWIlsv6OR5yptzCI+WDSGGSd9npu/RK8K+AgFC3QwvKnd6PHytLc/+F
         pjT03gOltvMQoXCOrXlc5tWiTtVV0YHhNgZZmzwbXFoYTWRRGfiwysM98ixvd5TFbc3t
         GA265DqxTVF5rHZvBf1k40AwQMB1cdZ/cuJ3WQCjbK4xsmXoR2rKXJ9KF68tiPXHBNFp
         KMAmvHQqGb/V+YZoTS30EK3hNFcvHOItwkUXsYsLsQHSg9a+SscIAQeMwkaFiQgpPRPT
         4D33TpRRkWuSzET9YDkNfcBR2ZrmglY+YcMmwiOtdRqNHDPcqejS/It+6wplUb00Vnmh
         vLoQ==
X-Gm-Message-State: AOAM53129YQ89np3FHKCOYwfVlDtSM3QGy/NbNZtiCgi2Y0R4tmg7bVT
        IWwci3UKXFbmxV6L9pKi/Gx9xevGKxbgDlCswQE=
X-Google-Smtp-Source: ABdhPJyk1tFrKk24g/oNjpsj259VACkd1z7im4SfhTwP2PQVQpraTXlTs1/jNW9RSKfXKPQK2rl7mDzlWKdiOwtNF3w=
X-Received: by 2002:a25:e811:: with SMTP id k17mr45524041ybd.401.1600511383079;
 Sat, 19 Sep 2020 03:29:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200827153041.27806-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20200827153041.27806-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Sat, 19 Sep 2020 11:29:17 +0100
Message-ID: <CA+V-a8tYK4k=NQmmt-jfU6_xuLtZf=GCRMsT1dX30K_3GVBcNw@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] dt-bindings: can: document R8A774E1
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>
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

Hi Wolfgang, Marc, David,

On Thu, Aug 27, 2020 at 4:30 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
>
> Hi All,
>
> Both the patches are part of series [1] (patch 18/20, 19/20),
> rest of the patches have been acked/merged so just sending
> two patches from the series.
>
> [1] https://lkml.org/lkml/2020/7/15/515
>
> Cheers,
> Prabhakar
>
> Changes for v2:
> * Added R8A774E1 to the list of SoCs that can use CANFD through "clkp2".
> * Added R8A774E1 to the list of SoCs that can use the CANFD clock.
>
> Lad Prabhakar (2):
>   dt-bindings: can: rcar_canfd: Document r8a774e1 support
>   dt-bindings: can: rcar_can: Document r8a774e1 support
>
>  Documentation/devicetree/bindings/net/can/rcar_can.txt   | 5 +++--
>  Documentation/devicetree/bindings/net/can/rcar_canfd.txt | 5 +++--
>  2 files changed, 6 insertions(+), 4 deletions(-)
>
Could either of you pick these patches please.

Cheers,
Prabhakar
