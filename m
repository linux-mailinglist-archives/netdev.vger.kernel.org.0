Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66298613A37
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 16:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbiJaPhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 11:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbiJaPhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 11:37:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA09BF7C;
        Mon, 31 Oct 2022 08:37:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7815C6127D;
        Mon, 31 Oct 2022 15:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2D4C433C1;
        Mon, 31 Oct 2022 15:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667230641;
        bh=htosT9j3prhic4OCFKTn+cYnB6WGmmVROgs2Id5cou0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ujWCtT6kGi/oxXQiRwuxyVSzSYLo/pusgj3E7kSwP+U2mjtPYV0ba5Dnb4KLO64hq
         LwqaQqbWAtd9mZbhLpc0xOWHvh3AfJeoi2awo6yFLD83l0EXhlyiA3CqsIRs8mYfuD
         js7xB3kYBeWGZPj4TTF9stcgePR29RYLGsO0agWHGn0dzGNH7paSqFbMhxe+LI5VRr
         Pem5QjvEfjt9D/oRZrL1jrxWzThrfop6xCd1uFvDZSFadLSpkP24I6+1+opzA2Qou/
         Qy/48tE+u28mPPrmvrVyVwNeFsSi9Kls8At2fM5IOVYAD/GMfWGzzz5aX2cNFgGFz5
         oN6OS1m8Yaflg==
Date:   Mon, 31 Oct 2022 15:37:13 +0000
From:   Lee Jones <lee@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?iso-8859-1?Q?n=E7_=DCNAL?= <arinc.unal@arinc9.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: Re: [PATCH v1 net-next 2/7] dt-bindings: mfd: ocelot: remove
 unnecessary driver wording
Message-ID: <Y1/rqW8kP4Yk/len@google.com>
References: <20221025050355.3979380-1-colin.foster@in-advantage.com>
 <20221025050355.3979380-3-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221025050355.3979380-3-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Oct 2022, Colin Foster wrote:

> Initially there was unnecessary verbage around "this driver" in the
> documentation. It was unnecessary. Remove self references about it being a
> "driver" documentation and replace it with a more detailed description
> about external interfaces that are supported.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Applied, thanks.

-- 
Lee Jones [李琼斯]
