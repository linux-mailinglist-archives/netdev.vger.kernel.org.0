Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE6196686BB
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 23:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240324AbjALWTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 17:19:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240839AbjALWSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 17:18:50 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB0E6E0E8
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 14:10:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dMPv0I4FZxxrjr9zAG/qiyE1B4A9IL3PFpXYVQwpkaw=; b=UH+7g7sQmiWuAw39AS7VgZAavr
        NBvTTYo4qOCQJMr3MR7QoXc0g2oAsJYh3oKGJ8p1tEQGdiqM/1SxDdJLd2KXy3WuIg9l0HA5K7BsK
        s7De94a4Jj104To3MUGb7NKF+rEal9RbQlGz7hcRo8EiOtxWGF1liDEp67NIw4gFmoNU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pG5m6-001viU-LW; Thu, 12 Jan 2023 23:10:18 +0100
Date:   Thu, 12 Jan 2023 23:10:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Thompson <davthompson@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, cai.huoqing@linux.dev,
        brgl@bgdev.pl, limings@nvidia.com, chenhao288@hisilicon.com,
        huangguangbin2@huawei.com, Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v3 2/4] mlxbf_gige: support 10M/100M/1G speeds
 on BlueField-3
Message-ID: <Y8CFSlrHOJZZtn2d@lunn.ch>
References: <20230112202609.21331-1-davthompson@nvidia.com>
 <20230112202609.21331-3-davthompson@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112202609.21331-3-davthompson@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 03:26:07PM -0500, David Thompson wrote:
> The BlueField-3 OOB interface supports 10Mbps, 100Mbps, and 1Gbps speeds.
> The external PHY is responsible for autonegotiating the speed with the
> link partner. Once the autonegotiation is done, the BlueField PLU needs
> to be configured accordingly.
> 
> This patch does two things:
> 1) Initialize the advertised control flow/duplex/speed in the probe
>    based on the BlueField SoC generation (2 or 3)
> 2) Adjust the PLU speed config in the PHY interrupt handler
> 
> Signed-off-by: David Thompson <davthompson@nvidia.com>
> Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
