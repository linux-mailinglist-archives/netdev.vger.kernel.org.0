Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32DF1D3ED5
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 22:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgENUQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 16:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726035AbgENUQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 16:16:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54263C061A0C;
        Thu, 14 May 2020 13:16:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C3627128D72F5;
        Thu, 14 May 2020 13:16:55 -0700 (PDT)
Date:   Thu, 14 May 2020 13:16:55 -0700 (PDT)
Message-Id: <20200514.131655.249413798024922962.davem@davemloft.net>
To:     thierry.reding@gmail.com
Cc:     hayeswang@realtek.com, kuba@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH net/next] r8152: Use MAC address from device tree if
 available
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514123848.933199-1-thierry.reding@gmail.com>
References: <20200514123848.933199-1-thierry.reding@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 13:16:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <thierry.reding@gmail.com>
Date: Thu, 14 May 2020 14:38:48 +0200

> From: Thierry Reding <treding@nvidia.com>
> 
> If a MAC address was passed via the device tree node for the r8152
> device, use it and fall back to reading from EEPROM otherwise. This is
> useful for devices where the r8152 EEPROM was not programmed with a
> valid MAC address, or if users want to explicitly set a MAC address in
> the bootloader and pass that to the kernel.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Yep, that looks good, applied.

Thank you.
