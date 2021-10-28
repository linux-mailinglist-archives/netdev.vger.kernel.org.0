Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7FA243E2A3
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhJ1Nxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:53:53 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:51603 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230406AbhJ1Nxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 09:53:52 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 197215805AF;
        Thu, 28 Oct 2021 09:51:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 28 Oct 2021 09:51:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=EY6Ppd
        RieQ6Lm/hdWqDPDgeMydgm2AXJQ8PLkaYkjtY=; b=n1XABuk8745wwFiYSV1A0p
        0uwWaRwyGRKSfjFryXWNrz8B6KA305fHhK3K+VJhq9Z82uYoZBw65w6yIPYKqKM0
        YKdSy3c6g0jhnIp/ETefxFOxlonyOjiZXDP+1FxtIHcU3vrW0RKzjxAgV1kg3UZ5
        BtVmjYUKHosSy44oDYPkwOKP7G0HIPnTZN2x/bseM0AR52k+Kyz+2rV1hBxWDRYG
        CwV8WWI3SDuL6Zzf+2H7s9kUomkgRgb3TNxIkMJ7rrhbO6oMN+v5+/NLOFhdOfLw
        ezXCciA8lzynz9XA2XPMUkDJku9yS7mtKrxFsCNX6L0xk5j8Dif9l+EdVZM9LJJQ
        ==
X-ME-Sender: <xms:3Kp6YYmAsTrphXhaSwmoyuvHVd0vWBHnZP9ZsZ46DTsKkHkjWwXnyQ>
    <xme:3Kp6YX3sUAv0rTyuZAtLELK95IWKodfixM51dGHq6LpN1QHjJ4LbqW3W_gy3etIcG
    vyF8EmYxUKlC3I>
X-ME-Received: <xmr:3Kp6YWpXieYFtGCFWStWxe4DXgllk8h4qHsYRWRGA0SZQKhCgSlh08gd4KaxzpjN8jyWHP7kwm6c1QyVzzf4ThbgDYWctQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdegvddgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:3Kp6YUngnlNHRCeUo9R3blMvtKee1TioUky6BU0aZ-nhcZkupzD5Ew>
    <xmx:3Kp6YW3ZtqX1Ia0R4cyC80irKwIB_qs3DbByq4uXjw7egzia40L4gg>
    <xmx:3Kp6YbsdlU0_ofGQj6CCkN7XcnMLTSjGJCsFoJfRJpq92GUIgaFXAw>
    <xmx:3ap6Yfug6nYyhGBFqUMNvl-wbQsIQRVVbmI8m3Oq5CSb-e_y9ZTdOA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 28 Oct 2021 09:51:23 -0400 (EDT)
Date:   Thu, 28 Oct 2021 16:51:19 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     sundeep subbaraya <sundeep.lkml@gmail.com>
Cc:     Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Rakesh Babu Saladi <rsaladi2@marvell.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [EXT] Re: [net-next PATCH 1/2] octeontx2-pf: Add devlink param
 to init and de-init serdes
Message-ID: <YXqq19HxleZd6V9W@shredder>
References: <1635330675-25592-1-git-send-email-sbhatta@marvell.com>
 <1635330675-25592-2-git-send-email-sbhatta@marvell.com>
 <20211027083808.27f39cb0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR18MB4671C22DB7C8E5C46647860FA1859@PH0PR18MB4671.namprd18.prod.outlook.com>
 <CALHRZurNzkkma7HGg2xNLz3ECbwT2Hv=QXMeWr7AXCEegHOciw@mail.gmail.com>
 <20211027100857.4d25544c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YXmWb2PZJQhpMfrR@shredder>
 <BY3PR18MB473794E01049EC94156E2858C6859@BY3PR18MB4737.namprd18.prod.outlook.com>
 <YXnRup1EJaF5Gwua@shredder>
 <CALHRZuqpaqvunTga+8OK4GSa3oRao-CBxit6UzRvN3a1-T0dhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALHRZuqpaqvunTga+8OK4GSa3oRao-CBxit6UzRvN3a1-T0dhA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 05:48:02PM +0530, sundeep subbaraya wrote:
> Actually we also need a case where debugging is required when the
> logical link is
> up (so that packets flow from kernel to SerDes continuously) but the
> physical link
> is down. 

Can you explain the motivation for that? In the past we discussed use
cases for forcing the operational state to down while the administrative
state is up and couldn't find any.

> We will change the commit description since it is giving the
> wrong impression.
> A command to change physical link up/down with no relation to ifconfig
> is needed.

So it is obvious that some drivers default to not shutting down the
physical link upon admin down, but that some users want to change that.
In addition, we have your use case to control the physical link without
relation to the logical link. I wonder if it can all be solved with a
new ethtool attribute (part of LINKINFO_{SET,GET} ?) that describes the
physical link policy and has the following values:

* auto: Physical link state is derived from logical link state
* up: Physical link state is always up
* down: Physical link state is always down

IIUC, it should solve your problem and that of the "link-down-on-close"
private flag. It also has the added benefit of allowing user space to
query the default policy. The expectation is that it would be "auto",
but in some scenarios it is "up".
