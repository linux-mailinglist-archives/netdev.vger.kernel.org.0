Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D4066593F
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 11:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238181AbjAKKnw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 11 Jan 2023 05:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237980AbjAKKnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 05:43:50 -0500
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9042718;
        Wed, 11 Jan 2023 02:43:48 -0800 (PST)
Received: from ip5b412258.dynamic.kabel-deutschland.de ([91.65.34.88] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1pFYa7-0004Th-7W; Wed, 11 Jan 2023 11:43:43 +0100
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     Anand Moon <anand@edgeble.ai>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Johan Jonker <jbx6244@gmail.com>,
        Jagan Teki <jagan@edgeble.ai>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCHv4 linux-next 3/4] Rockchip RV1126 has GMAC 10/100/1000M ethernet controller
Date:   Wed, 11 Jan 2023 11:43:42 +0100
Message-ID: <2917690.KRxA6XjA2N@diego>
In-Reply-To: <CACF1qnd=o+QWuofgAb+YXOs1R_dOuCPxWrb-+YEhuN4z8OnTrA@mail.gmail.com>
References: <20230111064842.5322-1-anand@edgeble.ai> <7148963.18pcnM708K@diego> <CACF1qnd=o+QWuofgAb+YXOs1R_dOuCPxWrb-+YEhuN4z8OnTrA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Mittwoch, 11. Januar 2023, 11:31:40 CET schrieb Anand Moon:
> Hi Heiko,
> 
> Thanks for your review comments.
> 
> On Wed, 11 Jan 2023 at 15:41, Heiko Stübner <heiko@sntech.de> wrote:
> >
> > Hi,
> >
> > Am Mittwoch, 11. Januar 2023, 07:48:38 CET schrieb Anand Moon:
> > > Add Ethernet GMAC node for RV1126 SoC.
> > >
> > > Signed-off-by: Anand Moon <anand@edgeble.ai>
> > > Signed-off-by: Jagan Teki <jagan@edgeble.ai>
> >
> > patches 2-4 have this Signed-off-by from Jagan again where he is not
> > not the author but also not the sender.
> 
> We both work to fix this patch hence Jagan's SoB was added.

ok, then I think the correct way to express that would be:

Co-Developed-by: Jagan Teki <jagan@edgeble.ai>
Signed-off-by: Jagan Teki <jagan@edgeble.ai>
Signed-off-by: Anand Moon <anand@edgeble.ai>


> >
> > Also this patch here, needs a fixed subject with the correct prefixes.
> >
> Ok, will fix this in the next version.
> >
> > Heiko
> >
> > > ---
> > > v4: sort the node as reg adds. update the commit message.
> > > v3: drop the gmac_clkin_m0 & gmac_clkin_m1 fix clock node which are not
> > >     used, Add SoB of Jagan Teki.
> > > v2: drop SoB of Jagan Teki.
> 
> Thanks
> -Anand
> 




