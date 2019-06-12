Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE7BC42E48
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 20:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbfFLSDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 14:03:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39316 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726857AbfFLSDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 14:03:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3FD5E1527F8D7;
        Wed, 12 Jun 2019 11:03:45 -0700 (PDT)
Date:   Wed, 12 Jun 2019 11:03:44 -0700 (PDT)
Message-Id: <20190612.110344.817827105748265826.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next] tcp: add optional per socket transmit delay
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190611030334.138942-1-edumazet@google.com>
References: <20190611030334.138942-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Jun 2019 11:03:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 10 Jun 2019 20:03:34 -0700

> Adding delays to TCP flows is crucial for studying behavior
> of TCP stacks, including congestion control modules.
> 
> Linux offers netem module, but it has unpractical constraints :
> - Need root access to change qdisc
> - Hard to setup on egress if combined with non trivial qdisc like FQ
> - Single delay for all flows.
> 
> EDT (Earliest Departure Time) adoption in TCP stack allows us
> to enable a per socket delay at a very small cost.
> 
> Networking tools can now establish thousands of flows, each of them
> with a different delay, simulating real world conditions.
> 
> This requires FQ packet scheduler or a EDT-enabled NIC.
> 
> This patchs adds TCP_TX_DELAY socket option, to set a delay in
> usec units.
 ...
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied to net-next and build testing.

Thanks.
