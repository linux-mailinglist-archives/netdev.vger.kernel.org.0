Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 444235C6E0
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 04:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfGBCB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 22:01:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53780 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbfGBCB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 22:01:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D836814DDFCBF;
        Mon,  1 Jul 2019 19:01:25 -0700 (PDT)
Date:   Mon, 01 Jul 2019 19:01:25 -0700 (PDT)
Message-Id: <20190701.190125.459047387188080362.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+d6636a36d3c34bd88938@syzkaller.appspotmail.com
Subject: Re: [Patch net] netrom: fix a memory leak in nr_rx_frame()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190627213058.3028-1-xiyou.wangcong@gmail.com>
References: <20190627213058.3028-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jul 2019 19:01:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Thu, 27 Jun 2019 14:30:58 -0700

> When the skb is associated with a new sock, just assigning
> it to skb->sk is not sufficient, we have to set its destructor
> to free the sock properly too.
> 
> Reported-by: syzbot+d6636a36d3c34bd88938@syzkaller.appspotmail.com
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable, thanks.
