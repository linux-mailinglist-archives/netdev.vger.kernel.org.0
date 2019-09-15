Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2271B2F3E
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 10:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbfIOIjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 04:39:15 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:50389 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725497AbfIOIjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 04:39:15 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7279F2BAE;
        Sun, 15 Sep 2019 04:39:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 15 Sep 2019 04:39:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=adaZZj
        vCTWrdbiLOE+6qzrLgFJXYOi49ik8NE3hmeYE=; b=vaTKl0bAzsM7eVEiIeMdlq
        40X/Tik8h1q0gIjE8jAyb7AmJQeBtJssJ1ubPXynjzsdmluRuQK7Qvr3FjIA459e
        1Dg6wOJSZOB4xL3O+TaBIOGMhn6ELhbaz06BhA5tEXyhq1XDQ/p97wxYHG/WgHsL
        F/ExS6uj/L/jHj0Wvz3/KgQQvT8tF4drsIyEOYY95amGWjzDT+GmO9JhggJXFQIZ
        lo8b2d1h2IcWn4q2MCbOgEtNw5+udk08nAk+6bmbu5iZn1hKtzCXnOXBcFLvBH9K
        JQLuyH2XG5rAtZ8TIT7rQcG/iICydtOgr7SypEokDt/rtC5/SHpW9WKyKGZI5tNA
        ==
X-ME-Sender: <xms:svh9XQ6tTd4qntUUPcim8l97OkId7TI2z-EkiRvgwHGg5M1Qqpz6TQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddugddtjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:svh9XSdpZm0TV4EN-yquLMxYJN2KbLw2_ynDVOY1mMpTqqci3IWxHQ>
    <xmx:svh9XYX-qbGTeQqHQp1DutUOoyDVGEBOyTbhNAJ8VpHWKeo1s75cIQ>
    <xmx:svh9XfUo84DqL11inOcc-pqqhFSaVcOTIH4l6kQVAOzL7U216PoZ1A>
    <xmx:svh9XZpP7DcGQPvwcYlegzNjv7cL9yOT5PESODG7r4tYWYUrxH-YIQ>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id D8F1AD6005B;
        Sun, 15 Sep 2019 04:39:13 -0400 (EDT)
Date:   Sun, 15 Sep 2019 11:39:11 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        dsahern@gmail.com, jakub.kicinski@netronome.com,
        tariqt@mellanox.com, saeedm@mellanox.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, shuah@kernel.org, mlxsw@mellanox.com
Subject: Re: [patch net-next 09/15] mlxsw: Propagate extack down to
 register_fib_notifier()
Message-ID: <20190915083911.GD11194@splinter>
References: <20190914064608.26799-1-jiri@resnulli.us>
 <20190914064608.26799-10-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190914064608.26799-10-jiri@resnulli.us>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 14, 2019 at 08:46:02AM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> During the devlink reaload the extack is present, so propagate it all

s/reaload/reload/

> the way down to register_fib_notifier() call in spectrum_router.c.
