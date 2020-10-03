Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2A0282776
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 01:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgJCXw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 19:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgJCXw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 19:52:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B44C0613D0
        for <netdev@vger.kernel.org>; Sat,  3 Oct 2020 16:52:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4A93E11E3E4C6;
        Sat,  3 Oct 2020 16:36:11 -0700 (PDT)
Date:   Sat, 03 Oct 2020 16:52:58 -0700 (PDT)
Message-Id: <20201003.165258.888778709204794261.davem@davemloft.net>
To:     rdunlap@infradead.org
Cc:     netdev@vger.kernel.org, luobin9@huawei.com, kuba@kernel.org,
        aviad.krawczyk@huawei.com, zhaochen6@huawei.com
Subject: Re: [PATCH net] net: hinic: fix DEVLINK build errors
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201001175449.3808-1-rdunlap@infradead.org>
References: <20201001175449.3808-1-rdunlap@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 03 Oct 2020 16:36:11 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Thu,  1 Oct 2020 10:54:49 -0700

> Fix many (lots deleted here) build errors in hinic by selecting NET_DEVLINK.
 ...
> Fixes: 51ba902a16e6 ("net-next/hinic: Initialize hw interface")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Applied, thank you.
