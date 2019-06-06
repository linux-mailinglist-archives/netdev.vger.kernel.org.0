Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F45837B3E
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 19:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730235AbfFFRj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 13:39:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54682 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728646AbfFFRjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 13:39:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D6B7014DD4FB6;
        Thu,  6 Jun 2019 10:39:24 -0700 (PDT)
Date:   Thu, 06 Jun 2019 10:39:24 -0700 (PDT)
Message-Id: <20190606.103924.1369913278652387015.davem@davemloft.net>
To:     maxime.chevallier@bootlin.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        antoine.tenart@bootlin.com, thomas.petazzoni@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, stefanc@marvell.com, mw@semihalf.com
Subject: Re: [PATCH net] net: mvpp2: Use strscpy to handle stat strings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190606084256.3703-1-maxime.chevallier@bootlin.com>
References: <20190606084256.3703-1-maxime.chevallier@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Jun 2019 10:39:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxime Chevallier <maxime.chevallier@bootlin.com>
Date: Thu,  6 Jun 2019 10:42:56 +0200

> Use a safe strscpy call to copy the ethtool stat strings into the
> relevant buffers, instead of a memcpy that will be accessing
> out-of-bound data.
> 
> Fixes: 118d6298f6f0 ("net: mvpp2: add ethtool GOP statistics")
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>

Applied and queued up for -stable.
