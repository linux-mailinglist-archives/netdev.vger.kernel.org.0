Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1AF58EB6F
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 13:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbiHJLnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 07:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiHJLnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 07:43:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 118E077571;
        Wed, 10 Aug 2022 04:43:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D14261313;
        Wed, 10 Aug 2022 11:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90947C433C1;
        Wed, 10 Aug 2022 11:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660131799;
        bh=/UT96ff++x2zfpBsE2pzswdgzbNltGEZ/hMX3N7VW58=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QW066Eh867kwheRp0QLWhqI58bqBOREru+c2GBYrj2ZOUniKjPFb5sRYhPcKv/0P/
         CDpWizV1NyGLSEh9y7z0HTbpDizmjAGF9bmByTTQmyuYgQwwKAE4GYt6fM0K31NVEX
         Yp3DctXCRIh08f7dOeMkFKZYAWpZoOdqwHyBuaAY9BYe2aJSH64mn8/z5bR5+dpmOH
         DEr9NlVMs1JFTp9FWboeKrrShWS6ay+d9Q3AWAn8IjuvpQ+ZBqd2LFoyHbFrWtvxbj
         v2Eu3zJfsO9Pw1JFQ23r0+NsBxTe8uzidawfeI9IDp6YACFF+Srga2L12XLreM2V0Y
         oM9YhhpYSg1DQ==
Date:   Wed, 10 Aug 2022 12:43:10 +0100
From:   Lee Jones <lee@kernel.org>
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
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Reichel <sre@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Andrew Davis <afd@ti.com>,
        linux-hwmon@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-leds@vger.kernel.org,
        netdev@vger.kernel.org, linux-pm@vger.kernel.org,
        alsa-devel@alsa-project.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH v2 4/5] dt-bindings: Drop Robert Jones
Message-ID: <YvOZzkPeU7dXz0Xo@google.com>
References: <20220809162752.10186-1-krzysztof.kozlowski@linaro.org>
 <20220809162752.10186-5-krzysztof.kozlowski@linaro.org>
 <YvOP9qr2CR9n1FCe@google.com>
 <f69bf678-0188-7178-7542-9773c15c1463@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f69bf678-0188-7178-7542-9773c15c1463@linaro.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Aug 2022, Krzysztof Kozlowski wrote:

> On 10/08/2022 14:01, Lee Jones wrote:
> > On Tue, 09 Aug 2022, Krzysztof Kozlowski wrote:
> > 
> >> Emails to Robert Jones bounce ("550 5.2.1 The email account that you
> >> tried to reach is disabled").
> >>
> >> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> >> Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> >>
> >> ---
> >>
> >> For maintainers entry see:
> >> https://lore.kernel.org/all/20220808111113.71890-1-krzysztof.kozlowski@linaro.org/
> >> ---
> >>  Documentation/devicetree/bindings/iio/imu/nxp,fxos8700.yaml | 2 +-
> >>  Documentation/devicetree/bindings/mfd/gateworks-gsc.yaml    | 1 -
> > 
> > Any reason to submit these as one patch?
> 
> Less work for me, less work for maintainer applying and sending fixes.

Easier for Jonathan and I to apply to our respective trees.

> I think this could go via Rob's tree as fixes for current cycle.

Happy for that to happen if it's okay with Rob:

Acked-by: Lee Jones <lee@kernel.org>

-- 
Lee Jones [李琼斯]
