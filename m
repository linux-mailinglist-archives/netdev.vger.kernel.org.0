Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4192B46C012
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 16:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239267AbhLGP74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:59:56 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:46220 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239259AbhLGP74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 10:59:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7E274CE1B7E;
        Tue,  7 Dec 2021 15:56:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD3DC341C5;
        Tue,  7 Dec 2021 15:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638892582;
        bh=zx5Bp47NIplgZcX8mw3eO5PeUIZ35w6aj5Z66F7rxEo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fqwQfKSMV+BCeDf6sqyKqtAqrbOQeyxYmhbDy1BdCgftBtoACKnYfriILebBbpMyJ
         uMs+AUVuMfMD0qcGv2zNKskkVNIGmDcIwBAG52W0xeEOBVFjBYLZu268sniTzkJaZP
         MK1FYd0f6cra5IJqGFYlPULAVgahCOnuDcQB5d26F+AXvJxBgrmYrbxa10bLtfB7oO
         ESiTGBw1Ir2WqUkCbKiLbKEVkmHTuZsYQcPZ5+qCewHRq5coHBV3jddQZjzwaKNesu
         yrMaKjEhgg70Yn1oD4gyh3WrqOVP6OkcWhQ/9Zrap1NTNmeV7GOjvcLBOzIL1W+PZ2
         AhziOT9XcTZsQ==
Received: by mail-ed1-f53.google.com with SMTP id x15so59015123edv.1;
        Tue, 07 Dec 2021 07:56:22 -0800 (PST)
X-Gm-Message-State: AOAM531i6Y9QfXuAELCsRxbvajzYHGiEQIipU+Sk6qtoL8j4O1p38HfL
        DCgl7p71pAUecsKhfkJ457KJMQfRTgc5/nY7iQ==
X-Google-Smtp-Source: ABdhPJw3sCqVBRhAv5mF8iejFN8VmxMNg6xNXZ9928w9hDdmncG+yAoaCf8vnR1I+geWFuqcKh0hLsUzPO2F6JSGeO8=
X-Received: by 2002:aa7:dc07:: with SMTP id b7mr10086778edu.327.1638892581030;
 Tue, 07 Dec 2021 07:56:21 -0800 (PST)
MIME-Version: 1.0
References: <20211206174139.2296497-1-robh@kernel.org> <20211206125753.6a5e837c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211206125753.6a5e837c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 7 Dec 2021 09:56:09 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+ncb5MzObpPRtFEqLYaG2mKxXAPhe-5ben9DcSea--5Q@mail.gmail.com>
Message-ID: <CAL_Jsq+ncb5MzObpPRtFEqLYaG2mKxXAPhe-5ben9DcSea--5Q@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: mdio: Allow any child node name
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        devicetree@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 6, 2021 at 2:57 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon,  6 Dec 2021 11:41:39 -0600 Rob Herring wrote:
> > An MDIO bus can have devices other than ethernet PHYs on it, so it
> > should allow for any node name rather than just 'ethernet-phy'.
>
> Hi Rob, what's your preference for merging these?

I can take them.

Rob
