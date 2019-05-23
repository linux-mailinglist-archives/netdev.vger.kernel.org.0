Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFBB283A6
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 18:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731155AbfEWQad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 12:30:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48552 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730790AbfEWQac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 12:30:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3E2541509BAEC;
        Thu, 23 May 2019 09:30:32 -0700 (PDT)
Date:   Thu, 23 May 2019 09:30:31 -0700 (PDT)
Message-Id: <20190523.093031.456990380849413310.davem@davemloft.net>
To:     andreas.oetken@siemens.com
Cc:     andreas@oetken.name, m-karicheri2@ti.com, a-kramer@ti.com,
        arvid.brodin@alten.se, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4] hsr: fix don't prune the master node from the
 node_db
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190523115714.19412-1-andreas.oetken@siemens.com>
References: <20190523115714.19412-1-andreas.oetken@siemens.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 May 2019 09:30:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andreas Oetken <andreas.oetken@siemens.com>
Date: Thu, 23 May 2019 13:57:14 +0200

> Don't prune the master node in the hsr_prune_nodes function.
> Neither time_in[HSR_PT_SLAVE_A] nor time_in[HSR_PT_SLAVE_B]
> will ever be updated by hsr_register_frame_in for the master port.
> Thus, the master node will be repeatedly pruned leading to
> repeated packet loss.
> This bug never appeared because the hsr_prune_nodes function
> was only called once. Since commit 5150b45fd355
> ("net: hsr: Fix node prune function for forget time expiry") this issue
> is fixed unveiling the issue described above.
> 
> Fixes: 5150b45fd355 ("net: hsr: Fix node prune function for forget time expiry")
> Signed-off-by: Andreas Oetken <andreas.oetken@siemens.com>
> Tested-by: Murali Karicheri <m-karicheri2@ti.com>

Applied.
