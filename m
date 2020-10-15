Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF02728F584
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 17:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389525AbgJOPGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 11:06:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388764AbgJOPGc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 11:06:32 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE7892225B;
        Thu, 15 Oct 2020 15:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602774392;
        bh=Wd9FL+i36edA929vY4EJpf6PgPZHGygvLJ8iTh3RguI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EcNFjvbtktX8NxzJXYqp1nJnGo68fic6NhwgVvaU2//+G1GwIOQ9ZVCXQ8bUL5MP+
         lZaGPRH6Viq09ACCWMOP/5HXajlAz69ENSRwfYxmWZQ2JiZQQsi3599pbjaWoH1tWI
         atYIUud4aJyJluZmUMBccQzA9nzRPE2QFeSw5Xqg=
Date:   Thu, 15 Oct 2020 08:06:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH v2] Add support for mv88e6393x family of Marvell.
Message-ID: <20201015080630.4c4e85aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201015022606.20706-1-pavana.sharma@digi.com>
References: <[PATCH v2] Add support for mv88e6393x family of Marvell>
        <20201015022606.20706-1-pavana.sharma@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Oct 2020 12:26:06 +1000 Pavana Sharma wrote:
> The Marvell 88E6393X device is a single-chip integration of a 11-port
> Ethernet switch with eight integrated Gigabit Ethernet (GbE) transceivers
> and three 10-Gigabit interfaces.
>=20
> This patch adds functionalities specific to mv88e6393x family (88E6393X,
> 88E6193X and 88E6191X)
>=20
> Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>

Not sure what you fixed, but there is still a warning here:

drivers/net/dsa/mv88e6xxx/global2.c:67:12: warning: =E2=80=98mv88e6393x_g2_=
maclink_int_mask=E2=80=99 defined but not used [-Wunused-function]
   67 | static int mv88e6393x_g2_maclink_int_mask(struct mv88e6xxx_chip *ch=
ip, u16 mask)
      |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
