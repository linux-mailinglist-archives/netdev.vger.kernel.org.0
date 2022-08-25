Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1E85A0706
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 03:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236772AbiHYB5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 21:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234419AbiHYB5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 21:57:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42E8A2232;
        Wed, 24 Aug 2022 18:51:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDED3B826E9;
        Thu, 25 Aug 2022 01:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1469C433D7;
        Thu, 25 Aug 2022 01:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661392259;
        bh=51wbqEOiFut6C1SPsrby7OvcY9fMy3mhVfaseztY30E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Uk3uZDzXxL8MYYs9m6YWUu6NLaQzbx22xiqJNhpxc/wtPt2cTKyKXzuA482tN1s5h
         xUSdj7g92LccFu9wFH0Sz/Kne4BZ9o/nugcR/Cwa0DaMvhzIvwX1utUd1CWBf5dSIR
         dEDyWwnIcaKv1FDx1s+ihDMoUpqXS4lF07Q75TaYTUer+zg+/yakaPoDGGXK8I6h6c
         trwHxpKLqY1M8sSgZ+yXeBE6EmljhB3naQSjUjBRaFpIy8knoR/n9Ra3TMYyxFs8Td
         2evY2V+5WB3ps6R97tBFuf+446sTduvu8DzB/cVLMAaabGezPyrEN83Y3kCTOprKUZ
         PbKnuybL5v7pw==
Date:   Wed, 24 Aug 2022 18:50:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: Add missing
 (unevaluated|additional)Properties on child nodes
Message-ID: <20220824185058.554b6d37@kernel.org>
In-Reply-To: <20220823145649.3118479-5-robh@kernel.org>
References: <20220823145649.3118479-5-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Aug 2022 09:56:36 -0500 Rob Herring wrote:
> In order to ensure only documented properties are present, node schemas
> must have unevaluatedProperties or additionalProperties set to false
> (typically).

Would you like this in 6.0 or 6.1? Applies to both, it seems.
