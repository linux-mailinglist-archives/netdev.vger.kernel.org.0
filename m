Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644A5209948
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 07:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389822AbgFYFEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 01:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389467AbgFYFEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 01:04:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E84C061573;
        Wed, 24 Jun 2020 22:04:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 028D112881172;
        Wed, 24 Jun 2020 22:04:45 -0700 (PDT)
Date:   Wed, 24 Jun 2020 22:04:45 -0700 (PDT)
Message-Id: <20200624.220445.806404128928129208.davem@davemloft.net>
To:     po.liu@nxp.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        idosch@idosch.org, jiri@resnulli.us, vinicius.gomes@intel.com,
        vlad@buslov.dev, claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, stephen@networkplumber.org
Subject: Re: [v2,net-next 2/4] net: enetc: add support max frame size for
 tc flower offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200624093631.13719-2-po.liu@nxp.com>
References: <20200623063412.19180-4-po.liu@nxp.com>
        <20200624093631.13719-1-po.liu@nxp.com>
        <20200624093631.13719-2-po.liu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jun 2020 22:04:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po Liu <po.liu@nxp.com>
Date: Wed, 24 Jun 2020 17:36:29 +0800

> From: Po Liu <Po.Liu@nxp.com>
> 
> Base on the tc flower offload police action add max frame size by the
> parameter 'mtu'. Tc flower device driver working by the IEEE 802.1Qci
> stream filter can implement the max frame size filtering. Add it to the
> current hardware tc flower stearm filter driver.
> 
> Signed-off-by: Po Liu <Po.Liu@nxp.com>

Applied.
