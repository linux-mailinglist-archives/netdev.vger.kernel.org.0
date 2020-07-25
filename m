Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E0F22D31C
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 02:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgGYAKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 20:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbgGYAKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 20:10:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FA4C0619D3;
        Fri, 24 Jul 2020 17:10:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2C2E61275D089;
        Fri, 24 Jul 2020 16:53:51 -0700 (PDT)
Date:   Fri, 24 Jul 2020 17:10:35 -0700 (PDT)
Message-Id: <20200724.171035.1263967627297774729.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, kuba@kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][V2] sctp: remove redundant initialization of variable
 status
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200724130919.18497-1-colin.king@canonical.com>
References: <20200724130919.18497-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jul 2020 16:53:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Fri, 24 Jul 2020 14:09:19 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable status is being initialized with a value that is never read
> and it is being updated later with a new value.  The initialization is
> redundant and can be removed.  Also put the variable declarations into
> reverse christmas tree order.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
> 
> V2: put variable declarations into reverse christmas tree order.

Applied to net-next, thanks.
