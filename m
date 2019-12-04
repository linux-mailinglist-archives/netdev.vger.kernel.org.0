Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E92F112C68
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 14:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbfLDNOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 08:14:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:43638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbfLDNOT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 08:14:19 -0500
Received: from dragon (98.142.130.235.16clouds.com [98.142.130.235])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6F622077B;
        Wed,  4 Dec 2019 13:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575465258;
        bh=xl+BgZikPZ3S+p4qh8p4csjvgehmP3T3fZ5LJMF7bxI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tejZatGaBwPto/vJPb2ZmY5UwQ44Wyg8wvdwP3PLS6KqJYMGkA1DbjnZ514Uzpozv
         Sd2JcwuEOPxk8SxpXWjxFoNtKfV7DG7r7q993pUfxBi7A22EYAfBj9N8NOrp3XJrLN
         pCN0QaEpmym124GP2ZlFwB9mFgYKeY95PMCAPTh0=
Date:   Wed, 4 Dec 2019 21:14:07 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Marc Zyngier <maz@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v2 0/2] ARM: dts: ls1021a: define and use external
 interrupt lines
Message-ID: <20191204131404.GN3365@dragon>
References: <20191114110254.32171-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191114110254.32171-1-linux@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 12:02:51PM +0100, Rasmus Villemoes wrote:
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

Sorry.  I usually send queued patches around -rc6 timeline to my
arm-soc maintainers.  Patches coming later than that will be scheduled
for the next release unless critical fixes.
> 
> v2: fix interrupt type in 2/2 (s/IRQ_TYPE_EDGE_FALLING/IRQ_TYPE_LEVEL_LOW/).
> 
> Rasmus Villemoes (1):
>   ARM: dts: ls1021a: add node describing external interrupt lines
> 
> Vladimir Oltean (1):
>   ARM: dts: ls1021a-tsn: Use interrupts for the SGMII PHYs

Applied both, thanks.
