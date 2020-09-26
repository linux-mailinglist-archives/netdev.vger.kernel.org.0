Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8743279571
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 02:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729641AbgIZAOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 20:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729493AbgIZAOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 20:14:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BE6C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 17:14:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0B0BC13BA3A12;
        Fri, 25 Sep 2020 16:57:17 -0700 (PDT)
Date:   Fri, 25 Sep 2020 17:14:04 -0700 (PDT)
Message-Id: <20200925.171404.196053411457915391.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] dpaa2-eth: small updates
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200925144421.7811-1-ioana.ciornei@nxp.com>
References: <20200925144421.7811-1-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 25 Sep 2020 16:57:18 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Fri, 25 Sep 2020 17:44:18 +0300

> This patch set is just a collection of small updates to the dpaa2-eth
> driver.
> 
> First, we only need to check the availability of the DTS child node, not
> both child and parent node. Then remove a call to
> dpaa2_eth_link_state_update() which is now just a leftover and it's not
> useful in how are things working now in the PHY integration. Lastly,
> modify how the driver is behaving when the the flow steering table is
> used between all the traffic classes.

Series applied.
