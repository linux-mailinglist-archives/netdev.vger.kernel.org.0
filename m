Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3A545E5CE5
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 10:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiIVIGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 04:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiIVIFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 04:05:44 -0400
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A654D47B9F;
        Thu, 22 Sep 2022 01:05:36 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 6FDB4124B;
        Thu, 22 Sep 2022 10:05:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1663833934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TpzBNG5UwdogbiC6mYdoQl1YRb9gRLtmngkK9Bob73I=;
        b=HMHyK+0h27R4POjRSpnqWkXxQIhda7BTUJ9xT4KhdmGDBspERK4EvFkuAMoVqz+13+ygt1
        B98WODZj4WNACvX2jh0KDkLeHg1swxTjk/6m4k/rZf00AoIVrOqEQUwI18KOFzE2OiNyZw
        lOi95CvwGNU0MaUqy0nXX4vhq9uYyss9nv972GTI6Ejt88UX4HL8q8aok7vc15mlJ8FxO9
        AXiJzzW+ix6W7JwThYh8+GyTc2PKfxEPyJ9wriFC3IO0CAE4t87MavkDAFZysqBSFb+7sd
        q/rU0LcWLoA6cvHvUYcC4e+3yZrrUNLJyPJfobh5nR++WYfx7iRiq9usy1ZghQ==
From:   Michael Walle <michael@walle.cc>
To:     marcus.carlberg@axis.com
Cc:     andrew@lunn.ch, davem@davemloft.net, devicetree@vger.kernel.org,
        edumazet@google.com, hkallweit1@gmail.com, kernel@axis.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, lxu@maxlinear.com, netdev@vger.kernel.org,
        pabeni@redhat.com, Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net-next 0/2] net: phy: mxl-gpy: Add mode for 2 leds
Date:   Thu, 22 Sep 2022 10:05:29 +0200
Message-Id: <20220922080529.928823-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220920151411.12523-1-marcus.carlberg@axis.com>
References: <20220920151411.12523-1-marcus.carlberg@axis.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> GPY211 phy default to using all four led pins.
> Hardwares using only two leds where led0 is used as the high
> network speed led and led1 the low network speed led will not
> get the correct behaviour since 1Gbit and 2.5Gbit will not be
> represented at all in the existing leds.

I might be wrong, but PHY LED bindings should be integrated with/using
the LED subsystem. Although I didn't see any development regarding this
for a long time.

That being said, it seems you are adding a new (DT) property which
just matches your particular hardware design, no?

-michael
