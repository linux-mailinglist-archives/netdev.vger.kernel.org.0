Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDFA48BD44
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 03:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348655AbiALC2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 21:28:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348651AbiALC2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 21:28:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152CAC061748;
        Tue, 11 Jan 2022 18:28:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD63A61732;
        Wed, 12 Jan 2022 02:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9163C36AEB;
        Wed, 12 Jan 2022 02:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641954491;
        bh=LKQxuf+e03vISf279LcO6bjfXRhK01rdCmFOm7s3OHw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YP5uE2ZNosmrbqOcrcG37yrML9gIfFMfm1tVlORS7PeKOBFTaOK85/N7TwsqUE6DT
         to6Xbd4ix46rAIDPM1nZcAmfpkliQd2xFLc4nVadbGkqDhp9QTNB6uKyRiyJnjc4vL
         AR9Wgi1SsDyCY4OmDnIYwBw17DvuboJqxXF9PBctOQJOIDpwAHWBR5M0EsduE7zxxx
         R9XgGPHMZWQVOYj3GoMQ2Yoj48INXrkzNMcLzTh306P2r4lcJm5wtxPnQGhcw6Wf+k
         D9uXGB9yo1B3hAwQ/IMAgz5MYGCQyUqWmZScHw/qUXLGVPc05/wmO14lUhBEgYvYYd
         yPtCb+ScUe53g==
Date:   Tue, 11 Jan 2022 18:28:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFm?= =?UTF-8?B?YcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next] Revert "of: net: support NVMEM cells with MAC
 in text format"
Message-ID: <20220111182809.23de1b21@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220111081206.2393560-1-michael@walle.cc>
References: <20220111081206.2393560-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Jan 2022 09:12:06 +0100 Michael Walle wrote:
> This reverts commit 9ed319e411915e882bb4ed99be3ae78667a70022.
> 
> We can already post process a nvmem cell value in a particular driver.
> Instead of having yet another place to convert the values, the post
> processing hook of the nvmem provider should be used in this case.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
> As mentioned in [1] I think we should discuss this a bit more and revert
> the patch for now before there are any users of it.
> 
> [1] https://lore.kernel.org/netdev/20211229124047.1286965-1-michael@walle.cc/

Revert seems reasonable since there are two different proposals, 
but I won't pretend to understand the space so if anyone has opinions
please share them.

> btw, now with net-next closed, should this patch have net-next or net as
> the queue in the subject?

net, technically, although currently the trees are pretty much
identical.
