Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 016832D556
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 08:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbfE2GEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 02:04:33 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57191 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725855AbfE2GEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 02:04:33 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 71A392239D;
        Wed, 29 May 2019 02:04:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 29 May 2019 02:04:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=iAw6G0
        C3R2R3kLb+QFYEoc99LuTKwom0MD5XfR5/r2M=; b=WFeTFvvUKCExaBlnVLumAl
        f3X3LLmf30q+/FOMhcDTsTqlvKTp+CvlE4ZT9+7sAwagR49+ocYg504+bqgjCYZf
        021ayoVZWHposgyNzYpRsVe+d0pTawYQ+AG1ys9iQ6Hdhll+FTvBXOarbHI28CND
        GN8qpg7cddzeukdcRNIVQIi5bakx7/hrntyBajAhXtwFXyAjDHEBPAzQmwRWWaje
        McGI1u9XUMZil17eLMjzXR4LZGPEn10HKKMdy7QIrTDjJxzmtUeOp+ZSBf8UTLvo
        4DRjMwmTN94xjT//5szA0pU77T1M3twRVdq2E+Tu6fUUv3okTQPcsBDlPy2bWh9g
        ==
X-ME-Sender: <xms:8CDuXP9IRYAZmPwYUvX87LZAzHdjIJPDtgrVWiIl15X5illzyNkwiA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddviedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepud
    elfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgt
    hhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:8CDuXDD_7iuGLMYYLBXeJ51W7a8MmwC2AqLQYP2qZIEz0rQu-z2zKw>
    <xmx:8CDuXBuE9yjH4Fj98VJPHXiEIrKo3kMWhQNphJ_4NnxCtXLsGVSRJw>
    <xmx:8CDuXEdwlxpabgiLE30nozsae5u7roAHgkpAeFcs5iYvqv4TKy59mQ>
    <xmx:8CDuXEK_S5R2gIo9VAwTlws3jvJP0KM0ouGNfE_LuNilukfMfeAWhg>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id C990C80066;
        Wed, 29 May 2019 02:04:31 -0400 (EDT)
Date:   Wed, 29 May 2019 09:04:29 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: Re: [patch net-next v2 4/7] devlink: allow driver to update progress
 of flash update
Message-ID: <20190529060429.GC10684@splinter>
References: <20190528114846.1983-1-jiri@resnulli.us>
 <20190528114846.1983-5-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528114846.1983-5-jiri@resnulli.us>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 01:48:43PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Introduce a function to be called from drivers during flash. It sends
> notification to userspace about flash update progress.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Reviewed-by: Ido Schimmel <idosch@mellanox.com>
