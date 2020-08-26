Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7364E253A59
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 00:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgHZWsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 18:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgHZWsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 18:48:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8442FC061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 15:48:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1CB4D128E5E95;
        Wed, 26 Aug 2020 15:31:27 -0700 (PDT)
Date:   Wed, 26 Aug 2020 15:48:12 -0700 (PDT)
Message-Id: <20200826.154812.1454781316271352545.davem@davemloft.net>
To:     vinicius.gomes@intel.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, vladimir.oltean@nxp.com, kurt@linutronix.de
Subject: Re: [PATCH net-next v1] taprio: Fix using wrong queues in gate mask
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200825174404.2727633-1-vinicius.gomes@intel.com>
References: <20200825174404.2727633-1-vinicius.gomes@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Aug 2020 15:31:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date: Tue, 25 Aug 2020 10:44:04 -0700

> Since commit 9c66d1564676 ("taprio: Add support for hardware
> offloading") there's a bit of inconsistency when offloading schedules
> to the hardware:
> 
> In software mode, the gate masks are specified in terms of traffic
> classes, so if say "sched-entry S 03 20000", it means that the traffic
> classes 0 and 1 are open for 20us; when taprio is offloaded to
> hardware, the gate masks are specified in terms of hardware queues.
> 
> The idea here is to fix hardware offloading, so schedules in hardware
> and software mode have the same behavior. What's needed to do is to
> map traffic classes to queues when applying the offload to the driver.
> 
> Fixes: 9c66d1564676 ("taprio: Add support for hardware offloading")
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

As a bug fix I've applied this to 'net' and queued it up for -stable as
well, thank you.
