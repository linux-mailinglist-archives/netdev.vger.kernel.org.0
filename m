Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C50C13503C
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 01:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgAIAEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 19:04:01 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50002 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbgAIAEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 19:04:01 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 60FE415371C47;
        Wed,  8 Jan 2020 16:04:00 -0800 (PST)
Date:   Wed, 08 Jan 2020 16:03:59 -0800 (PST)
Message-Id: <20200108.160359.356749095676572714.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     mkubecek@suse.cz, f.fainelli@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] ethtool: fix ->reply_size() error handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200108054125.feeckqg6xhab3wam@kili.mountain>
References: <20200108054125.feeckqg6xhab3wam@kili.mountain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jan 2020 16:04:00 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 8 Jan 2020 08:41:25 +0300

> The "ret < 0" comparison is never true because "ret" is still zero.
> 
> Fixes: 728480f12442 ("ethtool: default handlers for GET requests")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
