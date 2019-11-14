Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4CC5FD072
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 22:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfKNVkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 16:40:02 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54464 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfKNVkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 16:40:01 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6E6EB14A6F7EB;
        Thu, 14 Nov 2019 13:40:00 -0800 (PST)
Date:   Thu, 14 Nov 2019 13:39:59 -0800 (PST)
Message-Id: <20191114.133959.2299796714037910835.davem@davemloft.net>
To:     linux@rasmusvillemoes.dk
Cc:     shawnguo@kernel.org, leoyang.li@nxp.com, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        olteanv@gmail.com, maz@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch
Subject: Re: [PATCH v2 0/2] ARM: dts: ls1021a: define and use external
 interrupt lines
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191114110254.32171-1-linux@rasmusvillemoes.dk>
References: <20191114110254.32171-1-linux@rasmusvillemoes.dk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 Nov 2019 13:40:00 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date: Thu, 14 Nov 2019 12:02:51 +0100

> A device tree binding documentation as well as a driver implementing
> support for the external interrupt lines on the ls1021a has been
> merged into irqchip-next, so will very likely appear in v5.5. See
> 
> 87cd38dfd9e6 dt/bindings: Add bindings for Layerscape external irqs
> 0dcd9f872769 irqchip: Add support for Layerscape external interrupt lines
> 
> present in next-20191114.
> 
> These patches simply add the extirq node to the ls1021a.dtsi and make
> use of it on the LS1021A-TSN board. I hope these can be picked up so
> they also land in v5.5, so we don't have to wait a full extra release
> cycle.
> 
> v2: fix interrupt type in 2/2 (s/IRQ_TYPE_EDGE_FALLING/IRQ_TYPE_LEVEL_LOW/).

I am assuming this will go via an ARM tree.
