Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBCDEB8A7
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 22:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729825AbfJaVCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 17:02:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60968 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbfJaVCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 17:02:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B196814FF95DD;
        Thu, 31 Oct 2019 14:02:18 -0700 (PDT)
Date:   Thu, 31 Oct 2019 14:02:18 -0700 (PDT)
Message-Id: <20191031.140218.1305911211417298702.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        ncardwell@google.com, ycheng@google.com, w@1wt.eu, ycao009@ucr.edu
Subject: Re: [PATCH net] tcp: increase tcp_max_syn_backlog max value
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191030170546.146784-1-edumazet@google.com>
References: <20191030170546.146784-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Oct 2019 14:02:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 30 Oct 2019 10:05:46 -0700

> tcp_max_syn_backlog default value depends on memory size
> and TCP ehash size. Before this patch, the max value
> was 2048 [1], which is considered too small nowadays.
> 
> Increase it to 4096 to match the recent SOMAXCONN change.
> 
> [1] This is with TCP ehash size being capped to 524288 buckets.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied.
