Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5796721A96D
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 22:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgGIU4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 16:56:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726831AbgGIU4Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 16:56:25 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDF0820672;
        Thu,  9 Jul 2020 20:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594328185;
        bh=kApLZrtTG3oeQgTJBfE0Lgl7AR+pJp6rr+1o9BjoRVU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R3QtAutrvb6hPBl1cF5gJqcd9/7OSkk1rCaFQ2EtOytuXxGjxqpuJMbxuB4K9mJ+T
         xTTBSOMVJCAFmeqBKPYaMcTFOFUaukFK+ctSQGMFReErOaukfB7b3FkQoP3DQkm7KL
         mrAi8nj4G3TiKsR6Y9vtZiP0fJPK4wtpHPpJ9Xgk=
Date:   Thu, 9 Jul 2020 13:56:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, saeedm@mellanox.com,
        michael.chan@broadcom.com, edwin.peer@broadcom.com,
        emil.s.tantilov@intel.com, alexander.h.duyck@linux.intel.com,
        jeffrey.t.kirsher@intel.com, mkubecek@suse.cz
Subject: Re: [PATCH net-next v2 10/10] mlx4: convert to new udp_tunnel_nic
 infra
Message-ID: <20200709135623.0da08982@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <4c264a76-1f42-4a89-b23e-e4629c700ba7@mellanox.com>
References: <20200709011814.4003186-1-kuba@kernel.org>
        <20200709011814.4003186-11-kuba@kernel.org>
        <bb47d592-4ef8-3cde-7aee-a31f2adcc5bb@mellanox.com>
        <4c264a76-1f42-4a89-b23e-e4629c700ba7@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Jul 2020 20:08:54 +0300 Tariq Toukan wrote:
> On 7/9/2020 4:58 PM, Tariq Toukan wrote:
> > On 7/9/2020 4:18 AM, Jakub Kicinski wrote: =20
> >> Convert to new infra, make use of the ability to sleep in the callback.
> >>
> >> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> >> ---
> >> =C2=A0 .../net/ethernet/mellanox/mlx4/en_netdev.c=C2=A0=C2=A0=C2=A0 | =
107 ++++--------------
> >> =C2=A0 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h=C2=A0 |=C2=A0=C2=
=A0 2 -
> >> =C2=A0 2 files changed, 25 insertions(+), 84 deletions(-)
> >> =20
> >=20
> > Hi Jakub,
> > Thanks for your patch.
> >=20
> > Our team started running relevant functional tests to verify the change=
=20
> > and look for regressions.
> > I'll update about the results once done.
> >  =20
> Tests passed.
> Acked-by: Tariq Toukan <tariqt@mellanox.com>

Thank you!
