Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591C85E6EB4
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 23:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbiIVVmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 17:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbiIVVlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 17:41:49 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861BD36430
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 14:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=svwMEtgdQlrAE5sC5YklAhTS/bwgMIybVRpPO4cVeUc=; b=0OV2lq8YvHZDMzDEFSTTXPjlZa
        I50qqZq37UT1vWwZD3ML4KrmJ/78rBYZJeJSQiOhooUOndDShgQDsEQ5qvqVG5ePoiQh06ogC6ZPG
        OJ9BXsBTVK5+CRlUwAXH4/Sad2Mhwwd2wqSeHuwqOcDHGckcyjwyLMLxueqrViQtdAwQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1obTww-00HZd1-SC; Thu, 22 Sep 2022 23:41:38 +0200
Date:   Thu, 22 Sep 2022 23:41:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Message-ID: <YyzWkuFL+gPubz2M@lunn.ch>
References: <20220921153349.0519c35d@hermes.local>
 <20220922144123.5z3wib5apai462q7@skbuf>
 <YyyCgQMTaXf9PXf9@lunn.ch>
 <20220922184350.4whk4hpbtm4vikb4@skbuf>
 <20220922120449.4c9bb268@hermes.local>
 <20220922193648.5pt4w7vt4ucw3ubb@skbuf>
 <YyzGvyWHq+aV+RBP@lunn.ch>
 <862fa246-287f-519e-f537-fff85642fb15@gmail.com>
 <20220922212809.jameu6d4jtputjft@skbuf>
 <fa76bef5-50c5-d9d7-c2ed-e743dcbdcf2c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa76bef5-50c5-d9d7-c2ed-e743dcbdcf2c@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Hmm, did you see the parallel sub-thread with Jakub's proposed 'via'?
> > I was kind of reworking to use that, and testing it right now. What do
> > you prefer between the 2?
> 
> Emails crossed, I just responded to the parallel thread and do prefer
> "conduit".

"conduit" does have the advantage it is something we already use for
the concept of the master interface. 'via' would be totally new, and i
don't see any need to introduce a new term.

    Andrew
