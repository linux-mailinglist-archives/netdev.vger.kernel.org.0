Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733D8355FAD
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240992AbhDFXqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbhDFXqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 19:46:08 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E29C06174A;
        Tue,  6 Apr 2021 16:46:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 7E1244D2493AD;
        Tue,  6 Apr 2021 16:45:59 -0700 (PDT)
Date:   Tue, 06 Apr 2021 16:45:59 -0700 (PDT)
Message-Id: <20210406.164559.1676626074998403447.davem@davemloft.net>
To:     zhengyongjun3@huawei.com
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, kuba@kernel.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, hulkci@huawei.com
Subject: Re: [PATCH net-next] net: tipc: Fix spelling errors in net/tipc
 module
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210406151909.298732-1-zhengyongjun3@huawei.com>
References: <20210406151909.298732-1-zhengyongjun3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 06 Apr 2021 16:45:59 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>
Date: Tue, 6 Apr 2021 23:19:09 +0800

> These patches fix a series of spelling errors in net/tipc module.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

This does not apply to net-next, please respin.

Thanks.
