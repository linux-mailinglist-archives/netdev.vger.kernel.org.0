Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCB826E9A5
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 01:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbgIQXzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 19:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgIQXzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 19:55:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2A2C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 16:55:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B016A13667312;
        Thu, 17 Sep 2020 16:38:12 -0700 (PDT)
Date:   Thu, 17 Sep 2020 16:54:58 -0700 (PDT)
Message-Id: <20200917.165458.1824135603135069700.davem@davemloft.net>
To:     yangyingliang@huawei.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net-next] netlink: add spaces around '&' in
 netlink_recv/sendmsg()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200917033223.659862-1-yangyingliang@huawei.com>
References: <20200917033223.659862-1-yangyingliang@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 17 Sep 2020 16:38:12 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>
Date: Thu, 17 Sep 2020 11:32:23 +0800

> It's hard to read the code without spaces around '&',
> for better reading, add spaces around '&'.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Applied.
