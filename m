Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12CDCA9C78
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 09:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731375AbfIEH7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 03:59:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42948 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbfIEH7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 03:59:48 -0400
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 855C41538519F;
        Thu,  5 Sep 2019 00:59:46 -0700 (PDT)
Date:   Thu, 05 Sep 2019 00:59:45 -0700 (PDT)
Message-Id: <20190905.005945.484007088561769938.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, jon.maloy@ericsson.com,
        ying.xue@windriver.com, tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH net] tipc: add NULL pointer check before calling
 kfree_rcu
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f42a6270d821baf1445b5fa40dc201f7c9c5ebd0.1567504392.git.lucien.xin@gmail.com>
References: <f42a6270d821baf1445b5fa40dc201f7c9c5ebd0.1567504392.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Sep 2019 00:59:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Tue,  3 Sep 2019 17:53:12 +0800

> Unlike kfree(p), kfree_rcu(p, rcu) won't do NULL pointer check. When
> tipc_nametbl_remove_publ returns NULL, the panic below happens:
 ...
> Fixes: 97ede29e80ee ("tipc: convert name table read-write lock to RCU")
> Reported-by: Li Shuang <shuali@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thanks.
