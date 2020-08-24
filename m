Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1536C24FE14
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 14:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgHXMyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 08:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgHXMyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 08:54:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10B8C061573;
        Mon, 24 Aug 2020 05:54:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D20B812811098;
        Mon, 24 Aug 2020 05:37:28 -0700 (PDT)
Date:   Mon, 24 Aug 2020 05:54:12 -0700 (PDT)
Message-Id: <20200824.055412.154537872989436066.davem@davemloft.net>
To:     dinghao.liu@zju.edu.cn
Cc:     kjlu@umn.edu, yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        kuba@kernel.org, hkallweit1@gmail.com, Jason@zx2c4.com,
        snelson@pensando.io, mst@redhat.com, liuyonglong@huawei.com,
        yankejian@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: hns: Fix memleak in hns_nic_dev_probe
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200824054444.24142-1-dinghao.liu@zju.edu.cn>
References: <20200824054444.24142-1-dinghao.liu@zju.edu.cn>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 05:37:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>
Date: Mon, 24 Aug 2020 13:44:42 +0800

> hns_nic_dev_probe allocates ndev, but not free it on
> two error handling paths, which may lead to memleak.
> 
> Fixes: 63434888aaf1b ("net: hns: net: hns: enet adds support of acpi")
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>

Applied and queued up for -stable, thanks.
