Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9DCF22A0B4
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 22:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732809AbgGVUXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 16:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgGVUXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 16:23:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693A1C0619DC;
        Wed, 22 Jul 2020 13:23:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 11FAB1210C0BE;
        Wed, 22 Jul 2020 13:06:27 -0700 (PDT)
Date:   Wed, 22 Jul 2020 13:23:11 -0700 (PDT)
Message-Id: <20200722.132311.31388808811810422.davem@davemloft.net>
To:     stephen@networkplumber.org
Cc:     wangxiongfeng2@huawei.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net-sysfs: add a newline when printing 'tx_timeout'
 by sysfs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200722082741.1675d611@hermes.lan>
References: <1595314977-57991-1-git-send-email-wangxiongfeng2@huawei.com>
        <20200721.153632.1416164807029507588.davem@davemloft.net>
        <20200722082741.1675d611@hermes.lan>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jul 2020 13:06:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>
Date: Wed, 22 Jul 2020 08:27:41 -0700

> On Tue, 21 Jul 2020 15:36:32 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
> 
>> From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
>> Date: Tue, 21 Jul 2020 15:02:57 +0800
>> 
>> > When I cat 'tx_timeout' by sysfs, it displays as follows. It's better to
>> > add a newline for easy reading.
>> > 
>> > root@syzkaller:~# cat /sys/devices/virtual/net/lo/queues/tx-0/tx_timeout
>> > 0root@syzkaller:~#
>> > 
>> > Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>  
>> 
>> Applied, thank you.
> 
> Could you add

Stephen, of all people you should know by now that all of my commits
are %100 immutable.  So commit log changes cannot be made after I've
applied the patch, ever.
