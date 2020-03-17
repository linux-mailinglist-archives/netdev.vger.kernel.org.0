Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4680418776A
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 02:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733175AbgCQBZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 21:25:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50588 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733114AbgCQBZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 21:25:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 232ED157A55C2;
        Mon, 16 Mar 2020 18:25:11 -0700 (PDT)
Date:   Mon, 16 Mar 2020 18:25:10 -0700 (PDT)
Message-Id: <20200316.182510.943116149103375831.davem@davemloft.net>
To:     hqjagain@gmail.com
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, kuba@kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sctp: fix refcount bug in sctp_wfree
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1584330804-18477-1-git-send-email-hqjagain@gmail.com>
References: <1584330804-18477-1-git-send-email-hqjagain@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Mar 2020 18:25:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qiujun Huang <hqjagain@gmail.com>
Date: Mon, 16 Mar 2020 11:53:24 +0800

> Do accounting for skb's real sk.
> In some case skb->sk != asoc->base.sk.
> 
> Reported-and-tested-by: syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com
> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>

SCTP folks, please review.
