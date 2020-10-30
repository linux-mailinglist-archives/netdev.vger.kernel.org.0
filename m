Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208CA29FBF0
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 04:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgJ3C6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 22:58:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726313AbgJ3C6O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 22:58:14 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55A72206ED;
        Fri, 30 Oct 2020 02:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604026693;
        bh=qSrz3ntCYl1O2+08WQfwfB+cWl7FpvYAri7/geQrQb0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i1euAwq2M8gezsQvtFhfL7QrS6ld9s0K7QsP6HR4jnK3lCPgcKTRsC/OVRq1MCFrH
         sEr9ZtkD01pfqzCFEJzBZsHKXO5sMO4r7/o+kuG1JfprZ94A+wDIk06scbV36yfyEo
         X0FF78PT//UlvuRX8H7VlQcWSGfhlibgmf/up0/I=
Date:   Thu, 29 Oct 2020 19:58:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?xYF1a2Fzeg==?= Stelmach <l.stelmach@samsung.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?QmFydMWCb21pZWogxbtvbG5pZXJraWV3?= =?UTF-8?B?aWN6?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v3 RESEND] net: mii: Report advertised link capabilities
 when autonegotiation is off
Message-ID: <20201029195812.70adcc9c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201027114317.8259-1-l.stelmach@samsung.com>
References: <CGME20201027114743eucas1p23c4a5e6762ce18509296cf23435e7268@eucas1p2.samsung.com>
        <20201027114317.8259-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 12:43:17 +0100 =C5=81ukasz Stelmach wrote:
> Unify the set of information returned by mii_ethtool_get_link_ksettings(),
> mii_ethtool_gset() and phy_ethtool_ksettings_get(). Make the mii_*()
> functions report advertised settings when autonegotiation if disabled.
>=20
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>

Applied, thanks!
