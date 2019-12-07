Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEF91115AFB
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 05:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfLGEvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 23:51:37 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36142 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfLGEvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 23:51:37 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1281A1537E16A;
        Fri,  6 Dec 2019 20:51:37 -0800 (PST)
Date:   Fri, 06 Dec 2019 20:51:36 -0800 (PST)
Message-Id: <20191206.205136.926869407524154741.davem@davemloft.net>
To:     brunocarneirodacunha@usp.br
Cc:     netdev@vger.kernel.org, linux@danielsmartinez.com
Subject: Re: [PATCH] lpc_eth: kernel BUG on remove
From:   David Miller <davem@davemloft.net>
In-Reply-To: <3A5A66BC-5DAB-4408-A904-10D5EDD99158@usp.br>
References: <3A5A66BC-5DAB-4408-A904-10D5EDD99158@usp.br>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Dec 2019 20:51:37 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruno Carneiro da Cunha <brunocarneirodacunha@usp.br>
Date: Thu, 5 Dec 2019 17:16:26 -0300

> We may have found a bug in the nxp/lpc_eth.c driver. The function
> platform_set_drvdata() is called twice, the second time it is
> called, in lpc_mii_init(), it overwrites the struct net_device which
> should be at pdev->dev->driver_data with pldat->mii_bus. When trying
> to remove the driver, in lpc_eth_drv_remove(),
> platform_get_drvdata() will return the pldat->mii_bus pointer and
> try to use it as a struct net_device pointer. This causes
> unregister_netdev to segfault and generate a kernel BUG. Is this
> reproducible?
>
> Signed-off-by: Daniel Martinez <linux@danielsmartinez.com>
> Signed-off-by: Bruno Carneiro da Cunha <brunocarneirodacunha@usp.br>

Patch applied, thanks.
