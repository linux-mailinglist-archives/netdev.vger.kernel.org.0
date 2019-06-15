Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA3846DFD
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 05:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfFODSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 23:18:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58042 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfFODSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 23:18:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0AED01426651D;
        Fri, 14 Jun 2019 20:18:41 -0700 (PDT)
Date:   Fri, 14 Jun 2019 20:18:40 -0700 (PDT)
Message-Id: <20190614.201840.1535431493194799515.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, willemb@google.com, feng.tang@intel.com,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net 0/4] tcp: add three static keys
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190614232221.248392-1-edumazet@google.com>
References: <20190614232221.248392-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 20:18:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri, 14 Jun 2019 16:22:17 -0700

> Recent addition of per TCP socket rx/tx cache brought
> regressions for some workloads, as reported by Feng Tang.
> 
> It seems better to make them opt-in, before we adopt better
> heuristics.
> 
> The last patch adds high_order_alloc_disable sysctl
> to ask TCP sendmsg() to exclusively use order-0 allocations,
> as mm layer has specific optimizations.

Series applied.
