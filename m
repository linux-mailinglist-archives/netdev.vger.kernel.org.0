Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3A72D554
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 08:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbfE2GDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 02:03:17 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36899 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725855AbfE2GDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 02:03:17 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D782D21F3C;
        Wed, 29 May 2019 02:03:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 29 May 2019 02:03:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xqaksT
        i2DzsGMF2BytNUColXQR7Ew9YqWgpVWGT1318=; b=vlcPmDWwVa3mnoSDrrLRBi
        vuLxhsUlLfCzLjDD05EeO0WTzdOQrh/6+g2L/h0javDtZiNAZGh/v2ZvYoWWaFR2
        5/bPs4JzYbx/OFW+p1llqwP0buovYzpjiQqpNgduauT2DC66snI333cL2mtZ7qVg
        sELotdcoac4xsmIFcf79nHTqoslTLvi92Q9UPkNthdmUq260G2jytQ7yglML9ECi
        5aGdDRnTrjRgrCu5HkFGCwnlNHijTc4wnzEGfZncQN4SvhNPFGBCqPgWe/SXTn+5
        AT1/98xeh3aaSkHIdm42cVq+KFMaRGuBBwL7Bd6foOFkGTTBUrOtUjvCx+Z6FGlQ
        ==
X-ME-Sender: <xms:oyDuXJKt0SpmtKhmtjP1fKeJ9AKSv-rYRkWJW1U0PxrQb67DI8JkRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddviedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepud
    elfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgt
    hhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:oyDuXAAdo6mytVXDtvAnnyDqblhpK-yzzRTnLftzGDkHv8F1LAbejg>
    <xmx:oyDuXJgZsOWPp6GRTjjlMDxr9FA_6aRvKKfeUMJKKPi-fBUvI1HsXQ>
    <xmx:oyDuXImDA9lGzprTX6hRK4Tfx7emZCeNLXhBmx-h_7_nmYXQbS0C0Q>
    <xmx:oyDuXGocGWKb6yoDQdsXroIgkipLXBdrOpzJsARJDlhuMEQ0ALMxFA>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id B9EB080063;
        Wed, 29 May 2019 02:03:14 -0400 (EDT)
Date:   Wed, 29 May 2019 09:03:12 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: Re: [patch net-next v2 1/7] mlxsw: Move firmware flash
 implementation to devlink
Message-ID: <20190529060312.GA10684@splinter>
References: <20190528114846.1983-1-jiri@resnulli.us>
 <20190528114846.1983-2-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528114846.1983-2-jiri@resnulli.us>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 01:48:40PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Benefit from the devlink flash update implementation and ethtool
> fallback to it and move firmware flash implementation there.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Reviewed-by: Ido Schimmel <idosch@mellanox.com>
