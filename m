Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF8E22F633
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 19:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730274AbgG0RK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 13:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728835AbgG0RK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 13:10:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C13C061794;
        Mon, 27 Jul 2020 10:10:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 27C501286DD2E;
        Mon, 27 Jul 2020 09:53:39 -0700 (PDT)
Date:   Mon, 27 Jul 2020 10:10:21 -0700 (PDT)
Message-Id: <20200727.101021.661505441351232064.davem@davemloft.net>
To:     Julia.Lawall@inria.fr
Cc:     linux-net-drivers@solarflare.com, kernel-janitors@vger.kernel.org,
        ecree@solarflare.com, mhabets@solarflare.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] sfc: drop unnecessary list_empty
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1595761112-11003-3-git-send-email-Julia.Lawall@inria.fr>
References: <1595761112-11003-1-git-send-email-Julia.Lawall@inria.fr>
        <1595761112-11003-3-git-send-email-Julia.Lawall@inria.fr>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jul 2020 09:53:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julia Lawall <Julia.Lawall@inria.fr>
Date: Sun, 26 Jul 2020 12:58:27 +0200

> list_for_each_safe is able to handle an empty list.
> The only effect of avoiding the loop is not initializing the
> index variable.
> Drop list_empty tests in cases where these variables are not
> used.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

Applied to net-next.
