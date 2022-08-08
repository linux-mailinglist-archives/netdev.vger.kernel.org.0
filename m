Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728F058CEE1
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 22:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238466AbiHHUIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 16:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244000AbiHHUIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 16:08:42 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193FE1A38A;
        Mon,  8 Aug 2022 13:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mCH4Ky6LNxIz3EUvjmENi2wH/GDJf2ZQNALt04Jbl6M=; b=Zu/6NTWt6HC9WgZRwp7AyyegdH
        5drn41sivwpGtYz6kAC95f3lS2NipoJZek9gryL+xL+bIOhZQVVESLK8PPl7TKrPAeJ92ra/YLMFk
        x4AcVvZr2Nm366FdFHJOEJOLuYEWA3e/n7DHKG3xDlS11vB4N0oWXD+cBOSjtq7CZ/pE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oL92j-00CkuA-Uz; Mon, 08 Aug 2022 22:08:05 +0200
Date:   Mon, 8 Aug 2022 22:08:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andrew Davis <afd@ti.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
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
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Reichel <sre@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-hwmon@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-leds@vger.kernel.org, netdev@vger.kernel.org,
        linux-pm@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 5/5] dt-bindings: Drop Dan Murphy
Message-ID: <YvFtJRJHToDrfpkN@lunn.ch>
References: <20220808104712.54315-1-krzysztof.kozlowski@linaro.org>
 <20220808104712.54315-6-krzysztof.kozlowski@linaro.org>
 <43b3c497-97fd-29aa-a07b-bcd6413802c4@linaro.org>
 <6ae15e00-36a4-09a8-112e-553ed8c5f4da@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ae15e00-36a4-09a8-112e-553ed8c5f4da@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Either way, I have several of these parts and can support these. Feel free
> to replace Dan's email with my email if that works better.

Please could you submit a patch to MAINTAINERS replacing Dan's name
with your. I see lots of bounces from PHY driver patches because the
get_maintainers script returns his address.

Thanks
	Andrew
