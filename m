Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87F443BB75
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 22:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239128AbhJZUUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 16:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236912AbhJZUUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 16:20:11 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F93C061570
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 13:17:46 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id h11so894902ljk.1
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 13:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3yQ6Z3Z0g61pqCis/uuv07HaN60SDD6t3x64tUVmCrc=;
        b=zVCrpwgUCuyf/C/hkbrads+BfQnT2aOkSDLVcafimfed1MwT5sWMYIL1fDHi327fmc
         yZr5S10TVZ9lSekV/f5fd024O7WjINB4gAbL97xJQfepU3sIKJY2k58acEJh4pnEXHyc
         aubeuVwppfadgHeFDktIU0WsaAwHAUdHyrNmXFxNyJxcadiHha4aHaJjHe9vxz1S4nY7
         tYgHulsz5D/GAThBdbColkQ7I3IopOLLOnyrJzKFFALA6vVR2G2ykslyEotN2igARpDl
         B9YaBJH9y2CIPgpZdlvrq7NAHoIMkPcTJaa6Avddt33o74PLKpQmKWHYHaMhbqnxcEFc
         nN2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3yQ6Z3Z0g61pqCis/uuv07HaN60SDD6t3x64tUVmCrc=;
        b=XOjh+QMaXJtVTsKIAF1cBVBFIRg+NBjY7Mn1rhSPs9RWtABVdvNyd4kxN38/FGSRx3
         FLy8xJ3SMpapKXTTZEKBcD3VTvdSYpS/22QNwuzOyKYbuVDxL4wARIZHBhoxXJC/yjAK
         vdSm45BrPvpVBYTlD7lLf5Oau6Ol6ubpiwqa7bg0UWWPX59ArxpoBNAuCaKIOii/p3Fb
         czehLdKvDJQWyQcYc7bfzokajci31BdnwyjbM5+V/wFB0D+O2qN7gqKHPD+qeUJ1F/nn
         S1uRPaRIlbutZRQ4b4OWuknkeGx72iB2uEU5spo651I5ZiqT0N3wV/gBgyUj+r9pZ3VA
         KZgA==
X-Gm-Message-State: AOAM530LtoHbQOv+ARsaoxdKKUIyC2EXFslFchKx5557jfC8uGWTC9Vm
        tZJGL3E6a7fD7G9XtrjnrmVPLQuUatmwp29nJWj8Sg==
X-Google-Smtp-Source: ABdhPJzTLrslTFjnjrXfDz6oWJkFGCqP8GQsr4oBSanlHxtW3tmVL4ftXeaKjFPGzpseH8QTkdSkw0bhgm48Elqp/o8=
X-Received: by 2002:a2e:9c0b:: with SMTP id s11mr28696128lji.259.1635279465127;
 Tue, 26 Oct 2021 13:17:45 -0700 (PDT)
MIME-Version: 1.0
References: <20211026191703.1174086-1-clabbe@baylibre.com>
In-Reply-To: <20211026191703.1174086-1-clabbe@baylibre.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 26 Oct 2021 22:17:33 +0200
Message-ID: <CACRpkda-hh98yx7TQ9cmgXrQ+6uPf01gBzRddir0PYYcc5+uaw@mail.gmail.com>
Subject: Re: [PATCH] net: ethernet: cortina: permit to set mac address in DT
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 9:17 PM Corentin Labbe <clabbe@baylibre.com> wrote:

> Add ability of setting mac address in DT for cortina ethernet driver.
>
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>

That looks useful!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
