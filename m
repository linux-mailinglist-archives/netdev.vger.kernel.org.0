Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC4B3476F2
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 23:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbfFPVPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 17:15:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52304 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbfFPVPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 17:15:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 54CCE151C3458;
        Sun, 16 Jun 2019 14:15:19 -0700 (PDT)
Date:   Sun, 16 Jun 2019 14:15:18 -0700 (PDT)
Message-Id: <20190616.141518.1767310724813644109.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, willemb@google.com, feng.tang@intel.com,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net] tcp: fix compile error if !CONFIG_SYSCTL
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190615201955.97598-1-edumazet@google.com>
References: <20190615201955.97598-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Jun 2019 14:15:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Sat, 15 Jun 2019 13:19:55 -0700

> tcp_tx_skb_cache_key and tcp_rx_skb_cache_key must be available
> even if CONFIG_SYSCTL is not set.
> 
> Fixes: 0b7d7f6b2208 ("tcp: add tcp_tx_skb_cache sysctl")
> Fixes: ede61ca474a0 ("tcp: add tcp_rx_skb_cache sysctl")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Willem de Bruijn <willemb@google.com>

Applied.
