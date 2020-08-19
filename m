Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0BB124A745
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 21:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgHSTyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 15:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgHSTyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 15:54:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89EB3C061757;
        Wed, 19 Aug 2020 12:54:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4E77D11D69C3B;
        Wed, 19 Aug 2020 12:37:26 -0700 (PDT)
Date:   Wed, 19 Aug 2020 12:54:09 -0700 (PDT)
Message-Id: <20200819.125409.1636032207096298582.davem@davemloft.net>
To:     linmiaohe@huawei.com
Cc:     kuba@kernel.org, edumazet@google.com, kafai@fb.com,
        daniel@iogearbox.net, jakub@cloudflare.com, keescook@chromium.org,
        zhang.lin16@zte.com.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: Stop warning about SO_BSDCOMPAT usage
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200819083208.17825-1-linmiaohe@huawei.com>
References: <20200819083208.17825-1-linmiaohe@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Aug 2020 12:37:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Date: Wed, 19 Aug 2020 04:32:08 -0400

> We've been warning about SO_BSDCOMPAT usage for many years. We may remove
> this code completely now.
> 
> Suggested-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Applied to net-next, thank you.
