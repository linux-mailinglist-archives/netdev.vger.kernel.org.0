Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F1021DE38
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 19:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729937AbgGMRHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 13:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729840AbgGMRHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 13:07:08 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C0DC061755;
        Mon, 13 Jul 2020 10:07:08 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id AE9D22250C;
        Mon, 13 Jul 2020 19:07:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1594660022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=naa0bq160z/s1qRNFsxjOqcemEvMYEkV192FCUK+et4=;
        b=j6H9yteWuYc+17nhU0MWpo0V35tz7bLCR9TbrUnGp6MvG/LcQ3JcYY2F/aj7oildKk9TyC
        ybLDFEDd3WvTyqX+q335a2WLD2aczTLRavst+EIqXPgLKuGS0T++6i3pc40bxhBySSGAeD
        oIUvJMVfoWNhn6vRydRExX3gL9LBr28=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 13 Jul 2020 19:07:01 +0200
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v6 1/4] net: phy: add USXGMII link partner
 ability constants
In-Reply-To: <20200713170119.GI1078057@lunn.ch>
References: <20200709213526.21972-1-michael@walle.cc>
 <20200709213526.21972-2-michael@walle.cc>
 <20200713163416.3fegjdbrp6ccoqdm@skbuf> <20200713170119.GI1078057@lunn.ch>
User-Agent: Roundcube Webmail/1.4.7
Message-ID: <d28703d93f0f1112211bb4a4aa8f7c99@walle.cc>
X-Sender: michael@walle.cc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2020-07-13 19:01, schrieb Andrew Lunn:
> On Mon, Jul 13, 2020 at 07:34:16PM +0300, Vladimir Oltean wrote:
>> On Thu, Jul 09, 2020 at 11:35:23PM +0200, Michael Walle wrote:
>> > The constants are taken from the USXGMII Singleport Copper Interface
>> > specification. The naming are based on the SGMII ones, but with an MDIO_
>> > prefix.
>> >
>> > Signed-off-by: Michael Walle <michael@walle.cc>
>> > ---
>> 
>> Somebody would need to review this patch, as it is introducing UAPI.
> 
> Anybody have a link to the "USXGMII Singleport Copper Interface"
> specification.

You have to login at cisco (registration is free), see here:
   https://archive.nbaset.ethernetalliance.org/technology/specifications/

-michael
