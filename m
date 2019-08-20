Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A61FC96978
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 21:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730723AbfHTT31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 15:29:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50084 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730273AbfHTT31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 15:29:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3AA9F146D389B;
        Tue, 20 Aug 2019 12:29:26 -0700 (PDT)
Date:   Tue, 20 Aug 2019 12:29:25 -0700 (PDT)
Message-Id: <20190820.122925.1080288470348205792.davem@davemloft.net>
To:     haiyangz@microsoft.com
Cc:     sashal@kernel.org, saeedm@mellanox.com, leon@kernel.org,
        eranbe@mellanox.com, lorenzo.pieralisi@arm.com,
        bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        kys@microsoft.com, sthemmin@microsoft.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next,v2 2/6] PCI: hv: Add a Hyper-V PCI interface
 driver for software backchannel interface
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566242976-108801-3-git-send-email-haiyangz@microsoft.com>
References: <1566242976-108801-1-git-send-email-haiyangz@microsoft.com>
        <1566242976-108801-3-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 20 Aug 2019 12:29:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Mon, 19 Aug 2019 19:30:47 +0000

> +static void __exit exit_hv_pci_intf(void)
> +{
> +	pr_info("unloaded\n");
> +}
> +
> +static int __init init_hv_pci_intf(void)
> +{
> +	pr_info("loaded\n");
> +

Clogging up the logs with useless messages like this is inappropriate.
Please remove these pr_info() calls.

Also, all of these symbols should probably be GPL exported.
