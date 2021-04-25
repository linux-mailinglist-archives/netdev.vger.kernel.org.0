Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A878236A3AC
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 02:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhDYAZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 20:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbhDYAZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Apr 2021 20:25:18 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F97C06174A
        for <netdev@vger.kernel.org>; Sat, 24 Apr 2021 17:24:39 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id b23so303602lfv.8
        for <netdev@vger.kernel.org>; Sat, 24 Apr 2021 17:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5WR8dQYJUa1XML4lYiw3V24xbNj3qpJxpfUKdL6UNik=;
        b=kdRWdV+xz0cGtFlHE81ER9+UqoZz84Ss/7eSXeLS9dnQvp1YfVW+NZ1ZDQa4cYVCrO
         UZa6oP5V3cYYSzq/Atn0hj+97/omWtlKrgGbqWBpE0CcUg72Q4Gqt4h1KVS/uG2IAKEc
         E+5ZveE+BQrH/0O8AQWyhX6yXfHECChjVDP9KaJDvD55WtyH3qZL6p3YSkLpgih7DWnK
         Dq/louH0Te+3y6wKVaTcYGpHgzLJ3WE8OcN+2yvYKaCbI4ZAES/9vtaPpR14JQ5jBX/a
         aaXMB1oAdkwz6J4oMWZL73Omeqf13LMk1OLlqAITdzT+Ll+jsOw0wm9Kve17HeylFVr3
         RQlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5WR8dQYJUa1XML4lYiw3V24xbNj3qpJxpfUKdL6UNik=;
        b=pJJUlYAh140pazdF9R3P8oaNFBgh5Y+BLFKe/EismLZh7cTgvdhD1gH/7ef4iw+5Bq
         bCCsxWpBqE40z/k7QuJor59rwelYwFuK+wgtvdElaTtYdv/5PXBA3cKErRBROmsYsWoX
         zMv8n3O+Ut1A/OTK9QafXTvczksfyV2pZmuXQr66DAgng9P2fTaOawEWZ3zISFW1ZrTK
         vgReq9+cTmPlUj4HwR1eskkpLsA+Hk+O3Lko7qs2eq8PDvvhjCICy4R5GboXGLzF3/PF
         96XP4cEfLhLkgZtFsU7O/Iyvo62S5Pl0ay/4qzx4PyIcSpgRPV4z4/JCRRLr7Vd+DhZk
         sutg==
X-Gm-Message-State: AOAM531NE4RQjSdhtcafFvxdS0Y1bGDi3nEg21fhj6dhTWaCpt08qNur
        iOVtxLVcvE4P2Az+NUow/m63yXbuOFfiStCnPqYglg==
X-Google-Smtp-Source: ABdhPJyk1el2iJEAC5nGKFSLU5jZj2NH8WDX6XF2wkPJJGPT8WIqVYlrHEACs4H7/ZQB1SxqPQ8XQ3wLL7hgEfYkeaw=
X-Received: by 2002:a05:6512:3a85:: with SMTP id q5mr7406490lfu.465.1619310278090;
 Sat, 24 Apr 2021 17:24:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210423082208.2244803-1-linus.walleij@linaro.org> <YILeb1OyrE0k0PyY@lunn.ch>
In-Reply-To: <YILeb1OyrE0k0PyY@lunn.ch>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 25 Apr 2021 02:24:26 +0200
Message-ID: <CACRpkdZp8OYyQtuhRqGmjc2gVpmjyBMFivHbk3xBiQk5NKbbww@mail.gmail.com>
Subject: Re: [PATCH 1/3 net-next v3] net: ethernet: ixp4xx: Add DT bindings
To:     Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Zoltan HERPAI <wigyori@uid0.hu>,
        Raylynn Knight <rayknight@me.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 4:49 PM Andrew Lunn <andrew@lunn.ch> wrote:

> (...) it should be impossible for multiple devices to
> instantiate an MDIO bus. But with device tree, is that still true?
> Should there be validation that only one device has an MDIO bus in its
> device tree?

This would be more of a question to Rob.

I am "OK" at writing YAML but not great.

If I were to express that out of 3 nodes in the DT one and only
one *must* contain a certain subnode, but it doesn't matter
which one, I have no idea how to express that.

Since the abstract syntax in YAML is pretty much stateless
this beats me.

Yours,
Linus Walleij
