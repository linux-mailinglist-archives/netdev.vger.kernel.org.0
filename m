Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE539A338
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 00:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390655AbfHVWot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 18:44:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49948 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388967AbfHVWot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 18:44:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3175C15394C91;
        Thu, 22 Aug 2019 15:44:49 -0700 (PDT)
Date:   Thu, 22 Aug 2019 15:44:48 -0700 (PDT)
Message-Id: <20190822.154448.340842064168998207.davem@davemloft.net>
To:     yangbo.lu@nxp.com
Cc:     netdev@vger.kernel.org, allan.nielsen@microchip.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch
Subject: Re: [v4] ocelot_ace: fix action of trap
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190821015912.43151-1-yangbo.lu@nxp.com>
References: <20190821015912.43151-1-yangbo.lu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 Aug 2019 15:44:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yangbo Lu <yangbo.lu@nxp.com>
Date: Wed, 21 Aug 2019 09:59:12 +0800

> The trap action should be copying the frame to CPU and
> dropping it for forwarding, but current setting was just
> copying frame to CPU.
> 
> Fixes: b596229448dd ("net: mscc: ocelot: Add support for tcam")
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> Acked-by: Allan W. Nielsen <allan.nielsen@microchip.com>
> ---
> Changes for v4:
> 	- Added ACK and Fixes info in commit message.
> Changes for v3:
> 	- Set MASK_MODE to 1 for dropping forwarding.
> 	- Dropped other patches of patch-set.
> Changes for v2:
> 	- None.

Applied.
