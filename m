Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54384200083
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbgFSDGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729555AbgFSDGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 23:06:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4F3C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 20:06:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E20B0120ED49A;
        Thu, 18 Jun 2020 20:06:43 -0700 (PDT)
Date:   Thu, 18 Jun 2020 20:06:43 -0700 (PDT)
Message-Id: <20200618.200643.27869075586210896.davem@davemloft.net>
To:     yangyingliang@huawei.com
Cc:     netdev@vger.kernel.org, weiyongjun1@huawei.com
Subject: Re: [PATCH net] net: fix memleak in register_netdevice()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200616093921.2185939-1-yangyingliang@huawei.com>
References: <20200616093921.2185939-1-yangyingliang@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jun 2020 20:06:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>
Date: Tue, 16 Jun 2020 09:39:21 +0000

> I got a memleak report when doing some fuzz test:
 ...
> If call_netdevice_notifiers() failed, then rollback_registered()
> calls netdev_unregister_kobject() which holds the kobject. The
> reference cannot be put because the netdev won't be add to todo
> list, so it will leads a memleak, we need put the reference to
> avoid memleak.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Applied and queued up for -stable, thanks.
