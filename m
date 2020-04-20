Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32EA11B1644
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 21:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgDTTxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 15:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725988AbgDTTxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 15:53:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8C4C061A0C;
        Mon, 20 Apr 2020 12:53:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CE169127FF334;
        Mon, 20 Apr 2020 12:53:20 -0700 (PDT)
Date:   Mon, 20 Apr 2020 12:53:19 -0700 (PDT)
Message-Id: <20200420.125319.1795816205011903490.davem@davemloft.net>
To:     yanaijie@huawei.com
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        michal.kalderon@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] qed: use true,false for bool variables
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200420042720.18815-1-yanaijie@huawei.com>
References: <20200420042720.18815-1-yanaijie@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Apr 2020 12:53:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Yan <yanaijie@huawei.com>
Date: Mon, 20 Apr 2020 12:27:20 +0800

> Fix the following coccicheck warning:
> 
> drivers/net/ethernet/qlogic/qed/qed_dev.c:4395:2-34: WARNING:
> Assignment of 0/1 to bool variable
> drivers/net/ethernet/qlogic/qed/qed_dev.c:1975:2-34: WARNING:
> Assignment of 0/1 to bool variable
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Applied to net-next, thanks.
