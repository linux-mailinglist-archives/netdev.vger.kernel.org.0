Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C1720C506
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 02:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgF1Aln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 20:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgF1Alm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 20:41:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8175C061794
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 17:41:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 51B9313C43B4D;
        Sat, 27 Jun 2020 17:41:42 -0700 (PDT)
Date:   Sat, 27 Jun 2020 17:41:41 -0700 (PDT)
Message-Id: <20200627.174141.1720553661078489178.davem@davemloft.net>
To:     ysseung@google.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] tcp: improve delivered counts in
 SCM_TSTAMP_ACK
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200627040535.858564-1-ysseung@google.com>
References: <20200627040535.858564-1-ysseung@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 27 Jun 2020 17:41:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yousuk Seung <ysseung@google.com>
Date: Fri, 26 Jun 2020 21:05:31 -0700

> Currently delivered and delivered_ce in OPT_STATS of SCM_TSTAMP_ACK do
> not fully reflect the current ack being timestamped. Also they are not
> in sync as the delivered count includes packets being sacked and some of
> cumulatively acked but delivered_ce includes none.
> 
> This patch series updates tp->delivered and tp->delivered_ce together to
> keep them in sync. It also moves generating SCM_TSTAMP_ACK to later in
> tcp_clean_rtx_queue() to reflect packets being cumulatively acked up
> until the current skb for sack-enabled connections.

Series applied, thank you.
