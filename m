Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65F496DAFDE
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 17:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbjDGPrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 11:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbjDGPrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 11:47:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5941A9EE5;
        Fri,  7 Apr 2023 08:47:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE4046487C;
        Fri,  7 Apr 2023 15:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C99C433D2;
        Fri,  7 Apr 2023 15:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680882467;
        bh=U2UyJweFotw6U+oijMIvIL19GNAZ0Ch1uAY5xaWYFWo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TkX/hFrbJAt/GQCfTv/GnKyzLEtHeJhkn8B0g/NbdC8ufz/A9/tjP6P0fpHwc2XMj
         0AayUtzfp1z01/XR8tNqpCMPcI/FF9V6wdAoaKzy2JKI4jZePa7t1gUdP3xV6FOrho
         9WNCGCzmLo3/eMbyvkHxLC0kagESN1aWM/yI9k93fnZ0ebnXSJCqL1h2xjpbPss8u8
         usajRZ8AmB4hw8qpTx4aBxoYB51lKSayJ3gxzhDe4INtLXN+NV+XaP9maEUhe/KNq8
         lebjCVDranxwfOFaleHzzSlycIrQxJ39b6i2UE24+jdkD6Jkq+kq84s19s6/SAVA00
         PskURmuYMY/wg==
Date:   Fri, 7 Apr 2023 08:47:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>,
        Xu Liang <lxu@maxlinear.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oss-drivers@corigine.com,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>, linux-hwmon@vger.kernel.org
Subject: Re: [PATCH 1/8] net: netronome: constify pointers to
 hwmon_channel_info
Message-ID: <20230407084745.3aebbc9d@kernel.org>
In-Reply-To: <20230407145911.79642-1-krzysztof.kozlowski@linaro.org>
References: <20230407145911.79642-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  7 Apr 2023 16:59:04 +0200 Krzysztof Kozlowski wrote:
> This depends on hwmon core patch:
> https://lore.kernel.org/all/20230406203103.3011503-2-krzysztof.kozlowski@linaro.org/

That patch should have been put on a stable branch we can pull
and avoid any conflict risks... Next time?
