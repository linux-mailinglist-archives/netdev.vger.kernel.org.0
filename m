Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9CD51FA0E3
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 22:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731049AbgFOUCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 16:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728773AbgFOUCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 16:02:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A0DC061A0E;
        Mon, 15 Jun 2020 13:02:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 48A53120ED49A;
        Mon, 15 Jun 2020 13:02:16 -0700 (PDT)
Date:   Mon, 15 Jun 2020 13:02:15 -0700 (PDT)
Message-Id: <20200615.130215.401888060274877652.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     radhey.shyam.pandey@xilinx.com, kuba@kernel.org,
        michal.simek@xilinx.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: axienet: fix spelling mistake in comment
 "Exteneded" -> "extended"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200615082911.7252-1-colin.king@canonical.com>
References: <20200615082911.7252-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Jun 2020 13:02:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Mon, 15 Jun 2020 09:29:11 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a comment. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, thanks.
