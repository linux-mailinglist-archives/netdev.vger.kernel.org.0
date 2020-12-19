Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 361D02DF0EE
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 19:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbgLSSDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 13:03:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:58584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726979AbgLSSDS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Dec 2020 13:03:18 -0500
Date:   Sat, 19 Dec 2020 10:02:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608400958;
        bh=vulkPc+nc9Z0STr+6nVLelSgT/jX6gZ8O+Uare0Tt88=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Rn9qIB88TNXkLpmmqd7Fq3HZT56lZ1D0JByxlru+4h782to0F5VtQdtr09w8Jgeu5
         DdIr3wOvhDVnZ/hysffRpTZQizEJcekvjLFHVoXYEhWisOvI2sswWMec1OOhrUfySX
         ABfzTfh14nG30B+lTcqjKwKxo8Y+hYCdKysg0swS4ZS2xRK7uVUk1JQ3SjLixlw+LL
         kzuQ3jOo7URFPTmG2ejaaGYVB1gEEyPrQSkwOwoqvMKaTUtd4SMntDxWU2W+fW8QBz
         FKh+aj5oUbjUSLSDhNJvzdnLavxJ11sPCt2xmyHKUXTub15tuqkQsQ3O0PQPZfleoG
         seOAY66eWsr9Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcin Wojtas <mw@semihalf.com>,
        Stefan Chulski <stefanc@marvell.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, nadavh@marvell.com,
        Yan Markman <ymarkman@marvell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH net v3] net: mvpp2: disable force link UP during port
 init procedure
Message-ID: <20201219100237.0d3baa1e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAPv3WKcL_mj=Zk8MrnQ_=m1nv5EzbpurYsLadSXMNZ3BKjzQVw@mail.gmail.com>
References: <1608216735-14501-1-git-send-email-stefanc@marvell.com>
        <CAPv3WKcL_mj=Zk8MrnQ_=m1nv5EzbpurYsLadSXMNZ3BKjzQVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Dec 2020 04:36:18 +0100 Marcin Wojtas wrote:
> czw., 17 gru 2020 o 15:54 <stefanc@marvell.com> napisa=C5=82(a):
> >
> > From: Stefan Chulski <stefanc@marvell.com>
> >
> > Force link UP can be enabled by bootloader during tftpboot
> > and breaks NFS support.
> > Force link UP disabled during port init procedure.
> >
> > Fixes: f84bf386f395 ("net: mvpp2: initialize the GoP")
> > Signed-off-by: Stefan Chulski <stefanc@marvell.com>
>=20
> I confirm the patch fixes issue - tested on CN913x-DB and RGMII port.
> Other boards there I see no regression.
>=20
> Acked-by: Marcin Wojtas <mw@semihalf.com>

Applied, thanks!
