Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C46B1C79A9
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 20:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730482AbgEFSsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 14:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730145AbgEFSsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 14:48:52 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3633C061A10
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 11:48:51 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id j3so3511660ljg.8
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 11:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X288OaVurKdukegnulZAEmVQ4pDlcfHNVaAG2YEQ3y8=;
        b=LEQN64F2V4A+8YiuwoPA0zkTKbpVQtVTBzVgrPJcXw1qtpXhjXLZ8Tsq4h3ywPop9e
         fRlqsmBsRs/mLYg2/OuDloL8vg/PGWFGPuQaSgL1Dc00vZe+xih0p78ySiojlp87Rmdi
         LwcL4ZPsYaMOmEeXoYxLnOuKmQ7w/jzhZ1fvMtA65tbi+KhKJfONs1cDeQ3KNWwCSsK/
         /o+mkerCu6VulXGg5ugIPI8Nb+szcj73EFu9lCMYHU9MbK1zX8gWpzvRWmt3XLFL2zOI
         L7R90obbwIKOMXhNKKGYb9WAPariksocM/u/GHEtktElPzbbTPsFCdgDqjGzkMvcu3XV
         qNyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X288OaVurKdukegnulZAEmVQ4pDlcfHNVaAG2YEQ3y8=;
        b=Y8teN2V8uwqDk7PH9vW5LpxUG+Pq3O2CAfzknp4qQ/BRNM5MfZH/AoCF8inXJM2O8I
         5yb9I7pPLS6ZWl29tooBNTjZ4AYPpVUDeKKXAGXV/KSOYHSZ2N3n2kORo1JJuCjXKRxF
         yDcbyLd52yn73kkxNJ3dwlWYz4rXFe3/vRScXqhW+mVm569kCVs6cvGs2k7oieMsgGL0
         sUdeU/cXv0t7cp0lEPEURPuDOptVHEsbSQtmZ3r/fqL5yp1axrR/M5X+FKMLByew3jP6
         08/yRWgT/2FXewbql+EeLqQ06nt2CNIKXMdo9VHF4/mWxTlJhaaoRA4hHYF4FQinCKAV
         gU6w==
X-Gm-Message-State: AGi0PubaT2mIAynXYpyjn/Omo0IVGVZo/C6ro/CGQ9iRcq2mf6F+yGno
        FSm7BbICXnA7dwDqvJxEiNJ4f9Bu5BOvUpP5SL9XlJDc
X-Google-Smtp-Source: APiQypLLZoPNRlHUtRNsU2Uf1M/SP49hVCJR6Pr7fzEevP8WabBtlc94fXbOrs3iAv4ccFfKjuN+v3N0m0lQAR2Fb/c=
X-Received: by 2002:a2e:9012:: with SMTP id h18mr6002694ljg.28.1588790929673;
 Wed, 06 May 2020 11:48:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200505133602.25987-1-geert+renesas@glider.be> <CA+ASDXO8TJ09vNQaCyoMgfoFVouNQRw7Evx2Vfko1k_03q8GHA@mail.gmail.com>
In-Reply-To: <CA+ASDXO8TJ09vNQaCyoMgfoFVouNQRw7Evx2Vfko1k_03q8GHA@mail.gmail.com>
From:   Rajat Jain <rajatja@google.com>
Date:   Wed, 6 May 2020 11:48:12 -0700
Message-ID: <CACK8Z6HLhE+n=RUJLMsee5mMktzsaQqCbbkO95YmdD8SY3ntew@mail.gmail.com>
Subject: Re: [PATCH v4 resend 2] dt-bindings: net: btusb: DT fix s/interrupt-name/interrupt-names/
To:     Brian Norris <briannorris@chromium.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 10:38 AM Brian Norris <briannorris@chromium.org> wrote:
>
> On Tue, May 5, 2020 at 6:36 AM Geert Uytterhoeven
> <geert+renesas@glider.be> wrote:
> >
> > The standard DT property name is "interrupt-names".
> >
> > Fixes: fd913ef7ce619467 ("Bluetooth: btusb: Add out-of-band wakeup support")
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > Acked-by: Rob Herring <robh@kernel.org>
>
> If it matters:
>
> Reviewed-by: Brian Norris <briannorris@chromium.org>
Acked-by: Rajat Jain <rajatja@google.com>
>
> We're definitely using the plural ("interrupt-names") not the
> singular, so this was just a typo.
>
> Brian
