Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E29201C65
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 22:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389383AbgFSUa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 16:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387641AbgFSUa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 16:30:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA431C06174E;
        Fri, 19 Jun 2020 13:30:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A425F11D69C3E;
        Fri, 19 Jun 2020 13:30:57 -0700 (PDT)
Date:   Fri, 19 Jun 2020 13:30:57 -0700 (PDT)
Message-Id: <20200619.133057.1092745697470215527.davem@davemloft.net>
To:     gustavoars@kernel.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gustavo@embeddedor.com
Subject: Re: [PATCH][next] ethernet: ti: am65-cpsw-qos: Use struct_size()
 in devm_kzalloc()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200619173715.GA6998@embeddedor>
References: <20200619173715.GA6998@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Jun 2020 13:30:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Date: Fri, 19 Jun 2020 12:37:15 -0500

> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes. Also, remove unnecessary
> variable _size_.
> 
> This code was detected with the help of Coccinelle and, audited and
> fixed manually.
> 
> Addresses-KSPP-ID: https://github.com/KSPP/linux/issues/83
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Applied, thank you.
