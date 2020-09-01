Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAE725A187
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 00:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgIAWeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 18:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbgIAWeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 18:34:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C86BC061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 15:34:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 50DEA13659456;
        Tue,  1 Sep 2020 15:17:57 -0700 (PDT)
Date:   Tue, 01 Sep 2020 15:34:19 -0700 (PDT)
Message-Id: <20200901.153419.1567972938274024697.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, andy.shevchenko@gmail.com
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Fix W=1 warning with
 !CONFIG_OF
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200901023257.3030231-1-andrew@lunn.ch>
References: <20200901023257.3030231-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 01 Sep 2020 15:17:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Tue,  1 Sep 2020 04:32:57 +0200

> When building on platforms without device tree, e.g. amd64, W=1 gives
> a warning about mv88e6xxx_mdio_external_match being unused. Replace
> of_match_node() with of_device_is_compatible() to prevent this
> warning.
> 
> Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks Andrew.
