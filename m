Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14A302CE63
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbfE1SUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 14:20:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49522 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727428AbfE1SUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 14:20:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 352F812DAD570;
        Tue, 28 May 2019 11:20:20 -0700 (PDT)
Date:   Tue, 28 May 2019 11:20:19 -0700 (PDT)
Message-Id: <20190528.112019.816281435273023187.davem@davemloft.net>
To:     maxime.chevallier@bootlin.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        antoine.tenart@bootlin.com, thomas.petazzoni@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, stefanc@marvell.com, mw@semihalf.com,
        linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org,
        lkp@intel.com, dan.carpenter@oracle.com
Subject: Re: [PATCH net-next] net: mvpp2: cls: Check RSS table index
 validity when creating a context
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190527115201.12721-1-maxime.chevallier@bootlin.com>
References: <20190527115201.12721-1-maxime.chevallier@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 May 2019 11:20:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxime Chevallier <maxime.chevallier@bootlin.com>
Date: Mon, 27 May 2019 13:52:01 +0200

> Make sure we don't use an out-of-bound index for the per-port RSS
> context array.
> 
> As of today, the global context creation in mvpp22_rss_context_create
> will prevent us from reaching this case, but we should still make sure
> we are using a sane value anyway.
> 
> Reported-by: kbuild test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>

Applied.
