Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD86A58CE08
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 20:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244049AbiHHSwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 14:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbiHHSwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 14:52:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E080E2BE8;
        Mon,  8 Aug 2022 11:52:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72D846123A;
        Mon,  8 Aug 2022 18:52:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFE7C433D6;
        Mon,  8 Aug 2022 18:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659984724;
        bh=509Vlh0aaasSIvnKS+Wl7RWhla5F0k13Qa/Ysf/hWIQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QxKtOC/ccHzrXIeZMLSlvQph5yP51eHmcmjuHBs9Rm+3R7M7hKtWEqkr0g9jsCtF2
         1IdikxPNDR5kSThNTeqGfE3dSPLwwBvL0HaG84/TVtuBsIY7BguX/mSC7/qX3XrGOo
         AYClkonIzyrgrJO3OHqxafNecB1zeyCdz9qS6VH34b0Vub0dOtQyxDWH4yvLvrHglW
         ZCP5NXAn/WfqBAqUa3+dTpIRmLBfJcugxLcOt5WDgG5uPMBobus3cmPDdF6fcIsj4W
         B0zrapECVlc01kIbz57H55MXRkQJ31ffWOSIg1yXJ68vL0J8Hqgc4FGpHr6dvEGO4H
         CgKm9GuZUy5gg==
Date:   Mon, 8 Aug 2022 11:52:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Michael Hennerich <Michael.Hennerich@analog.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Pavel Machek <pavel@ucw.cz>,
        Tim Harvey <tharvey@gateworks.com>,
        Robert Jones <rjones@gateworks.com>,
        Lee Jones <lee@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Reichel <sre@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Ricardo Rivera-Matos <r-rivera-matos@ti.com>,
        linux-hwmon@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-leds@vger.kernel.org,
        netdev@vger.kernel.org, linux-pm@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 0/5] iio/hwmon/mfd/leds/net/power/ASoC: dt-bindings: few
 stale maintainers cleanup
Message-ID: <20220808115202.3175eb1f@kernel.org>
In-Reply-To: <20220808104712.54315-1-krzysztof.kozlowski@linaro.org>
References: <20220808104712.54315-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  8 Aug 2022 13:47:07 +0300 Krzysztof Kozlowski wrote:
> Several of the bindings here had only one
> maintainer and history does not always point to a new one (although I did not
> perform extensive digging). I added subsystem maintainer, because dtschema
> requires such entry. This is not the best choice as simply subsystem maintainer
> might not have the actual device (or its datasheets or any interest in it).
> 
> However dtschema requires a maintainer. Maybe we could add some
> "orphaned" entry in such case?

Integrating it with MAINTAINERS would be another option worth exploring
although slightly tangential.

How do you want this merged? It's all over the place subsystem-wise.
