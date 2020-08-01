Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E6A234ECD
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 02:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgHAAA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 20:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgHAAA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 20:00:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8670BC06174A
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 17:00:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D283211E58FA9;
        Fri, 31 Jul 2020 16:44:11 -0700 (PDT)
Date:   Fri, 31 Jul 2020 17:00:56 -0700 (PDT)
Message-Id: <20200731.170056.2160921698138656684.davem@davemloft.net>
To:     ysseung@google.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, ncardwell@google.com,
        soheil@google.com, ycheng@google.com
Subject: Re: [PATCH net-next] tcp: add earliest departure time to
 SCM_TIMESTAMPING_OPT_STATS
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200730224440.2930115-1-ysseung@google.com>
References: <20200730224440.2930115-1-ysseung@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 Jul 2020 16:44:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yousuk Seung <ysseung@google.com>
Date: Thu, 30 Jul 2020 15:44:40 -0700

> This change adds TCP_NLA_EDT to SCM_TIMESTAMPING_OPT_STATS that reports
> the earliest departure time(EDT) of the timestamped skb. By tracking EDT
> values of the skb from different timestamps, we can observe when and how
> much the value changed. This allows to measure the precise delay
> injected on the sender host e.g. by a bpf-base throttler.
> 
> Signed-off-by: Yousuk Seung <ysseung@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Neal Cardwell <ncardwell@google.com>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> Acked-by: Yuchung Cheng <ycheng@google.com>

Applied, thanks.
