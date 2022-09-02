Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55BCB5AA64D
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 05:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235194AbiIBDW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 23:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234622AbiIBDW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 23:22:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBBAA99F9;
        Thu,  1 Sep 2022 20:22:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D881EB82980;
        Fri,  2 Sep 2022 03:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24D7C433D6;
        Fri,  2 Sep 2022 03:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662088972;
        bh=47feahsbwJMMuZYJG0XCwSe5FDCgnOyKkfLrDsV455g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dy9j7C3muf+St6PIzZ1PH6dV9m0FtsZjIu+O6wLkqHljooJrpyQesWoAhUImXe/9I
         a8OLuGf40LfmJPrmgKxGA9dYYiJOEU/UB6rTAQ34Fz2LDgCrj4/si9cCKD+sghGrFQ
         +V+D/W7mL6AGaUcQIiqIyF68YqKZB2dDe1D4hivvvpHGwTkZ/2KgPsqMlZlRaGAKYb
         NkyyRAeMqAFwqOroVZ1A1QitM9jL7m3K1P/9U1AvERo1DFrLKhXvf3NYFBo7Q7nFR/
         HuJlapuMP8dy6UsCd9YtZjcAJ+mC2x+kCefGVA7yrECawc31BAwrkjxe7uPXDJSznY
         wSgSeMegNminA==
Date:   Thu, 1 Sep 2022 20:22:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        kernel test robot <lkp@intel.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v5 5/7] ethtool: add interface to interact with
 Ethernet Power Equipment
Message-ID: <20220901202251.6fd23828@kernel.org>
In-Reply-To: <20220831133240.3236779-6-o.rempel@pengutronix.de>
References: <20220831133240.3236779-1-o.rempel@pengutronix.de>
        <20220831133240.3236779-6-o.rempel@pengutronix.de>
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

On Wed, 31 Aug 2022 15:32:38 +0200 Oleksij Rempel wrote:
> Add interface to support Power Sourcing Equipment. At current step it
> provides generic way to address all variants of PSE devices as defined
> in IEEE 802.3-2018 but support only objects specified for IEEE 802.3-2018 104.4
> PoDL Power Sourcing Equipment (PSE).

include/linux/pse-pd/pse.h:37: warning: Function parameter or member 'podl_admin_state' not described in 'pse_control_status'
include/linux/pse-pd/pse.h:37: warning: Function parameter or member 'podl_pw_status' not described in 'pse_control_status'
include/linux/pse-pd/pse.h:52: warning: Function parameter or member 'ethtool_get_status' not described in 'pse_controller_ops'
include/linux/pse-pd/pse.h:52: warning: Function parameter or member 'ethtool_set_config' not described in 'pse_controller_ops'
