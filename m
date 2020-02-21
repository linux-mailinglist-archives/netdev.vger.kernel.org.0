Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12D2016880F
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 21:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgBUUFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 15:05:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40656 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbgBUUFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 15:05:31 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4152414958064;
        Fri, 21 Feb 2020 12:05:31 -0800 (PST)
Date:   Fri, 21 Feb 2020 12:05:30 -0800 (PST)
Message-Id: <20200221.120530.2053615303875944335.davem@davemloft.net>
To:     manivannan.sadhasivam@linaro.org
Cc:     kuba@kernel.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvalo@codeaurora.org
Subject: Re: [PATCH v2 0/2] Migrate QRTR Nameservice to Kernel
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200220151327.4823-1-manivannan.sadhasivam@linaro.org>
References: <20200220151327.4823-1-manivannan.sadhasivam@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Feb 2020 12:05:31 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Date: Thu, 20 Feb 2020 20:43:25 +0530

> This patchset migrates the Qualcomm IPC Router (QRTR) Nameservice from userspace
> to kernel under net/qrtr.
> 
> The userspace implementation of it can be found here:
> https://github.com/andersson/qrtr/blob/master/src/ns.c
> 
> This change is required for enabling the WiFi functionality of some Qualcomm
> WLAN devices using ATH11K without any dependency on a userspace daemon. Since
> the QRTR NS is not usually packed in most of the distros, users need to clone,
> build and install it to get the WiFi working. It will become a hassle when the
> user doesn't have any other source of network connectivity.
> 
> The original userspace code is published under BSD3 license. For migrating it
> to Linux kernel, I have adapted Dual BSD/GPL license.
> 
> This patchset has been verified on Dragonboard410c and Intel NUC with QCA6390
> WLAN device.

Series applied, thank you.
