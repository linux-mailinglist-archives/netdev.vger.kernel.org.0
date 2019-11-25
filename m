Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDE5109589
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 23:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfKYWhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 17:37:07 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55742 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfKYWhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 17:37:06 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D6AE9150689CA;
        Mon, 25 Nov 2019 14:37:05 -0800 (PST)
Date:   Mon, 25 Nov 2019 14:36:59 -0800 (PST)
Message-Id: <20191125.143659.27849901302112844.davem@davemloft.net>
To:     ajaykuee@gmail.com
Cc:     netdev@vger.kernel.org, treding@nvidia.com, ajayg@nvidia.com
Subject: Re: [PATCH 0/2] net: stmmac: dwc-qos: ACPI device support 
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191125215115.12981-1-ajayg@nvidia.com>
References: <20191125215115.12981-1-ajayg@nvidia.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 Nov 2019 14:37:06 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ajay Gupta <ajaykuee@gmail.com>
Date: Mon, 25 Nov 2019 13:51:13 -0800

> These two changes are needed to enable ACPI based devices to use stmmac
> driver. First patch is to use generic device api (device_*) instead of
> device tree based api (of_*). Second patch avoids clock and reset accesses
> for Tegra ACPI based devices. ACPI interface will be used to access clock
> and reset for Tegra ACPI devices in later patches.

This is a new feature, and thus only suitable for the net-next tree, which
is closed right now as per:

	http://vger.kernel.org/~davem/net-next.html

Resubmit this when the net-next tree opens back up.

Thank you.
