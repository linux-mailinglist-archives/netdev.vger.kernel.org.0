Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50A920994B
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 07:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389860AbgFYFEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 01:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389833AbgFYFEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 01:04:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0EDC061573;
        Wed, 24 Jun 2020 22:04:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9DE7F1288116B;
        Wed, 24 Jun 2020 22:04:51 -0700 (PDT)
Date:   Wed, 24 Jun 2020 22:04:50 -0700 (PDT)
Message-Id: <20200624.220450.570880550629138791.davem@davemloft.net>
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
Subject: Re: [v2,net-next 3/4] net: qos: police action add index for tc
 flower offloading
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200624093631.13719-3-po.liu@nxp.com>
References: <20200623063412.19180-4-po.liu@nxp.com>
        <20200624093631.13719-1-po.liu@nxp.com>
        <20200624093631.13719-3-po.liu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jun 2020 22:04:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po Liu <po.liu@nxp.com>
Date: Wed, 24 Jun 2020 17:36:30 +0800

> From: Po Liu <Po.Liu@nxp.com>
> 
> Hardware device may include more than one police entry. Specifying the
> action's index make it possible for several tc filters to share the same
> police action when installing the filters.
> 
> Propagate this index to device drivers through the flow offload
> intermediate representation, so that drivers could share a single
> hardware policer between multiple filters.
> 
> v1->v2 changes:
> - Update the commit message suggest by Ido Schimmel <idosch@idosch.org>
> 
> Signed-off-by: Po Liu <Po.Liu@nxp.com>

Applied.
