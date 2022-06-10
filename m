Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86265546E7D
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 22:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348823AbiFJUeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 16:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347934AbiFJUeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 16:34:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD1F4EDC6;
        Fri, 10 Jun 2022 13:34:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE2FFB83779;
        Fri, 10 Jun 2022 20:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F3FC34114;
        Fri, 10 Jun 2022 20:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654893254;
        bh=EILQd+YWkr1rPaW8ldUePcDfeY9c8mbJR99AZrSm2Ig=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tRJxW2CgJlRYQKru9IQVWPEQ8ciuLvcEp92RphQNQzTMqjeTikbb2boPaglcjC0U2
         WqjuxlZ9jSXCGvzDPUtE9luEsBC/26WF8D9jbu8eOVsSIf+doY2456z/p+O1lGkG3p
         ziPVG2p0bw+AAZcWADO0Wv5BHNHU6ovnoGSve6BzyoGcsmefGhJnSVUi/pyWk0I1ph
         UqSOeu+k00MmuBgBuRrC4jMnCzydJCQtqxbeVrPKxR4B4v5bEErJgIT9rAfs6CZqVa
         2u1eyr0uCMJ+y0UJeBDgV+JelhOaPQz/oz1Z1E9rBtXC1h/J1iSbl7Wi8FwoRYL3Np
         e7C2mBTBbLKJg==
Date:   Fri, 10 Jun 2022 13:34:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v10 net-next 0/7] add support for VSC7512 control over
 SPI
Message-ID: <20220610133413.39ba9170@kernel.org>
In-Reply-To: <20220610202330.799510-1-colin.foster@in-advantage.com>
References: <20220610202330.799510-1-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jun 2022 13:23:23 -0700 Colin Foster wrote:
> v10
>     * Fix warming by removing unused function

I've had it today with people bombarding the list with multiple
versions of the same patchset.

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#i-have-received-review-feedback-when-should-i-post-a-revised-version-of-the-patches

If you can't find a compiler before sending the set you're gonna
have to wait. I'm tossing this, come back after the weekend, bye.
