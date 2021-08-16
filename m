Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020283EE002
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 00:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbhHPWjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 18:39:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232318AbhHPWi7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 18:38:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43E7960ED5;
        Mon, 16 Aug 2021 22:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629153507;
        bh=TVf2uzR4jirvF9BbJhUjp7gJa/XAkGW3TYT+/BzzVS0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yskc/adWy1i5OzlXHg0sD9C/xYC7Kg/epWTqMRaxbo9UOiAF2c07lIU2sPzcndTXo
         b/bf41pA7hRWWP+gxDgRRiDq/msxeu2LgSK3oQ+xidL/UGSh0aXgMjhZ7wkLjnUPjV
         6Mwc6xYIcn6AHFYHFMsQVjtiGEWRoWcdl6iBeh4y69bMfqwMdZz463hXthbuWfLvQ8
         prFPBxgSKG9AC0MIbo6SAUv/NzuplaySt9e/+0P4sV3XBancw8fsecHTmcl0/kjdg9
         foUN3UYZdZs1ucrRBbgZ3xToNiaapOvLoeVsCMmjBltVI0x3GnVQ5va/TJNHeZ5Dz1
         7XDZbT4GD0FaQ==
Date:   Mon, 16 Aug 2021 15:38:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next 16/17] net/mlx5: Bridge, allow merged eswitch
 connectivity
Message-ID: <20210816153826.4b7e4330@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210816211847.526937-17-saeed@kernel.org>
References: <20210816211847.526937-1-saeed@kernel.org>
        <20210816211847.526937-17-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Aug 2021 14:18:46 -0700 Saeed Mahameed wrote:
> From: Vlad Buslov <vladbu@nvidia.com>
>=20
> Allow connectivity between representors of different eswitch instances th=
at
> are attached to same bridge when merged_eswitch capability is enabled. Add
> ports of peer eswitch to bridge instance and mark them with
> MLX5_ESW_BRIDGE_PORT_FLAG_PEER. Mark FDBs offloaded on peer ports with
> MLX5_ESW_BRIDGE_FLAG_PEER flag. Such FDBs can only be aged out on their
> local eswitch instance, which then sends SWITCHDEV_FDB_DEL_TO_BRIDGE even=
t.
> Listen to the event on mlx5 bridge implementation and delete peer FDBs in
> event handler.
>=20
> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>


drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c: In function =E2=80=
=98mlx5_esw_bridge_switchdev_fdb_event_work=E2=80=99:
drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:286:21: warning: va=
riable =E2=80=98priv=E2=80=99 set but not used [-Wunused-but-set-variable]
  286 |  struct mlx5e_priv *priv;
      |                     ^~~~
