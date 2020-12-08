Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A3D2D1F52
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 01:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728860AbgLHAsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 19:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728854AbgLHAsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 19:48:13 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61D6C061794;
        Mon,  7 Dec 2020 16:47:32 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id p126so17641216oif.7;
        Mon, 07 Dec 2020 16:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2ciAmC+wYX3Dr9kQrTLjVuUEig5lOYXKfT3hhM8LDD4=;
        b=D55OYt5QyoNgo118maJiV0w7sRDAkH79G7bKH1SR4Yjji0/JFQWxGKIqbu+m7eq8fT
         SsSZU9hKiGSI8PniwkU7d8yNLapFn2s4z9kWCt+zzJgQj3/dUgIS8KlQd/kL1XWP3SfO
         TVWAdYvijZg/TahfycAUm4p8268orvWuOhmbrZKrSq5rpT5ASIac2UYsSeLE87v7GrME
         xBgxE+NaJhwc5FR+Nq7V9DV1FA4V9ANDGcVVeLw61UTLTBleA9Zj9C0P/fYKT1B5TE0H
         ePKE2VqixP8S9VcTS0UD2jnPGH/v4LIy8EjUPtC3nRQ/z3Tuw5JK3LC3cieARefXcjOK
         O9ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2ciAmC+wYX3Dr9kQrTLjVuUEig5lOYXKfT3hhM8LDD4=;
        b=MACVN6ao4+X1C+LpM0WqXLAsrUbkCrXChfN1K05LtfoE2yMs1RqFnjTrJjYEjga442
         ul65vlU2rveYKutEs1DGtIM2sPaY6hoow3QsAemMuCRGZrYeNZDRdbn4VRw3PcSyojvC
         aY6M8KG7yB4tOwYZNl5ENmCY60qlRr7dDei5hjOP32eT7GEb6reXvAQv8LxJTcORe00y
         7ypySmPwBulOErAnm1ayRjO6YVZWQX3TGhkyTZ5tnWXNW34tNf0ZznVllpCaJIZL8WwZ
         gwOa98/2wOqjHwMPrFyq5wE5fyh9MmX4RSsi5n7erIhHGH74QVOsL9/2JvnDBRQKFoF4
         c7TA==
X-Gm-Message-State: AOAM533WwMkMx/TMuBydYRWUGv8tu/q7p5j0q7UOt7Vtkcla9qx0mtcv
        TdvfLRBq3tceK9E9+1t2Z9bcV1GnEq5M6V9GTg==
X-Google-Smtp-Source: ABdhPJyCUe2Pfe36+YtteBDcJ7+eA/+kIiCHrj/UzXoJX1i3oh67MbZ5Wlo/KRFAU4S6pAnfH1xACnSWbCwg/NAfPoE=
X-Received: by 2002:a54:4603:: with SMTP id p3mr1018414oip.127.1607388452232;
 Mon, 07 Dec 2020 16:47:32 -0800 (PST)
MIME-Version: 1.0
References: <20201207220355.8707-3-george.mccollister@gmail.com> <202012080829.sTB6QzCz-lkp@intel.com>
In-Reply-To: <202012080829.sTB6QzCz-lkp@intel.com>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Mon, 7 Dec 2020 18:47:19 -0600
Message-ID: <CAFSKS=OOU5jKcHVfmXEHUjd87BeNUcbhjy2z3rU9U8AGr-Q8pQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/3] net: dsa: add Arrow SpeedChips XRS700x driver
To:     kernel test robot <lkp@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, kbuild-all@lists.01.org,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 7, 2020 at 6:40 PM kernel test robot <lkp@intel.com> wrote:
>    drivers/net/dsa/xrs700x/xrs700x.c:511:3: error: 'const struct dsa_switch_ops' has no member named 'get_stats64'

This patch depends on "net: dsa: add optional stats64 support" being
merged first:
https://lore.kernel.org/netdev/20201204145624.11713-2-o.rempel@pengutronix.de/
