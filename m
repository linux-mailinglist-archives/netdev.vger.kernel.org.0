Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1909A9EF7
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 11:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387629AbfIEJ5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 05:57:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43908 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbfIEJ5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 05:57:08 -0400
Received: from localhost (unknown [89.248.140.11])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C9556153878CC;
        Thu,  5 Sep 2019 02:57:06 -0700 (PDT)
Date:   Thu, 05 Sep 2019 11:57:05 +0200 (CEST)
Message-Id: <20190905.115705.2055196374824241901.davem@davemloft.net>
To:     john.fastabend@gmail.com
Cc:     hdanton@sina.com, jakub.kicinski@netronome.com,
        netdev@vger.kernel.org
Subject: Re: [net PATCH] net: sock_map, fix missing ulp check in sock hash
 case
From:   David Miller <davem@davemloft.net>
In-Reply-To: <156754228993.21629.4076822768659778848.stgit@john-Precision-5820-Tower>
References: <156754228993.21629.4076822768659778848.stgit@john-Precision-5820-Tower>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Sep 2019 02:57:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>
Date: Tue, 03 Sep 2019 13:24:50 -0700

> sock_map and ULP only work together when ULP is loaded after the sock
> map is loaded. In the sock_map case we added a check for this to fail
> the load if ULP is already set. However, we missed the check on the
> sock_hash side.
> 
> Add a ULP check to the sock_hash update path.
> 
> Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
> Reported-by: syzbot+7a6ee4d0078eac6bf782@syzkaller.appspotmail.com
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Applied and queued up for -stable, thanks.
