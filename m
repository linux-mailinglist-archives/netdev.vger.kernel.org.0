Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C97375101
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 10:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbhEFImq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 04:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbhEFImp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 04:42:45 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A910AC061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 01:41:46 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id c3so6643694lfs.7
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 01:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vqoqqwG/Sm/7StgZJFZzPWzpMUimMU/fZ4yBiGhx1bU=;
        b=lyzebzklAgUpuJEr2Z4nZzaqEiO3LAfi5JsJfB0R6bBQLR35qmIDQh9zSxuSnHbyCp
         eLkefy3UQF+/VZbkyyv5cx7gRtBB/m8iVbu/hBBlneq4fcJGzoPAbumxhR1EKrUUYK2A
         LfNCwDeG+0Gt8ULhLKh6O5Oe1+/zaa7pbmUIGyefaVBePre/XWKma88cqYzw+5s77aDC
         y7caWjLCUPfPrHPj78cHXdXoSU0a41LbqSUWt/nUPc4RbcxqdynW6k0nbJTSigcLtpzq
         bd2gPOf3bseZfwm0wYAcyD5gCv/ByJpRBAmT+SIG5h1Lq4lSc1XwpSrsH+lpYe/Beg4o
         XBaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vqoqqwG/Sm/7StgZJFZzPWzpMUimMU/fZ4yBiGhx1bU=;
        b=S9GH9+crSnjVKq7Vt8X8HTlc26+t6X2ndeTFu00VQINtWYW6QMInaHDYMjJmQNXFpA
         t1rdUf8BhPz81R8nzVEO9AYbs5yBk+xhSBVea+s/Bb9sBSF7tYP843PtIwo6DU6Y04uv
         n155NIagBzVuFxmz7XDf+PX0xtDW6+jV+yLF5RVkqGa/XhJl5CJc1ZRs5xLlaZ/Gp5Ad
         qpjrzU+SJXBacU7WRkHPSFzKhpGouqeiqEUwEQJrp7xuVjhnh/O6PytKVGkHGg9SC2uR
         ybTp7J/tBUESRhQTD0RBtGlftws+XaqRWfNXMiO9lDcNxSLeU7yKbKLqTEvaz/0opYHr
         EUyQ==
X-Gm-Message-State: AOAM530pnBqNy4GD0PR70Y6E8QvkOJA/mmiTtb3gps7Orhm/EDuf5KhP
        hNzZ9IQJ7wJJuPfWUb81vXxv3ThmAwMUYSN4mR8YoQ==
X-Google-Smtp-Source: ABdhPJwpbPqssKuUoKhLJ2Oxg5Y9MSO0cU6Ssng9STHq/8W/zGsIgP+MVZxC4Aj8oKr6eiPaX8kqmim4zEJkNJNvy+0=
X-Received: by 2002:a05:6512:149:: with SMTP id m9mr2045704lfo.157.1620290505124;
 Thu, 06 May 2021 01:41:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210429192326.1148440-1-clabbe@baylibre.com>
In-Reply-To: <20210429192326.1148440-1-clabbe@baylibre.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 6 May 2021 10:41:34 +0200
Message-ID: <CACRpkdY7dC=QXdnshHK7ByTE8NkThiDm7sZSZrH07F7GBiMM5w@mail.gmail.com>
Subject: Re: [PATCH v2] dt-bindings: net: Convert mdio-gpio to yaml
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 29, 2021 at 9:24 PM Corentin Labbe <clabbe@baylibre.com> wrote:

> Converts net/mdio-gpio.txt to yaml
>
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>

This v2 looks good to me, I suppose you will need to wait for
net-next to open and resend it with "net-next" in the subject
though.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
