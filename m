Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB7A11DB75
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 02:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbfLMBFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 20:05:08 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46762 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbfLMBFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 20:05:08 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 69F7915421AED;
        Thu, 12 Dec 2019 17:05:07 -0800 (PST)
Date:   Thu, 12 Dec 2019 17:05:06 -0800 (PST)
Message-Id: <20191212.170506.1014670344797867509.davem@davemloft.net>
To:     ktkhai@virtuozzo.com
Cc:     netdev@vger.kernel.org, axboe@kernel.dk,
        pankaj.laxminarayan.bharadiya@intel.com, keescook@chromium.org,
        viro@zeniv.linux.org.uk, hare@suse.com, tglx@linutronix.de,
        edumazet@google.com, arnd@arndb.de
Subject: Re: [PATCH net-next v2 0/2] unix: Show number of scm files in
 fdinfo
From:   David Miller <davem@davemloft.net>
In-Reply-To: <157588565669.223723.2766246342567340687.stgit@localhost.localdomain>
References: <157588565669.223723.2766246342567340687.stgit@localhost.localdomain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Dec 2019 17:05:07 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kirill Tkhai <ktkhai@virtuozzo.com>
Date: Mon, 09 Dec 2019 13:03:34 +0300

> v2: Pass correct argument to locked in patch [2/2].
> 
> Unix sockets like a block box. You never know what is pending there:
> there may be a file descriptor holding a mount or a block device,
> or there may be whole universes with namespaces, sockets with receive
> queues full of sockets etc.
> 
> The patchset makes number of pending scm files be visible in fdinfo.
> This may be useful to determine, that socket should be investigated
> or which task should be killed to put a reference counter on a resourse.
> 
> $cat /proc/[pid]/fdinfo/[unix_sk_fd] | grep scm_fds
> scm_fds: 1

Series applied.
