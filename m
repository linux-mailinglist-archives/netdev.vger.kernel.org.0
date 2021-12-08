Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D90E46D620
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235510AbhLHOyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235471AbhLHOyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 09:54:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA00C061746;
        Wed,  8 Dec 2021 06:51:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF5B1B8212D;
        Wed,  8 Dec 2021 14:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8A4C00446;
        Wed,  8 Dec 2021 14:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638975069;
        bh=yGjzonjEv/so3t2HT7veoFlNxdzM4AIgobZRia0+8Sc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SaI+ztZkpI1ebk9ZRj7Dsd8J038h00I02vrcqTsq/qZIWKsOnX7pr2a/VBb9k56OS
         6KAW3YB6jYlry/hpF/8lmLwbPmSyX+GUon9bYf2TZhLk3TAeHsIxX+FudMv/LxiTiM
         kVfenrfDavWWBro0la9B/lpWJA/ENAOm0rp17n4N0AzzSjO4ELIO49nBoSU5o97DT8
         +AKEt8ZEfNJF5R6b14Cm2F7HgWtaPIH9bnd/Isiru6mo5BX4kj5pJ4snR4A2T7Afoy
         3af4tttNQsvo+O7YRy/wpE4tWvUlCO9xsub5p6terbp4+UNRhRsuGxfujy2FCb6Fqy
         r5N2DSbUWSkSg==
Date:   Wed, 8 Dec 2021 06:51:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: Re: [PATCH net-next v6 4/4] net: ocelot: add FDMA support
Message-ID: <20211208065108.27a2a3eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211208085814.19e4ec71@fixe.home>
References: <20211207154839.1864114-1-clement.leger@bootlin.com>
        <20211207154839.1864114-5-clement.leger@bootlin.com>
        <20211207194514.32218911@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211208085814.19e4ec71@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 08:58:14 +0100 Cl=C3=A9ment L=C3=A9ger wrote:
> > drivers/net/ethernet/mscc/ocelot_fdma.h:156: warning: Function paramete=
r or member 'napi' not described in 'ocelot_fdma' =20
>=20
> And base does not exists anymore. I will also reorder the members in
> the doc to match the struct.

Hah, curious that the kdoc script did not catch that.
