Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC7565D97D
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbfGCApg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:45:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45208 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbfGCApg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 20:45:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1FC06140093FF;
        Tue,  2 Jul 2019 15:15:21 -0700 (PDT)
Date:   Tue, 02 Jul 2019 15:15:20 -0700 (PDT)
Message-Id: <20190702.151520.28926436187090300.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        jsperbeck@google.com, jarod@redhat.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net
Subject: Re: [PATCH net-next] bonding/main: fix NULL dereference in
 bond_select_active_slave()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190701174851.70293-1-edumazet@google.com>
References: <20190701174851.70293-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jul 2019 15:15:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon,  1 Jul 2019 10:48:51 -0700

> A bonding master can be up while best_slave is NULL.
 ...
> Fixes: e2a7420df2e0 ("bonding/main: convert to using slave printk macros")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: John Sperbeck <jsperbeck@google.com>

Applied, thanks.
