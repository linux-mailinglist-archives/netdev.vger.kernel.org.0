Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF2B236833B
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 17:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237561AbhDVPX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 11:23:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236545AbhDVPX0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 11:23:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24A306143B;
        Thu, 22 Apr 2021 15:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619104971;
        bh=S23DvyFbD937/eRF/yGO4YHwePp1UxxeFZXs819frVc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mr3fVlfvk0nnjFaRFExNjCMBOWYrHkqslozgig1GNjDf9RcZW4QWxxj1SHB1k8j96
         lfTJFpRjntxMl+Tlgbk3Xd586MBzTNodrXsqbGFGD44SFmjSU7StGSBQHjkmNBpnjb
         xenenO+8l4HllQZgGNfh0/+/kS+gU8PMpRmvlnDQqTD9zf/ubaNeIvJmVX9O9oqwKI
         WVdSx04CXu26Mis7ajCZEerdVz/VMEQIroyonS9pxVZyeyGfx2j4m7CNxlxCzmd3yz
         dlhKYv+LZPUBIlZskHVL3ilQam4QgVaRV9XmAAJWlfYFEPjooK/UCKeQeoPwT3d3Ps
         hQKzmTQc8/PcQ==
Received: by mail-wm1-f49.google.com with SMTP id n127so12522778wmb.5;
        Thu, 22 Apr 2021 08:22:51 -0700 (PDT)
X-Gm-Message-State: AOAM5301QPx1jZq7saA//nBmf5OdB9LrQ9XQvDd085mu6wie763GhW12
        y1S46uDkqWSQt25VBWHMYer0itRRcLHbpYWaQ0A=
X-Google-Smtp-Source: ABdhPJyoqMZkh2iVaSsCHD5prrldh89au5x5VTTB0Au5qmjidvSi0VHRgBUmYUlk+xcZBjT7RFhcntH4fy5u8AwRCjg=
X-Received: by 2002:a7b:c14a:: with SMTP id z10mr562999wmi.75.1619104969636;
 Thu, 22 Apr 2021 08:22:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210422133518.1835403-1-arnd@kernel.org> <20210422151451.hp6w2jlgdt53lq4j@skbuf>
In-Reply-To: <20210422151451.hp6w2jlgdt53lq4j@skbuf>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 22 Apr 2021 17:22:29 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2FvQer9ryjWyeXpHg=umcV2_aULN04mA4w+zeKNGbhcA@mail.gmail.com>
Message-ID: <CAK8P3a2FvQer9ryjWyeXpHg=umcV2_aULN04mA4w+zeKNGbhcA@mail.gmail.com>
Subject: Re: [PATCH] [net-next] net: enetc: fix link error again
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 5:15 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>> The problem is that the enetc Makefile is not actually used for
>> the ierb module if that is the only built-in driver in there
>> and everything else is a loadable module.
>
> I feel so bad that I'm incapable of troubleshooting even the most
> elementary Kconfig issues... I did not even once think of opening that
> Makefile.
>
> Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>

No worries, this is a particularly nasty way Kconfig can go wrong, I thing
most kernel developers would struggle with this.

       Arnd
