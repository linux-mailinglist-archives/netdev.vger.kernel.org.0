Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2156F1EAD1F
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 20:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731128AbgFASmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 14:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731512AbgFASmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 14:42:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D657C00863D;
        Mon,  1 Jun 2020 11:33:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D4D8E11D53F8B;
        Mon,  1 Jun 2020 11:33:51 -0700 (PDT)
Date:   Mon, 01 Jun 2020 11:33:51 -0700 (PDT)
Message-Id: <20200601.113351.412390872566987442.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     vishal@chelsio.com, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] cxgb4: cleanup error code in
 setup_sge_queues_uld()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200528124957.GD1219412@mwanda>
References: <20200528124957.GD1219412@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 11:33:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 28 May 2020 15:49:57 +0300

> The caller doesn't care about the error codes, they only check for zero
> vs non-zero.  Still, it's better to preserve the negative error codes
> from alloc_uld_rxqs() instead of changing it to 1.  We can also return
> directly if there is a failure.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
