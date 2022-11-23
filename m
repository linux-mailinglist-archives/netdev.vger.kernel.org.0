Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06416362FB
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238151AbiKWPMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238305AbiKWPMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:12:43 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5A917E17
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 07:12:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YVwegqIeGRMvlOVx9TUybvDtI976bquXSGVDR9S2SDE=; b=rapBTrBJ8BKLpjezJdIIm1lUhD
        sk6G2Ir98W6mRixraSo2NY+mB8ZcUX1Tovmll/1Qq+TRAxcTzwDSd3SR+/RhCG1WCxVA02oBCvBXF
        x4zW/hYDLGchamXKAmdXDtaxlzc2GErUB+6iwyNB6pE77YB/2EtCsxzMzTTwgFjMj224=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oxrQ2-003Eah-Ja; Wed, 23 Nov 2022 16:12:10 +0100
Date:   Wed, 23 Nov 2022 16:12:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Steve Williams <steve.williams@getcruise.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        vinicius.gomes@intel.com, xiaoliang.yang_1@nxp.com
Subject: Re: [EXT] Re: [PATCH net-next] net/hanic: Add the hanic network
 interface for high availability links
Message-ID: <Y344ShAVEjFtKyXA@lunn.ch>
References: <20221118232639.13743-1-steve.williams@getcruise.com>
 <20221121195810.3f32d4fd@kernel.org>
 <20221122113412.dg4diiu5ngmulih2@skbuf>
 <CALHoRjcw8Du+4Px__x=vfDfjKnHVRnMmAhBBEznQ2CfHPZ9S0A@mail.gmail.com>
 <20221123142558.akqff2gtvzrqtite@skbuf>
 <Y34zoflZsC2pn9RO@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y34zoflZsC2pn9RO@nanopsycho>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I guess for the same reason other soft netdevice driver are in the
> kernel. You can do bridge, bond, etc in a silimilar way you described
> here...

Performance of tun/tap is also not great.

Doing this in the kernel does seem correct. But we need one
implementation which can be expanded over time to cover everything in
the standard. From what has been said so far, it seems like this
implementation focuses on leaf nodes, because that is what the author
of the code is interested in. But is the design generic enough it can
be expanded to cover everything else? I'm not saying it actually needs
to implement it now, we just need to have a vision of how it can be
extended to implement the rest. What we don't want is one way for leaf
nodes, and a completely different code base for other nodes.

       Andrew
