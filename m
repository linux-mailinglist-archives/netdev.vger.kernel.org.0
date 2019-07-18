Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8BE56D57C
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 21:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391413AbfGRTxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 15:53:04 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:43058 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbfGRTxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 15:53:04 -0400
Received: by mail-oi1-f193.google.com with SMTP id w79so22503475oif.10;
        Thu, 18 Jul 2019 12:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/BAco0qTgyfJ8ndZzbhvqz94T+T1pPPU3Fqjw/cFLps=;
        b=nW6kgwO+5AOfTm3FSkl7N9sJcwHTCEUPlrvRBDc5G3FKn1LbLB2gxabP98tb6/y72o
         dtc0GCjblMnHKYEAf8ATrDoknCDAQ9NTFUnMXCNe5aqGRp/US3zz2Bnz9pPUYdSCPXig
         LrZ01aFRxs50n5MBeBhgBWPGMWGabpgUHzczWiVP5FtC4Ryx8Fq+z7y9KYdeFM7e7zH+
         tnLDTGFsYh1DJmccfxnLSdb6awxms4+S77W0IbzAZObFxNP9z8HtJMuCQwL3V5B//XYm
         jWmyKBUof/ICQZF4UTWwVEAp/UYVsvoVUzicuq3nP1Ghl4NjQCIfR7blvqnoaubm1fcI
         MjNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/BAco0qTgyfJ8ndZzbhvqz94T+T1pPPU3Fqjw/cFLps=;
        b=oVGj7S5ThggeeQruWBNUdewcTu9a1MIXc3uQ/96THhZiAlsfVZJ1d7S80WIQs5k0tT
         2yAWEVEnmR/GRFkZ3NloE9b+3Efn8ga6xB46wdvKeQYzyHdg463fb1TTW74bD4Bbz60k
         21ixuBx+hzzAZUefuI01j5mQYhk7g8G/Cl8trFAxeJKIRpRIilbItAZ6Ubq5a22V1Vt8
         1kLdaTa6yKagOPQLEjHF24bdbsJ1oXWbQj0CqtcHpvPhDdCL+7BZDUeBbMmGUNKvi2P+
         Zj+TxnCih4neIJR52TJ/a7l0QN3dK9Nid+IGgEvqYze9FgjHo+ukefYnPkx0KSppeJmx
         pciQ==
X-Gm-Message-State: APjAAAU0TdGrC9wFo9i8LmZzCMYjfyxX8TXIn/Z057SlShzTh6njzdxh
        twMtThvrAZTDbmFm0+fgYw6uwrYW0GLYfLOGTRs=
X-Google-Smtp-Source: APXvYqwTBPzyPhPjB0VaBnbsiYOrGI3rkLFZrwgDaKK3LTDTHNYYlEPvOYwHkit/SyzUnkQw3nflcqZiU86SaVW9do4=
X-Received: by 2002:aca:75c2:: with SMTP id q185mr25667268oic.103.1563479583204;
 Thu, 18 Jul 2019 12:53:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190718143428.2392-1-TheSven73@gmail.com> <1563468471.2676.36.camel@pengutronix.de>
 <CAOMZO5A_BuWMr1n_fFv4veyaXdcfjxO+9nFAgGfCrmAhNmzV5g@mail.gmail.com>
 <CAGngYiULAjXwwxmUyHxEXhv1WzSeE_wE3idOLSnD5eEaZg3xDw@mail.gmail.com> <20190718194131.GK25635@lunn.ch>
In-Reply-To: <20190718194131.GK25635@lunn.ch>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Thu, 18 Jul 2019 15:52:52 -0400
Message-ID: <CAGngYiWESbg6uq4pdtb5--YSzatwAwXiGnRjiAfAQj8nRYPMqw@mail.gmail.com>
Subject: Re: [PATCH] net: fec: generate warning when using deprecated phy reset
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Fabio Estevam <festevam@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Thu, Jul 18, 2019 at 3:41 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> Hi Sven
>
> One option would be to submit a patch or a patchset changing all
> existing device tree files to make use of the core method. Anybody
> cut/pasting will then automatically use the correct core way of doing
> it.
>
> There is also a move towards using YAML to verify the correctness of
> DT files. It should be possible to mark the old property as
> deprecated, so there will be a build time warning, not a boot time
> warning.
>

Thanks for the helpful suggestions, that makes sense.

What I keep forgetting in my little arm-imx6 world, is that devicetrees
aren't in-kernel apis, but that they have out-of-kernel
dependencies. It makes more sense to to see them as userspace
apis, albeit directed at firmware/bootloaders, right?

So if bootloaders were as varied/uncontrollable as userspace,
then deprecated properties would have to be supported forever...
