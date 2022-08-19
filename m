Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54AC759A0BE
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 18:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349962AbiHSQMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 12:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352126AbiHSQLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 12:11:32 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E0D113DD0;
        Fri, 19 Aug 2022 08:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GrUZ6R8n7vev89O6T0Ky0Xq1mndn1wTWujgzj1y80B4=; b=r6vufpG6vTiXmsN1xb2U0nStuA
        Asurqg9pfrJdFlGSErBpZ5pV+SKIt06vaC5VqPy56rmX4PLdzKbAQqC2JkgsjL06FETqpD6PS3Dcs
        WnUuyQAJS8+ii02bIC20xViWK9GTaeXEiFhdQfPp6fy2EtRuwTYvxyq5VReIv4g02aAo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oP4Mt-00Dvit-Pr; Fri, 19 Aug 2022 17:57:07 +0200
Date:   Fri, 19 Aug 2022 17:57:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     wei.fang@nxp.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: fec: change the default rx copybreak length to
 1518
Message-ID: <Yv+y0x6MzVmShWL9@lunn.ch>
References: <20220819090041.1541422-1-wei.fang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819090041.1541422-1-wei.fang@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 05:00:41PM +0800, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> Set the default rx copybreak value to 1518 so that improve the
> performance when SMMU is enabled. User can change the copybreak
> length in dynamically by ethtool.

Please provide some benchmark for this. And include a range of SoCs
which include the FEC. Maybe this helps for the platform you are
testing on, but is bad for imx25, Vybrid etc?

> + * The driver support .set_tunable() interface for ethtool, user
> + * can dynamicly change the copybreak value.
> + */

Which also means you could change it for your platform. So a patch
like this needs justifying.

     Andrew
