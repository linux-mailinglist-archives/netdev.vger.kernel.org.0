Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 108B4E9384
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 00:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfJ2XW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 19:22:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32798 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbfJ2XW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 19:22:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4DA2914EBC32C;
        Tue, 29 Oct 2019 16:22:26 -0700 (PDT)
Date:   Tue, 29 Oct 2019 16:22:25 -0700 (PDT)
Message-Id: <20191029.162225.1300242481281236911.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch
Subject: Re: [PATCH net 0/2] VLAN fixes for Ocelot switch
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191026180427.14039-1-olteanv@gmail.com>
References: <20191026180427.14039-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 16:22:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sat, 26 Oct 2019 21:04:25 +0300

> This series addresses 2 issues with vlan_filtering=1:
> - Untagged traffic gets dropped unless commands are run in a very
>   specific order.
> - Untagged traffic starts being transmitted as tagged after adding
>   another untagged VID on the port.
> 
> Tested on NXP LS1028A-RDB board.

Series applied, thanks.
