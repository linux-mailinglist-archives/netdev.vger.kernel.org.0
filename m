Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840DD1E33B5
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 01:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgEZX3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 19:29:36 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:45613 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725804AbgEZX3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 19:29:36 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id E7EC05C0111;
        Tue, 26 May 2020 19:29:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 26 May 2020 19:29:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=0aoEel
        7QwWSvuMMO0ZKyF50ptOju77GvcTrXezZ8Pz0=; b=Z+OLIvRONrhbYRqxPNcvZG
        d+fZnLbMYg41svLzh/37xeA0mw6lEvwG5fRcwVVZldspt2abB5h8ieHKhfBZgZmQ
        8U3zraek5ybYkMoKQ+hhC9WQJfG5sMxS7W5jR3u+Tao+U6dDes/I9k6Vp0oWS5mA
        9G9NJQ10dSHBgwQPJPQcPxDUOUHlevKvGPTMZa+nDtrw4N0z4BsCOvO62wzPBwnD
        AadJZaaFxB/LATBqg85PH926VKiq4SKZchanJvv+ph25IPGmE20pNhCTOZf9bgTI
        aAbSpqbqtbeuHR/HA0IWd8gUtl3TjME8kF8y4RMFUG3u+lLAbjfkAvqa5RXUZ6MA
        ==
X-ME-Sender: <xms:XqbNXv3uO5-vGRxJnoRlcZ6nPsDzcWzGmFkwhmNhfbJd3qRuiqaLmA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvfedgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepjeelrddujeeirddvgedruddtjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:XqbNXuErbqSq3__avKPA0LNC-6LhFz0ME4IqvQ2mu5n_rz3t09ShnQ>
    <xmx:XqbNXv4sIYcwYxm9pKX6gxHn9d7WwVDTyvmdNh1NR0slnyXS5GKhsw>
    <xmx:XqbNXk3Il1rCO_zEOs8-bRuBUHqM4E04iPxF_ADslWllKkT9Fmm4vQ>
    <xmx:XqbNXuDBWcS_1YkVC0XVYQZ9uP0WxfA0ni8ELIxKiG_qG4cwiUE4Zw>
Received: from localhost (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 284B430665DD;
        Tue, 26 May 2020 19:29:33 -0400 (EDT)
Date:   Wed, 27 May 2020 02:29:25 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Colin King <colin.king@canonical.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mlxsw: spectrum_router: remove redundant initialization
 of pointer br_dev
Message-ID: <20200526232925.GA1509289@splinter>
References: <20200526225649.64257-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526225649.64257-1-colin.king@canonical.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 11:56:49PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> index 71aee4914619..8f485f9a07a7 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> @@ -7572,11 +7572,12 @@ static struct mlxsw_sp_fid *
>  mlxsw_sp_rif_vlan_fid_get(struct mlxsw_sp_rif *rif,
>  			  struct netlink_ext_ack *extack)
>  {
> -	struct net_device *br_dev = rif->dev;
> +	struct net_device *br_dev;
>  	u16 vid;
>  	int err;
>  
>  	if (is_vlan_dev(rif->dev)) {
> +

Colin, please drop the extra blank line and mention in subject prefix
that the patch is for net-next. Thanks!

>  		vid = vlan_dev_vlan_id(rif->dev);
>  		br_dev = vlan_dev_real_dev(rif->dev);
>  		if (WARN_ON(!netif_is_bridge_master(br_dev)))
> -- 
> 2.25.1
> 
