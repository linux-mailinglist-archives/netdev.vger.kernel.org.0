Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C756242F0
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 14:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbiKJNKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 08:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbiKJNKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 08:10:05 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8E4742E4;
        Thu, 10 Nov 2022 05:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+2SL6ff+kWU3cRnOVLAgE4xFk13QlakKrQ2biA/MOFk=; b=EuIyH5/SgPwinwGVfhlkSvXX9T
        QYIWVUUpFLMJ1/VLX/4LOg7QgEVH0mldjOJQcwR4OnqFEqrkwyX2iIwPWWJcJnXEloCeEswJy/wqI
        9brl46KEwRradfMiK3oQ7E0leXkrMbmrUstoBFjcllp0JZUwlOrzTD7cCvRKHOGkWpYw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ot7Iv-002259-6L; Thu, 10 Nov 2022 14:09:13 +0100
Date:   Thu, 10 Nov 2022 14:09:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tan Tee Min <tee.min.tan@intel.com>,
        Lay Kuan Loon <kuan.loon.lay@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Zulkifli Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>,
        Gan Yi Fang <yi.fang.gan@intel.com>
Subject: Re: [PATCH net v2 RESEND 1/1] net: phy: dp83867: Fix SGMII FIFO
 depth for non OF devices
Message-ID: <Y2z3+QlfgpSFNbXm@lunn.ch>
References: <20221110054938.925347-1-michael.wei.hong.sit@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110054938.925347-1-michael.wei.hong.sit@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 01:49:38PM +0800, Michael Sit Wei Hong wrote:
> Current driver code will read device tree node information,
> and set default values if there is no info provided.
> 
> This is not done in non-OF devices leading to SGMII fifo depths being
> set to the smallest size.
> 
> This patch sets the value to the default value of the PHY as stated in the
> PHY datasheet.
> 
> Fixes: 4dc08dcc9f6f ("net: phy: dp83867: introduce critical chip default init for non-of platform")
> Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>

https://www.spinics.net/lists/netdev/msg858366.html

When sending a new version, please add any Acked-by, or Reviewed-by
tags you have received. It helps get your patch merged if it can
easily be seen is has been reviewed.

   Andrew
