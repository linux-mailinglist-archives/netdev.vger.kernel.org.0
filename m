Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D765B233CAE
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 02:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731017AbgGaAo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 20:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730888AbgGaAo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 20:44:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C710C061574;
        Thu, 30 Jul 2020 17:44:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 38F1B126C49AD;
        Thu, 30 Jul 2020 17:28:09 -0700 (PDT)
Date:   Thu, 30 Jul 2020 17:44:54 -0700 (PDT)
Message-Id: <20200730.174454.1086955191077922322.davem@davemloft.net>
To:     wanghai38@huawei.com
Cc:     kuba@kernel.org, michal.simek@xilinx.com, esben@geanix.com,
        timur@kernel.org, f.fainelli@gmail.com, weiyongjun1@huawei.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: ll_temac: Use
 devm_platform_ioremap_resource_byname()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200730072419.57030-1-wanghai38@huawei.com>
References: <20200730072419.57030-1-wanghai38@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Jul 2020 17:28:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>
Date: Thu, 30 Jul 2020 15:24:19 +0800

> platform_get_resource() may fail and return NULL, so we had better
> check its return value to avoid a NULL pointer dereference a bit later
> in the code. Fix it to use devm_platform_ioremap_resource_byname()
> instead of calling platform_get_resource_byname() and devm_ioremap().
> 
> Fixes: 8425c41d1ef7 ("net: ll_temac: Extend support to non-device-tree platforms")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

Applied to net-next.
