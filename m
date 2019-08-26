Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB329D7F4
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 23:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbfHZVNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 17:13:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38318 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfHZVNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 17:13:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9EB4515008345;
        Mon, 26 Aug 2019 14:13:38 -0700 (PDT)
Date:   Mon, 26 Aug 2019 14:13:38 -0700 (PDT)
Message-Id: <20190826.141338.1571164902049647689.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     horatiu.vultur@microchip.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, UNGLinuxDriver@microchip.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH v2 0/3] Add NETIF_F_HW_BR_CAP feature
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190826123811.GA13411@lunn.ch>
References: <1566807075-775-1-git-send-email-horatiu.vultur@microchip.com>
        <20190826123811.GA13411@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 26 Aug 2019 14:13:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Mon, 26 Aug 2019 14:38:11 +0200

> I'm still not convinced this is needed. The model is, the hardware is
> there to accelerate what Linux can do in software. Any peculiarities
> of the accelerator should be hidden in the driver.  If the accelerator
> can do its job without needing promisc mode, do that in the driver.

I completely agree.
