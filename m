Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534C72F7004
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 02:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731508AbhAOBcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 20:32:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:58824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbhAOBcp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 20:32:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9579E23A57;
        Fri, 15 Jan 2021 01:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610674325;
        bh=HIv5cotgYAuj//kfH2TKa6/HlDFIgXZCmmHzYRabRhA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SgIuHPCYdQzWNBMyTLvXGGYMsAdZR4ZgY7U38kQs4SCFntsUB0Hb6tP+mPlHx446s
         3HDAjOR9PgBSOu/PE5vFXdSWnpY7IKeq/D97doqaAxqzDbhn+ApZOS8eub75NGON8H
         NCxYrkabi9dyXq1qtG00cSsMteYouvLQlav67a5lTHvr1qZBKxutzAbJal3VQQwj0F
         sqB4HmNfubnMx0K8MbTog0toiYXrG85gzAXmBT0l0S7d/sPnKqbqDKCo9zRZ+mJf1A
         oZBTvDKxNhuP9ZMXGWbzh761IFNH6lpDWwKz7h6Wdao9r7/1U0m8pSLgfYqDNgHh57
         fFNqlAhbi2/Zg==
Date:   Thu, 14 Jan 2021 17:32:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v5 net-next 10/10] net: mscc: ocelot: configure
 watermarks using devlink-sb
Message-ID: <20210114173203.6da0f4f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210114141522.2478059-11-olteanv@gmail.com>
References: <20210114141522.2478059-1-olteanv@gmail.com>
        <20210114141522.2478059-11-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/ethernet/mscc/ocelot_net.c:141:33: warning: =E2=80=98ocelot_dev=
link_ops=E2=80=99 defined but not used [-Wunused-const-variable=3D]
  141 | static const struct devlink_ops ocelot_devlink_ops =3D {
      |                                 ^~~~~~~~~~~~~~~~~~
