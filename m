Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0E5463A4E
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239087AbhK3Poq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:44:46 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:49568 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239060AbhK3Pop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:44:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 271E8CE1A43
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 15:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0ACC53FC1;
        Tue, 30 Nov 2021 15:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638286883;
        bh=t1+tIvvo95tSXV9G9xObB7wjhqndNvBe0jYppMJbVco=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WD6ssXXnOAawzHECjFOhHYrl41gfzKZ8L2CMzcUjcbNwT7ic2L9+AbyCwKQgoy0Kh
         an6dwBpZ3OSWCbrNSHjUr34gWhiUxX9MkRfliInVGZ+7Xqrau4WXsNG/NARbIoiekd
         orx+O8Z6M28aFHHKHrnfWDhXqiH5DfNtFYZLaFOzOXdVWeTX3rrSSa5vaNCmjzOnWk
         ADgnzSAJNj25ACxO3hdY3+rq3FIQJV3aCQsX7JsDjKhU/bexJMBk59IUYKrUoSO9xE
         y6butF15BhdyIgh1CQqi8cyUAiOiceZixzx2gsz0KskWhsz+OQUOjKrRj+wSwjGAef
         vB73Om+VdDUng==
Date:   Tue, 30 Nov 2021 16:41:18 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 1/5] net: dsa: consolidate phylink creation
Message-ID: <20211130164118.7f2f6edd@thinkpad>
In-Reply-To: <E1ms2tP-00ECJ3-Uf@rmk-PC.armlinux.org.uk>
References: <YaYiiU9nvmVugqnJ@shell.armlinux.org.uk>
        <E1ms2tP-00ECJ3-Uf@rmk-PC.armlinux.org.uk>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 13:09:55 +0000
"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk> wrote:

> The code in port.c and slave.c creating the phylink instance is very
> similar - let's consolidate this into a single function.
>=20
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---

Reviewed-by: Marek Beh=C3=BAn <kabel@kernel.org>
