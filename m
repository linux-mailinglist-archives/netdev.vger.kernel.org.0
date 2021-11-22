Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2707245951F
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 19:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbhKVSz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 13:55:57 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:46075 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238104AbhKVSzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 13:55:11 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C78355C0120;
        Mon, 22 Nov 2021 13:52:01 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 22 Nov 2021 13:52:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=qCtdN3
        oL8PM5+xfXLqc9HUJToV0PWtXUl1G5Cq114lc=; b=G8/Lak5sBhDPbHdnKZ8Pha
        NIO770iOdZt0kuYTu8rYtyRlTq2p2RQcX48CAtwl6HGTKHjjvb1xNhkFTA96lljC
        i7AXlYvi1oV5K1UQ9EvmoPzFUhjIEZ2bO1P/uBsfXPmcamPXToduN54Jf4SZnoqp
        YH4G7+CRPLR9AqTVwgYECUzF79icO3UOrS9mhYbh5Q5wykNZEQS4tuFUHLqdPJQn
        PTAeR3qjkBz7DklxdyT5dd4/RBC4thtNdwR+wF5fnczOD1xG0sYafsSp3dxYf1Qm
        vyDVNL9WCgB1/nyiu2I2RP0nTXZZrei1IzRqB6g8P9JF5jzPv4RSsVrpS0yg0fNw
        ==
X-ME-Sender: <xms:0eabYYgLNbNYnLJOvP1Ox4Ji7Fm-ZDc9JqiSmcXfYUSWzWlIDfiQhQ>
    <xme:0eabYRA1SM-uWEg4ENuWeeYTnvZQ7hUXk5GPuy1JNKQORLh6GUWatATUqnKvmHw6f
    OADehqVwcv2JTE>
X-ME-Received: <xmr:0eabYQFQi-PSgntqCtyxOvuBoUR5nA_grX2bWMXZV-f8soyUBQsJgSdFnDyvXUV-Us3zIxvCf08BgWkksaRgG9HaQ2p6oQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeeggdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:0eabYZRiAfAdb-VtDrgnGyQYFUpaFd9XInCWXATFKmaVtdDx9YhuAA>
    <xmx:0eabYVy12-PQvdoA7ixKsttxBha_SZ3tf1t8O2pdJpcfKIRBp7uztA>
    <xmx:0eabYX58M-MyORXOLTnv-JYGOTYfK7mq4I0wQszCYlF-z-Uhy7CBLQ>
    <xmx:0eabYWqsIhNC049Lo5zfmHV2ThLVdq3Bs3ayQuZ0ZVpWSfLR0fhRPA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 Nov 2021 13:52:00 -0500 (EST)
Date:   Mon, 22 Nov 2021 20:51:56 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev <netdev@vger.kernel.org>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [ethtool v5 2/6] Add cable test TDR support
Message-ID: <YZvmzIVHP8nReWJC@shredder>
References: <20200705175452.886377-1-andrew@lunn.ch>
 <20200705175452.886377-3-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200705175452.886377-3-andrew@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 05, 2020 at 07:54:48PM +0200, Andrew Lunn wrote:
> +/* Receive the broadcasted messages until we get the cable test
> + * results
> + */
> +static int nl_cable_test_tdr_process_results(struct cmd_context *ctx)
> +{
> +	struct nl_context *nlctx = ctx->nlctx;
> +	struct nl_socket *nlsk = nlctx->ethnl_socket;
> +	struct cable_test_context ctctx;
> +	int err;
> +
> +	nlctx->is_monitor = true;
> +	nlsk->port = 0;
> +	nlsk->seq = 0;

Andrew, is this missing the following patch?

diff --git a/netlink/cable_test.c b/netlink/cable_test.c
index 17139f7d297d..9305a4763c5b 100644
--- a/netlink/cable_test.c
+++ b/netlink/cable_test.c
@@ -225,6 +225,7 @@ static int nl_cable_test_process_results(struct cmd_context *ctx)
        nlctx->is_monitor = true;
        nlsk->port = 0;
        nlsk->seq = 0;
+       nlctx->filter_devname = ctx->devname;
 
        ctctx.breakout = false;
        nlctx->cmd_private = &ctctx;
@@ -496,6 +497,7 @@ static int nl_cable_test_tdr_process_results(struct cmd_context *ctx)
        nlctx->is_monitor = true;
        nlsk->port = 0;
        nlsk->seq = 0;
+       nlctx->filter_devname = ctx->devname;
 
        ctctx.breakout = false;
        nlctx->cmd_private = &ctctx;

I don't have hardware with cable test support so wondered if you could
test it. I think that without this patch you would see problems with two
simultaneous cable tests. The first one to finish will terminate both
ethtool processes because the code is processing all cable tests
notifications regardless of the device for which the test was issued.

Context: I'm using a similar scheme for transceiver module firmware
update in order to support simultaneous update of several modules.

> +
> +	ctctx.breakout = false;
> +	nlctx->cmd_private = &ctctx;
> +
> +	while (!ctctx.breakout) {
> +		err = nlsock_process_reply(nlsk, nl_cable_test_tdr_results_cb,
> +					   nlctx);
> +		if (err)
> +			return err;
> +	}
> +
> +	return err;
> +}
