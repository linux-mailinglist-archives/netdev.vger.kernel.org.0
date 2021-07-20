Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869BF3CFB09
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238679AbhGTNFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238685AbhGTNED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 09:04:03 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69732C0613E7
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 06:44:25 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id t20so15362084ljd.2
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 06:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2Pwib/nSsZUkH8ptWIN/k9l+GA5UYugaaQKNP1mxQcQ=;
        b=tVTvtiF5WqGCTIlmiJjygQbPG2uoMcRTG7d0lU6e/DTwe4IeELn4dIR1Iciu8yPr5c
         Iv9Wp964jHPzYDImAGTO9VPqZQeb9ncrRyfBqmpPebwtrwD+xcOMk9jA/anVByNsXVfD
         MbeV7OsF1tIIS75zvd51bAqWrtOHw+U4QAw8r3j2gksjCw1CgkcuCnl7PlvnoPOtRkbw
         iLeQBcH+GMsDXSozT7Lm7ZwrJPR+Ksuj4kACk5sdQIpejS0cyHSdpoyv3sX9veYuyArc
         SXbw3HRd24Kc77TL/mI62RFjHvyUOKtw0l9jDMa/WmAdzTK/FKtMtAYk1rdTJ86UJz5O
         qf4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2Pwib/nSsZUkH8ptWIN/k9l+GA5UYugaaQKNP1mxQcQ=;
        b=WTX/4g9mPir1xGf2Ojv811Iz6WtDP+aRB5qQeTubgZiq0ccIKtvnG+QC0cZvvyZwYN
         ERHYc00tINODBkFWlBkIzBdyppogGjZ2BRIGWU0QMNt8MjYAJ7Z4Xk1IEq7/cMmzXqmr
         mSoMidlSez4gjsdEqRkifd0vSNODnrQ9VTldal1sjS7OyBcEQvmF67iT5PdkDJjybT5b
         D4ybrCHmH5wKbNcmazCk7I1BSyX5JGoosTo9jUSu75fnGqOk3x8Ctm2zvVt6bVBuB75Q
         PjK5DTf4Cn7DdQAe7mSQo7fBGFKOUWROcdvik7pIejZ5Rau0tIGp/7EhqwSax8pD6MpL
         Ea9Q==
X-Gm-Message-State: AOAM533OV/7lxR3H2gOGWiDODn2dohbpIJWMxIJ0nVAwQZs7RYXS/3yE
        zsCPaRFnRpDuqecHVxz1wtCSMfKbGvsFqopzNiw=
X-Google-Smtp-Source: ABdhPJzOY6HYAiDHTuQXJKHvpnJJ7MrTwqvoAi/nGXisrayLuX3BGtCYZtyXm22+ENBLAy4kzhz6wrp5UdObazKvt6s=
X-Received: by 2002:a2e:a785:: with SMTP id c5mr26864457ljf.490.1626788662321;
 Tue, 20 Jul 2021 06:44:22 -0700 (PDT)
MIME-Version: 1.0
References: <E1m5psb-0003qh-VP@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1m5psb-0003qh-VP@rmk-PC.armlinux.org.uk>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Tue, 20 Jul 2021 10:44:11 -0300
Message-ID: <CAOMZO5DZ0a-5UGoSuwW4QOB7dNANNRVMaZpp=8Js_+7OrdKZAQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: phy: at803x: simplify custom phy id matching
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Tue, Jul 20, 2021 at 10:40 AM Russell King
<rmk+kernel@armlinux.org.uk> wrote:
>
> The at803x driver contains a function, at803x_match_phy_id(), which
> tests whether the PHY ID matches the value passed, comparing phy_id
> with phydev->phy_id and testing all bits that in the driver's mask.
>
> This is the same test that is used to match the driver, with phy_id
> replaced with the driver specified ID, phydev->drv->phy_id.
>
> Hence, we already know the value of the bits being tested if we look
> at phydev->drv->phy_id directly, and we do not require a complicated
> test to check them. Test directly against phydev->drv->phy_id instead.
>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Yes, this makes it simpler:

Reviewed-by: Fabio Estevam <festevam@gmail.com>
