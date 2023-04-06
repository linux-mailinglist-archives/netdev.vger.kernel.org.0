Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0EF36D9976
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 16:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238741AbjDFOTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 10:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbjDFOTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 10:19:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0840F8684;
        Thu,  6 Apr 2023 07:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=TBfJ6wf8alf/OvpFhE5XchUiN3YClBlfWzj1WbPnxqk=; b=JwmG56fnSsOzm9DmtW7KC58bCI
        GZLBEYgVqyxR6pOXPauHKw6mqESPpTVXo1DxH88hF0ZwYvv67O496D7DLCo431Phc/6JxRP8xk6gG
        8fMtUkiE+VIRHII1RksnLtO36PN+BL0rEb/GjAoX/wecF1n0HWSQUzu4Ye2w4GBLkRfU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pkQSZ-009dUG-Nd; Thu, 06 Apr 2023 16:19:31 +0200
Date:   Thu, 6 Apr 2023 16:19:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Lukasz Majewski <lukma@denx.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phy: smsc: Implement .aneg_done callback for LAN8720Ai
Message-ID: <aa6415be-e99b-46df-bb3b-d2c732a33f31@lunn.ch>
References: <20230406131127.383006-1-lukma@denx.de>
 <ZC7Nu5Qzs8DyOfQY@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZC7Nu5Qzs8DyOfQY@corigine.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 03:48:43PM +0200, Simon Horman wrote:
> On Thu, Apr 06, 2023 at 03:11:27PM +0200, Lukasz Majewski wrote:
> > The LAN8720Ai has special bit (12) in the PHY SPECIAL
> > CONTROL/STATUS REGISTER (dec 31) to indicate if the
> > AutoNeg is finished.
> > 
> > Signed-off-by: Lukasz Majewski <lukma@denx.de>
> 
> Hi Lukasz,
> 
> I think you need to rebase this on net-next.
> 
> If you repost please also include 'net-next' in the subject:
> [PATCH net-next v2].
> 
> And a note about the changes between v1 and v2.

This actually seems like a fix. So it should probably be based on net,
and have a Fixes: tag.

Lukasz, how does this bit differ to the one in BMSR? Is the BMSR bit
broken? Is there an errata for this? It would be good to describe the
problem you see which this patch fixes.

	Andrew
