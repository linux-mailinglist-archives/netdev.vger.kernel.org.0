Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4733914940F
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 10:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgAYJK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 04:10:26 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48690 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgAYJK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 04:10:26 -0500
Received: from localhost (unknown [147.229.117.36])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4106115A1AD1F;
        Sat, 25 Jan 2020 01:10:24 -0800 (PST)
Date:   Sat, 25 Jan 2020 10:10:15 +0100 (CET)
Message-Id: <20200125.101015.1746094284319700109.davem@davemloft.net>
To:     ajaykuee@gmail.com
Cc:     mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        joabreu@synopsys.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, ajayg@nvidia.com
Subject: Re: [PATCH] net: stmmac: platform: fix probe for ACPI devices
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200123011635.15137-1-ajayg@nvidia.com>
References: <20200123011635.15137-1-ajayg@nvidia.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Jan 2020 01:10:25 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ajay Gupta <ajaykuee@gmail.com>
Date: Wed, 22 Jan 2020 17:16:35 -0800

> From: Ajay Gupta <ajayg@nvidia.com>
> 
> Use generic device API to get phy mode to fix probe failure
> with ACPI based devices.
> 
> Signed-off-by: Ajay Gupta <ajayg@nvidia.com>

Applied, thanks.
