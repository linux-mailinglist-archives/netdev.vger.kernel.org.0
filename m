Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E281F5BE5FD
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 14:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbiITMhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 08:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiITMhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 08:37:19 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8706B673;
        Tue, 20 Sep 2022 05:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1vlRjcki9MOAV92J5tw0HifJCcSh2HyPOOh/yKDlPgA=; b=HEYKTrBejJ+Q0RnwJYBHzR0SAB
        sAAFOCK8c3jh7OVsJO2eq6KWCMxPxmD6l5lgTYJ/xiOoqeWfSaJUoIkUmm0IG1GaRFtRwzp5JfjyF
        xohBkYoJozNvoyYV1Liida45KlIaZzD/uYAl/bVijTBsEhJsUntJ9YH0cIs7uuM4R/qY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oacUu-00HGfR-B5; Tue, 20 Sep 2022 14:37:08 +0200
Date:   Tue, 20 Sep 2022 14:37:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Zheyu Ma <zheyuma97@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Nick Bowler <nbowler@draconx.ca>
Subject: Re: [PATCH] net: sunhme: Fix packet reception for len <
 RX_COPY_THRESHOLD
Message-ID: <Yymz9K6QXi860AWh@lunn.ch>
References: <20220918215534.1529108-1-seanga2@gmail.com>
 <YyjTa1qtt7kPqEaZ@lunn.ch>
 <ab2ce38a-313b-7e87-aaf5-cfc2b6e0cb28@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab2ce38a-313b-7e87-aaf5-cfc2b6e0cb28@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Please could you add a Fixes: tag indicating when the problem was
> > introduced. Its O.K. if that was when the driver was added. It just
> > helps getting the patch back ported to older stable kernels.
> 
> Well, the driver was added before git was started...
> 
> I suppose I could blame 1da177e4c3f4 ("Linux-2.6.12-rc2"), but maybe I
> should just CC the stable list?

That is a valid commit to use. It is unlikely anybody will backport it
that far, but it does give the machinery a trigger it does need
backporting.

	Andrew

