Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC7F5A7066
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 00:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbiH3WLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 18:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbiH3WLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 18:11:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12F557897;
        Tue, 30 Aug 2022 15:11:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CBAE60EDE;
        Tue, 30 Aug 2022 22:11:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CF3C433C1;
        Tue, 30 Aug 2022 22:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661897462;
        bh=wa5piPrgmjWz6tZbqfUlg2LDAAe92By2WjU8solW5EE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h7NBNvLv1/2ad14L5VglVJFgDzSA/m+VkicYhMCPWmLKglLMExDn3HapETMX78C5v
         ucPcZ+FyWxJfyiq3wLFIaeeYjcBd8AWBdD0sVUCjnVXbiTFo5NEiHGYThxbRz5kYKU
         O0X1n/BAmc3taanQPrHK+/aDXEp3RP/ert0CzCCLMKYPggKfsr13wp6uxeHN3fuI2q
         KCBiLJBEx1N2KfonpBj94kWIaYJp18JtpXCfY9R6tNhK+gyKkdzCYYrNu45Z/yvAyX
         4nvE10oxhrgGgrT6334g78OorJfdJO2vOHRh4aSuAxnqbEJr5Tvk4uzJPFoIuFJ7b3
         kv1Ma5BUftAtw==
Date:   Tue, 30 Aug 2022 15:11:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yevhen Orlov <yevhen.orlov@plvision.eu>
Cc:     netdev@vger.kernel.org,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: Re: [PATCH net-next v4 7/9] net: marvell: prestera: add stub
 handler neighbour events
Message-ID: <20220830151100.10ea3800@kernel.org>
In-Reply-To: <20220825202415.16312-8-yevhen.orlov@plvision.eu>
References: <20220825202415.16312-1-yevhen.orlov@plvision.eu>
        <20220825202415.16312-8-yevhen.orlov@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Aug 2022 23:24:13 +0300 Yevhen Orlov wrote:
> Actual handler will be added in next patches

Please make sure each point in the patch set builds cleanly.
Here we have a warning which disappears with the next patch:

drivers/net/ethernet/marvell/prestera/prestera_router.c:624:26: warning: unused variable 'sw' [-Wunused-variable]
        struct prestera_switch *sw = net_work->sw;
                                ^
