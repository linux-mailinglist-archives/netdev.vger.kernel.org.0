Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D06D37B632
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 08:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbhELGgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 02:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbhELGgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 02:36:03 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364D8C061574;
        Tue, 11 May 2021 23:34:56 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id z1so11534024qvo.4;
        Tue, 11 May 2021 23:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m0gzjTtB8QgGDKc9baNE5fji+M4gSffyk6B9ol6NXGU=;
        b=jUEVqe1XDHL7tDNQhartGrq92p9/k6UW9fKPRdne7IH/OuCd9L1yYO1wgxpGOTxPSs
         ntkaU7BUzBfp9MXqwm+WL60+vf31gZXNM2dSs0AucAx6Sb7gdO2Clv4dXXCVgawulN0C
         vdmVIaxUSRl/TRx0eodWZZE+6+9psduUNrRLU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m0gzjTtB8QgGDKc9baNE5fji+M4gSffyk6B9ol6NXGU=;
        b=k8vuClm2ez1akbVRX3qeiNVo2i27Wkfcz6o5CnCTvM/kifyopOpueXr2sMzWCrTO4E
         2GsQnoqj+JhOHGeiLsGs8Cw40LmKXE6uewqMNQmoUq8csZWg94baB0uwssp/YXouTCfX
         Y4PKL/Jka08s1clyRVGjqfVu8IInRd9cUsd6PeAnkCVNfWn56TXvJ2+Svt4wOJsgRxsA
         AQXoWxsLSsV2ReeDE5Dk6Ep23tBIEl0eny0NxYnguKbaLRPxI41LOiQ9uYD2pkWIYSF1
         otVDjVORCfVVd0+zDPWGaGCeYOWeOwtO39XZ0qdiVngu7NIfmfc++5uF09VFTaBecWK+
         tyog==
X-Gm-Message-State: AOAM532FP0VETxNDgO7I3Ua1lejb2q0ii3/Cm3IyFxCTioi2E6TE9CJ5
        Yzc/agtVXwW3hUVOjHuXyK+4gKOMDkWEUka62kWdUAMgpjk=
X-Google-Smtp-Source: ABdhPJzCEIxh2H2pOIMO0oGM6WytczIHKo2s4ibtRpIOtbi/FfQbPNDCxuathbrJE3659y5tRD8UwjdUuWE/VcOYors=
X-Received: by 2002:a0c:d786:: with SMTP id z6mr33336335qvi.18.1620801295398;
 Tue, 11 May 2021 23:34:55 -0700 (PDT)
MIME-Version: 1.0
References: <1620790204-15658-1-git-send-email-zou_wei@huawei.com>
In-Reply-To: <1620790204-15658-1-git-send-email-zou_wei@huawei.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Wed, 12 May 2021 06:34:43 +0000
Message-ID: <CACPK8XeEHCPXt_xq4YFy5ZAdAuBgoAE0SfcyRX1P39T7Dz6d4g@mail.gmail.com>
Subject: Re: [PATCH net-next] net: mdio: Add missing MODULE_DEVICE_TABLE
To:     Zou Wei <zou_wei@huawei.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, hkallweit1@gmail.com,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Networking <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 May 2021 at 03:13, Zou Wei <zou_wei@huawei.com> wrote:
>
> This patch adds missing MODULE_DEVICE_TABLE definition which generates
> correct modalias for automatic loading of this driver when it is built
> as an external module.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zou Wei <zou_wei@huawei.com>

Fixes: f160e99462c6 ("net: phy: Add mdio-aspeed")
Acked-by: Joel Stanley <joel@jms.id.au>

Thanks for the patch.
