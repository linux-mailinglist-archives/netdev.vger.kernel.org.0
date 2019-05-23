Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F25D82824E
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 18:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731231AbfEWQNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 12:13:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48220 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730782AbfEWQNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 12:13:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 15F221509A10C;
        Thu, 23 May 2019 09:13:49 -0700 (PDT)
Date:   Thu, 23 May 2019 09:13:48 -0700 (PDT)
Message-Id: <20190523.091348.50431813829161038.davem@davemloft.net>
To:     maxime.chevallier@bootlin.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        antoine.tenart@bootlin.com, thomas.petazzoni@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, stefanc@marvell.com, mw@semihalf.com
Subject: Re: [PATCH net] net: mvpp2: cls: Fix leaked ethtool_rx_flow_rule
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190523084724.14639-1-maxime.chevallier@bootlin.com>
References: <20190523084724.14639-1-maxime.chevallier@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 May 2019 09:13:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxime Chevallier <maxime.chevallier@bootlin.com>
Date: Thu, 23 May 2019 10:47:24 +0200

> The flow_rule is only used when configuring the classification tables,
> and should be free'd once we're done using it. The current code only
> frees it in the error path.
> 
> Fixes: 90b509b39ac9 ("net: mvpp2: cls: Add Classification offload support")
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>

Applied, thanks Maxime.
