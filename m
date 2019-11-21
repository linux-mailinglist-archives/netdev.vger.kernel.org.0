Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60C59105CBC
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 23:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfKUWjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 17:39:17 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54806 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbfKUWjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 17:39:16 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BF09915099D97;
        Thu, 21 Nov 2019 14:39:15 -0800 (PST)
Date:   Thu, 21 Nov 2019 14:39:15 -0800 (PST)
Message-Id: <20191121.143915.761687373012909585.davem@davemloft.net>
To:     yangbo.lu@nxp.com
Cc:     netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, richardcochran@gmail.com
Subject: Re: [PATCH 0/5] Support PTP clock and hardware timestamping for
 DSA Felix driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191120082318.3909-1-yangbo.lu@nxp.com>
References: <20191120082318.3909-1-yangbo.lu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Nov 2019 14:39:16 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yangbo Lu <yangbo.lu@nxp.com>
Date: Wed, 20 Nov 2019 16:23:13 +0800

> This patch-set is to support PTP clock and hardware timestamping
> for DSA Felix driver. Some functions in ocelot.c/ocelot_board.c
> driver were reworked/exported, so that DSA Felix driver was able
> to reuse them as much as possible.
> 
> On TX path, timestamping works on packet which requires timestamp.
> The injection header will be configured accordingly, and skb clone
> requires timestamp will be added into a list. The TX timestamp
> is final handled in threaded interrupt handler when PTP timestamp
> FIFO is ready.
> On RX path, timestamping is always working. The RX timestamp could
> be got from extraction header.

Series applied, thank you.
