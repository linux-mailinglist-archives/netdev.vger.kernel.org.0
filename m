Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3651BC9380
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 23:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729537AbfJBV27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 17:28:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37144 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728883AbfJBV26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 17:28:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 837011550E35B;
        Wed,  2 Oct 2019 14:28:58 -0700 (PDT)
Date:   Wed, 02 Oct 2019 14:28:57 -0700 (PDT)
Message-Id: <20191002.142857.103707051355196502.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next] net_sched: remove need_resched() from
 qdisc_run()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191001210236.176111-1-edumazet@google.com>
References: <20191001210236.176111-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 02 Oct 2019 14:28:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue,  1 Oct 2019 14:02:36 -0700

> Now is the time to remove the schedule point, since the default
> limit of 64 packets matches the number of packets a typical NAPI
> poll can process in a row.
 ...

Agreed.

Applied.
