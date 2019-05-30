Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 026032F46D
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 06:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388570AbfE3EiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 00:38:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46748 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388532AbfE3EiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 00:38:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 529CD136E13CB;
        Wed, 29 May 2019 21:38:10 -0700 (PDT)
Date:   Wed, 29 May 2019 21:38:09 -0700 (PDT)
Message-Id: <20190529.213809.1804206775236133314.davem@davemloft.net>
To:     joergen.andreasen@microchip.com
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        alexandre.belloni@bootlin.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/1] net: mscc: ocelot: Implement port
 policers via tc command
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190528124917.22034-2-joergen.andreasen@microchip.com>
References: <20190502094029.22526-1-joergen.andreasen@microchip.com>
        <20190528124917.22034-1-joergen.andreasen@microchip.com>
        <20190528124917.22034-2-joergen.andreasen@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 May 2019 21:38:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joergen Andreasen <joergen.andreasen@microchip.com>
Date: Tue, 28 May 2019 14:49:17 +0200

> Hardware offload of matchall classifier and police action are now
> supported via the tc command.
> Supported police parameters are: rate and burst.
> 
> Example:
> 
> Add:
> tc qdisc add dev eth3 handle ffff: ingress
> tc filter add dev eth3 parent ffff: prio 1 handle 2	\
> 	matchall skip_sw				\
> 	action police rate 100Mbit burst 10000
> 
> Show:
> tc -s -d qdisc show dev eth3
> tc -s -d filter show dev eth3 ingress
> 
> Delete:
> tc filter del dev eth3 parent ffff: prio 1
> tc qdisc del dev eth3 handle ffff: ingress
> 
> Signed-off-by: Joergen Andreasen <joergen.andreasen@microchip.com>

Applied.
