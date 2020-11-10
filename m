Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9A92ACA7F
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 02:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731151AbgKJBae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 20:30:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:60170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727311AbgKJBae (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 20:30:34 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F885206ED;
        Tue, 10 Nov 2020 01:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604971833;
        bh=BFzB2azWq8+a+a9QFA8mE7NZIuLSHKj8AUJOUkTwKZw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SR2pwuabPXBNayuJ7gdil4sWC8XI/FONxuOhfvuxYOUachspeZCgXehsHkPdxMTc1
         IX1wPB6qNlUAS/9vbTVL8hE/F2Ncn0IZNhPfhVxqFAvpszYRJylodpJFM+5mxFPke0
         +kS9ErpDlWfYZ5HJDy92KPmHaxJbIEBIp0Od0E8Q=
Date:   Mon, 9 Nov 2020 17:30:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan =?UTF-8?B?TmV1c2Now6RmZXI=?= <j.neuschaefer@gmx.net>
Cc:     linux-doc@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: networking: phy: s/2.5 times faster/2.5 times as
 fast/
Message-ID: <20201109173032.4584b001@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201107220822.1291215-1-j.neuschaefer@gmx.net>
References: <20201107220822.1291215-1-j.neuschaefer@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  7 Nov 2020 23:08:21 +0100 Jonathan Neusch=C3=A4fer wrote:
> 2.5 times faster would be 3.5 Gbps (4.375 Gbaud after 8b/10b encoding).
>=20
> Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>

Applied, thanks!
