Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B931527B5E
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 13:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729962AbfEWLHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 07:07:23 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:33441 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbfEWLHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 07:07:23 -0400
X-Originating-IP: 90.88.22.185
Received: from localhost (aaubervilliers-681-1-80-185.w90-88.abo.wanadoo.fr [90.88.22.185])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 13C8C1BF211;
        Thu, 23 May 2019 11:07:15 +0000 (UTC)
Date:   Thu, 23 May 2019 13:07:15 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Antoine =?utf-8?Q?T=C3=A9nart?= <antoine.tenart@bootlin.com>
Subject: Re: [PATCH 6/8] dt-bindings: net: stmmac: Convert the binding to a
 schemas
Message-ID: <20190523110715.ckyzpec3quxr26cp@flea>
References: <74d98cc3c744d53710c841381efd41cf5f15e656.1558605170.git-series.maxime.ripard@bootlin.com>
 <ba1a5d8ad34a8c9ab99f504c04fbe65bde42081b.1558605170.git-series.maxime.ripard@bootlin.com>
 <78EB27739596EE489E55E81C33FEC33A0B92B864@DE02WEMBXB.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78EB27739596EE489E55E81C33FEC33A0B92B864@DE02WEMBXB.internal.synopsys.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

On Thu, May 23, 2019 at 10:11:39AM +0000, Jose Abreu wrote:
> From: Maxime Ripard <maxime.ripard@bootlin.com>
> Date: Thu, May 23, 2019 at 10:56:49
>
> > Switch the STMMAC / Synopsys DesignWare MAC controller binding to a YAML
> > schema to enable the DT validation.
> >
> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
>
> How exactly can I see the final results of this ? Do you have any link ?
> (I'm no expert in YAML at all).

You need some extra tooling, that you can find here:
https://github.com/devicetree-org/dt-schema

You can then run make dtbs_check, and those YAML files will be used to
validate that any devicetree using those properties are doing it
properly. That implies having the right node names, properties, types,
ranges of values when relevant, and so on.

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
