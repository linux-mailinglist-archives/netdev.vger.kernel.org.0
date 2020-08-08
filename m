Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8552923F920
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 23:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgHHV1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 17:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbgHHV1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 17:27:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA32FC061756;
        Sat,  8 Aug 2020 14:27:40 -0700 (PDT)
Received: from localhost (50-47-102-2.evrt.wa.frontiernet.net [50.47.102.2])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D5E51127359E8;
        Sat,  8 Aug 2020 14:10:53 -0700 (PDT)
Date:   Sat, 08 Aug 2020 14:27:38 -0700 (PDT)
Message-Id: <20200808.142738.431277384120054736.davem@davemloft.net>
To:     thierry.reding@gmail.com
Cc:     kuba@kernel.org, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org, ejh@nvidia.com
Subject: Re: [PATCH net] r8152: Use MAC address from correct device tree
 node
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200807073632.63057-1-thierry.reding@gmail.com>
References: <20200807073632.63057-1-thierry.reding@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 08 Aug 2020 14:10:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <thierry.reding@gmail.com>
Date: Fri,  7 Aug 2020 09:36:32 +0200

> From: Thierry Reding <treding@nvidia.com>
> 
> Query the USB device's device tree node when looking for a MAC address.
> The struct device embedded into the struct net_device does not have a
> device tree node attached at all.
> 
> The reason why this went unnoticed is because the system where this was
> tested was one of the few development units that had its OTP programmed,
> as opposed to production systems where the MAC address is stored in a
> separate EEPROM and is passed via device tree by the firmware.
> 
> Reported-by: EJ Hsu <ejh@nvidia.com>
> Fixes: acb6d3771a03 ("r8152: Use MAC address from device tree if available")
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Applied, thank you.

