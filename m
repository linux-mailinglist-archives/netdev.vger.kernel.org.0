Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B2665B601
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 18:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbjABRlF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 2 Jan 2023 12:41:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232197AbjABRlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 12:41:04 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C461DA4
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 09:41:02 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1pCOo0-00054t-FH; Mon, 02 Jan 2023 18:41:00 +0100
Received: from [2a0a:edc0:0:900:1d::4e] (helo=lupine)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1pCOnz-003OR5-N1; Mon, 02 Jan 2023 18:40:59 +0100
Received: from pza by lupine with local (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1pCOnz-000ELv-22; Mon, 02 Jan 2023 18:40:59 +0100
Message-ID: <af5dd2c21d7805315e719f8b0fd163bcaa6aea39.camel@pengutronix.de>
Subject: Re: [PATCH 1/2] dt-bindings: net: Add rfkill-gpio binding
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        kernel@pengutronix.de
Date:   Mon, 02 Jan 2023 18:40:58 +0100
In-Reply-To: <e99d6756-e275-7dd6-a57f-1c9a120b4ef3@kernel.org>
References: <20221221104803.1693874-1-p.zabel@pengutronix.de>
         <e99d6756-e275-7dd6-a57f-1c9a120b4ef3@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.38.3-1+deb11u1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Do, 2022-12-22 at 11:20 +0100, Krzysztof Kozlowski wrote:
> On 21/12/2022 11:48, Philipp Zabel wrote:
> > Add a device tree binding document for GPIO controlled rfkill switches.
> > The name, type, shutdown-gpios and reset-gpios properties are the same
> > as defined for ACPI.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> 
> Please use scripts/get_maintainers.pl to get a list of necessary people
> and lists to CC.  It might happen, that command when run on an older
> kernel, gives you outdated entries.  Therefore please be sure you base
> your patches on recent Linux kernel.
> 
> You missed several maintainers. Resend.

Thank you for the review, I've sent a v2:

https://lore.kernel.org/all/20230102-rfkill-gpio-dt-v2-0-d1b83758c16d@pengutronix.de/T

[...]
> 
> 
> > +  shutdown-gpios:
> > +    maxItems: 1
> > +
> > +  reset-gpios:
> > +    maxItems: 1
> 
> Reset of rfkill? It seems entire binding is a workaround of missing
> reset in your device. I don't think this is suitable for binding.

I've dropped the reset-gpios property. The device I would like to
control with this is the 'wireless disable' pin of an M.2 connector.

regards
Philipp
