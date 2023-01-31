Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90D5F682390
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 06:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjAaE7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 23:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjAaE7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 23:59:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B7922A0D
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 20:59:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B265611CB
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 04:59:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47829C433EF;
        Tue, 31 Jan 2023 04:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675141186;
        bh=8leMDtfEeAOcfIy3fKUUUP8H826PMRnCnIeB3ObB/Nk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ni5REN9WND4OcLyj1JmEsksqzBAcWes15lhS8NQ7hj7X7xL07nL19lRaxO9upeV8M
         QIowin8U88T+5WCAZQJZ7desjEVrd+4r0+x0njCQn1+W+NtifQs9lDsIXMIsZjJFng
         MD7VzNSk7kyAYoR4w3vwhVS4QaJ3Op6XDyeXRfhVv9Fw3qEHbqqo4p8vxT96fuhnvY
         T7GQ/2lmOd0+E+4P3OiOl/pqnnWOSJRvAJ5hqY4Hw1BwvdXFqDuH1zZVF1j+ZnJmp+
         NYtWNFC+XIXgKNoYXyPes90dm8poK7YOVuczI6Nl6WJvuQDJ9eq1oK4mJOnaiM78un
         MqMtdhOSqopYg==
Date:   Mon, 30 Jan 2023 20:59:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
Subject: Re: [PATCH net-next] net: mdio: mux-meson-g12a: use
 __clk_is_enabled to simplify the code
Message-ID: <20230130205945.07593ea2@kernel.org>
In-Reply-To: <84fb199a-d459-646f-8522-0fe1f7455e26@gmail.com>
References: <84fb199a-d459-646f-8522-0fe1f7455e26@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Jan 2023 21:39:16 +0100 Heiner Kallweit wrote:
> By using __clk_is_enabled () we can avoid defining an own variable for
> tracking whether enable counter is zero.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Appears to have been applied, thanks!
