Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A30FE58DF67
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 20:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347334AbiHISxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 14:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343914AbiHISwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 14:52:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23A351A27;
        Tue,  9 Aug 2022 11:23:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4056B6120C;
        Tue,  9 Aug 2022 18:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68EAC433D7;
        Tue,  9 Aug 2022 18:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660069431;
        bh=wIuMzWI3SH6GkOhuSmYYKpDVKw+Zt9Rpl0tkIVhn/mc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j6BUX+q7nXY1SgQGco59LqQLSMl8PEPNupt+l7j0AExL9vrcU76xMOfdT8gVgy3jW
         n/4aGpHqmENnxcKmYRuiC33wqZ8sfOX5W1SjCiVul7gj0l1MHTUrVxVexLGCNR9TJN
         VyFRySD7qoVn2l+IW+5ZBPKGU1uCf6z5raHWNg7quGTlK/Yo4BoKR71+g3/S0Rx0Qr
         pSufsNurSB+suT2p0BJpmQyvO9XG/DIiPe4T52pUJLvicGvwp7R/+0qKQ7taVioSdm
         Tw+Us95xoH6KScaoHs744A2Lw3GDuiMwtqJ0DjogeagZXLxdzGy7uEdx1h+ul5KqnQ
         Rq6hc0QHz5+Nw==
Date:   Tue, 9 Aug 2022 11:23:41 -0700
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
Message-ID: <20220809112341.7599d68e@kernel.org>
In-Reply-To: <c6b890b6-e72f-0377-f0ae-cd15d29c23a1@linaro.org>
References: <20220808104712.54315-1-krzysztof.kozlowski@linaro.org>
        <20220808115202.3175eb1f@kernel.org>
        <c6b890b6-e72f-0377-f0ae-cd15d29c23a1@linaro.org>
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

On Tue, 9 Aug 2022 08:25:29 +0300 Krzysztof Kozlowski wrote:
> On 08/08/2022 21:52, Jakub Kicinski wrote:
> > Integrating it with MAINTAINERS would be another option worth exploring
> > although slightly tangential.
> > 
> > How do you want this merged? It's all over the place subsystem-wise.  
> 
> I was thinking this could go via Rob's tree as fixes for current cycle,
> so your Ack would be great

Sounds good!
