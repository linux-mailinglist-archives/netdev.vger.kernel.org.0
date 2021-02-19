Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 896E031F550
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 08:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhBSHNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 02:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhBSHNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 02:13:21 -0500
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C41DC061574
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 23:12:41 -0800 (PST)
Received: by mail-vk1-xa35.google.com with SMTP id f145so1011491vka.8
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 23:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h8b8kj6NxJte4jtxipAMcQxsgEPMdcte/jGDhlUCEVQ=;
        b=KQfvP0r/Ul+rxpVEUWjrgHegfLb1FWjUL7qNfJeEFeGo4PqQUozggRkurFpThTofDI
         JEw5lKf+6ddJt8eJXL+7R4bBcDxiDxycmKXPuRRAM4GvL2yM1pVM9G+4i2BQZY3Ep7qi
         NEUiOwt7TfBXSjtdtRn2i+Irlnz/IH8TJz0AI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h8b8kj6NxJte4jtxipAMcQxsgEPMdcte/jGDhlUCEVQ=;
        b=qmwCcUmQoV+UxE+q825Q7dMh9yoSvOozpI2gFfyfSWTqKwp4VlCa6Od7hifaPAQPgi
         EbMB3PURPyFc1uuR9Cio3m0gvbkHs5/7mhwKIoPf3vyNBpBoflhYBPAHc3oXM/XPnJgx
         5P+m+7Ejt6Ob+55wMDL9uZxgErsGR4vPx5EtMUF80+b2EDMvyv+QRHgRzPa6eAA741fn
         TJqEvXsWPvCuaPZy9pXWCs5uDznKzL77FBy0qEcjnRPBaXaeBVp3jLa62QveMzEhlesD
         44bkwwNnsn9oozyMtjYAHlt3xhp6mCZ5Ln85YnMLKlW2J1GF2p++pDf3OhLNtGgYyC2U
         7YSA==
X-Gm-Message-State: AOAM533kY/sbmrfERn30KlGvQso6eOs0J9N9K7ZTe0/TdpmpXTzbN6xB
        E8KyeuigLvuWtTCoWG5mlZiIjbwfeX5OKNiMiipzXQ==
X-Google-Smtp-Source: ABdhPJy0h89Ff+Jn7fL82RJ+IOVsPOdU6jhz7YxZBssOkYXvV2Uil1FxzzQ9/kt6j5J58tyjIEteXbq6RdI2GQQolTY=
X-Received: by 2002:a1f:dc86:: with SMTP id t128mr202639vkg.7.1613718760054;
 Thu, 18 Feb 2021 23:12:40 -0800 (PST)
MIME-Version: 1.0
References: <20210218102038.2996-1-oneukum@suse.com> <20210218102038.2996-2-oneukum@suse.com>
 <CANEJEGu+fqkgu6whO_1BXFpnf5K6BG8Z7nUmHcJaYU9_tc7svg@mail.gmail.com> <YC7E/LvO8+k83lIL@lunn.ch>
In-Reply-To: <YC7E/LvO8+k83lIL@lunn.ch>
From:   Grant Grundler <grundler@chromium.org>
Date:   Fri, 19 Feb 2021 07:12:28 +0000
Message-ID: <CANEJEGtnPJgHT9mGY6_zQNe2Lye2N2XtzygZOyXJ2a9rE=eo9w@mail.gmail.com>
Subject: Re: [PATCHv3 1/3] usbnet: specify naming of usbnet_set/get_link_ksettings
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Grant Grundler <grundler@chromium.org>,
        Oliver Neukum <oneukum@suse.com>,
        netdev <netdev@vger.kernel.org>, davem@devemloft.org,
        Hayes Wang <hayeswang@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roland Dreier <roland@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 7:50 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Feb 18, 2021 at 07:31:41PM +0000, Grant Grundler wrote:
> > Oliver, Jakub,
> > Can I post v4 and deal with the issues below?
>
> You should probably wait for two weeks. We are far enough into the
> merge window that i doubt it will get picked up. So please wait,
> rebase, and then post.

ACK - thank you.

> > Nit: The v2/v3 lines should be included BELOW the '---' line since
> > they don't belong in the commit message.
>
> netdev actually prefers them above, so we see the history of how a
> patched changed during review.

Ok. Thanks for clarifying. :)

cheers,
grant

>
>         Andrew
