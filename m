Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960EF1B52A1
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 04:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgDWCkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 22:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgDWCkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 22:40:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C20C03C1AB;
        Wed, 22 Apr 2020 19:40:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 25EBD127AD655;
        Wed, 22 Apr 2020 19:40:20 -0700 (PDT)
Date:   Wed, 22 Apr 2020 19:40:19 -0700 (PDT)
Message-Id: <20200422.194019.686324336801344834.davem@davemloft.net>
To:     tangbin@cmss.chinamobile.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhangshengju@cmss.chinamobile.com
Subject: Re: [PATCH] net: phy: Use IS_ERR() to check and simplify code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200422081542.8344-1-tangbin@cmss.chinamobile.com>
References: <20200422081542.8344-1-tangbin@cmss.chinamobile.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 19:40:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tang Bin <tangbin@cmss.chinamobile.com>
Date: Wed, 22 Apr 2020 16:15:42 +0800

> Use IS_ERR() and PTR_ERR() instead of PTR_ZRR_OR_ZERO()
> to simplify code, avoid redundant paramenter definitions
> and judgements.
> 
> Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>

Applied, thanks.
