Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E8C39487E
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 23:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbhE1V6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 17:58:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:36826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229589AbhE1V6Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 17:58:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 230D861132;
        Fri, 28 May 2021 21:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622239009;
        bh=o/Wva7vldZz4W2fkN2wQCOTzrtFzHJ83xKfc+kvGHhY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IuULp3BP0bOD2GrQP3M7FuMbPGzb6+yVWndzpkUarwC//k2ZYUkQrprIdj2Efnc6u
         W1ibk+Y1uQP46/CnLHEk2rNgF12YXjIj6fQHg7NTtGul3IXSfdE0xx8whR62YJv5d+
         Xv7kzCcVKy5JjldEEbs758Rb63tYC/2iVDD4SIAn4sxf0g0kXD3I+IJRk4Axv9AGZy
         PwUroSLzNP4wdPSQ8Rz2JQuF3gwh4Vi1IXEn+5P3/XkGKZ6+IMewBXO9itr1C+juG/
         cxmIOG+YWyQqcPAR0bA0j2AcALKQu2hMVOU8wv/5OBM1o7vy3V60uNvEkQis4AMHna
         0G+ofXtku5AzA==
Date:   Fri, 28 May 2021 14:56:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>
Subject: Re: [PATCH net-next 3/8] nfp: flower-ct: add ct zone table
Message-ID: <20210528145648.68eae3cb@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210528144246.11669-4-simon.horman@corigine.com>
References: <20210528144246.11669-1-simon.horman@corigine.com>
        <20210528144246.11669-4-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 May 2021 16:42:41 +0200 Simon Horman wrote:
> From: Louis Peens <louis.peens@corigine.com>
>=20
> Add initial zone table to nfp_flower_priv. This table will be used
> to store all the information required to offload conntrack.
>=20
> Signed-off-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>

> @@ -193,6 +193,7 @@ struct nfp_fl_internal_ports {
>   * @qos_stats_lock:	Lock on qos stats updates
>   * @pre_tun_rule_cnt:	Number of pre-tunnel rules offloaded
>   * @merge_table:	Hash table to store merged flows
> + * @ct_zone_table	Hash table used to store the different zones

Missing :

> +static void nfp_free_zone_table_entry(void *ptr, void *arg)
> +{
> +	struct nfp_fl_ct_zone_entry *zt =3D ptr;
> +}

drivers/net/ethernet/netronome/nfp/flower/metadata.c:588:31: warning: unuse=
d variable =E2=80=98zt=E2=80=99 [-Wunused-variable]
  588 |  struct nfp_fl_ct_zone_entry *zt =3D ptr;
      |                               ^~
