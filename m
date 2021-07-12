Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922DD3C5B54
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 13:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233822AbhGLLPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 07:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbhGLLPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 07:15:20 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914B2C0613DD;
        Mon, 12 Jul 2021 04:12:32 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id dj21so7551224edb.0;
        Mon, 12 Jul 2021 04:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3fBpC1rXmZX5LMI0TFijx2o2OGs4BtPvlFwjIuqvPNw=;
        b=mfLsKRxMFZbjIvA0T0NXkLcKGux0YfShJT7zPeBlb6Y4q0mCkPEml93WJ/ylRuQgUi
         z/iMz7rNiyt+CcoHTpeaI0YT3l8zpGQ5edAWFmuhYl09bYSz0Np1BbU+T4g90a/Nnxqq
         UdNe1Mk+bwMLaC3PQEccIjH7EQy1u2MZJHluuWTENfC1MYmYSJCoL5U2huab2w9HIqla
         JSQkJ5LbAKbkkmC+zSCjyUZCZ6EbeakUnDhs32KyL/PNVA8WtS7P4V9vuGp8da7MREEG
         xJeirA7LhpmTVmwGSl815wiawb9Vp989gcHHr3Djw31+/KF/vToKEeyOk4JvHebC/x+v
         hUcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3fBpC1rXmZX5LMI0TFijx2o2OGs4BtPvlFwjIuqvPNw=;
        b=L7BKoUoa38PH5+5lRrZTF7x0VBHeDfOQvthqrE89BeIt9SrbMLAvy/22adyZzVkquW
         6Wj3oOylZL1QBODlODsoxOThbXf2Qg6vFa1jUQVx2D540HPaTfMYqEEtInFxjKna1N/v
         1edE/Z/zU5Wo2Fx7pw+VsjSz9v/XeqGlpXpuMRMGF7dODD8l0aOcj00NsFHIlPSDh33a
         2c6IHPGTFDO1QHYreqZyJYi72YP2j+cAAVZAgKTUn1+12AoN/O/M8ZpDe7fS/95hpyju
         uBvBx5BjXCsueSZfnqMZSslo+5TVCj+t0qzIEv8LhW0vmwXcQ4GjXkXLwmmHDNHzViEO
         6psg==
X-Gm-Message-State: AOAM531WVHyD8ovRRcRc8ZTbCZHD63mD4HTYULpfRn/PxGX62eDxz5oL
        P8dwAccnIVFZcGwVm4q+bdifmH024V110vrlg9o=
X-Google-Smtp-Source: ABdhPJxhg1F73UC7nMQmO8fEb2NVEmja/9eo6QATaqnMF26NzgHNBAWxRds9YpBmRTN/oWkUUIYoBQ8dRC3irA3+C90=
X-Received: by 2002:a05:6402:190c:: with SMTP id e12mr30878778edz.176.1626088351168;
 Mon, 12 Jul 2021 04:12:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210712072413.11490-1-ms@dev.tdt.de>
In-Reply-To: <20210712072413.11490-1-ms@dev.tdt.de>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Mon, 12 Jul 2021 13:12:20 +0200
Message-ID: <CAFBinCCMtBxvdpkiiFbB1xvy4qhCTb-hU5VJEMQdHDDAYWq=5g@mail.gmail.com>
Subject: Re: [PATCH net-next v5] net: phy: intel-xway: Add RGMII internal
 delay configuration
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>, f.fainelli@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 9:24 AM Martin Schiller <ms@dev.tdt.de> wrote:
>
> This adds the possibility to configure the RGMII RX/TX clock skew via
> devicetree.
>
> Simply set phy mode to "rgmii-id", "rgmii-rxid" or "rgmii-txid" and add
> the "rx-internal-delay-ps" or "tx-internal-delay-ps" property to the
> devicetree.
>
> Furthermore, a warning is now issued if the phy mode is configured to
> "rgmii" and an internal delay is set in the phy (e.g. by pin-strapping),
> as in the dp83867 driver.
>
> Signed-off-by: Martin Schiller <ms@dev.tdt.de>
Thanks for this updated version!
Everything's looking good so:
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
