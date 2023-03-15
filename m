Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4216BBD97
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 20:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbjCOTvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 15:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbjCOTve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 15:51:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54766A5E2;
        Wed, 15 Mar 2023 12:51:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 045E5B81F20;
        Wed, 15 Mar 2023 19:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B71C433D2;
        Wed, 15 Mar 2023 19:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678909890;
        bh=l5A3kT8PPPRXMpDnSmkQkzIl6qsFMDQpORaaSvOA6KE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L9cTXeFNnPx7JkvNHLXN+kt5Rv/F/0Bv+3dbCcVHalkEaevOSSsuVdDTpgfLvEfgX
         9Dg8wrWKXx3q8IRDz0KEMm356qiY2knyX7+rWwEcTgbLUOP2Q0y08WVxT/6MsbFNFU
         gRWU6seXEA5RYKiENdUyJQYPxNCeIVb7LP2bGzRMgXziMxj7XsFs7XjpjrKaYGpSyl
         8gCrJcKf1vjtimXAx5Bb0sKZti12+CIPnXGqucmtIh2O/XS+Erl9TJUpMNRzPMbgRS
         6oADOgJSEtNCUNdPtHXKLKyUPLubO28MXYcGQW7j7uQcaUi36IPYH9LBHfQXnQIgnk
         GQKKJph/nNn9Q==
Date:   Wed, 15 Mar 2023 12:51:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        hauke@hauke-m.de, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, colin.foster@in-advantage.com,
        michael.hennerich@analog.com, alex.aring@gmail.com,
        stefan@datenfreihafen.org, miquel.raynal@bootlin.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org
Subject: Re: [PATCH 01/12] net: dsa: lantiq_gswip: mark OF related data as
 maybe unused
Message-ID: <20230315125129.39c02f9c@kernel.org>
In-Reply-To: <167886842083.29094.15777402773268782712.git-patchwork-notify@kernel.org>
References: <20230311173303.262618-1-krzysztof.kozlowski@linaro.org>
        <167886842083.29094.15777402773268782712.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023 08:20:20 +0000 patchwork-bot+netdevbpf@kernel.org
wrote:
> This series was applied to netdev/net-next.git (main)
> by David S. Miller <davem@davemloft.net>:

:) :) :)
