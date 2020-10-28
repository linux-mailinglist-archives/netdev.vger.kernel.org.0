Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B51829D5A8
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730105AbgJ1WH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:07:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730086AbgJ1WHX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:07:23 -0400
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CD2D247D1;
        Wed, 28 Oct 2020 15:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603899267;
        bh=VYcPjR+ebfllZ4YlcOSFVT4hBDi5/UY7tzG73DNnUwc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=wCpHhyYNCehwFLbKv0mk1kUex4LGlg9coqIqwumxfBfFFMO2lUh/9NveJUNqY8zo6
         rj+vRo//mBV0oaUdETBet7dHTWXzuDezzSwBPJA5OUZfyqvbp2jKoo8WEavXMhip9S
         2e5AVxPCf2dY6hTBdJvNQN5eY2CoZ02lS0pbyljw=
Received: by mail-qk1-f175.google.com with SMTP id b18so4887982qkc.9;
        Wed, 28 Oct 2020 08:34:27 -0700 (PDT)
X-Gm-Message-State: AOAM533MZDUs+scTezBPOKRIFz5kYIy86nXCWsebZagFws6lPFdLMzba
        Or+lZoz+ImL8i//pY+64WH7rFCPmoh25lpRD6RA=
X-Google-Smtp-Source: ABdhPJx1QoTcGYVWjOyWd5KjX41Uik43iizjmXnLwvBFnEoat7q2LLXXZFCO56jsFC74qHv4bz/Wqv+y3FA4TSjzyZ4=
X-Received: by 2002:a05:620a:b13:: with SMTP id t19mr7398431qkg.3.1603899266150;
 Wed, 28 Oct 2020 08:34:26 -0700 (PDT)
MIME-Version: 1.0
References: <20201026165113.3723159-1-arnd@kernel.org> <20201027181613.03f3f67a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201027181613.03f3f67a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 28 Oct 2020 16:34:09 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1oeb05dnt196OQCJ7FxeJze9CNV=14Qv0qb8LjsX0akw@mail.gmail.com>
Message-ID: <CAK8P3a1oeb05dnt196OQCJ7FxeJze9CNV=14Qv0qb8LjsX0akw@mail.gmail.com>
Subject: Re: [PATCH] mdio: use inline functions for to_mdio_device() etc
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 2:16 AM Jakub Kicinski <kuba@kernel.org> wrote:
> On Mon, 26 Oct 2020 17:51:09 +0100 Arnd Bergmann wrote:
 >
> > Fixes: a9049e0c513c ("mdio: Add support for mdio drivers.")
>
> I feel like this is slightly onerous, please drop the tag.
>
> Harmless W=2 warnings hardly call for getting this into the cogs of
> the stable machinery.
>
...
> >       unsigned int reset_deassert_delay;
> >  };
> > -#define to_mdio_device(d) container_of(d, struct mdio_device, dev)
>
> empty line

I fixed all of those now, plan to resend next week. Thanks for
taking a look!

      Arnd
