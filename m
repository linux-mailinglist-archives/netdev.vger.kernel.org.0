Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2DD17B12F
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 23:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgCEWGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 17:06:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:48052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgCEWGH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 17:06:07 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6E462073D;
        Thu,  5 Mar 2020 22:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583445967;
        bh=QePBU6/mz9YQo5vyPYDpTlJxKtAEUtqJOcwVnlJ0RqM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1MU441VM1WmRRvOy2owYRFbq3nO/PtE9hF+f0e09s89EX7YRd53gV95hvV5VyuMLq
         GrhyG4isQh35APdd62mFzeh3Ay+hmDyc7mSFuD/GkIwP9f2LplyhQCsA1k/rYt33XT
         uapqQy+wRqGZn+WcyngEfHkKJY3eIEv4GkbSzWkE=
Date:   Thu, 5 Mar 2020 14:06:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        petrm@mellanox.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 1/5] net: sched: Make FIFO Qdisc offloadable
Message-ID: <20200305140605.5d7e9b4b@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200305071644.117264-2-idosch@idosch.org>
References: <20200305071644.117264-1-idosch@idosch.org>
        <20200305071644.117264-2-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  5 Mar 2020 09:16:40 +0200 Ido Schimmel wrote:
> From: Petr Machata <petrm@mellanox.com>
> 
> Invoke ndo_setup_tc() as appropriate to signal init / replacement,
> destroying and dumping of pFIFO / bFIFO Qdisc.
> 
> A lot of the FIFO logic is used for pFIFO_head_drop as well, but that's a
> semantically very different Qdisc that isn't really in the same boat as
> pFIFO / bFIFO. Split some of the functions to keep the Qdisc intact.
> 
> Signed-off-by: Petr Machata <petrm@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
