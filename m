Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFFDA3F031A
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 13:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234896AbhHRL7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 07:59:02 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49273 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231500AbhHRL7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 07:59:00 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B7C425C00BD;
        Wed, 18 Aug 2021 07:58:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 18 Aug 2021 07:58:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=v2JFN1
        DSkjegBrCPzVOFqy6vNBDTyF74NPfYbQKl8VY=; b=WoGtXsb/tGGM7lsYaoNrTu
        yd4c6g/VafZ1PHspTeku62MGkMVDlSREXbDnGwO2mzIgIe7GgWwIJ1dhoj5jNGAj
        9Zanm42OAMMO98w/unDkeQo3ej7tjpMWI0fHEhrCFN3HpypE6d8s0wMaNqYCnDJj
        eyhrkCs0z7H1XzR+tXHzEmIB1EOR7fdftR+FFvmY7IbKp9rPzNCm39LiZuaClxEF
        fP2VbPn4JLZJICLtvxNdK+MEk8ULIBz8kbm693VSPh5yk53VZya6jVbTaHJ5fXTZ
        GgGpwJ+XA3eR/7gb8VXDVBHthdXcXOxpUyRz4Im5pJdq4ZPPvi4/4850NeIYhAmA
        ==
X-ME-Sender: <xms:4fUcYZDrKRxbFHseIQLgNapptiRONL2wwrCDlbIk0yxskCFliWLctA>
    <xme:4fUcYXjIMvhN-iGo25qlWidLJFhH5JJDDr3YPAK53ZlY5PQFeIbN5mDHqIrgTZ5SN
    SQ9ZiGw47qz6fM>
X-ME-Received: <xmr:4fUcYUmDuyMtRhkcWr8Zv2NZIb9ogm1Q5-xSbVz2DWcHTNTgT-clYvFDpoIPsfbf4dhjWKfndGp6pRP6ptUXOxAQ3ylS9A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrleehgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttdertd
    dttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpedtffekkeefudffveegueejffejhfetgf
    euuefgvedtieehudeuueekhfduheelteenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:4fUcYTzo-UgiW7eEuoKX_NcK_pI55gRkpCqnn6rOf9ISkWPvcJvWMQ>
    <xmx:4fUcYeSNofQLY5sxWkpGVaYC5jNFJ7xxZWJpjlRxxdtvyuX9IHi7rA>
    <xmx:4fUcYWbeWlUMDF5UknMZT4YwJxuzuuaZ2xbZofL2stELneLq35wGvQ>
    <xmx:4fUcYcdqPtVKJLVWsWWVEQ6H6CbXGcihU9dg8DgPHvUVSuNUzrSrwg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 18 Aug 2021 07:58:24 -0400 (EDT)
Date:   Wed, 18 Aug 2021 14:58:19 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     13145886936@163.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gushengxian <gushengxian@yulong.com>
Subject: Re: [PATCH] flow_offload: action should not be NULL when it is
 referenced
Message-ID: <YRz1297sFSjG7/Cc@shredder>
References: <20210626115606.1243151-1-13145886936@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210626115606.1243151-1-13145886936@163.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 26, 2021 at 04:56:06AM -0700, 13145886936@163.com wrote:
> From: gushengxian <gushengxian@yulong.com>
> 
> "action" should not be NULL when it is referenced.
> 
> Signed-off-by: gushengxian <13145886936@163.com>
> Signed-off-by: gushengxian <gushengxian@yulong.com>
> ---
>  include/net/flow_offload.h | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index dc5c1e69cd9f..69c9eabf8325 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -319,12 +319,14 @@ flow_action_mixed_hw_stats_check(const struct flow_action *action,
>  	if (flow_offload_has_one_action(action))
>  		return true;
>  
> -	flow_action_for_each(i, action_entry, action) {
> -		if (i && action_entry->hw_stats != last_hw_stats) {
> -			NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");
> -			return false;
> +	if (action) {

This patch generates a smatch warning:

include/net/flow_offload.h:322 flow_action_mixed_hw_stats_check() warn: variable dereferenced before check 'action' (see line 319)

Why the patch is needed? 'action' is already dereferenced in
flow_offload_has_one_action()

> +		flow_action_for_each(i, action_entry, action) {
> +			if (i && action_entry->hw_stats != last_hw_stats) {
> +				NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");
> +				return false;
> +			}
> +			last_hw_stats = action_entry->hw_stats;
>  		}
> -		last_hw_stats = action_entry->hw_stats;
>  	}
>  	return true;
>  }
> -- 
> 2.25.1
> 
> 
