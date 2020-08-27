Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3FA1254714
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 16:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgH0Ohm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 10:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbgH0Ohg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 10:37:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D88C061264;
        Thu, 27 Aug 2020 07:37:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CADEC127504A2;
        Thu, 27 Aug 2020 07:20:47 -0700 (PDT)
Date:   Thu, 27 Aug 2020 07:37:33 -0700 (PDT)
Message-Id: <20200827.073733.1876161431562899494.davem@davemloft.net>
To:     himadrispandya@gmail.com
Cc:     kuba@kernel.org, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] net: usb: Fix uninit-was-stored issue in
 asix_read_phy_addr()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200827065355.15177-1-himadrispandya@gmail.com>
References: <20200827065355.15177-1-himadrispandya@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Aug 2020 07:20:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Himadri Pandya <himadrispandya@gmail.com>
Date: Thu, 27 Aug 2020 12:23:55 +0530

> The buffer size is 2 Bytes and we expect to receive the same amount of
> data. But sometimes we receive less data and run into uninit-was-stored
> issue upon read. Hence modify the error check on the return value to match
> with the buffer size as a prevention.
> 
> Reported-and-tested by: syzbot+a7e220df5a81d1ab400e@syzkaller.appspotmail.com
> Signed-off-by: Himadri Pandya <himadrispandya@gmail.com>

Applied, thanks.
