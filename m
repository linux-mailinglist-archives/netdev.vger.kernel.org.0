Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A629510B62B
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 19:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbfK0Sxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 13:53:55 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56160 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbfK0Sxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 13:53:54 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4660B149C722E;
        Wed, 27 Nov 2019 10:53:54 -0800 (PST)
Date:   Wed, 27 Nov 2019 10:53:51 -0800 (PST)
Message-Id: <20191127.105351.2221389937421619881.davem@davemloft.net>
To:     yangbo.lu@nxp.com
Cc:     netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, vladimir.oltean@nxp.com
Subject: Re: [v2, 0/2] net: mscc: ocelot: fix potential issues accessing
 skbs list
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191127072757.34502-1-yangbo.lu@nxp.com>
References: <20191127072757.34502-1-yangbo.lu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 Nov 2019 10:53:54 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yangbo Lu <yangbo.lu@nxp.com>
Date: Wed, 27 Nov 2019 15:27:55 +0800

> Fix two prtential issues accessing skbs list.
> - Break the matching loop when find the matching skb to avoid
>   consuming more skbs incorrectly. The timestamp ID is only
>   from 0 to 3 while the FIFO supports 128 timestamps at most.
> - Convert to use skb queue instead of the list of skbs to provide
>   protect with lock.
> 
> ---
> Changes for v2:
> 	- Split into two patches.
> 	- Converted to use skb queue.

Series applied, thanks.
