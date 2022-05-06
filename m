Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A0C51DDFD
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 18:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443996AbiEFRCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 13:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392317AbiEFRC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 13:02:29 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DFE6A401
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 09:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=X1Z9IR3ee1uLnZkYJAlLEPfHnAGa9eV36iTxpDaZ1ks=; b=ZoTQ0OmAGEK5pIMJcAg2BVf1ur
        vp2gdhyfFXKk+TX61BuEJIsWXnFwF4tuX+Rsztf3T5I7EvAKu2oJR5FsaFpq3aMvvYbFBw4afyT4O
        /+KoxwUDJlwEZ6iIKnI+z89yt94hMEBD228crIQIN3/8ilm7ehXbK2pm3bivlHJ6/Q+M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nn1Ht-001YC4-K6; Fri, 06 May 2022 18:58:41 +0200
Date:   Fri, 6 May 2022 18:58:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@mellanox.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH RFC] net: bridge: Clear offload_fwd_mark when passing
 frame up bridge interface.
Message-ID: <YnVTwbPH8YU4kciG@lunn.ch>
References: <20220505225904.342388-1-andrew@lunn.ch>
 <20220506143644.mzfffht44t3glwci@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506143644.mzfffht44t3glwci@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Some safer alternatives to this patch are based on the idea that we
> could ignore skb->offload_fwd_mark coming from an unoffloaded bridge
> port (i.e. treat this condition at br1, not at br0). We could:
> - clear skb->offload_fwd_mark in br_handle_frame_finish(), if p->hwdom is 0
> - change nbp_switchdev_allowed_egress() to return true if cb->src_hwdom == 0

O.K, i will try out these solutions.

Thanks
     Andrew
