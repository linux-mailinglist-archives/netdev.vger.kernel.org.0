Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3F82D1692
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 17:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbgLGQjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 11:39:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727385AbgLGQjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 11:39:43 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91904C061793
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 08:38:57 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id m19so20343428ejj.11
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 08:38:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gi/jqrtSXJ/1XPFnDapyzkb7Bcu2viRkU1kz/jwzVVs=;
        b=rjesOFU4V7gH3+GOQtQ8gcJDLO0m3jo4thjkjvpHM1QHtLp7mQfFtZfIeX3rrlnrSX
         HQfdcF2/nh6nOC2daltGykSSIZc2No11jMquCmlh7m0pyHv6fXpWp1ojTXNqGNDDSok0
         wIh/UOjz13KJMQ++7ReXUnuINetJnp35jLeWU/XDss+XQ4/gySLl+Ifim8uSwI/Dm/23
         T1JJGzWtaUTRgnASOFztr4/RlMtB3u0A9eyFZtYpkyqINXNzqDVbFrN1xtDszvlkCMoO
         CknHDYjw8t54gGQG4PL6Czg26Qe1IgHpllRD3Z8r4VU+JrfA8eKCMurCaRuTtVp4vrPK
         sykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gi/jqrtSXJ/1XPFnDapyzkb7Bcu2viRkU1kz/jwzVVs=;
        b=N2QEnQ+SOwcC9JWCvSLeg7x5wV7hscIsFK7MBNTpcn39q5e0AsbWUekilLE2ElcCMf
         pQSq2TmFgVgDX0evPUGHBPeKt4lAzFPV6JgvBdooDAR7OrzQTOgreGah0PjfVUJ1+qct
         v146tFVY9nd7QyCE47T88ZdF+b678uyVOHx2cnydbkbJtM4cSOhuaSzKUdDGGGkphtuR
         q9HAxRLvkdoBOx+Y6d37uOyCP6Yu6HWgygn1Tk+DlbeM11j/+VcDzSenzHL/9YayiwRa
         fnZdKCM3sQYInH+wlLUYzdaHMErWxBXb7Kcgw9HjowAdBga5s3WXOKioRAe/4oc+C+ZD
         RJjg==
X-Gm-Message-State: AOAM531z7Fk8DxdY4ZXtB7t6WffEMYBE0rtYtS3n4EYRLUzwUNnC9yGj
        GS3VG8UyV/fwd6CQtZS6fzHGb01ly03zDTH2XB9CfOPQj/IlTQ==
X-Google-Smtp-Source: ABdhPJwHnB6BQs1HiERZ8CmnuxUM0CXIft1KH2djHzgcG1wTQhNUKN2kB6B89oxiDEQQ9YdSBPnGX3Aeo5RC3wWWWxo=
X-Received: by 2002:a17:906:e093:: with SMTP id gh19mr19814991ejb.510.1607359136226;
 Mon, 07 Dec 2020 08:38:56 -0800 (PST)
MIME-Version: 1.0
References: <1607017240-10582-1-git-send-email-loic.poulain@linaro.org> <3a2ca2c269911de71df6dca2e981f7fe@codeaurora.org>
In-Reply-To: <3a2ca2c269911de71df6dca2e981f7fe@codeaurora.org>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Mon, 7 Dec 2020 17:45:17 +0100
Message-ID: <CAMZdPi-Nrus0JrHpjg02QaVwr0TKGU=p96BjXAtd4LALAvk2HQ@mail.gmail.com>
Subject: Re: [PATCH] net: rmnet: Adjust virtual device MTU on real device capability
To:     subashab@codeaurora.org
Cc:     stranche@codeaurora.org,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Subash,

On Fri, 4 Dec 2020 at 22:56, <subashab@codeaurora.org> wrote:
>
> On 2020-12-03 10:40, Loic Poulain wrote:
> > A submitted qmap/rmnet packet size can not be larger than the linked
> > interface (real_dev) MTU. This patch ensures that the rmnet virtual
> > iface MTU is configured according real device capability.
> >
> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
[...]
> > @@ -242,6 +247,9 @@ int rmnet_vnd_newlink(u8 id, struct net_device
> > *rmnet_dev,
> >
> >       priv->real_dev = real_dev;
> >
> > +     /* Align default MTU with real_dev MTU */
> > +     rmnet_vnd_change_mtu(rmnet_dev, real_dev->mtu -
> > RMNET_NEEDED_HEADROOM);
> > +
> >       rc = register_netdevice(rmnet_dev);
> >       if (!rc) {
> >               ep->egress_dev = rmnet_dev;
>
> This would need similar checks in the NETDEV_PRECHANGEMTU
> netdev notifier.

What about just returning an error on NETDEV_PRECHANGEMTU notification
to prevent real device MTU change while virtual rmnet devices are
linked? Not sure there is a more proper and thread safe way to manager
that otherwise.

Regards,
Loic
