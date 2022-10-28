Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE980611D40
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 00:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiJ1WLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 18:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiJ1WLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 18:11:06 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B2422B7BB;
        Fri, 28 Oct 2022 15:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=g4W+xGwSlEmjVfbkfAYd8kTZ+lY/v1FjV+L0OFae/HQ=; b=BNsJUJeDdpbWR/vJ5rAmIuoIpw
        yiS5WLb+sdrB2NGZlngtbDF3bs75iRr6HqF9rkJL9IVxGtOCJCWcpGy2c6MlpTQACwQxBRph8Kr8G
        huLORH0XJ1Pu7igzzYruyrGo3mkkHM+CGUb8DvW0p8OMCQGNJifnBNYjTSn0kG/Zu12Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ooXXZ-000s3a-ES; Sat, 29 Oct 2022 00:09:25 +0200
Date:   Sat, 29 Oct 2022 00:09:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, corbet@lwn.net, michael.chan@broadcom.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        huangguangbin2@huawei.com, chenhao288@hisilicon.com,
        moshet@nvidia.com, linux@rempel-privat.de,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next v2] ethtool: linkstate: add a statistic for PHY
 down events
Message-ID: <Y1xTFa1cy5/XSQWj@lunn.ch>
References: <20221028012719.2702267-1-kuba@kernel.org>
 <Y1vIg8bR8NBnQ3J5@lunn.ch>
 <20221028092047.45fa3d19@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028092047.45fa3d19@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Do you have a preference for it being 64b vs 32b at the uAPI level?
> I was leaning slightly towards making both 32b in v3..

32 bit should be sufficient, and keeps everything simple.

   Andrew

