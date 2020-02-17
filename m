Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCE73160843
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 03:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgBQCmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 21:42:08 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47902 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgBQCmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 21:42:07 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1712B153BB8DD;
        Sun, 16 Feb 2020 18:42:07 -0800 (PST)
Date:   Sun, 16 Feb 2020 18:42:06 -0800 (PST)
Message-Id: <20200216.184206.1168397979817043530.davem@davemloft.net>
To:     alexandre.belloni@bootlin.com
Cc:     nicolas.ferre@microchip.com, harini.katakam@xilinx.com,
        shubhrajyoti.datta@xilinx.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: macb: ensure interface is not suspended on
 at91rm9200
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200212164538.383741-1-alexandre.belloni@bootlin.com>
References: <20200212164538.383741-1-alexandre.belloni@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 18:42:07 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>
Date: Wed, 12 Feb 2020 17:45:38 +0100

> Because of autosuspend, at91ether_start is called with clocks disabled.
> Ensure that pm_runtime doesn't suspend the interface as soon as it is
> opened as there is no pm_runtime support is the other relevant parts of the
> platform support for at91rm9200.
> 
> Fixes: d54f89af6cc4 ("net: macb: Add pm runtime support")
> Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

Applied, thanks.
