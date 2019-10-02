Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C569C4577
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 03:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729667AbfJBBX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 21:23:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55264 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728984AbfJBBX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 21:23:57 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:b5c5:ae11:3e54:6a07])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1003014D65306;
        Tue,  1 Oct 2019 18:23:56 -0700 (PDT)
Date:   Tue, 01 Oct 2019 21:23:55 -0400 (EDT)
Message-Id: <20191001.212355.540884408544073853.davem@davemloft.net>
To:     decui@microsoft.com
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, stefanha@redhat.com, gregkh@linuxfoundation.org,
        arnd@arndb.de, deepa.kernel@gmail.com, ytht.net@gmail.com,
        tglx@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        mikelley@microsoft.com, sgarzare@redhat.com, jhansen@vmware.com
Subject: Re: [PATCH net v3] vsock: Fix a lockdep warning in
 __vsock_release()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1569868998-56603-1-git-send-email-decui@microsoft.com>
References: <1569868998-56603-1-git-send-email-decui@microsoft.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 18:23:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>
Date: Mon, 30 Sep 2019 18:43:50 +0000

> Lockdep is unhappy if two locks from the same class are held.
> 
> Fix the below warning for hyperv and virtio sockets (vmci socket code
> doesn't have the issue) by using lock_sock_nested() when __vsock_release()
> is called recursively:
 ...
> Tested-by: Stefano Garzarella <sgarzare@redhat.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>

Applied, thanks.
