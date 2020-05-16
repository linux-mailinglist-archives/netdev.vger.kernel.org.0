Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008B21D63F7
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 22:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgEPUZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 16:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726422AbgEPUZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 16:25:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE77DC061A0C;
        Sat, 16 May 2020 13:25:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C343E1194A8AC;
        Sat, 16 May 2020 13:25:04 -0700 (PDT)
Date:   Sat, 16 May 2020 13:25:04 -0700 (PDT)
Message-Id: <20200516.132504.766576117055386086.davem@davemloft.net>
To:     luobin9@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoxianjun@huawei.com, yin.yinshi@huawei.com,
        cloud.wangxiaoyun@huawei.com
Subject: Re: [PATCH net-next] hinic: add support to set and get pause param
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200516020030.23017-1-luobin9@huawei.com>
References: <20200516020030.23017-1-luobin9@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 May 2020 13:25:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luo bin <luobin9@huawei.com>
Date: Sat, 16 May 2020 02:00:30 +0000

> add support to set pause param with ethtool -A and get pause
> param with ethtool -a. Also remove set_link_ksettings ops for VF.
> 
> Signed-off-by: Luo bin <luobin9@huawei.com>

Why are you using a semaphore and not a plain mutex.

Semaphores should be used as an absolute last resort, and only
after trying vigorously to use other locking primitives.
