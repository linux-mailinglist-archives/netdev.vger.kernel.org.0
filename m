Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBB396981
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 21:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730501AbfHTTeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 15:34:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50130 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729409AbfHTTeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 15:34:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 28724146D3BE5;
        Tue, 20 Aug 2019 12:34:04 -0700 (PDT)
Date:   Tue, 20 Aug 2019 12:34:03 -0700 (PDT)
Message-Id: <20190820.123403.529519756132327697.davem@davemloft.net>
To:     vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, marek.behun@nic.cz, f.fainelli@gmail.com,
        andrew@lunn.ch
Subject: Re: [PATCH net-next v2 0/6] net: dsa: enable and disable all ports
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190819200053.21637-1-vivien.didelot@gmail.com>
References: <20190819200053.21637-1-vivien.didelot@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 20 Aug 2019 12:34:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vivien Didelot <vivien.didelot@gmail.com>
Date: Mon, 19 Aug 2019 16:00:47 -0400

> The DSA stack currently calls the .port_enable and .port_disable switch
> callbacks for slave ports only. However, it is useful to call them for all
> port types. For example this allows some drivers to delay the optimization
> of power consumption after the switch is setup. This can also help reducing
> the setup code of drivers a bit.
> 
> The first DSA core patches enable and disable all ports of a switch, regardless
> their type. The last mv88e6xxx patches remove redundant code from the driver
> setup and the said callbacks, now that they handle SERDES power for all ports.
> 
> Changes in v2: do not guard .port_disable for broadcom switches.

Series applied, thanks Vivien.
