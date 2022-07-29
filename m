Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21239584B19
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 07:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234256AbiG2F1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 01:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiG2F1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 01:27:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD407D798;
        Thu, 28 Jul 2022 22:27:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD3B461E93;
        Fri, 29 Jul 2022 05:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A653C433D6;
        Fri, 29 Jul 2022 05:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659072469;
        bh=/hlOl1IQn/qU70Ay1UTQfxp2QrDXw51RL4e4TJGjLlU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JVeC4PGVgH++SPXFo71BDc9tSNyNWdIFXj7cFn/3evOWqT6ae+/eNHmnf6VN/FeMR
         7pDw+G0mow27vV9FBGn5KaWcLO9/0dwWhfDmZ4E1rjoQDIfqCT4UL0W6wAyHDYg+jg
         gRL2ba6oycOu7CSXendBLwkyKxYHNhtxLrB/gx1qUM1rdvzGQFgQA9Vp1W9fv3y+lB
         EE3N0dW4nP+49Uq1K35umKUl3kJvdxcgWTdUcWeHhLjlqqIRtjQTeTE7984Kkn2uSW
         bFisZ615aNi0NJMlLlfOPjkIKlNBFgHKmzFgNK5gLijW9hlv1zBWptDlZO2NyBHTJb
         VBRY/jvG3o1Fw==
Date:   Thu, 28 Jul 2022 22:27:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Rob Herring <robh@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ajay Singh <ajay.kathat@microchip.com>,
        linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Kalle Valo <kvalo@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Adham Abozaeid <adham.abozaeid@microchip.com>,
        Mark Greer <mgreer@animalcreek.com>
Subject: Re: [PATCH 1/2] dt-bindings: nfc: use spi-peripheral-props.yaml
Message-ID: <20220728222747.1a791bc6@kernel.org>
In-Reply-To: <ea684136-bdbb-1b2c-35d3-64fdbd1d1764@linaro.org>
References: <20220727164130.385411-1-krzysztof.kozlowski@linaro.org>
        <20220728151802.GA900320-robh@kernel.org>
        <ea684136-bdbb-1b2c-35d3-64fdbd1d1764@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jul 2022 18:31:32 +0200 Krzysztof Kozlowski wrote:
> Yeah, I wanted to express it that almost no impact is expected if it
> goes independently. I could be more explicit here.

I'm taking the nfc one, and leaving the wireless change for Kalle.
