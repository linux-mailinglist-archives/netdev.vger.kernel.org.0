Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3148727089C
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 23:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgIRV45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 17:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbgIRV44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 17:56:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22A1C0613CE;
        Fri, 18 Sep 2020 14:56:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E869815A0D92C;
        Fri, 18 Sep 2020 14:40:08 -0700 (PDT)
Date:   Fri, 18 Sep 2020 14:56:55 -0700 (PDT)
Message-Id: <20200918.145655.108889132068479351.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, kuba@kernel.org,
        tuong.t.lien@dektech.com.au, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] tipc: Remove unused macro CF_SERVER
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918131615.20124-1-yuehaibing@huawei.com>
References: <20200918131615.20124-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 14:40:09 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Fri, 18 Sep 2020 21:16:15 +0800

> It is no used any more, so can remove it.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
