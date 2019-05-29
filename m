Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF3E2D555
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 08:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbfE2GDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 02:03:39 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55165 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725855AbfE2GDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 02:03:38 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D837E223A7;
        Wed, 29 May 2019 02:03:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 29 May 2019 02:03:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=dJgTbK
        ttqvT9HpGvq13udvpeVfOd3ITUqPbAm+m1/OU=; b=Z0fEb4pk1ARKBfFlOmrGFv
        xZ/zTwSpaC/mRJF/QJkol6mrsIUYXXZ6R3Fo4pWiiQl/5KFuZ30l4aMdWRCCDg+R
        /yrvVenSaot3zP38gAp5JzThEb1V8rayJpFsLBAlgN/9wl8Oi3P8j35qGuwtGB7F
        J8+4supyAnz3a+xrBSUZ7dASgHiAUzQSbJS7vPk6EZ7P+Il9iHhaD4x1J5MvtWgd
        9phm3BHgXuHogrbYfqlY6EbEQ6DHeTzqyGfLLIkSljGASPoS59I3IYQTZsn+Fw3E
        8keRvAiFzbtck+eHJ6NRU/HX0rgUKXUMtQfofoGsMVZFVxT5prgJJ09rlhenWaFA
        ==
X-ME-Sender: <xms:uSDuXN8bbR6Cnm4lS-OHOjemW49qS6wkTVPzcrJSTLtHYWmF_tL3Ww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddviedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepud
    elfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgt
    hhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:uSDuXM51Et8sn4MF3XSlKPZ3gzI0VzYdHyQpqShX3qG6FDKT1BEtEQ>
    <xmx:uSDuXO260wphX8W321rHSzqCmQ3y9lRv7SvCr2m6oEzpVO2vLN-SNg>
    <xmx:uSDuXLyKQI0b6IGqippQiM-g6WtE666PAnJ4sISCKWVxtJjsyDPjIg>
    <xmx:uSDuXBI3H-w9n8jGz5nIEpSV9Yb5xB2DTDmZLcpPLg3G7LASi9h_Vw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 300C98005A;
        Wed, 29 May 2019 02:03:37 -0400 (EDT)
Date:   Wed, 29 May 2019 09:03:35 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: Re: [patch net-next v2 3/7] mlxfw: Propagate error messages through
 extack
Message-ID: <20190529060335.GB10684@splinter>
References: <20190528114846.1983-1-jiri@resnulli.us>
 <20190528114846.1983-4-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528114846.1983-4-jiri@resnulli.us>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 01:48:42PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Currently the error messages are printed to dmesg. Propagate them also
> to directly to user doing the flashing through extack.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Reviewed-by: Ido Schimmel <idosch@mellanox.com>
