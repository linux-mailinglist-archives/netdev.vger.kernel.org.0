Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFE222F853
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 10:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbfE3IK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 04:10:29 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:47595 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727330AbfE3IK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 04:10:29 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0D517221B2;
        Thu, 30 May 2019 04:10:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 30 May 2019 04:10:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=CbDfGe
        MVPd2/37JgdRvt0z0VONEnxstESL+ma2+ZpnY=; b=6u06bRiNTgjHMWRXYrSja5
        BpXG+CEjgSa5dNg6AYUtMbsxRHGMz39D5wqsVx1Sz9JoEf60eBrszywuiFoZoN9P
        kI4QkGBumFiDXiPZtycJ/DSPnNjOEmITeK9H3P/G8A9XvxpO8Df2hpmWCt77VBW4
        7Fdu0CzqYn1btBglCwP+i5E4zpXg2WIqVgONXc3KcgucK3NpSJrGjmUljqwLXyws
        1VOjyNPkGAZigCHQyPiLXHpxwSfKUfDntwqkRqVd0d1O9q8TlpOpQVj18fozBgd1
        xGSmCk2IDPS0q3LsGmodRbIcDnROUyEwadUCKIyrBQtYIiZWqugfkgR6NZOHT1pw
        ==
X-ME-Sender: <xms:84_vXCD8PJ4_ttklzFrGod1-7W8NmK4IkiNRFHH-zYgFcMq4E3vORg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvlecutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfutghh
    ihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfedrge
    ejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihgu
    ohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:84_vXL89Y3MaMn33bXHdgcZ0xo5-YDIjAwz4JGnkkGYONm0IcX5bFQ>
    <xmx:84_vXGrp-WwAFaDn2vkxLjVwoq_06uzjWcqdH3Kv2Y6-CgFbUu7IvA>
    <xmx:84_vXFERgDtAaNyVJAv_VEUiS9QPxmbf8f4RS-FKR1nUb9XY9RMbrg>
    <xmx:9I_vXK4SgPFw6eeiqsGb8iK3rktLTXv9hXXvcl6_Rv33t3-EkyL5aQ>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1F42380059;
        Thu, 30 May 2019 04:10:26 -0400 (EDT)
Date:   Thu, 30 May 2019 11:10:25 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, idosch@mellanox.com,
        saeedm@mellanox.com, kafai@fb.com, weiwan@google.com,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next 5/7] mlxsw: Fail attempts to use routes with
 nexthop objects
Message-ID: <20190530081025.GA16276@splinter>
References: <20190530030800.1683-1-dsahern@kernel.org>
 <20190530030800.1683-6-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190530030800.1683-6-dsahern@kernel.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 08:07:58PM -0700, David Ahern wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> Fail attempts to use nexthop objects with routes until support can be
> properly added.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>

Reviewed-by: Ido Schimmel <idosch@mellanox.com>
