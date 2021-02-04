Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9382630E89A
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234158AbhBDAfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:35:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:35962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234102AbhBDAfr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 19:35:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DADE764F5F;
        Thu,  4 Feb 2021 00:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612398907;
        bh=8+QLYOxMOAblaY/j4tkADQtzjWFhpCgjixr2ZiiRo8k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g6eXqKDLNk6XZmr9qVtU16c6bHNtk5rK2ZSjUBHJZo+pJ5NRhCrvi3gkVOUK3qkDa
         bl7SgDxNZIbHP8pVa1Kw1FzCH1e72o78gLMvSyiJ6kUEsEPXPCMjDAzmbfoPbe75XJ
         IujqvS9hPgbht3rFeOegrFuaekWIN7a9QKjFkkUlXB+mhmKMnsEf/LaKPvvluzdGW4
         a6JO/XfmUyIwT8q4bU/PkZKG+vmLWKHBlariPQqDZmV+wMI7a0ikgU8H9XwuK09/TC
         +GTu6dNsIU7bA/O/NaNuV/XceZX4IaS054ZGGlqE5g3IueAA6u6WRFaWdeGVrC29f3
         gUno5vD59EEhg==
Date:   Wed, 3 Feb 2021 16:35:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Wunderlich <sw@simonwunderlich.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>
Subject: Re: [PATCH 2/4] batman-adv: Update copyright years for 2021
Message-ID: <20210203163506.4b4dbff0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210202174037.7081-3-sw@simonwunderlich.de>
References: <20210202174037.7081-1-sw@simonwunderlich.de>
        <20210202174037.7081-3-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  2 Feb 2021 18:40:34 +0100 Simon Wunderlich wrote:
> From: Sven Eckelmann <sven@narfation.org>
> 
> Signed-off-by: Sven Eckelmann <sven@narfation.org>
> Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
> ---
>  include/uapi/linux/batadv_packet.h     | 2 +-
>  include/uapi/linux/batman_adv.h        | 2 +-
>  net/batman-adv/Kconfig                 | 2 +-
>  net/batman-adv/Makefile                | 2 +-
>  net/batman-adv/bat_algo.c              | 2 +-
>  net/batman-adv/bat_algo.h              | 2 +-
>  net/batman-adv/bat_iv_ogm.c            | 2 +-
>  net/batman-adv/bat_iv_ogm.h            | 2 +-
>  net/batman-adv/bat_v.c                 | 2 +-
>  net/batman-adv/bat_v.h                 | 2 +-
>  net/batman-adv/bat_v_elp.c             | 2 +-
>  net/batman-adv/bat_v_elp.h             | 2 +-
>  net/batman-adv/bat_v_ogm.c             | 2 +-
>  net/batman-adv/bat_v_ogm.h             | 2 +-
>  net/batman-adv/bitarray.c              | 2 +-
>  net/batman-adv/bitarray.h              | 2 +-
>  net/batman-adv/bridge_loop_avoidance.c | 2 +-
>  net/batman-adv/bridge_loop_avoidance.h | 2 +-
>  net/batman-adv/distributed-arp-table.c | 2 +-
>  net/batman-adv/distributed-arp-table.h | 2 +-
>  net/batman-adv/fragmentation.c         | 2 +-
>  net/batman-adv/fragmentation.h         | 2 +-
>  net/batman-adv/gateway_client.c        | 2 +-
>  net/batman-adv/gateway_client.h        | 2 +-
>  net/batman-adv/gateway_common.c        | 2 +-
>  net/batman-adv/gateway_common.h        | 2 +-
>  net/batman-adv/hard-interface.c        | 2 +-
>  net/batman-adv/hard-interface.h        | 2 +-
>  net/batman-adv/hash.c                  | 2 +-
>  net/batman-adv/hash.h                  | 2 +-
>  net/batman-adv/log.c                   | 2 +-
>  net/batman-adv/log.h                   | 2 +-
>  net/batman-adv/main.c                  | 2 +-
>  net/batman-adv/main.h                  | 2 +-
>  net/batman-adv/multicast.c             | 2 +-
>  net/batman-adv/multicast.h             | 2 +-
>  net/batman-adv/netlink.c               | 2 +-
>  net/batman-adv/netlink.h               | 2 +-
>  net/batman-adv/network-coding.c        | 2 +-
>  net/batman-adv/network-coding.h        | 2 +-
>  net/batman-adv/originator.c            | 2 +-
>  net/batman-adv/originator.h            | 2 +-
>  net/batman-adv/routing.c               | 2 +-
>  net/batman-adv/routing.h               | 2 +-
>  net/batman-adv/send.c                  | 2 +-
>  net/batman-adv/send.h                  | 2 +-
>  net/batman-adv/soft-interface.c        | 2 +-
>  net/batman-adv/soft-interface.h        | 2 +-
>  net/batman-adv/tp_meter.c              | 2 +-
>  net/batman-adv/tp_meter.h              | 2 +-
>  net/batman-adv/trace.c                 | 2 +-
>  net/batman-adv/trace.h                 | 2 +-
>  net/batman-adv/translation-table.c     | 2 +-
>  net/batman-adv/translation-table.h     | 2 +-
>  net/batman-adv/tvlv.c                  | 2 +-
>  net/batman-adv/tvlv.h                  | 2 +-
>  net/batman-adv/types.h                 | 2 +-
>  57 files changed, 57 insertions(+), 57 deletions(-)
> 
> diff --git a/include/uapi/linux/batadv_packet.h b/include/uapi/linux/batadv_packet.h
> index 9c8604c5b5f6..67b773ea0ec3 100644
> --- a/include/uapi/linux/batadv_packet.h
> +++ b/include/uapi/linux/batadv_packet.h
> @@ -1,5 +1,5 @@
>  /* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) */
> -/* Copyright (C) 2007-2020  B.A.T.M.A.N. contributors:
> +/* Copyright (C) 2007-2021  B.A.T.M.A.N. contributors:
>   *
>   * Marek Lindner, Simon Wunderlich
>   */

Is this how copyright works? I'm not a layer, but I thought it was
supposed to reflect changes done to given file in a given year.
