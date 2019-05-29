Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0742D565
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 08:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbfE2GMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 02:12:16 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:40743 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725855AbfE2GMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 02:12:16 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2832322185;
        Wed, 29 May 2019 02:12:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 29 May 2019 02:12:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=yD4CrY
        3B1rvjhyAZVVRCtMzS6vYgSQA1CW40AV+/XkI=; b=gKed7JLhUVBVSzQErGofUz
        CddRw3sKnleLgzQz8focC1/zlV17b2np4qbjernqq/KSaJVTmRcXqN5bgkIqa7XC
        KffNKxd0KcGktJ1gwoMtRBPxh+gd7ct08fHBc2XhL0T5Hqm0cVF8xb0pQHhqCcA+
        v76DenjwHID4tNVVcS6ALIza0gw5qPnmHdMY+m/qhoTZv7dNwsPOIIidHxsLZWg3
        RExC4JOI/AH3I5v2SEttBuyp19XKex+mdF59/eH7DMe9AnIG9c1E2S3RalYe5Twa
        Mtiam8O4ZHzP9EwYrL8tyD3ZmSWEYVvb1Jnz5GieADj0B71yqL1EpDjCmL/giRLA
        ==
X-ME-Sender: <xms:viLuXEsUB2R19pSBmWsUd8ngx-H5ZXqF3dDKSEza5A6_U74HxTuCwA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddviedguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepud
    elfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgt
    hhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:viLuXGsPYsHZoPuLdw5Q9ZYdN9u7Q44PX1jio6HdOlvfONjGSIuyKQ>
    <xmx:viLuXBdS0klkTdUcz8f9KIshtU0DmcbX51-7yn3pzo0LvCr2DuzHQA>
    <xmx:viLuXPaTyjcRtX_njr08HBrX0qcxtQXUzaHaYbHBlFQTIxlEJaihuA>
    <xmx:vyLuXIVYWeKJzkMijqngoirRWyWYnImw_Fu10z5H_mqXI_HSEhUkCg>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 94857380085;
        Wed, 29 May 2019 02:12:13 -0400 (EDT)
Date:   Wed, 29 May 2019 09:12:11 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: Re: [patch net-next v2 6/7] mlxsw: Implement flash update status
 notifications
Message-ID: <20190529061211.GE10684@splinter>
References: <20190528114846.1983-1-jiri@resnulli.us>
 <20190528114846.1983-7-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528114846.1983-7-jiri@resnulli.us>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 01:48:45PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Implement mlxfw status_notify op by passing notification down to
> devlink. Also notify about flash update begin and end.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Reviewed-by: Ido Schimmel <idosch@mellanox.com>
