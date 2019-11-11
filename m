Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 865FAF8182
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 21:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbfKKUrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 15:47:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:32804 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbfKKUrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 15:47:18 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 21E77153D649C;
        Mon, 11 Nov 2019 12:47:18 -0800 (PST)
Date:   Mon, 11 Nov 2019 12:47:15 -0800 (PST)
Message-Id: <20191111.124715.822581099721936180.davem@davemloft.net>
To:     john.efstathiades@pebblebay.com
Cc:     UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] Support LAN743x PTP periodic output on any
 GPIO
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191107170833.16239-1-john.efstathiades@pebblebay.com>
References: <20191107170833.16239-1-john.efstathiades@pebblebay.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 Nov 2019 12:47:18 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Efstathiades <john.efstathiades@pebblebay.com>
Date: Thu,  7 Nov 2019 17:08:33 +0000

> The LAN743x Ethernet controller provides two independent PTP event
> channels. Each one can be used to generate a periodic output from
> the PTP clock. The output can be routed to any one of the available
> GPIO pins on the device.
> 
> The PTP clock API can now be used to:
> - select any LAN743x GPIO pin to function as a periodic output
> - select either LAN743x PTP event channel to generate the output
> 
> The LAN7430 has 4 GPIO pins that are multiplexed with its internal
> PHY LED control signals. A pin assigned to the LED control function
> will be assigned to the GPIO function if selected for PTP periodic
> output.
> 
> Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>

Applied, thanks.
