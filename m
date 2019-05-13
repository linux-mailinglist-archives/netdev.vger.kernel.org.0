Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD801BB5F
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 18:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731089AbfEMQ4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 12:56:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40024 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731063AbfEMQ4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 12:56:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D647814E266D0;
        Mon, 13 May 2019 09:56:22 -0700 (PDT)
Date:   Mon, 13 May 2019 09:56:21 -0700 (PDT)
Message-Id: <20190513.095621.1645129482960405173.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     linux-omap@vger.kernel.org, netdev@vger.kernel.org, nsekhar@ti.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: ethernet: ti: netcp_ethss: fix build
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1557753396-12367-1-git-send-email-grygorii.strashko@ti.com>
References: <1557753396-12367-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 May 2019 09:56:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Mon, 13 May 2019 16:16:36 +0300

> Fix reported build fail:
> ERROR: "cpsw_ale_flush_multicast" [drivers/net/ethernet/ti/keystone_netcp_ethss.ko] undefined!
> ERROR: "cpsw_ale_create" [drivers/net/ethernet/ti/keystone_netcp_ethss.ko] undefined!
> ERROR: "cpsw_ale_add_vlan" [drivers/net/ethernet/ti/keystone_netcp_ethss.ko] undefined!
> 
> Fixes: 16f54164828b ("net: ethernet: ti: cpsw: drop CONFIG_TI_CPSW_ALE config option")
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Applied, thank you.
