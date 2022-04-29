Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F6B514055
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 03:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353993AbiD2Bnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 21:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353990AbiD2Bnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 21:43:33 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55EF2BB3A;
        Thu, 28 Apr 2022 18:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Oe0OrgHnXO1atGl84DOheHPrpv5NgL2S7w3gvQvSD04=; b=Ez1bInSFT4ZvYvQAgFYLxFFajJ
        YII/5/40WXf6X2HxQwj56dGWgbE0AfIWxpc0uX22wa5MufX3DkP7EjlbAo7R6FMEhRpboM4RE4NDe
        nQCEWC/9ApbCAweG8Pp7Axz61MKl3MQNxPCJk7vpSM/DMf01MNJBeVpeuUVYgR++jaew=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nkFc5-000PG2-9v; Fri, 29 Apr 2022 03:40:05 +0200
Date:   Fri, 29 Apr 2022 03:40:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joel Stanley <joel@jms.id.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dylan Hung <dylan_hung@aspeedtech.com>,
        David Wilder <dwilder@us.ibm.com>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Wilder <wilder@us.ibm.com>
Subject: Re: [PATCH net] net: ftgmac100: Disable hardware checksum on AST2600
Message-ID: <YmtB9QcMjOGL2lIa@lunn.ch>
References: <20220428082858.545176-1-joel@jms.id.au>
 <Yms5JzcVMKDYpR5H@lunn.ch>
 <CACPK8Xeq8MLmRmYW=qo7+FDRG_bwaSTMQtrHhPCwGJ8-ZeFp=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACPK8Xeq8MLmRmYW=qo7+FDRG_bwaSTMQtrHhPCwGJ8-ZeFp=A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 29, 2022 at 01:35:43AM +0000, Joel Stanley wrote:
> On Fri, 29 Apr 2022 at 01:02, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > Fixes: 39bfab8844a0 ("net: ftgmac100: Add support for DT phy-handle property")
> > > Reported-by: David Wilder <wilder@us.ibm.com>
> > > Signed-off-by: Joel Stanley <joel@jms.id.au>
> > > ---
> > > Net maintainers, if no one has a counter proposal I would like this
> > > merged as a fix. Please give Dylan from Aspeed a chance to reply before
> > > applying the patch.
> >
> > What has phy-handle got to do with this? You might want to add an
> > explanation why you picked that as a Fixes: commit, if it is in fact
> > correct.
> 
> If you have a look at that commit, you can see that was where ast2600
> support was added to the driver.

O.K, so please do add an explanation, because it is not obvious. I'm
partially to blame, i should of asked for that patch to be split in
two.

     Andrew
