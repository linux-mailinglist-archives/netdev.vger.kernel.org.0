Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7841B6713
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 00:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgDWWvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 18:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgDWWvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 18:51:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690F1C09B042;
        Thu, 23 Apr 2020 15:51:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0BEEC127E678B;
        Thu, 23 Apr 2020 15:51:10 -0700 (PDT)
Date:   Thu, 23 Apr 2020 15:51:10 -0700 (PDT)
Message-Id: <20200423.155110.1574910055917042092.davem@davemloft.net>
To:     vulab@iscas.ac.cn
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sched : Remove unnecessary cast in kfree
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200423054313.10535-1-vulab@iscas.ac.cn>
References: <20200423054313.10535-1-vulab@iscas.ac.cn>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Apr 2020 15:51:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xu Wang <vulab@iscas.ac.cn>
Date: Thu, 23 Apr 2020 13:43:13 +0800

> Remove unnecassary casts in the argument to kfree.
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>

Applied to net-next, thanks.
