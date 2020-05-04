Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567831C4482
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 20:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732216AbgEDSH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 14:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731676AbgEDSH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 14:07:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37ABBC061A0E;
        Mon,  4 May 2020 11:07:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A766C15D266F6;
        Mon,  4 May 2020 11:07:54 -0700 (PDT)
Date:   Mon, 04 May 2020 11:07:53 -0700 (PDT)
Message-Id: <20200504.110753.1196693099669354507.davem@davemloft.net>
To:     nicolas.ferre@microchip.com
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        claudiu.beznea@microchip.com, harini.katakam@xilinx.com,
        linux-kernel@vger.kernel.org, alexandre.belloni@bootlin.com,
        antoine.tenart@bootlin.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, andrew@lunn.ch, michal.simek@xilinx.com
Subject: Re: [PATCH v3 0/7] net: macb: Wake-on-Lan magic packet fixes and
 GEM handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1588597759.git.nicolas.ferre@microchip.com>
References: <cover.1588597759.git.nicolas.ferre@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 May 2020 11:07:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <nicolas.ferre@microchip.com>
Date: Mon, 4 May 2020 15:44:15 +0200

> Here is the 3rd series to fix WoL magic-packet on the current macb driver.
> I also add, in the second part of this series the feature to GEM types of IPs.
> Please tell me if they should be separated; but the two last patches cannot go
> without the 5 fixes first ones.

Please separate these into a pure bug fix series for 'net', and once that is
integrated and propagated to 'net-next' you can submit the GEM support.
