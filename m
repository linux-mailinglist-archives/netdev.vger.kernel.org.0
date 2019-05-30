Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 601912F703
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 07:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbfE3FDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 01:03:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46926 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727394AbfE3FDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 01:03:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1A96713D3B820;
        Wed, 29 May 2019 22:03:18 -0700 (PDT)
Date:   Wed, 29 May 2019 22:03:17 -0700 (PDT)
Message-Id: <20190529.220317.450232553317203536.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        linux@roeck-us.net, hkallweit1@gmail.com, jdelvare@suse.com,
        linux-hwmon@vger.kernel.org
Subject: Re: [PATCH] net: phy: tja11xx: Switch to HWMON_CHANNEL_INFO()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190528181541.1946-1-marex@denx.de>
References: <20190528181541.1946-1-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 May 2019 22:03:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Tue, 28 May 2019 20:15:41 +0200

> The HWMON_CHANNEL_INFO macro simplifies the code, reduces the likelihood
> of errors, and makes the code easier to read.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Applied to net-next.
