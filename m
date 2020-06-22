Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E679203774
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbgFVNGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 09:06:53 -0400
Received: from mail.nic.cz ([217.31.204.67]:35112 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727995AbgFVNGs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 09:06:48 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 9CA94140973;
        Mon, 22 Jun 2020 15:06:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1592831204; bh=YvIFrI8NhlWPESoX21R+i+8ipF/XQJ3o3JVfkwr00t0=;
        h=Date:From:To;
        b=vVv11fJzBxDoK077k//Dd7bYZcTkSAqe0LVLatEO2Hh0/hOfVqTSlNzo0UaKhRSI3
         s9JaBhUCA1CRRcCO4rNCXGbckB61F8exFgz+qSfB9BormTrnzqTZKolMGx3l7SR8ly
         pw89I/3UGdYi2LLpMFE2XZmZUc6s0dCeKYFKX8vo=
Date:   Mon, 22 Jun 2020 15:06:44 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     =?UTF-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: secondary CPU port facing switch does not come up/online
Message-ID: <20200622150644.232e159b@nic.cz>
In-Reply-To: <50a02fb5-cb6c-5f37-150f-8ecfccdd473b@gmx.net>
References: <d47ad9bb-280b-1c9c-a245-0aebd689ccf5@gmx.net>
        <8f29251c-d572-f37f-3678-85b68889fd61@gmail.com>
        <eb0b71bb-4df3-ff3e-2424-a0d92b26741a@gmx.net>
        <20200622143155.2d57d7f7@nic.cz>
        <50a02fb5-cb6c-5f37-150f-8ecfccdd473b@gmx.net>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Jun 2020 12:58:00 +0000
=D1=BD=D2=89=E1=B6=AC=E1=B8=B3=E2=84=A0 <vtol@gmx.net> wrote:

> Thank you for the input and pointer to patches.
>=20
> The problem is that it would require TOS deployed on the device, which=20
> is not the case and the repo being twice removed from the kernel source=20
> -> OpenWrt -> TOS, patches are neither available in mainline or OpenWrt  =
=20
> whilst the Marvell SoC chipset is not unique to the CZ.NIC manufactured=20
> devices but leveraged by other vendors as well.
>=20
> It seems a bit strange to be nudged to the deployment of a particular=20
> repo, unless self-compiling kernel with those patch sets, instead of the=
=20
> same functionality being provided straight from mainline. Are those=20
> patch sets being introduced to mainline?

Hi,

I sent a RFC patch series last year adding multiCPU DSA to upstream
kernel, but the problem is a rather complicated. I plan to try again,
but do not know when.

As for OpenWRT - yes, we will try to add full support for Omnia into
upstream OpenWRT sometime soon. We were waiting for some other
patches to be accepted in upstream kernel.

Marek
