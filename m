Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8178671FA1
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 20:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387511AbfGWSvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 14:51:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35094 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbfGWSvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 14:51:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8B47C153B91FF;
        Tue, 23 Jul 2019 11:51:12 -0700 (PDT)
Date:   Tue, 23 Jul 2019 11:51:12 -0700 (PDT)
Message-Id: <20190723.115112.1824255524103179323.davem@davemloft.net>
To:     jonathanh@nvidia.com
Cc:     robin.murphy@arm.com, Jose.Abreu@synopsys.com, lists@bofh.nu,
        ilias.apalodimas@linaro.org, Joao.Pinto@synopsys.com,
        alexandre.torgue@st.com, maxime.ripard@bootlin.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, wens@csie.org,
        mcoquelin.stm32@gmail.com, linux-tegra@vger.kernel.org,
        peppe.cavallaro@st.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
From:   David Miller <davem@davemloft.net>
In-Reply-To: <8756d681-e167-fe4a-c6f0-47ae2dcbb100@nvidia.com>
References: <BYAPR12MB32692AF2BA127C5DA5B74804D3C70@BYAPR12MB3269.namprd12.prod.outlook.com>
        <6c769226-bdd9-6fe0-b96b-5a0d800fed24@arm.com>
        <8756d681-e167-fe4a-c6f0-47ae2dcbb100@nvidia.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jul 2019 11:51:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>
Date: Tue, 23 Jul 2019 13:09:00 +0100

> Setting "iommu.passthrough=1" works for me. However, I am not sure where
> to go from here, so any ideas you have would be great.

Then definitely we are accessing outside of a valid IOMMU mapping due
to the page pool support changes.

Such a problem should be spotted with swiommu enabled with debugging.
