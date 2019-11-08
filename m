Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFA2F3E75
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 04:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbfKHDl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 22:41:59 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52632 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbfKHDl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 22:41:59 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C32C514EBB7A9;
        Thu,  7 Nov 2019 19:41:58 -0800 (PST)
Date:   Thu, 07 Nov 2019 19:41:56 -0800 (PST)
Message-Id: <20191107.194156.2189564128567853310.davem@davemloft.net>
To:     michael@walle.cc
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        claudiu.manoil@nxp.com, andrew@lunn.ch
Subject: Re: [PATCH] enetc: fix return value for enetc_ioctl()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191107235821.12767-1-michael@walle.cc>
References: <20191107235821.12767-1-michael@walle.cc>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 19:41:59 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Walle <michael@walle.cc>
Date: Fri,  8 Nov 2019 00:58:21 +0100

> Return -EOPNOTSUPP instead of -EINVAL if the requested ioctl is not
> implemented.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Always specificy explcitly the target tree for your change, in the
Subject line, which in this case should have been:

	[PATCH net-next] enetc: ...
