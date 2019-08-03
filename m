Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE8EC80381
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 02:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392712AbfHCAdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 20:33:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52592 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390597AbfHCAdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 20:33:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 361A11264FD7C;
        Fri,  2 Aug 2019 17:33:03 -0700 (PDT)
Date:   Fri, 02 Aug 2019 17:33:02 -0700 (PDT)
Message-Id: <20190802.173302.1282952894728020522.davem@davemloft.net>
To:     andrew@aj.id.au
Cc:     netdev@vger.kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        joel@jms.id.au, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/4] net: phy: Add AST2600 MDIO support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190731053959.16293-1-andrew@aj.id.au>
References: <20190731053959.16293-1-andrew@aj.id.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 02 Aug 2019 17:33:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Jeffery <andrew@aj.id.au>
Date: Wed, 31 Jul 2019 15:09:55 +0930

> v2 of the ASPEED MDIO series addresses comments from Rob on the devicetree
> bindings and Andrew on the driver itself.
> 
> v1 of the series can be found here:
> 
> http://patchwork.ozlabs.org/cover/1138140/
> 
> Please review!

Series applied, thank you.
