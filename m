Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F832A1CA8
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 09:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgKAIWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 03:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgKAIWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 03:22:11 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E8EC0617A6
        for <netdev@vger.kernel.org>; Sun,  1 Nov 2020 01:22:09 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id f16so10300332ilr.0
        for <netdev@vger.kernel.org>; Sun, 01 Nov 2020 01:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TK++KPYDroVf9ubvezv0Y64RhMyfa8VbuIjgSzK+73I=;
        b=Y6p3sJnttBbEC2/VOqD5i162COFCnmjZIZLHRTZausIgYXmBLtEXrX3+9XqMOws2Ye
         +q/1lMTxn7mdx1E38hwK/tjPxsQqHelPngMsuMPSWexH+IVb/XDxkIMk/2DY+xwcB8Up
         GLZgad0ou2NdIsfaM5sTQR5a+Y+u8i8yPKgCl3R84GoYLNBwARw1bx++/BKu7AEkmtWw
         1Xy49vmErDLfE0R5REnRt1lTePviYpFa09vwtw6e3SWuDFZNnvVLkh7fXrVjmqh9yzn8
         thyNCtSiLecy1cqdoljQ2wip6T9pdQYtN3otLuepsqRrDqZCky8RanXao/6VJYjts5y9
         eQLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TK++KPYDroVf9ubvezv0Y64RhMyfa8VbuIjgSzK+73I=;
        b=bEkfpE+d9/D6JqAA3O5c0X5d8uZzJ6KcnDpatlm2jaUWCPFKMPk8JFr0YKgS2VA9H7
         Onub4bXolCphvoWxXRx60e/wooQuarSnq4IJv0mE95clJ8EB6vdcYqyAb2FHG45Zyb2z
         Fbs5r7H3LXKn/At6wl1Q2nWZUCeg52oiHHHqWwBDjVerDtb4O5uxbBC7fZlfEp5Afvq4
         7KPHmrE0N14y7QqxvAcBrliICJ2TA1XxPrOywHXQ+YE3LME1EeEGnhrrcJZWqsXweXzx
         Ii490xyzB5P/6xQ/ghR4iANso3kEoH4VG1nQxd2MW9SjzRY+hlOFYzynW0kwqKccv2ld
         Lm4w==
X-Gm-Message-State: AOAM532L+Mp5J/InHL2+LvswolzbNzecWQZMixh/ca8oJwR50vLa8vW0
        c6i8/SmL5LtLDQcs+nOBkdlmwAnGZdvHy3+NZCc=
X-Google-Smtp-Source: ABdhPJxnfipzEVWoBPmnVm0w+6EJ9sKv6yAVMe3iuPq/b4bTNBFTQBaW+8wmQyW0f6OxoJDZw93PLRj81trBZ5dxHnE=
X-Received: by 2002:a92:8e51:: with SMTP id k17mr6940368ilh.270.1604218929214;
 Sun, 01 Nov 2020 01:22:09 -0700 (PDT)
MIME-Version: 1.0
References: <1603948549-781-1-git-send-email-sundeep.lkml@gmail.com> <20201031150552.006e2c93@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201031150552.006e2c93@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Sun, 1 Nov 2020 13:51:57 +0530
Message-ID: <CALHRZurzg1VTvxCG+vgFBhAQF=VnHX35Aoc8FX7NDrM3GT+4xA@mail.gmail.com>
Subject: Re: [v2 net-next PATCH 00/10] Support for OcteonTx2 98xx silcion
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        netdev@vger.kernel.org, Subbaraya Sundeep <sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Jakub,

Sundeep

On Sun, Nov 1, 2020 at 3:35 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 29 Oct 2020 10:45:39 +0530 sundeep.lkml@gmail.com wrote:
> > From: Subbaraya Sundeep <sbhatta@marvell.com>
> >
> > OcteonTx2 series of silicons have multiple variants, the
> > 98xx variant has two network interface controllers (NIX blocks)
> > each of which supports upto 100Gbps. Similarly 98xx supports
> > two crypto blocks (CPT) to double the crypto performance.
> > The current RVU drivers support a single NIX and
> > CPT blocks, this patchset adds support for multiple
> > blocks of same type to be active at the same time.
> >
> > Also the number of serdes controllers (CGX) have increased
> > from three to five on 98xx. Each of the CGX block supports
> > upto 4 physical interfaces depending on the serdes mode ie
> > upto 20 physical interfaces. At a time each CGX block can
> > be mapped to a single NIX. The HW configuration to map CGX
> > and NIX blocks is done by firmware.
> >
> > NPC has two new interfaces added NIX1_RX and NIX1_TX
> > similar to NIX0 interfaces. Also MCAM entries is increased
> > from 4k to 16k. To support the 16k entries extended set
> > is added in hardware which are at completely different
> > register offsets. Fortunately new constant registers
> > can be read to figure out the extended set is present
> > or not.
>
> Applied, thanks!
