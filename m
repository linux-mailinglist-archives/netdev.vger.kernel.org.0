Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F0727655D
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 02:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgIXAqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 20:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXAqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 20:46:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3C7C0613CE;
        Wed, 23 Sep 2020 17:46:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C99BD11FFD34A;
        Wed, 23 Sep 2020 17:29:16 -0700 (PDT)
Date:   Wed, 23 Sep 2020 17:46:03 -0700 (PDT)
Message-Id: <20200923.174603.788077534707375688.davem@davemloft.net>
To:     george.cherian@marvell.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 0/2] Add support for VLAN based flow
 distribution
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200922130727.2350661-1-george.cherian@marvell.com>
References: <20200922130727.2350661-1-george.cherian@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 23 Sep 2020 17:29:16 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: George Cherian <george.cherian@marvell.com>
Date: Tue, 22 Sep 2020 18:37:25 +0530

> This series add support for VLAN based flow distribution for octeontx2
> netdev driver. This adds support for configuring the same via ethtool.
> 
> Following tests have been done.
> 	- Multi VLAN flow with same SD
> 	- Multi VLAN flow with same SDFN
> 	- Single VLAN flow with multi SD
> 	- Single VLAN flow with multi SDFN
> All tests done for udp/tcp both v4 and v6

Series applied to net-next, thanks.
