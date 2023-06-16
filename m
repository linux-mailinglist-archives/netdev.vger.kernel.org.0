Return-Path: <netdev+bounces-11412-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E39A7330A4
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 14:01:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FFC81C20F83
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:01:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18F5D168B9;
	Fri, 16 Jun 2023 12:01:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D31CBA23
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 12:01:15 +0000 (UTC)
Received: from mail11.truemail.it (mail11.truemail.it [IPv6:2001:4b7e:0:8::81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49677273F;
	Fri, 16 Jun 2023 05:01:12 -0700 (PDT)
Received: from francesco-nb.int.toradex.com (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 345E22168C;
	Fri, 16 Jun 2023 14:01:08 +0200 (CEST)
Date: Fri, 16 Jun 2023 14:01:02 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Judith Mendez <jm@ti.com>
Cc: Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Schuyler Patton <spatton@ti.com>, Nishanth Menon <nm@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Tero Kristo <kristo@kernel.org>, Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 4/4] DO_NOT_MERGE arm64: dts: ti: Enable MCU MCANs for
 AM62x
Message-ID: <ZIxO/uo7FICKsmdb@francesco-nb.int.toradex.com>
References: <20230419223323.20384-1-jm@ti.com>
 <20230419223323.20384-5-jm@ti.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419223323.20384-5-jm@ti.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Apr 19, 2023 at 05:33:23PM -0500, Judith Mendez wrote:
> On AM62x there are no hardware interrupts routed to GIC interrupt
> controller for MCU MCAN IP, A53 Linux cannot receive hardware
> interrupts. Since an hrtimer will be used to generate software
> interrupts, add MCU MCAN nodes to dtsi and default to disabled.
> 
> AM62x does not carry on-board CAN transceivers, so instead of
> changing DTB permanently use an overlay to enable MCU MCANs and to
> add CAN transceiver nodes.
> 
> If an hrtimer is used to generate software interrupts, the two
> required interrupt attributes in the MCAN node do not have to be
> included.
> 
> Signed-off-by: Judith Mendez <jm@ti.com>

[...]

> +	mcu_mcan1: can@4e00000 {
this should be mcu_mcan0

> +		compatible = "bosch,m_can";
> +		reg = <0x00 0x4e00000 0x00 0x8000>,
> +			  <0x00 0x4e08000 0x00 0x200>;

[...]

> +	mcu_mcan2: can@4e10000 {
mcu_mcan1

> +		compatible = "bosch,m_can";
> +		reg = <0x00 0x4e10000 0x00 0x8000>,
> +			  <0x00 0x4e18000 0x00 0x200>;

Francesco

