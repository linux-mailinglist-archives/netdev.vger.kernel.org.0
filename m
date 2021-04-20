Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2176936544E
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 10:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhDTIjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 04:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbhDTIjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 04:39:44 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47FB5C061763
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 01:39:12 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id x20so29960573lfu.6
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 01:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=orqsEsSGNDkaCD/TobYSQuLrm7fPaZKF+27hGxmnjzg=;
        b=f8/xVpcp5XhwiyEdsUgRw7IGyJmZSf1zIg2Enf/26z91OJQgeo6X9Bn4o3PCvNODrX
         5kaCg1HMoeujhGCKFPkEEqAaxxBNanTzR9+qmwJwDyulqgi1F2dkIxHEufLaXedQ4ZQj
         lae8MbFvP2fdhmNxr+oRllZY2OEC6HxbhisOW363maCCCj0XMyYy3HUdvnNvseRTrdgJ
         5e5l6sArHjVhSzH47NISexZSdKJTorkDqI4R+V38rBgzdsNEoHG35x9q0S/3WoeaC1Dd
         jlmSu4camBK6UOYB6y25+hejNoFJz7CTLJu+3rVqq6keoi5T65O+HCaeqYcax2NE4kFv
         80vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=orqsEsSGNDkaCD/TobYSQuLrm7fPaZKF+27hGxmnjzg=;
        b=pTbgGJRTsX5xJQsg128KQZAacr9ZKTBZk+7McpZZc1BggvJcmlW+wX7XZDXN7xcNxU
         p5tfnJAOtEGfTMrjKf4ljQxrLQqmfqCZ5knsPfa81rwr0Vgnx0AW0ySnCv0h/PxAzZWB
         veFAFIxm1+s6SmU81MMSXe0j+j7DRZNG/GejbWylpIIqpfYjK3BzavAxMjorZsNbZ0At
         gnBmar0y+Zq70rVv6BFMiF7Quv5tTesHgQbJCFSGXdijIXZkKq4WQVv5vj24c1PaeJUm
         yvqHnDddAlK4sVQFbKCfH88WQ78LWAz0GZu6HG3h0pDXEo3685SMXxx8CNo0zOtCDDDK
         nWJg==
X-Gm-Message-State: AOAM531I0ghKr3BEXGa0aravywHuVWTrP/HW8hP+QxB0fuVYMazCzgdE
        QjL0VYFmiMi4I49iNTsKsbytwvW6uuk9DG0mNh+kPA==
X-Google-Smtp-Source: ABdhPJwlcVM+nus6UhXr36QJrzd6rrgkgQT4TBb37scVlEJGQwFWfD+uSkrhzpkhYg0Th/oEIthWIX1nJUdWWDFN6kQ=
X-Received: by 2002:a05:6512:3a85:: with SMTP id q5mr14949897lfu.465.1618907950778;
 Tue, 20 Apr 2021 01:39:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210419225133.2005360-1-linus.walleij@linaro.org>
 <20210419225133.2005360-2-linus.walleij@linaro.org> <YH4v9AWjVMtGqLAw@lunn.ch>
In-Reply-To: <YH4v9AWjVMtGqLAw@lunn.ch>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 20 Apr 2021 10:38:59 +0200
Message-ID: <CACRpkdYdoPY0+Mt4QVNhMu44V1Y+6EsG1sMdXbf=h7e3FKKDMw@mail.gmail.com>
Subject: Re: [PATCH 2/3] net: ethernet: ixp4xx: Support device tree probing
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Zoltan HERPAI <wigyori@uid0.hu>,
        Raylynn Knight <rayknight@me.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 3:35 AM Andrew Lunn <andrew@lunn.ch> wrote:

> > +     phy_np = of_parse_phandle(np, "phy-handle", 0);
> > +     if (phy_np) {
> > +             ret = of_property_read_u32(phy_np, "reg", &val);
> > +             if (ret) {
> > +                     dev_err(dev, "cannot find phy reg\n");
> > +                     return NULL;
> > +             }
> > +             of_node_put(phy_np);
> > +     } else {
> > +             dev_err(dev, "cannot find phy instance\n");
> > +             val = 0;
> > +     }
> > +     plat->phy = val;
>
> phy-handle can point to a PHY on any bus. You should not assume it is
> the devices own bus. Once you have phy_np call of_phy_find_device()
> which gives you the actual phy device. Please don't let the
> limitations of the current platform data limit you from implementing
> this correctly.

In patch 3/3 I migrate to of_phy_get_and_connect() which I assume
fixes this, I just wanted to split up the work, but do you prefer
that I simply squash patches 2 & 3 into one?

Yours,
Linus Walleij
