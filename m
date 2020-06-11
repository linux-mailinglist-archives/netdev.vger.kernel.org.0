Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0961F5F0F
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 02:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgFKAI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 20:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgFKAI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 20:08:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3812BC08C5C1;
        Wed, 10 Jun 2020 17:08:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4EB2C11F5F667;
        Wed, 10 Jun 2020 17:08:27 -0700 (PDT)
Date:   Wed, 10 Jun 2020 17:08:26 -0700 (PDT)
Message-Id: <20200610.170826.949931991037316223.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, vladimir.oltean@nxp.com,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net] docs: networkng: convert sja1105's devlink info to
 RTS
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200610235911.426444-1-kuba@kernel.org>
References: <20200610235911.426444-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Jun 2020 17:08:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Wed, 10 Jun 2020 16:59:11 -0700

> A new file snuck into the tree after all existing documentation
> was converted to RST. Convert sja1105's devlink info and move
> it where the rest of the drivers are documented.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Applied with Vlad's ack/test tags.

Please integrate those and add a v2 next time in this situation.

Thank you.
