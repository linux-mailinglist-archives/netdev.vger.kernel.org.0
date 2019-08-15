Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 183168F79B
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 01:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbfHOXbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 19:31:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52162 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfHOXbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 19:31:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D24ED1264EC85;
        Thu, 15 Aug 2019 16:31:32 -0700 (PDT)
Date:   Thu, 15 Aug 2019 16:31:29 -0700 (PDT)
Message-Id: <20190815.163129.2226019861728178605.davem@davemloft.net>
To:     antoine.tenart@bootlin.com
Cc:     richardcochran@gmail.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com,
        andrew@lunn.ch
Subject: Re: [PATCH net-next v6 0/6] net: mscc: PTP Hardware Clock (PHC)
 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190812144537.14497-1-antoine.tenart@bootlin.com>
References: <20190812144537.14497-1-antoine.tenart@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 Aug 2019 16:31:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>
Date: Mon, 12 Aug 2019 16:45:31 +0200

> This series introduces the PTP Hardware Clock (PHC) support to the Mscc
> Ocelot switch driver. In order to make use of this, a new register bank
> is added and described in the device tree, as well as a new interrupt.
> The use this bank and interrupt was made optional in the driver for dt
> compatibility reasons.

Series applied, thank you.
