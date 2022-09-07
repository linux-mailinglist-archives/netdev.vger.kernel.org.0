Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44FF25AF900
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 02:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiIGAhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 20:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIGAhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 20:37:33 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5FA85A8B;
        Tue,  6 Sep 2022 17:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1w+PiibJZ2yyuhgSvo52DkSUg05XLDMRLXc6gQeov3U=; b=okSr5ZQbJBoDHWc3KTd52Jkw/J
        ojX7oRUowARXyW8mgmxV3NF9Mh8/KAvbqjpOOYu1FmPWYAiM18m92LwTDq/qE58rtBV6Dg/7RAHSS
        nS3xBKmPrX4tsYUYk/SpVMZSRthhew1WZKsxcxELAuYiYhbhUs+O1Fkmm3xcjEnxTXVQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oVj3R-00Fnzn-ER; Wed, 07 Sep 2022 02:36:33 +0200
Date:   Wed, 7 Sep 2022 02:36:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tao Ren <rentao.bupt@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heyi Guo <guoheyi@linux.alibaba.com>,
        Dylan Hung <dylan_hung@aspeedtech.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Liang He <windhl@126.com>, Hao Chen <chenhao288@hisilicon.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>, Tao Ren <taoren@fb.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] ARM: dts: aspeed: elbert: Enable mac3
 controller
Message-ID: <YxfnkSAVq6FO0vd/@lunn.ch>
References: <20220905235634.20957-1-rentao.bupt@gmail.com>
 <20220905235634.20957-3-rentao.bupt@gmail.com>
 <YxaS2mS5vwW4HuqL@lunn.ch>
 <YxalTToannPyLQpI@taoren-fedora-PC23YAB4>
 <Yxc1N1auY5jk3yJI@lunn.ch>
 <45cdae58-632a-7cbb-c9d5-74c126ba6a3e@gmail.com>
 <YxfZOPz/iWVm0G5F@taoren-fedora-PC23YAB4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxfZOPz/iWVm0G5F@taoren-fedora-PC23YAB4>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Specific to this Elbert platform, we don't have plan to configure
> BCM53134 via OpenBMC MDIO (dts), because we expect the switch always
> loads configurations from its EEPROM.

DSA offers more than configuration. You can also get interface
statistics, and knowledge of if an interface is up/down. And since the
PHY of the switch becomes normal Linux PHYs, you can do cable testing,
if the PHY has support, etc.

Do you have spanning tree to break L2 network loops? Linux will
provide that as well.

However, if you are happy with dumb switch, then what you posted is
sufficient.

	Andrew
