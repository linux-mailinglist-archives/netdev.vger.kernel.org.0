Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B84B399B0
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 01:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbfFGXWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 19:22:04 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39846 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727933AbfFGXWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 19:22:04 -0400
Received: by mail-lf1-f68.google.com with SMTP id p24so2793573lfo.6
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 16:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7occGw+Nj/axW1YYQGvEntV7oJSJx3lTDhBE0vbJYGw=;
        b=xeQ4Wx/7qTZN3PRIKsSACk1u1dvX63yFoIaUTU/qTkyWNZA+P/hk1Zb4BsX0UFdNe/
         XlbdWB4Pfr3LPob0TAGjogYKQP+fxhPmV/JulLwCvSz3cpKrblGitc7qf6trWNLYoy7P
         EwZ8yjRKMCZgQ5PKJ5me/mkeZ+8F3tajO0YPTox+5vjlTNXPiIGUHfw6PMru1c68V4TY
         nsTtcGJZNzZ5y3b+/N0U2rU1yuplZoHaq6AGRfV2GZPLVNCiYLJCVXzIvtvvMUEPEJKg
         d+g5mc6f7LWghlw6Re4w+hF1o2oeRMUHoTpOHCfS77i67Xd1a+4hpvA1a8w8/dtMs+e1
         N6mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7occGw+Nj/axW1YYQGvEntV7oJSJx3lTDhBE0vbJYGw=;
        b=uLYxHm/30vakcYPtwzbWphjPk+Jk++LyrMPUQDi9YvitAqWDAPKuL7a20oc1G7ZS08
         UN1lbVeloN530gRod0rTSjM8TVoyCMJfTe5lqL9PqNABtOW1vpNu1CCtlpAmgxM5D0Me
         Lp9P4zgXFwBfe4XS/mp1IWwLCzVfpFGjKQktD/Znu4A0sFMru6c5TLEjhogTNgFMIqkw
         zrD18XgKrQ+WjsaaafbWZda1opfMtcz0EfyFtSNGRYKP6A08nmbAbhGsKZ9+qG24AqIC
         og2ob+9rU6WYRcICx/LoMjp5nDUcSu9b8tN6K3Y/3Xwjf8h9lKF3SkahkAnjDoKSbp4W
         UAsA==
X-Gm-Message-State: APjAAAV0PwshHddjrcURzYX4D1V4ctuDBvorrAqFzayG4aoqCss3wumV
        Wge9/oCjjU9vDS5fnaCYCse0aZrZUEPnxuWghC7Ohg==
X-Google-Smtp-Source: APXvYqz6eKvcASmHyB9Tj+msiYP2wBgsFz4hXUWe3yVOvMgQKvmRdYWGsMKNkumkxAPyZ4keeIugqHdeZ+MzOFmfUVs=
X-Received: by 2002:ac2:5382:: with SMTP id g2mr27506420lfh.92.1559949721966;
 Fri, 07 Jun 2019 16:22:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190606094707.23664-1-anders.roxell@linaro.org> <20190606125024.GE20899@lunn.ch>
In-Reply-To: <20190606125024.GE20899@lunn.ch>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sat, 8 Jun 2019 01:21:54 +0200
Message-ID: <CACRpkdZdQPuLKtpsgA4zUeFhubeTwajDUAzvsQ9RY0Q3WFKxcQ@mail.gmail.com>
Subject: Re: [PATCH 1/8] drivers: net: dsa: realtek: fix warning same module names
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Anders Roxell <anders.roxell@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 6, 2019 at 2:50 PM Andrew Lunn <andrew@lunn.ch> wrote:
> On Thu, Jun 06, 2019 at 11:47:07AM +0200, Anders Roxell wrote:
> > When building with CONFIG_NET_DSA_REALTEK_SMI and CONFIG_REALTEK_PHY
> > enabled as loadable modules, we see the following warning:
> >
> > warning: same module names found:
> >   drivers/net/phy/realtek.ko
> >   drivers/net/dsa/realtek.ko
> >
> > Rework so the names matches the config fragment.
> >
> > Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
>
> [Removes most of the Cc:]
>
> Hi Anders
>
> Please base this patch on net-next and submit it to David
> Miller/netdev.
>
> It would also be nice to state the new name of the module in the
> commit message.
>
> Linus, would you prefer this module is called rtl8366?

Yes that should be unique enough!

Anders: thanks for looking into this. I just always compiled
all modules as y.

Yours,
Linus Walleij
