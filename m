Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A824029B8
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 15:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344163AbhIGNcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 09:32:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232913AbhIGNby (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 09:31:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BCEF610FF;
        Tue,  7 Sep 2021 13:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631021448;
        bh=xTkyLNPnJPyXuLzvNlvt4hYG7W6Lobgi75bqBRDcJ1I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jNGIGlF2QqSfZBXq6Wtan3P9h/poVwlaKZyc+KLpCIFPzfe0VvsxV2n+650fY9GFu
         HNpsABAOoEEo1v5mGut/XvTAvQuBeMRTNmqAWK2fGKZ+E/f2oHwIUei0UOVKsMpRh5
         picSduHvgtM+/fcjNeXHwS4Potmok/QjN55ctSsCEarvVjtihLArMmq9fLHLP0clg6
         b7h5mivdNL4k3f83ljrG0a67vIcPY65fR3DpQaLDn7Dg5mp6Lz5NU0Mj8SKgVJcgax
         TAHfMa+/x2OZcTj3858vd5SG/lTlCNILFbRN1p1G0t/4jsjkHfSaFPJUs8FLzZsOLc
         LCSOPTugiKNlA==
Received: by mail-wr1-f45.google.com with SMTP id n5so14453190wro.12;
        Tue, 07 Sep 2021 06:30:48 -0700 (PDT)
X-Gm-Message-State: AOAM5314zQ27TfC9TnqBN2HHgs64c3uNME72glyE4ZMEeNTXAqH3vVrg
        +JsADrRsXpJJbVHcpNGJzfA296Tu8jr41+nSscY=
X-Google-Smtp-Source: ABdhPJz12Y0DD7ny5Nz2kpeAnIT0VRDPotP4tionUYPLoK+ZSfVA/BTMmHc1JnDopxaOmKmQdJgCaT1RHVA/j6rjLOc=
X-Received: by 2002:adf:f884:: with SMTP id u4mr18113941wrp.411.1631021446958;
 Tue, 07 Sep 2021 06:30:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210907131046.117800-1-arnd@kernel.org> <CAMuHMdX8CnSZaJ31RB0cefZjZiU3czvo-8RSSHeUGJDgwND0Cg@mail.gmail.com>
In-Reply-To: <CAMuHMdX8CnSZaJ31RB0cefZjZiU3czvo-8RSSHeUGJDgwND0Cg@mail.gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 7 Sep 2021 15:30:30 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0fUzfKAC-pRECxsKQp1_5KrHWNW_52+jgni_KgKhT8Tg@mail.gmail.com>
Message-ID: <CAK8P3a0fUzfKAC-pRECxsKQp1_5KrHWNW_52+jgni_KgKhT8Tg@mail.gmail.com>
Subject: Re: [PATCH] ne2000: fix unused function warning
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Armin Wolf <W_Armin@gmx.de>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 7, 2021 at 3:19 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> > Move the function into the #ifdef section that contains its
> > only caller.
>
> What about the second caller inside #ifdef MODULE?

Indeed, please disregard this patch, I'll send a v2.

        Arnd
