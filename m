Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5469462C1E
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 00:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfGHWuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 18:50:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59732 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfGHWuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 18:50:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B154512D8E26B;
        Mon,  8 Jul 2019 15:50:22 -0700 (PDT)
Date:   Mon, 08 Jul 2019 15:50:22 -0700 (PDT)
Message-Id: <20190708.155022.248281138752107741.davem@davemloft.net>
To:     maxime.chevallier@bootlin.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, antoine.tenart@bootlin.com,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        mw@semihalf.com
Subject: Re: [PATCH net-next 0/2] net: mvpp2: Add classification based on
 the ETHER flow
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190705120913.25013-1-maxime.chevallier@bootlin.com>
References: <20190705120913.25013-1-maxime.chevallier@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 15:50:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxime Chevallier <maxime.chevallier@bootlin.com>
Date: Fri,  5 Jul 2019 14:09:11 +0200

> Hello everyone,
> 
> This series adds support for classification of the ETHER flow in the
> mvpp2 driver.
> 
> The first patch allows detecting when a user specifies a flow_type that
> isn't supported by the driver, while the second adds support for this
> flow_type by adding the mapping between the ETHER_FLOW enum value and
> the relevant classifier flow entries.

Series applied, thanks.
