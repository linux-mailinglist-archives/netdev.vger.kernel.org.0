Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE7F6CBCFD
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 13:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbjC1LDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 07:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjC1LDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 07:03:01 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8393E7
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 04:02:59 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ph76I-0005mW-Es; Tue, 28 Mar 2023 13:02:50 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ph76F-0003Or-5S; Tue, 28 Mar 2023 13:02:47 +0200
Date:   Tue, 28 Mar 2023 13:02:47 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Alexandre TORGUE <alexandre.torgue@foss.st.com>
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v1] ARM: dts: stm32: prtt1c: Add PoDL PSE regulator nodes
Message-ID: <20230328110247.GE15196@pengutronix.de>
References: <20230323123242.3763673-1-o.rempel@pengutronix.de>
 <1a2d16c8-8c16-5fcc-7906-7b454a81922f@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1a2d16c8-8c16-5fcc-7906-7b454a81922f@foss.st.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 11:58:34AM +0200, Alexandre TORGUE wrote:
> Hi Oleksij
> 
> On 3/23/23 13:32, Oleksij Rempel wrote:
> > This commit introduces Power over Data Line (PoDL) Power Source
> > Equipment (PSE) regulator nodes to the PRTT1C devicetree. The addition
> > of these nodes enables support for PoDL in PRTT1C devices, allowing
> > power delivery and data transmission over a single twisted pair.
> > 
> > The new PoDL PSE regulator nodes provide voltage capability information
> > of the current board design, which can be used as a hint for system
> > administrators when configuring and managing power settings. This
> > update enhances the versatility and simplifies the power management of
> > PRTT1C devices while ensuring compatibility with connected Powered
> > Devices (PDs).
> > 
> > After applying this patch, the power delivery can be controlled from
> > user space with a patched [1] ethtool version using the following commands:
> >    ethtool --set-pse t1l2 podl-pse-admin-control enable
> > to enable power delivery, and
> >    ethtool --show-pse t1l2
> > to display the PoDL PSE settings.
> > 
> > By integrating PoDL PSE support into the PRTT1C devicetree, users can
> > benefit from streamlined power and data connections in their
> > deployments, improving overall system efficiency and reducing cabling
> > complexity.
> > 
> > [1] https://lore.kernel.org/all/20230317093024.1051999-1-o.rempel@pengutronix.de/
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> 
> Please, fix the introduction of those new yaml validation errors:
> 
> arch/arm/boot/dts/stm32mp151a-prtt1c.dtb: ethernet-pse-1: $nodename:0:
> 'ethernet-pse-1' does not match '^ethernet-pse(@.*)?$'
>         From schema:
> /Documentation/devicetree/bindings/net/pse-pd/podl-pse-regulator.yaml
> arch/arm/boot/dts/stm32mp151a-prtt1c.dtb: ethernet-pse-2: $nodename:0:
> 'ethernet-pse-2' does not match '^ethernet-pse(@.*)?$'
>         From schema: /local/home/frq08678/STLINUX/kernel/my-kernel/stm32/Documentation/devicetree/bindings/net/pse-pd/podl-pse-regulator.yaml

Using ethernet-pse@1 will require to use "reg" or "ranges" properties.
Which makes no sense in this use case. I need to fix the schema instead by
allowing this patter with following regex: "^ethernet-pse(@.*|-[0-9a-f])*$"

Should I send schema fix together with this patch?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
