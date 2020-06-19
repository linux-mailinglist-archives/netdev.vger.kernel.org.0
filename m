Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49AE7201BAD
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 21:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390883AbgFSTyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 15:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387750AbgFSTyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 15:54:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CACAC06174E;
        Fri, 19 Jun 2020 12:54:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F387A12835ABD;
        Fri, 19 Jun 2020 12:54:18 -0700 (PDT)
Date:   Fri, 19 Jun 2020 12:54:16 -0700 (PDT)
Message-Id: <20200619.125416.1386065322120149725.davem@davemloft.net>
To:     po.liu@nxp.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jiri@resnulli.us, vinicius.gomes@intel.com, vlad@buslov.dev,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, stephen@networkplumber.org
Subject: Re: [v2,net-next] net: qos offload add flow status with dropped
 count
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200619060107.6325-1-po.liu@nxp.com>
References: <20200324034745.30979-1-Po.Liu@nxp.com>
        <20200619060107.6325-1-po.liu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Jun 2020 12:54:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po Liu <po.liu@nxp.com>
Date: Fri, 19 Jun 2020 14:01:07 +0800

> From: Po Liu <Po.Liu@nxp.com>
> 
> This patch adds a drop frames counter to tc flower offloading.
> Reporting h/w dropped frames is necessary for some actions.
> Some actions like police action and the coming introduced stream gate
> action would produce dropped frames which is necessary for user. Status
> update shows how many filtered packets increasing and how many dropped
> in those packets.
> 
> v2: Changes
>  - Update commit comments suggest by Jiri Pirko.
> 
> Signed-off-by: Po Liu <Po.Liu@nxp.com>

Applied, thank you.
