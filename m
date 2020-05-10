Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B7B1CCD48
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 21:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbgEJTfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 15:35:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728756AbgEJTfL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 15:35:11 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A4572080C;
        Sun, 10 May 2020 19:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589139311;
        bh=5MXw1JA2FxXczrLd+WIBMxcTMM7ZMd30vMPXe3JfhdY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ycn7KJYq2/JRqFA6IL8b7NKlTGK2ZtYz6EZTL1fd76lXrp6wmheR8hXu1wJ8RSDsC
         KoIUNiHtNLYJshH/N5UYs8qNVCCzhNBkYnm8VScLBiZusylRjxU3txzVD1BU1Vcc1i
         3R+Ymy8cKQ6kNUH/Tnj+6arDofCqCYRQHjF6J+xE=
Date:   Sun, 10 May 2020 12:35:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v4 00/10] Ethernet Cable test support
Message-ID: <20200510123509.07dbf9e2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200510191240.413699-1-andrew@lunn.ch>
References: <20200510191240.413699-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 May 2020 21:12:29 +0200 Andrew Lunn wrote:
> any copper Ethernet PHY have support for performing diagnostics of
> the cable. Are the cable shorted, broken, not plugged into anything at
> the other end? And they can report roughly how far along the cable any
> fault is.
>=20
> Add infrastructure in ethtool and phylib support for triggering a
> cable test and reporting the results. The Marvell 1G PHY driver is
> then extended to make use of this infrastructure.
>=20
> For testing, a modified ethtool(1) can be found here:
> https://github.com/lunn/ethtool.git feature/cable-test-v4. This also
> contains extra code for TDR dump, which will be added to the kernel in
> a later patch series.
>=20
> Thanks to Chris Healy for extensive testing.

=F0=9F=91=8D=F0=9F=91=8D=20

Applied, I'll push out once builds are done (probably an hour).

Thank you!
