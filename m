Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6A23049E0
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732259AbhAZFUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:20:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:40742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730383AbhAYPrE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 10:47:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAD8C23437;
        Mon, 25 Jan 2021 15:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611588635;
        bh=EmPrUfxqlC3BbhLyRHPGam8TCOPGVDqO0gXPBHN3ns8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rytCda4c8c0qU/QtnVjznHxf1rU87pfOhsrjpVcp7AjlYWg8hbQvJU14GpT3/8h97
         LU2PeOVc7aZXDv+PhvHGPEKe2mU9a06seAe+nJ4kpX7s8uKnz717ghemZwrOd/p8ss
         imeXh69t87Ep5r//oibMx8yi2eJiEpTRA6umqf+JyeiLYMy60uAAiIz0EkwHX8s46e
         iFPDpr7XapYh0+ZlihK02qLCUYhFXF3SAncmwCL52yO7vtbK7vikm0M+E5tTFddvvF
         cI2uHEPjhYZ4u9iYzf/8YM9d9Z5TOaNWh9fzH1W2NR79pWu3vgTuIWM+DYH2ocLrFe
         dJbj2zKOvffAQ==
Received: by mail-ot1-f50.google.com with SMTP id i20so13096387otl.7;
        Mon, 25 Jan 2021 07:30:34 -0800 (PST)
X-Gm-Message-State: AOAM530EINj7N6+s5wA2aJTVVuXicb3N1j5L3/hYEgms1yK8YVEbHdLU
        5EvSmO6ZVhKMtNNTSclX07bF0cQRbfKYEJif1OM=
X-Google-Smtp-Source: ABdhPJwpmB8lUqQn2QUtuaRAK/JYN+VeYAQWycLjxEFBq7i7egHvMBWpPlt9xBfOvG3+0T6uFJ1kVYjVZaBSV+rOGBY=
X-Received: by 2002:a9d:741a:: with SMTP id n26mr822645otk.210.1611588634379;
 Mon, 25 Jan 2021 07:30:34 -0800 (PST)
MIME-Version: 1.0
References: <20210125113557.2388311-1-arnd@kernel.org> <YA7iVQtm8P2F1VAN@builder.lan>
In-Reply-To: <YA7iVQtm8P2F1VAN@builder.lan>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 25 Jan 2021 16:30:18 +0100
X-Gmail-Original-Message-ID: <CAK8P3a21TwzvESbnmGYpj9vrvpWM5uayZjpk9KA4Cg9wk78C4Q@mail.gmail.com>
Message-ID: <CAK8P3a21TwzvESbnmGYpj9vrvpWM5uayZjpk9KA4Cg9wk78C4Q@mail.gmail.com>
Subject: Re: [PATCH] [net-next] ipa: add remoteproc dependency
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 4:23 PM Bjorn Andersson
<bjorn.andersson@linaro.org> wrote:
>
> On Mon 25 Jan 05:35 CST 2021, Arnd Bergmann wrote:
>
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > Compile-testing without CONFIG_REMOTEPROC results in a build failure:
> >
> > >>> referenced by ipa_main.c
> > >>>               net/ipa/ipa_main.o:(ipa_probe) in archive drivers/built-in.a
> > ld.lld: error: undefined symbol: rproc_put
> > >>> referenced by ipa_main.c
> > >>>               net/ipa/ipa_main.o:(ipa_probe) in archive drivers/built-in.a
> > >>> referenced by ipa_main.c
> > >>>               net/ipa/ipa_main.o:(ipa_remove) in archive drivers/built-in.a
> >
> > Add a new dependency to avoid this.
> >
>
> Afaict this should be addressed by:
>
> 86fdf1fc60e9 ("net: ipa: remove a remoteproc dependency")
>
> which is present in linux-next.

Ok, good. I was testing with next-20210122, which was
still lacking that commit.

      Arnd
