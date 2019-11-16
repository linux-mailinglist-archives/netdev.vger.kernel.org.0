Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 987C1FF590
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 21:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbfKPUtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 15:49:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53596 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727385AbfKPUtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 15:49:33 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9E6401518AA4D;
        Sat, 16 Nov 2019 12:49:32 -0800 (PST)
Date:   Sat, 16 Nov 2019 12:49:32 -0800 (PST)
Message-Id: <20191116.124932.1614312576197513633.davem@davemloft.net>
To:     po.liu@nxp.com
Cc:     ivan.khoronzhuk@linaro.org, claudiu.manoil@nxp.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vinicius.gomes@intel.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        roy.zang@nxp.com, mingkai.hu@nxp.com, jerry.huang@nxp.com,
        leoyang.li@nxp.com
Subject: Re: [v4,net-next, 1/2] enetc: Configure the Time-Aware Scheduler
 via tc-taprio offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191115031846.4871-1-Po.Liu@nxp.com>
References: <20191114045833.18064-2-Po.Liu@nxp.com>
        <20191115031846.4871-1-Po.Liu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 Nov 2019 12:49:33 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po Liu <po.liu@nxp.com>
Date: Fri, 15 Nov 2019 03:33:33 +0000

> ENETC supports in hardware for time-based egress shaping according
> to IEEE 802.1Qbv. This patch implement the Qbv enablement by the
> hardware offload method qdisc tc-taprio method.
> Also update cbdr writeback to up level since control bd ring may
> writeback data to control bd ring.
> 
> Signed-off-by: Po Liu <Po.Liu@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>

Applied.
