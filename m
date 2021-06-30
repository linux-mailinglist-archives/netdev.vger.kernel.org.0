Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C7E3B8A5D
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 00:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbhF3WRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 18:17:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232459AbhF3WRh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 18:17:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD1E661476;
        Wed, 30 Jun 2021 22:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625091307;
        bh=ntoGudrHrFJ2rcbL/OpgcgUyyAIhV6vEnQPBh24omdk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TZ3HQeHc1OqhrOaUhiO1XSqxON4+mz5Hs3Za/QiWpzj0iy96VQ8+o81luJAX2zPqA
         K23VYoTtWQXv6/SfwrnNo0FI43ej8bXrht99E0/LdnLuk2WGkyZeOSxdDPPefQcS1Z
         KHjVhJpv/ohrsrGlHGp5kiLkE2u5/j6y79Drs6rct+ODtGkehAL3PBygG8qvnXOm3g
         y4GOihZzEQEBaGD9VHLFcUURN4X9UBQwXI4PEyrZg6B2x+gJb0GSR8nD6P6FpFZpQ7
         8k5iATiv9CWfofF9MQa3uPrV9N8h6JhPt+i5Shb+ek+hplAiArMnZQwyrcJ7kOT1xE
         sNqgr7THgVtgw==
Date:   Thu, 1 Jul 2021 00:15:03 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net 5/6] net: dsa: mv88e6xxx: enable SerDes RX stats for
 Topaz
Message-ID: <20210701001503.01aa4d07@thinkpad>
In-Reply-To: <20210630174308.31831-6-kabel@kernel.org>
References: <20210630174308.31831-1-kabel@kernel.org>
        <20210630174308.31831-6-kabel@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Jun 2021 19:43:07 +0200
Marek Beh=C3=BAn <kabel@kernel.org> wrote:

> Commit 0df952873636a ("mv88e6xxx: Add serdes Rx statistics") added
> support for RX statistics on SerDes ports for Peridot.
>=20
> This same implementation is also valid for Topaz, but was not enabled
> at the time.
>=20
> Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>
> Fixes: 0df952873636a ("mv88e6xxx: Add serdes Rx statistics")

I accidentally sent wrong version of this fix which won't work. There
is another change needed which I applied to another branch while
testing and then generated the patches from the branch where this
change was missing.

I am going to send v2 in a moment.
