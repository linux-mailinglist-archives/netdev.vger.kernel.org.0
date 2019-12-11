Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7E9411A0B7
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 02:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbfLKBro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 20:47:44 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:51354 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbfLKBro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 20:47:44 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8EDE71506508A;
        Tue, 10 Dec 2019 17:47:43 -0800 (PST)
Date:   Tue, 10 Dec 2019 17:47:42 -0800 (PST)
Message-Id: <20191210.174742.719483404374318765.davem@davemloft.net>
To:     chenwandun@huawei.com
Cc:     claudiu.manoil@nxp.com, po.liu@nxp.com, vladimir.oltean@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] enetc: remove variable 'tc_max_sized_frame' set but
 not used
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1575973490-88354-1-git-send-email-chenwandun@huawei.com>
References: <1575973490-88354-1-git-send-email-chenwandun@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Dec 2019 17:47:43 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen Wandun <chenwandun@huawei.com>
Date: Tue, 10 Dec 2019 18:24:50 +0800

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/ethernet/freescale/enetc/enetc_qos.c: In function enetc_setup_tc_cbs:
> drivers/net/ethernet/freescale/enetc/enetc_qos.c:195:6: warning: variable tc_max_sized_frame set but not used [-Wunused-but-set-variable]
> 
> Fixes: c431047c4efe ("enetc: add support Credit Based Shaper(CBS) for hardware offload")
> Signed-off-by: Chen Wandun <chenwandun@huawei.com>

Applied to net-next.
