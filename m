Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDDF277E69
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 05:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgIYDKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 23:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgIYDKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 23:10:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12DCC0613CE;
        Thu, 24 Sep 2020 20:10:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7C77F135F8F2B;
        Thu, 24 Sep 2020 19:53:28 -0700 (PDT)
Date:   Thu, 24 Sep 2020 20:10:14 -0700 (PDT)
Message-Id: <20200924.201014.1985667809546779432.davem@davemloft.net>
To:     helmut.grohne@intenta.de
Cc:     nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
        ludovic.desroches@microchip.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: microchip: really look for phy-mode in port
 nodes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200924083746.GA9410@laureti-dev>
References: <20200910.123257.1333858679864684014.davem@davemloft.net>
        <20200924083746.GA9410@laureti-dev>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 24 Sep 2020 19:53:29 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Helmut Grohne <helmut.grohne@intenta.de>
Date: Thu, 24 Sep 2020 10:37:47 +0200

> The previous implementation failed to account for the "ports" node. The
> actual port nodes are not child nodes of the switch node, but a "ports"
> node sits in between.
> 
> Fixes: edecfa98f602 ("net: dsa: microchip: look for phy-mode in port nodes")
> Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>

Applied and queued up for -stable.

> I am very sorry that I need to send a fixup. It turned out that my
> testing methodology was flawed. When I reintegrated Linus' master
> branch, I noticed that it didn't work.

You should be testing against the 'net' GIT tree, not Linus's master
branch.
