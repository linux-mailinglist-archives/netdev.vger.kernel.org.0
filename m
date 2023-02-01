Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC95A685F4E
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 06:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbjBAFze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 00:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjBAFzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 00:55:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF74DA24B
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 21:55:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB380B8205D
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 05:55:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75027C433EF;
        Wed,  1 Feb 2023 05:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675230930;
        bh=wma6HotgBo/yi05Re0C5F0WxjqM4CDoXrwTj+UVTXOE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tgs/POS4q7c/EHAs9J4RA7R6jbFlyHpK6Cp+oQ5yKWDHSALuleR82Ccfv7m8nHHCj
         kni4V29ICoIOZDyWhnxdVvz9rx5xMkWuTtSrGRDa7U17828KE/YoEg4ElaZV4FJ9K0
         fD11yjhMGbmqXJlsjGEcT8sGZ2CKu8P/pHEoS4+fO9EbsulNgKiHz+o/HqA5+km5DN
         YhrhRIq3ju3OnEOQvVAmw37pb4UWK6fmc7L2TgFqsQPx0SnvncEA8V9VcShOqy9jPK
         qI1Tk/ivQpVVf4JmXSbCjQWEdXwZRBO6/oD8NqRcz69niswum4PnyJI8Plyg+wJkWp
         bM6+vh6Ygj9rA==
Date:   Tue, 31 Jan 2023 21:55:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        Chris Healy <cphealy@gmail.com>, Kevin Hao <haokexin@gmail.com>
Subject: Re: [PATCH net] net: phy: meson-gxl: use MMD access dummy stubs for
 GXL, internal PHY
Message-ID: <20230131215528.7a791a54@kernel.org>
In-Reply-To: <23ecd290-56fb-699a-8722-f405b723b763@gmail.com>
References: <23ecd290-56fb-699a-8722-f405b723b763@gmail.com>
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

On Tue, 31 Jan 2023 22:03:21 +0100 Heiner Kallweit wrote:
> Jerome provided the information that also the GXL internal PHY doesn't
> support MMD register access and EEE. MMD reads return 0xffff, what
> results in e.g. completely wrong ethtool --show-eee output.
> Therefore use the MMD dummy stubs.
> 
> Note: The Fixes tag references the commit that added the MMD dummy
> access stubs.
> 
> Fixes: 5df7af85ecd8 ("net: phy: Add general dummy stubs for MMD register access")

Please make sure to CC the author. Adding Kevin Hao <haokexin@gmail.com>
