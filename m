Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A422FD4C7D
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 05:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbfJLDiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 23:38:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55226 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbfJLDiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 23:38:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D377B14FD3304;
        Fri, 11 Oct 2019 20:38:12 -0700 (PDT)
Date:   Fri, 11 Oct 2019 20:38:12 -0700 (PDT)
Message-Id: <20191011.203812.1828730130029996774.davem@davemloft.net>
To:     andrew@aj.id.au
Cc:     netdev@vger.kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@jms.id.au, benh@kernel.crashing.org,
        linux-aspeed@lists.ozlabs.org
Subject: Re: [PATCH v2 0/3] net: ftgmac100: Ungate RCLK for RMII on ASPEED
 MACs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191010020756.4198-1-andrew@aj.id.au>
References: <20191010020756.4198-1-andrew@aj.id.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 11 Oct 2019 20:38:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Jeffery <andrew@aj.id.au>
Date: Thu, 10 Oct 2019 12:37:53 +1030

> This series slightly extends the devicetree binding and driver for the
> FTGMAC100 to describe an optional RMII RCLK gate in the clocks property.
> Currently it's necessary for the kernel to ungate RCLK on the AST2600 in NCSI
> configurations as u-boot does not yet support NCSI (which uses the
> R(educed)MII).
> 
> v2:
> * Clear up Reduced vs Reversed MII in the cover letter
> * Mitigate anxiety in the commit message for 1/3 
> * Clarify that AST2500 is also affected in the clocks property description in
>   2/3
> * Rework the error paths and update some comments in 3/3
> 
> v1 can be found here: https://lore.kernel.org/netdev/20191008115143.14149-1-andrew@aj.id.au/

Series applied to net-next, thank you.
