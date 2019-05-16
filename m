Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D05F120FFD
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 23:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbfEPV1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 17:27:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33500 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbfEPV1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 17:27:24 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4333712D6C7DF;
        Thu, 16 May 2019 14:27:24 -0700 (PDT)
Date:   Thu, 16 May 2019 14:27:23 -0700 (PDT)
Message-Id: <20190516.142723.557275007944961345.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] net: avoid weird emergency message
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190516150957.217157-1-edumazet@google.com>
References: <20190516150957.217157-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 May 2019 14:27:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu, 16 May 2019 08:09:57 -0700

> When host is under high stress, it is very possible thread
> running netdev_wait_allrefs() returns from msleep(250)
> 10 seconds late.
> 
> This leads to these messages in the syslog :
> 
> [...] unregister_netdevice: waiting for syz_tun to become free. Usage count = 0
> 
> If the device refcount is zero, the wait is over.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied, thanks.
