Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E15029DA20
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390238AbgJ1XOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:14:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389529AbgJ1XM6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 19:12:58 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1779206FB;
        Wed, 28 Oct 2020 23:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603926778;
        bh=YtGhFLTEWh3IhMSk1JUw+QTsMFqJxiOvCyFwJrfTBNE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T6qHpw87q6laRew2i8fV7gJ22HUBQEjIxpWzLEyNFuGUNHe9+gTTpjY+gsCekJsTF
         9zA1Ue7ZQtBntE7hXpnNoh2TNHusF90/LCdac5PNlKZ4eSRfMgdy7VWhz0NGRRPAF4
         KiGqOB3NLeX0z4EdtMNA9t296LxbxLypQs5XLi8c=
Date:   Wed, 28 Oct 2020 16:12:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, davem@davemloft.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, vivien.didelot@gmail.com
Subject: Re: [PATCH v5 3/3] net: dsa: mv88e6xxx: Add support for mv88e6393x
 family of Marvell
Message-ID: <20201028161256.399bd045@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e5fdcddeda21884a21162e441d1e8a04994f2825.1603837679.git.pavana.sharma@digi.com>
References: <cover.1603837678.git.pavana.sharma@digi.com>
        <e5fdcddeda21884a21162e441d1e8a04994f2825.1603837679.git.pavana.sharma@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 10:09:50 +1000 Pavana Sharma wrote:
> The Marvell 88E6393X device is a single-chip integration of a 11-port
> Ethernet switch with eight integrated Gigabit Ethernet (GbE) transceivers
> and three 10-Gigabit interfaces.
>=20
> This patch adds functionalities specific to mv88e6393x family (88E6393X,
> 88E6193X and 88E6191X)
>=20
> Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
> ---
> Changes in v2:
>   - Fix a warning (Reported-by: kernel test robot <lkp@intel.com>)
> Changes in v3:
>   - Fix 'unused function' warning
> Changes in v4, v5:
>   - Incorporated feedback from maintainers.

drivers/net/dsa/mv88e6xxx/port.c:29:5: warning: no previous prototype for =
=E2=80=98mv88e6xxx_port_wait_bit=E2=80=99 [-Wmissing-prototypes]
   29 | int mv88e6xxx_port_wait_bit(struct mv88e6xxx_chip *chip, int port, =
int reg,
      |     ^~~~~~~~~~~~~~~~~~~~~~~
drivers/net/dsa/mv88e6xxx/port.c:29:5: warning: symbol 'mv88e6xxx_port_wait=
_bit' was not declared. Should it be static?
drivers/net/dsa/mv88e6xxx/port.c:29:5: warning: no previous prototype for =
=E2=80=98mv88e6xxx_port_wait_bit=E2=80=99 [-Wmissing-prototypes]
   29 | int mv88e6xxx_port_wait_bit(struct mv88e6xxx_chip *chip, int port, =
int reg,
      |     ^~~~~~~~~~~~~~~~~~~~~~~
