Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2111B183AC6
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 21:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgCLUni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 16:43:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726246AbgCLUni (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 16:43:38 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFBF2206CD;
        Thu, 12 Mar 2020 20:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584045818;
        bh=UHBjkjFZGaMpEDn7u4B18VvX1rueHGDOSfN844jzYwg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dcsv4khfxEX1eVIUxR5peEmdp6rOVSyojkAZW2iHykunRtwAFPPBZVRIuRNrB1nn5
         kunqK48XqdSIaEqeSY2fO3IxMCm72wcjAXKHnHSvBy3LlJ4xQgL69VRkTvdrNtK4Ar
         ct/tPQvA7rKy+IWxtFZZaLwV04qBzCh5JY0qePiY=
Date:   Thu, 12 Mar 2020 13:43:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@mellanox.com>
Cc:     netdev@vger.kernel.org, Roman Mashak <mrv@mojatatu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [PATCH net-next v3 3/6] net: sched: RED: Introduce an ECN
 nodrop mode
Message-ID: <20200312134336.5a05a9ec@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200312180507.6763-4-petrm@mellanox.com>
References: <20200312180507.6763-1-petrm@mellanox.com>
        <20200312180507.6763-4-petrm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Mar 2020 20:05:04 +0200 Petr Machata wrote:
> When the RED Qdisc is currently configured to enable ECN, the RED algorithm
> is used to decide whether a certain SKB should be marked. If that SKB is
> not ECN-capable, it is early-dropped.
> 
> It is also possible to keep all traffic in the queue, and just mark the
> ECN-capable subset of it, as appropriate under the RED algorithm. Some
> switches support this mode, and some installations make use of it.
> 
> To that end, add a new RED flag, TC_RED_NODROP. When the Qdisc is
> configured with this flag, non-ECT traffic is enqueued instead of being
> early-dropped.
> 
> Signed-off-by: Petr Machata <petrm@mellanox.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
