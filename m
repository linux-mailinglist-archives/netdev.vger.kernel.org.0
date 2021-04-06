Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93953355FC7
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245241AbhDFXyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:54:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235884AbhDFXyC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 19:54:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9B7A61246;
        Tue,  6 Apr 2021 23:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617753234;
        bh=4GsI23uc2b38M72cbGw0/+4oV9boBJnPV5Q65K5kCwM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DfdzJmiZPYl/ZZjzqsfCkejUb06D33cIF+L7/keFqleTR090iOafWE2cSCaNvunXs
         ah+V27yWUFb0H1dVk/vfr4NYa+YU2yhHhVeGUvsC8MvtkRQAFY3hmwao/XFAleorjI
         8jURldwylEh/TmTfPqnf5v1ksE4rE8n5fojElyNyI4Ta9b0hcnS5VQHxMMtHJxj+8Z
         lVxJMXPuqcR3oB44itHEj5iTD6GUz7JbU54BPISyV1TrX8v7nXtBMHn+emHf2poRfs
         nnD5dEu28u1saCJ78mimuoPq7kePY6Jf+LBGAaLks3ie3AW3zeuXDfmIaodzKTophg
         9iw1/ymCc1/qg==
Date:   Wed, 7 Apr 2021 01:53:49 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org
Subject: Re: [PATCH net-next v3 07/18] net: phy: marvell10g: support all
 rate matching modes
Message-ID: <20210407015349.5acc27f9@thinkpad>
In-Reply-To: <YGzvzfLYMWLHA6b6@lunn.ch>
References: <20210406221107.1004-1-kabel@kernel.org>
        <20210406221107.1004-8-kabel@kernel.org>
        <YGzvzfLYMWLHA6b6@lunn.ch>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Apr 2021 01:33:33 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Wed, Apr 07, 2021 at 12:10:56AM +0200, Marek Beh=C3=BAn wrote:
> > Add support for all rate matching modes for 88X3310 (currently only
> > 10gbase-r is supported, but xaui and rxaui can also be used).
> >=20
> > Add support for rate matching for 88E2110 (on 88E2110 the MACTYPE
> > register is at a different place). =20
>=20
> What is not clear to me is how rate matching mode gets enabled. What
> sets the mactype to one of these modes?
>=20
> It probably just needs an explanation here in the commit message.
>=20
>    Andrew

Currently MACTYPE is set via strapping pins. I will add this to the
commit message for v4.

Both Russell King and myself are working on patches to support
selecting correct/better MACTYPE from information about which interface
modes are supported by the MAC and by the board. But first I want to
get this merged.

Marek
