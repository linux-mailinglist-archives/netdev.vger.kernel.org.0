Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 433BD62318E
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 18:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbiKIRfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 12:35:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbiKIRfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 12:35:00 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB52018E15
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 09:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=A3A/7fEc5XmqivpsUy9hha+PuMXfWQ6HHaCE96W6INs=; b=eR6PWbGofUNIhNnnjW+qvOIjWb
        0E5Wdd8FytbevOnCN0FeM1n3e2l49L3KLgNSlxJte2U3dg2FKbGrBLw3WSnZ7hLbrc+n+/XGcqRXY
        lZiA1AZDd83uCC81WEFsUyyvVXLXvugP+11ZBlVWUToPpiSrTgepsetH4anusrxYHrK8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1osoyX-001w4P-Ao; Wed, 09 Nov 2022 18:34:57 +0100
Date:   Wed, 9 Nov 2022 18:34:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rodolfo Giometti <giometti@enneenne.com>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Stephen Hemminger <shemminger@osdl.org>,
        Flavio Leitner <fbl@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net br_netlink.c:y allow non "disabled" state for
 !netif_oper_up() links
Message-ID: <Y2vkwYyivfTqAfEp@lunn.ch>
References: <20221109152410.3572632-1-giometti@enneenne.com>
 <20221109152410.3572632-2-giometti@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109152410.3572632-2-giometti@enneenne.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 04:24:10PM +0100, Rodolfo Giometti wrote:
> A generic loop-free network protocol (such as STP or MRP and others) may
> require that a link not in an operational state be into a non "disabled"
> state (such as listening).
> 
> For example MRP states that a MRM should set into a "BLOCKED" state (which is
> equivalent to the LISTENING state for Linux bridges) one of its ring
> connection if it detects that this connection is "DOWN" (that is the
> NO-CARRIER status).

Does MRP explain Why?

This change seems odd, and "Because the standard says so" is not the
best of explanations.

     Andrew
