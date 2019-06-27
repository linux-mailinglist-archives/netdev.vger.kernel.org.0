Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F16F57979
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 04:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfF0CaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 22:30:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45648 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbfF0CaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 22:30:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4D7D414DDE50E;
        Wed, 26 Jun 2019 19:30:12 -0700 (PDT)
Date:   Wed, 26 Jun 2019 19:30:11 -0700 (PDT)
Message-Id: <20190626.193011.1423969728804124428.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, nhorman@tuxdriver.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH net] sctp: change to hold sk after auth shkey is
 created successfully
From:   David Miller <davem@davemloft.net>
In-Reply-To: <14de0d292dc2fe01ecadaba00feb925b337b558f.1561393305.git.lucien.xin@gmail.com>
References: <14de0d292dc2fe01ecadaba00feb925b337b558f.1561393305.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Jun 2019 19:30:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 25 Jun 2019 00:21:45 +0800

> Now in sctp_endpoint_init(), it holds the sk then creates auth
> shkey. But when the creation fails, it doesn't release the sk,
> which causes a sk defcnf leak,
> 
> Here to fix it by only holding the sk when auth shkey is created
> successfully.
> 
> Fixes: a29a5bd4f5c3 ("[SCTP]: Implement SCTP-AUTH initializations.")
> Reported-by: syzbot+afabda3890cc2f765041@syzkaller.appspotmail.com
> Reported-by: syzbot+276ca1c77a19977c0130@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thanks Xin.
