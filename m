Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D9227F6A6
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 02:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731973AbgJAAZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 20:25:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731951AbgJAAZj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 20:25:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C52AC206B2;
        Thu,  1 Oct 2020 00:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601511939;
        bh=oGtztnI8buqE0M1BMLPPAYjH5zWL7v7N0DohNSpt5pk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Dv6OtNS7haAZLy9YaeDaXzw1lvuTJCNAcUA7K9qGncWVc3tMew+5WRPxRJyPR+fYI
         6WnWoWpBBvaVUpfp4iVhJBUfFFgGAkSZFBHS89z8CH8iDpHd7p357ljW0ntQKQycnP
         11rfv7qwdPWrk0l/KeDFmGXhKBEf9DicarZUwBzQ=
Date:   Wed, 30 Sep 2020 17:25:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@nvidia.com,
        idosch@nvidia.com
Subject: Re: [PATCH net-next v2 4/4] dpaa2-eth: add support for devlink
 parser error drop traps
Message-ID: <20200930172537.0e41772a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200930191645.9520-5-ioana.ciornei@nxp.com>
References: <20200930191645.9520-1-ioana.ciornei@nxp.com>
        <20200930191645.9520-5-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Sep 2020 22:16:45 +0300 Ioana Ciornei wrote:
> Add support for the new group of devlink traps - PARSER_ERROR_DROPS.
> This consists of registering the array of parser error drops supported,
> controlling their action through the .trap_group_action_set() callback
> and reporting an erroneous skb received on the error queue
> appropriately.
> DPAA2 devices do not support controlling the action of independent
> parser error traps, thus the .trap_action_set() callback just returns an
> EOPNOTSUPP while .trap_group_action_set() actually notifies the hardware
> what it should do with a frame marked as having a header error.
>=20
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

On a 32bit build:

drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c: In function =E2=80=98setu=
p_rx_err_flow=E2=80=99:
drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:3422:19: warning: cast fro=
m pointer to integer of different size [-Wpointer-to-int-cast]
 3422 |  q.user_context =3D (u64)fq;
      |                   ^
drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:3422:31: warning: non size=
-preserving pointer to integer cast
