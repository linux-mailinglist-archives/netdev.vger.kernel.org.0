Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF93158DF73
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 20:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347295AbiHISyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 14:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245458AbiHISxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 14:53:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E347452459;
        Tue,  9 Aug 2022 11:24:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50B0CB81719;
        Tue,  9 Aug 2022 18:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1456AC433D6;
        Tue,  9 Aug 2022 18:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660069455;
        bh=Orpxpb4ht5cPC7Dmsq+/pb4XIrE3ThWv+PJnw3hJ7e4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UfyjxJkBaNxVbvRwC2r0rZpqU53z5JEtiDzCh/itrvbU5rw32TLXOuYECgtiiUh4N
         sLsmF5mZKHb21ZR/jKEikDBKKGpEjuiZx3DedIlg08AWoPmsMoqv/tiZgwL26OHbj/
         eOyts2pLeTu12bZm5S5IwUF6sDjZk2CJ1QC/riFKIob9FGSbmRAy1gpky6u5aoLyqO
         LxNXP57+6cJih1V++iDehFhGJERKHnyYckUHRgVXKiyXhr2F/e5csIJGOikPlorlEh
         Xi4MuuuHlrenP5ypB06He/SgYZasBbimGB6t3WH3cQFB7H4oUaEiciVj15RhLgKPoa
         +96h0l6UbpqHg==
Date:   Tue, 9 Aug 2022 11:24:05 -0700
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
Subject: Re: [PATCH 5/5] dt-bindings: Drop Dan Murphy
Message-ID: <20220809112405.071130e2@kernel.org>
In-Reply-To: <20220808104712.54315-6-krzysztof.kozlowski@linaro.org>
References: <20220808104712.54315-1-krzysztof.kozlowski@linaro.org>
        <20220808104712.54315-6-krzysztof.kozlowski@linaro.org>
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

On Mon,  8 Aug 2022 13:47:12 +0300 Krzysztof Kozlowski wrote:
>  Documentation/devicetree/bindings/net/ti,dp83822.yaml           | 2 +-
>  Documentation/devicetree/bindings/net/ti,dp83867.yaml           | 2 +-
>  Documentation/devicetree/bindings/net/ti,dp83869.yaml           | 2 +-

Acked-by: Jakub Kicinski <kuba@kernel.org>
