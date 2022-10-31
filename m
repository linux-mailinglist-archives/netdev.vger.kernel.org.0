Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6080C613A31
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 16:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbiJaPgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 11:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbiJaPgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 11:36:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E8B11A02;
        Mon, 31 Oct 2022 08:36:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 651A0612DA;
        Mon, 31 Oct 2022 15:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A10C43140;
        Mon, 31 Oct 2022 15:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667230582;
        bh=hQTeoRIMnGPp9UdgDT08Aavn4R9xt6+Q4i1tH0XNAtE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XTouMncDtMEck6F3hpEnv5HTI5FxTrknmp7Hw+WJKidcVfbyNHJdYHjmRRLvQ1NMi
         79k6ew61nkE5JUU/R+H8Y4UkCM20ONTgi5IvomLie4xhwbM01zKP+BP1cqNj41B9je
         sLE2SObyNqVO4v93GRBtNDBDS1YoRyjPj1/UmGcrG3SCxctMAeXaLiGn9k43iyOphl
         OD9LKi73/RdJWgcEKIBGJaisJJ7orl49E0Azz9nIM82iK8Ztons+syGXtHWUhfTqMH
         gFNoIxoQRefbmGC7wkvpFacJV+m4GepDRdg8aa0Qzqxqd72bVQhwRsLd5G8iJPOxg2
         vLf/O4qQ+5HyQ==
Date:   Mon, 31 Oct 2022 15:36:14 +0000
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
Subject: Re: [PATCH v1 net-next 1/7] dt-bindings: mfd: ocelot: remove
 spi-max-frequency from required properties
Message-ID: <Y1/rbgXwUZZXY3JK@google.com>
References: <20221025050355.3979380-1-colin.foster@in-advantage.com>
 <20221025050355.3979380-2-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221025050355.3979380-2-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Oct 2022, Colin Foster wrote:

> The property spi-max-frequency was initially documented as a required
> property. It is not actually required, and will break bindings validation
> if other control mediums (e.g. PCIe) are used.
> 
> Remove this property from the required arguments.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml | 1 -
>  1 file changed, 1 deletion(-)

Applied, thanks.

-- 
Lee Jones [李琼斯]
