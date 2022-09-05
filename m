Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22EB35AD7E7
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 18:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbiIEQyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 12:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237618AbiIEQxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 12:53:51 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4668A4F66A
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 09:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=k2l9yz+he8FGnjcVFUgQnA0e4Agd4V2sSdppyYADFa0=; b=vRsaD25GV/4tz4qOkv6kAyAN8T
        9upHCyF+RgfoKZ/IZ1cHsDFAmh+3BHmS0bPePs78HjabkE6RfZwIoW9elJO6skE49/Ov0nJF635Tm
        LHFzThKEU13FzDTL55W28ArlAZ4McK0gEmR9lN/sxoxHjq9vs2JTjGAj5Riv+uiMqCRY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oVFLq-00FfJn-NN; Mon, 05 Sep 2022 18:53:34 +0200
Date:   Mon, 5 Sep 2022 18:53:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Casper Andersson <casper.casan@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH net-next] net: sparx5: fix return values to correctly use
 bool
Message-ID: <YxYpjjYPK6lQzGAw@lunn.ch>
References: <20220902084521.3466638-1-casper.casan@gmail.com>
 <YxIyRDzQt5cN7Lbn@lunn.ch>
 <20220905152855.ud6a7cqbygoyvnfj@wse-c0155>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220905152855.ud6a7cqbygoyvnfj@wse-c0155>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 05, 2022 at 05:33:44PM +0200, Casper Andersson wrote:
> Hi,
> 
> On 2022-09-02 18:41, Andrew Lunn wrote:
> > On Fri, Sep 02, 2022 at 10:45:21AM +0200, Casper Andersson wrote:
> > > Function was declared to return bool, but used error return strategy (0
> > > for success, else error). Now correctly uses bool to indicate whether
> > > the entry was found or not.
> > 
> > I think it would be better to actually return an int. < 0 error, 0 =
> > not foumd > 1 found. You can then return ETIMEDOUT etc.
> > 
> >     Andrew
> 
> I can submit a new version with this. But since the commit title will be
> different I assume I should make it a new patch and not a v2.

I don't think it matters if it is a new patch, or a v2. There is some
attempts to track patches through their revisions, but subjects do
change as patches get revised, so it is never a precise things.

       Andrew
