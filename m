Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE1A2D7063
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 07:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436540AbgLKGxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 01:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395564AbgLKGwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 01:52:31 -0500
Received: from mail-vk1-xa41.google.com (mail-vk1-xa41.google.com [IPv6:2607:f8b0:4864:20::a41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CABC0613D3;
        Thu, 10 Dec 2020 22:51:50 -0800 (PST)
Received: by mail-vk1-xa41.google.com with SMTP id s13so341235vkb.11;
        Thu, 10 Dec 2020 22:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U+kfsQcREhjj6iUweM6iPAiozZ1/2mIevjtLhHtCEI8=;
        b=LcVvyaW8krm/Qx/WlnVFzJFkViCLf+MBIdWHyrLn3STwe5vC8M2b2nLO5coS9bEyWU
         KBfLI2fN/zqgXok+phpVxpGul/mb0KKBSgdzwaOlrektD6PGMAykG7aTTKn66SoC6smC
         ORhepN3WUO1fNoSD3unJXKlGnkzNQSFzH1g1OC+ZnxvvPkCyole4PMN/TypnFxsiEkkb
         kaD99glswq5M/VGDsFdmAivN060XpCKeBDxZqge9Ju71THKusL4IAd6MTPTbib2pBifo
         uBLSkrkSlTPS9Gc+v5hUULOULvZt6CIAnJEU5DCHVJ+DZ6jQtRf45EnYqzsfha4J+V5p
         3Y4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U+kfsQcREhjj6iUweM6iPAiozZ1/2mIevjtLhHtCEI8=;
        b=XA9N4ajG9lyB3Udg4Tl47FFNGd3afhSquJqXtgJ0LiwfX8fT7ZZNgdRufDe8MM+ga+
         76bGt91Avhcwc+tzIxAeLeuXrvwRzKcl5/U34BDW0VT4peoW+CUr0wpLYIeAQX7DClQM
         SCcAgIPT7T6OYXIuZ13FyT7Zp5C3CCF6JQUGARxwwTbQ3L5YjWkUEQnBRgb8qzo4U/p3
         18RNgE6OsbYLAmFxr9dVW8dyEdbK+Geuy+uqwOELTCyJ0G1yuKgvFitWoJ2bWGT92FiP
         uNv4aiilem8t3soLaPhEEmYIgT4sE5UKYwqObPe0I2QN38+pgGsYHRV0jHPPf0E1JGLe
         u5iw==
X-Gm-Message-State: AOAM530Lgez2xG0WmIjtTkdwjLL2hQVQSey/4vuVAG4q/tAZX0uNeFg7
        W16nzAMjhTDK9vUNhtcs56n4AbMx+1XPPsto8OU=
X-Google-Smtp-Source: ABdhPJyGLEO+5mA6kP2n0J+TYi31DJbJy/NQ9a8ts0oVRZdMFNFCtcKaFFmD+6E9VvLtBmqTtuGf+pyTvkEGNkhdXj4=
X-Received: by 2002:a1f:c545:: with SMTP id v66mr12563955vkf.15.1607669510097;
 Thu, 10 Dec 2020 22:51:50 -0800 (PST)
MIME-Version: 1.0
References: <1607542617-4005-1-git-send-email-jrdr.linux@gmail.com> <87ft4e9lmg.fsf@codeaurora.org>
In-Reply-To: <87ft4e9lmg.fsf@codeaurora.org>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Fri, 11 Dec 2020 12:21:38 +0530
Message-ID: <CAFqt6zbgFuQWzmjtYFVcMTLd5zo4g9B1zvEyOzXmWTw=2jPMJQ@mail.gmail.com>
Subject: Re: [PATCH] mt76: Fixed kernel test robot warning
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     nbd@nbd.name, lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 12:46 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Souptick Joarder <jrdr.linux@gmail.com> writes:
>
> > Kernel test robot throws below warning ->
> >
> >    drivers/net/wireless/mediatek/mt76/tx.c: In function
> > 'mt76_txq_schedule':
> >>> drivers/net/wireless/mediatek/mt76/tx.c:499:21: warning: variable 'q'
> >>> set but not used [-Wunused-but-set-variable]
> >      499 |  struct mt76_queue *q;
> >          |                     ^
> >
> > This patch will silence this warning.
> >
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
>
> I would like to take this directly to wireless-drivers-next, ok?

Ok.
>
> I'll also change the title to:
>
> mt76: remove unused variable q
>
> --
> https://patchwork.kernel.org/project/linux-wireless/list/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
