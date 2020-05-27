Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04FA61E390B
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 08:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgE0GW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 02:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbgE0GW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 02:22:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE1EC061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 23:22:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 439F9127F279D;
        Tue, 26 May 2020 23:22:58 -0700 (PDT)
Date:   Tue, 26 May 2020 23:22:57 -0700 (PDT)
Message-Id: <20200526.232257.1172414099345555958.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, hkallweit1@gmail.com,
        cphealy@gmail.com, mkubecek@suse.cz
Subject: Re: [PATCH v3 net-next 0/7] Raw PHY TDR data
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200526222143.793613-1-andrew@lunn.ch>
References: <20200526222143.793613-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 May 2020 23:22:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Wed, 27 May 2020 00:21:36 +0200

> Some ethernet PHYs allow access to raw TDR data in addition to summary
> diagnostics information. Add support for retrieving this data via
> netlink ethtool. The basic structure in the core is the same as for
> normal phy diagnostics, the PHY driver simply uses different helpers
> to fill the netlink message with different data.
> 
> There is a graphical tool under development, as well a ethtool(1)
> which can dump the data as text and JSON.
 ...

Series applied, thanks Andrew.
