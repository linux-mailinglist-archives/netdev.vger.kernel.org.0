Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8391D5CD2
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 01:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgEOXdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 19:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726183AbgEOXdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 19:33:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E06C061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 16:33:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B68171581D667;
        Fri, 15 May 2020 16:33:53 -0700 (PDT)
Date:   Fri, 15 May 2020 16:33:53 -0700 (PDT)
Message-Id: <20200515.163353.1445882151778041888.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     ioana.ciornei@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
 classes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200515152500.158ca070@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200515124059.33c43d03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB3871F0358FE1369A2F00621DE0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200515152500.158ca070@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 May 2020 16:33:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 15 May 2020 15:25:00 -0700

> With the Rx QoS features users won't even be able to tell via standard
> Linux interfaces what the config was.

+1

