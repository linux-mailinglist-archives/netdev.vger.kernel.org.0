Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9331235776F
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 00:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbhDGWN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 18:13:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43636 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhDGWNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 18:13:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 4B5D84266DBD3;
        Wed,  7 Apr 2021 15:13:15 -0700 (PDT)
Date:   Wed, 07 Apr 2021 15:13:10 -0700 (PDT)
Message-Id: <20210407.151310.197667379826410564.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     aelior@marvell.com, skalluru@marvell.com,
        GR-everest-linux-l2@marvell.com, kuba@kernel.org,
        eilong@broadcom.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bnx2x: Fix potential infinite loop
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210407142802.495539-1-colin.king@canonical.com>
References: <20210407142802.495539-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 07 Apr 2021 15:13:15 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Wed,  7 Apr 2021 15:28:02 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> The for_each_tx_queue loop iterates with a u8 loop counter i and
> compares this with the loop upper limit of bp->num_queues that
> is an int type.  There is a potential infinite loop if bp->num_queues
> is larger than the u8 loop counter. Fix this by making the loop
> counter the same type as bp->num_queues.
> 
> Addresses-Coverity: ("Infinite loop")
> Fixes: ad5afc89365e ("bnx2x: Separate VF and PF logic")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Please show how num_queues can take on a value larger than 255.

Thank you.
