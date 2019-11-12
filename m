Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96990F99FB
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 20:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfKLTn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 14:43:59 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48532 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726970AbfKLTn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 14:43:58 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AD5A8154CFA3E;
        Tue, 12 Nov 2019 11:43:57 -0800 (PST)
Date:   Tue, 12 Nov 2019 11:43:57 -0800 (PST)
Message-Id: <20191112.114357.667316757358233747.davem@davemloft.net>
To:     antoine.tenart@bootlin.com
Cc:     linux@armlinux.org.uk, andrew@lunn.ch,
        alexandre.belloni@bootlin.com, nicolas.ferre@microchip.com,
        netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        mparab@cadence.com, piotrs@cadence.com, dkangude@cadence.com,
        ewanm@cadence.com, arthurm@cadence.com, stevenh@cadence.com
Subject: Re: [PATCH net-next v2] net: macb: convert to phylink
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191112142548.13037-1-antoine.tenart@bootlin.com>
References: <20191112142548.13037-1-antoine.tenart@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 11:43:58 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>
Date: Tue, 12 Nov 2019 15:25:48 +0100

> This patch converts the MACB Ethernet driver to the Phylink framework.
> The MAC configuration is moved to the Phylink ops and Phylink helpers
> are now used in the ethtools functions. This helps to access the flow
> control and pauseparam logic and this will be helpful in the future
> for boards using this controller with SFP cages.
> 
> Tested-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Things like pulling out the buffer init code into a helper function are
separate from the actual phylink conversion, so please split these changes
out into separate patches and make this a bonafide patch series.

Please do not forget to provide an appropriate patch series header
posting when you do this.

Thank you.
