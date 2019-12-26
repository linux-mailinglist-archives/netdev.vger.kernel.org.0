Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4C5C12AADA
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 08:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbfLZHtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 02:49:18 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:35767 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725815AbfLZHtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 02:49:18 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C94D021FFC;
        Thu, 26 Dec 2019 02:49:16 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 26 Dec 2019 02:49:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=dy89Q83ASi2EdUgIT39r5yhxansGtU+CJzDQuZIkK
        B0=; b=nAOPXWc4iDnOccMzLFQ2DXX4GfxuYbHs3Yi1Wmhpee98VifGovolI4hax
        JJC52cMVk+1dQfD9JVfHkUkj7giW244YIrM9oFjz28XDEWwQf94GeAeeKsSUrGce
        +AoYH1f0JllKvY/pjSxVlwICO7oRUsIw8bD0QrqcJyLJkrT0ccm9faJevfZfBlBt
        Ihup7/kncFoMc43gwlEBuETPreNEmgwjTLG5X0PGRw0vPe8nnmLGKm76T9OTGd3R
        uMuhDcM2ft9YkOhlM2020YdHU4opov2dPH5+nVHqoxeUPZ0WoDbvhsqBAVy7rq86
        x/Wp3+L1xiA9w3G4OFmCISLIfd8Cw==
X-ME-Sender: <xms:_GUEXpnBfgbv2OgA_9f741yRMHNwAFADE5ZBbGM_Y4dvOKusC1l9dw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvhedgudduvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtugfgjgesth
    ekredttddtudenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehi
    ughoshgthhdrohhrgheqnecuffhomhgrihhnpehgihhthhhusgdrtghomhenucfkphepud
    elfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgt
    hhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:_GUEXqKE73SQiYDAWjCWykYb4DeJbzDoi9bMUP9t-dCq8Zd9rp1eFQ>
    <xmx:_GUEXvgV9yHO6aEhts_Jsc5PnVDclBGu8i_D27n9ir_gvWArmX1kmw>
    <xmx:_GUEXpl200lsrf3YvzYfdH9jMVWnGdVix_WQ7GqzsmHU6p7wSAIJZA>
    <xmx:_GUEXs73Xe40o6l9E9WEA7Xm_GAfvuwkNElx_txKj9lr82_ynxx1BQ>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id A21098005A;
        Thu, 26 Dec 2019 02:49:15 -0500 (EST)
Date:   Thu, 26 Dec 2019 09:49:14 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     wenxu <wenxu@ucloud.cn>
Cc:     netdev@vger.kernel.org, mlxsw@mellanox.com
Subject: Re: Problem about gre tunnel route offload in mlxsw
Message-ID: <20191226074914.GA30900@splinter>
References: <1577267303-24780-1-git-send-email-wenxu@ucloud.cn>
 <6ed792a4-6f64-fe57-4e1e-215bfa701ccf@ucloud.cn>
 <20191225.195000.1150683636639114235.davem@davemloft.net>
 <8bb9cc6b-bda1-5808-d88c-6e33076ac264@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bb9cc6b-bda1-5808-d88c-6e33076ac264@ucloud.cn>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 26, 2019 at 01:07:33PM +0800, wenxu wrote:
> Hi mlxsw team,
> 
> 
> I did a route test with gre tunnel and vrf.
> 
> This test under current net-next tree with following script:
> 
> 
> ifconfig enp3s0np31 up
> ip a a dev enp3s0np31 172.168.152.247/24
> 
> ip l add dev vrf11 type vrf table 11
> ifconfig vrf11 up
> ip l set dev enp3s0np11 master vrf11
> ifconfig enp3s0np11 10.0.7.1/24 up
> ip tunnel add name gre11 mode gre local 172.168.152.247 remote 172.168.152.73 key 11 tos inherit  ttl inherit
> ip l set dev gre11 master vrf11
> ifconfig gre11 10.0.2.1/24 up
> 
> ip l add dev vrf21 type vrf table 21
> ifconfig vrf21 up
> ip l set dev enp3s0np21 master vrf21
> ifconfig enp3s0np21 10.0.7.1/24 up
> ip tunnel add name gre21 mode gre local 172.168.152.247 remote 172.168.152.73 key 21 tos inherit  ttl inherit
> ip l set dev gre21 master vrf21
> ifconfig gre21 10.0.2.1/24 up
> 
> 
> If there is only one tunnel. The route rule can be offloaded. But two tunnel only with different key can't be offloaded.
> 
> If I add a new address 172.168.152.248 for tunnel source and change the gre21 to
> 
> "ip tunnel add name gre21 mode gre local 172.168.152.248 remote 172.168.152.73 key 21 tos inherit  ttl inherit"
> 
> It's work.
> 
> So it means dispatch based on tunnel key is not supported ?

Yes. See:
"No two tunnels that share underlay VRF shall share a local address
(i.e. dispatch based on tunnel key is not supported)"

https://github.com/Mellanox/mlxsw/wiki/L3-Tunneling#features-and-limitations

> It is a hardware limits or just software unsupported?

Software. In hardware you can perform decapsulation in the router or
using ACLs. mlxsw uses the former so the key is {tb_id, prefix}. With
ACLs it is possible to match on more attributes.

> 
> 
> And if a replace the gre device to vxlan device,  the route can't be offloaded again only with one vxlan tunnel.
> 
> "ip l add dev vxlan11 type vxlan local 172.168.152.247 remote 172.168.152.73 id 11 noudpcsum tos inherit ttl inherit dstport 4789"
> 
> So currently the vxlan device can't work with routing?

Yes. We don't perform VXLAN encapsulation in the router, only in bridge.
See:
https://github.com/Mellanox/mlxsw/wiki/Virtual-eXtensible-Local-Area-Network-%28VXLAN%29

> 
> 
> BR
> 
> wenxu
> 
> 
> 
> 
> 
