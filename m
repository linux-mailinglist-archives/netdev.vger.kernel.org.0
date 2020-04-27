Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11AC51BAACE
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 19:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbgD0RJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 13:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgD0RJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 13:09:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B0FC0610D5;
        Mon, 27 Apr 2020 10:09:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BDC5C15D4A413;
        Mon, 27 Apr 2020 10:09:45 -0700 (PDT)
Date:   Mon, 27 Apr 2020 10:09:43 -0700 (PDT)
Message-Id: <20200427.100943.572427286242813655.davem@davemloft.net>
To:     o.rempel@pengutronix.de
Cc:     jcliburn@gmail.com, chris.snook@gmail.com, andrew@lunn.ch,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1] net: ag71xx: extend link validation to
 support other SoCs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200424045914.26682-1-o.rempel@pengutronix.de>
References: <20200424045914.26682-1-o.rempel@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Apr 2020 10:09:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>
Date: Fri, 24 Apr 2020 06:59:14 +0200

> Most (all?) QCA SoCs have two MAC with different supported link
> capabilities. Extend ag71xx_mac_validate() to properly validate this
> variants.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Applied, thanks.
