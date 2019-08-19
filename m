Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAF7194EBC
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 22:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbfHSULJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 16:11:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35730 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727925AbfHSULJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 16:11:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 70BC9145F5279;
        Mon, 19 Aug 2019 13:11:08 -0700 (PDT)
Date:   Mon, 19 Aug 2019 13:11:07 -0700 (PDT)
Message-Id: <20190819.131107.1894082352888011748.davem@davemloft.net>
To:     vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, marek.behun@nic.cz, f.fainelli@gmail.com,
        andrew@lunn.ch
Subject: Re: [PATCH net-next 0/6] net: dsa: enable and disable all ports
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190818173548.19631-1-vivien.didelot@gmail.com>
References: <20190818173548.19631-1-vivien.didelot@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 19 Aug 2019 13:11:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vivien Didelot <vivien.didelot@gmail.com>
Date: Sun, 18 Aug 2019 13:35:42 -0400

> The DSA stack currently calls the .port_enable and .port_disable switch
> callbacks for slave ports only. However, it is useful to call them for all
> port types. For example this allows some drivers to delay the optimization
> of power consumption after the switch is setup. This can also help reducing
> the setup code of drivers a bit.
> 
> The first DSA core patches enable and disable all ports of a switch, regardless
> their type. The last mv88e6xxx patches remove redundant code from the driver
> setup and the said callbacks, now that they handle SERDES power for all ports.

Looks like the bcm_sf2 parts need some adjustments.
