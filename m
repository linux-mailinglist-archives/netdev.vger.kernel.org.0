Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9466F4CE
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 20:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbfGUSwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 14:52:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33834 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbfGUSwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 14:52:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 410021525A40D;
        Sun, 21 Jul 2019 11:52:40 -0700 (PDT)
Date:   Sun, 21 Jul 2019 11:52:39 -0700 (PDT)
Message-Id: <20190721.115239.1805057977710895563.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, rmk+kernel@arm.linux.org.uk,
        Chris.Healy@zii.aero
Subject: Re: [PATCH net] net: phy: sfp: hwmon: Fix scaling of RX power
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190721165008.26597-1-andrew@lunn.ch>
References: <20190721165008.26597-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 21 Jul 2019 11:52:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Sun, 21 Jul 2019 18:50:08 +0200

> The RX power read from the SFP uses units of 0.1uW. This must be
> scaled to units of uW for HWMON. This requires a divide by 10, not the
> current 100.
> 
> With this change in place, sensors(1) and ethtool -m agree:
> 
> sff2-isa-0000
> Adapter: ISA adapter
> in0:          +3.23 V
> temp1:        +33.1 C
> power1:      270.00 uW
> power2:      200.00 uW
> curr1:        +0.01 A
> 
>         Laser output power                        : 0.2743 mW / -5.62 dBm
>         Receiver signal average optical power     : 0.2014 mW / -6.96 dBm
> 
> Reported-by: chris.healy@zii.aero
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Fixes: 1323061a018a ("net: phy: sfp: Add HWMON support for module sensors")

Applied and queued up for -stable, thanks Andrew.
