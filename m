Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDEABF0C09
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 03:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730741AbfKFCar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 21:30:47 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42308 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbfKFCar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 21:30:47 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A6D5F15108908;
        Tue,  5 Nov 2019 18:30:46 -0800 (PST)
Date:   Tue, 05 Nov 2019 18:30:46 -0800 (PST)
Message-Id: <20191105.183046.464228788999222253.davem@davemloft.net>
To:     kai.heng.feng@canonical.com
Cc:     oliver@neukum.org, hayeswang@realtek.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] r8152: Add macpassthru support for ThinkPad
 Thunderbolt 3 Dock Gen 2
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191105112452.13905-1-kai.heng.feng@canonical.com>
References: <20191105112452.13905-1-kai.heng.feng@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 18:30:46 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>
Date: Tue,  5 Nov 2019 19:24:52 +0800

> ThinkPad Thunderbolt 3 Dock Gen 2 is another docking station that uses
> RTL8153 based USB ethernet.
> 
> The device supports macpassthru, but it failed to pass the test of -AD,
> -BND and -BD. Simply bypass these tests since the device supports this
> feature just fine.
> 
> Also the ACPI objects have some differences between Dell's and Lenovo's,
> so make those ACPI infos no longer hardcoded.
> 
> BugLink: https://bugs.launchpad.net/bugs/1827961
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
> v3:
> - Simplify the logic of bypassing macpassthru test.
> v2:
> - Use idVendor and idProduct directly.

Applied to net-next, thank you.
