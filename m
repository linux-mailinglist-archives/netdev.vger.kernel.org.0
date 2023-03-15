Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F096BB655
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 15:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbjCOOl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 10:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbjCOOl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 10:41:28 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298A36A48;
        Wed, 15 Mar 2023 07:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=W2BBs960owSPDTyfR6THQhGliS/0eEum7n0/NRvPXVA=; b=VajmKnChbeV7YPUA20i4UIUZuv
        bOKSBPXgLsNTHrxdnNSNVXrnTr0u15dgZ2kuVhUbc//dYIyG7d4FFG/J9kh/IoqTxER6vMLi9rQgX
        o4Vp1Uf4VuQ4CXMQNbkJ2WNJdcAC6rbGaVpFvI9wNLZUm/Ms4DB3aAueQPsMw3JEzx14=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pcSJZ-007P84-NX; Wed, 15 Mar 2023 15:41:17 +0100
Date:   Wed, 15 Mar 2023 15:41:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Klaus Kudielka <klaus.kudielka@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: don't dispose of Global2 IRQ
 mappings from mdiobus code
Message-ID: <e240e5d2-954d-435f-a36a-c6ef831fa197@lunn.ch>
References: <20230314182659.63686-1-klaus.kudielka@gmail.com>
 <20230314182659.63686-2-klaus.kudielka@gmail.com>
 <ed91b3db532bfe7131635990acddd82d0a276640.camel@gmail.com>
 <20230314200100.7r2pmj3pb4aew7gp@skbuf>
 <e3ae62c36cfe49abc5371009ba6c29cddc2f2ebe.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3ae62c36cfe49abc5371009ba6c29cddc2f2ebe.camel@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 07:07:57AM +0100, Klaus Kudielka wrote:
> On Tue, 2023-03-14 at 22:01 +0200, Vladimir Oltean wrote:
> > 
> > I'm a bit puzzled as to how you managed to get just this one patch to
> > have a different subject-prefix from the others?
> 
> A long story, don't laugh at me.
> 
> I imported your patch with "git am", but I imported the "mbox" of the
> complete message. That was the start of the disaster.

What i found useful is

b4 am [msgid]

It gives you an mbox file containing just patches, which should then
cleanly git am.

	Andrew
