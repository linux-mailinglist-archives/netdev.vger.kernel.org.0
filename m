Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25BE71E18A9
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 03:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388387AbgEZBGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 21:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387888AbgEZBGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 21:06:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B750C061A0E;
        Mon, 25 May 2020 18:06:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C44BE127A593B;
        Mon, 25 May 2020 18:06:45 -0700 (PDT)
Date:   Mon, 25 May 2020 18:06:44 -0700 (PDT)
Message-Id: <20200525.180644.2144373699068176809.davem@davemloft.net>
To:     wu000273@umn.edu
Cc:     shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kjlu@umn.edu
Subject: Re: [PATCH] qlcnic: fix missing release in
 qlcnic_83xx_interrupt_test.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200525082439.14113-1-wu000273@umn.edu>
References: <20200525082439.14113-1-wu000273@umn.edu>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 May 2020 18:06:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wu000273@umn.edu
Date: Mon, 25 May 2020 03:24:39 -0500

> From: Qiushi Wu <wu000273@umn.edu>
> 
> In function qlcnic_83xx_interrupt_test(), function
> qlcnic_83xx_diag_alloc_res() is not handled by function
> qlcnic_83xx_diag_free_res() after a call of the function
> qlcnic_alloc_mbx_args() failed. Fix this issue by adding
> a jump target "fail_mbx_args", and jump to this new target
> when qlcnic_alloc_mbx_args() failed.
> 
> Fixes: b6b4316c8b2f ("qlcnic: Handle qlcnic_alloc_mbx_args() failure")
> Signed-off-by: Qiushi Wu <wu000273@umn.edu>

Applied, thank you.
