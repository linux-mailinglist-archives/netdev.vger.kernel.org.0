Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329A326D008
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 02:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgIQAjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 20:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgIQAjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 20:39:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE37C06174A;
        Wed, 16 Sep 2020 17:39:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7BA3413C788AB;
        Wed, 16 Sep 2020 17:22:28 -0700 (PDT)
Date:   Wed, 16 Sep 2020 17:39:14 -0700 (PDT)
Message-Id: <20200916.173914.735810705311066748.davem@davemloft.net>
To:     liushixin2@huawei.com
Cc:     vishal@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] cxgb4vf: convert to use DEFINE_SEQ_ATTRIBUTE
 macro
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200916025018.3992419-1-liushixin2@huawei.com>
References: <20200916025018.3992419-1-liushixin2@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 16 Sep 2020 17:22:28 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Liu Shixin <liushixin2@huawei.com>
Date: Wed, 16 Sep 2020 10:50:18 +0800

> Use DEFINE_SEQ_ATTRIBUTE macro to simplify the code.
> 
> Signed-off-by: Liu Shixin <liushixin2@huawei.com>

Looks good, applied to net-next, thanks.
