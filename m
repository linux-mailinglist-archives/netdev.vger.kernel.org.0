Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 527AC63E392
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiK3WkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:40:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiK3Wj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:39:58 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94E292A2C
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4XAnVCdMTYxqo2RlZScaFvUY2o4X31nW853ZpBBsF18=; b=FnCZuOpPl8LKpkZIq3vEA79fn5
        Xebg1GyaDyRjCX1dg14ucYL0Z5AG40/ceZbXpl+j1CQ/sskjzNMfpksS+yRHRqBvoWQ8wLHJUQ4J5
        bvpmDHDkXpxzqvwuQqr3nN88Qs9q29MmrpMdYEmHSqVK6mu/N9k/Lqh+styIPNTDSJ9E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0VkA-0040RK-2N; Wed, 30 Nov 2022 23:39:54 +0100
Date:   Wed, 30 Nov 2022 23:39:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next v2 2/4] tsnep: Add ethtool::get_channels support
Message-ID: <Y4fbullq1JjRtyWL@lunn.ch>
References: <20221130193708.70747-1-gerhard@engleder-embedded.com>
 <20221130193708.70747-3-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130193708.70747-3-gerhard@engleder-embedded.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 08:37:06PM +0100, Gerhard Engleder wrote:
> Allow user space to read number of TX and RX queue. This is useful for
> device dependent qdisc configurations like TAPRIO with hardware offload.
> Also ethtool::get_per_queue_coalesce / set_per_queue_coalesce requires
> that interface.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
