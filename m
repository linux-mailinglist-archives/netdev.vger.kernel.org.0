Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E626EF5C2
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 15:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241224AbjDZNsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 09:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241210AbjDZNsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 09:48:38 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E776A70;
        Wed, 26 Apr 2023 06:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=8wWWPvur8h/Ij6ruLlvui/wCIPbLdjmdshto9tS44Xk=; b=OIhLt+Mx0FLhYVseg7n40tccW9
        T08XOqPLYztlGByIliFPzd9f4zNosrZKwCvXsZtBG7pAysrtvSXHBz1c0aAuTsn4k9wFjh+5rU5Bp
        0hIRfrwjd9I8lwmXsicA69Y1J1pSHxD6NI1vvt1gwh51WnWQY5fF75YO+29EmJCHuN5w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1prfVQ-00BHEm-8J; Wed, 26 Apr 2023 15:48:24 +0200
Date:   Wed, 26 Apr 2023 15:48:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Harini Katakam <harini.katakam@amd.com>
Cc:     robh+dt@kernel.org, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, vladimir.oltean@nxp.com,
        wsa+renesas@sang-engineering.com,
        krzysztof.kozlowski+dt@linaro.org, simon.horman@corigine.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, harinikatakamlinux@gmail.com,
        michal.simek@amd.com, radhey.shyam.pandey@amd.com
Subject: Re: [PATCH net-next v2 3/3] phy: mscc: Add support for VSC8531_02
 with RGMII tuning
Message-ID: <2bbbe874-2879-4b1a-bf79-2d5c1a7a35f4@lunn.ch>
References: <20230426104313.28950-1-harini.katakam@amd.com>
 <20230426104313.28950-4-harini.katakam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426104313.28950-4-harini.katakam@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 04:13:13PM +0530, Harini Katakam wrote:
> From: Harini Katakam <harini.katakam@xilinx.com>
> 
> Add support for VSC8531_02 (Rev 2) device.
> Add support for optional RGMII RX and TX delay tuning via devicetree.
> The hierarchy is:
> - Retain the defaul 0.2ns delay when RGMII tuning is not set.
> - Retain the default 2ns delay when RGMII tuning is set and DT delay
> property is NOT specified.

tuning is probably the wrong word here. I normally consider tuning as
small changes from 0ns/2ns. The course setting of 0ns or 2ns is not
tuning. I normally use RGMII internal delays to refer to that.

However, i'm not sure there is consistency among drivers.

	 Andrew
