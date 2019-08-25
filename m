Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 470A29C119
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 02:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbfHYACC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 20:02:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48766 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbfHYACC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 20:02:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E43CF15263140;
        Sat, 24 Aug 2019 17:02:01 -0700 (PDT)
Date:   Sat, 24 Aug 2019 17:02:01 -0700 (PDT)
Message-Id: <20190824.170201.651765358087784080.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     rmk+kernel@arm.linux.org.uk, linux@roeck-us.net,
        Chris.Healy@zii.aero, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: sfp: Add labels to hwmon sensors
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190824230417.17657-1-andrew@lunn.ch>
References: <20190824230417.17657-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 24 Aug 2019 17:02:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Sun, 25 Aug 2019 01:04:17 +0200

> SFPs can report two different power values, the transmit power and the
> receive power. Add labels to make it clear which is which. Also add
> labels to the other sensors, VCC power supply, bias and module
> temperature.
> 
> sensors(1) now shows:
> 
> sff2-isa-0000
> Adapter: ISA adapter
> VCC:          +3.23 V
> temperature:  +33.4 C
> TX_power:    276.00 uW
> RX_power:     20.00 uW
> bias:         +0.01 A
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks Andrew.
