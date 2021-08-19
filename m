Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E413F1CC9
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 17:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238460AbhHSPau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 11:30:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58732 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232821AbhHSPar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 11:30:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=EcvOdzr1sgHe/sRPbHW+tONtkzJ+mXVH97Z7UeFGlNA=; b=SGqqy+6G/b9KRvuhJSVPl5gU8p
        IzBssXFnhmgbQSlhgIPiwXe1c48gSIRhj9SzpnUul0okBZFmJsQQKrEYCqXYYS2zI8lhhT3RlhEp+
        iy5VqH/UiasqqnHiM3rjanw26BqT8X856cv2hbaToxyrWY1J+uKaYzmIJz6aXoGYjVBo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mGjz5-000zTP-Pe; Thu, 19 Aug 2021 17:29:35 +0200
Date:   Thu, 19 Aug 2021 17:29:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        Biju Das <biju.das.jz@bp.renesas.com>, davem@davemloft.net,
        kuba@kernel.org, sergei.shtylyov@gmail.com,
        geert+renesas@glider.be, s.shtylyov@omprussia.ru,
        aford173@gmail.com, ashiduka@fujitsu.com,
        yoshihiro.shimoda.uh@renesas.com, yangyingliang@huawei.com,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris.Paterson2@renesas.com, biju.das@bp.renesas.com,
        prabhakar.mahadev-lad.rj@bp.renesas.com
Subject: Re: [PATCH net-next v3 0/9] Add Gigabit Ethernet driver support
Message-ID: <YR5435p8EE5ORQXT@lunn.ch>
References: <20210818190800.20191-1-biju.das.jz@bp.renesas.com>
 <162937140695.9830.1977811163674506658.git-patchwork-notify@kernel.org>
 <9b060154-aed4-1e11-68ac-6468e5f4f136@omp.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b060154-aed4-1e11-68ac-6468e5f4f136@omp.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Are we in such a haste? I was just going to review these patches
> today...

I guess the thinking is, fixup patches can always be applied after the
fact. But i agree, i really liked the 3 day wait time for patches to
be merged, it gave a reasonable amount of time for reviews, without
slowing down development work. The current 1 day or less does seem
counter productive, i expect there are less reviews happening as a
result, lower quality code, more bugs...

	Andrew
