Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81DBE1BAAD0
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 19:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgD0RK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 13:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgD0RK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 13:10:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC3AC0610D5;
        Mon, 27 Apr 2020 10:10:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 391F015D4A660;
        Mon, 27 Apr 2020 10:10:55 -0700 (PDT)
Date:   Mon, 27 Apr 2020 10:10:54 -0700 (PDT)
Message-Id: <20200427.101054.2128954519257276284.davem@davemloft.net>
To:     o.rempel@pengutronix.de
Cc:     andrew@lunn.ch, robh+dt@kernel.org, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1] dt-bindings: net: convert qca,ar71xx
 documentation to yaml
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200424052116.17204-1-o.rempel@pengutronix.de>
References: <20200424052116.17204-1-o.rempel@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Apr 2020 10:10:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>
Date: Fri, 24 Apr 2020 07:21:16 +0200

> Now that we have the DT validation in place, let's convert the device tree
> bindings for the Atheros AR71XX over to a YAML schemas.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Applied, thanks.
