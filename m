Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7437D1238E8
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbfLQVzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:55:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43396 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfLQVzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:55:42 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 51F9B146CF6E0;
        Tue, 17 Dec 2019 13:55:41 -0800 (PST)
Date:   Tue, 17 Dec 2019 13:55:40 -0800 (PST)
Message-Id: <20191217.135540.2268575994795714403.davem@davemloft.net>
To:     ajaykuee@gmail.com
Cc:     netdev@vger.kernel.org, treding@nvidia.com, ajayg@nvidia.com
Subject: Re: [PATCH v3 0/2] net: stmmac: dwc-qos: ACPI device support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191216061452.6514-1-ajayg@nvidia.com>
References: <20191216061452.6514-1-ajayg@nvidia.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Dec 2019 13:55:41 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ajay Gupta <ajaykuee@gmail.com>
Date: Sun, 15 Dec 2019 22:14:50 -0800

> These two changes are needed to enable ACPI based devices to use stmmac
> driver. First patch is to use generic device api (device_*) instead of
> device tree based api (of_*). Second patch avoids clock and reset accesses
> for Tegra ACPI based devices. ACPI interface will be used to access clock
> and reset for Tegra ACPI devices in later patches.

Series applied, thank you.
