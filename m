Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B173D5A11
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 15:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbhGZM2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 08:28:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45324 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233115AbhGZM2m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 08:28:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dhQwJKzfJ+LDvVUWR4XkBK09mhQDRw9khjLWzcPj1Eg=; b=D+KtqWEKNHNIciFdip/AaCRIiY
        JdQs4hlTriqVf7p0MhgMfsDswSS67ItUDIOEE9TebIvSk4rvx05jFdg+mqCsTmIV/6mY4gFqInC8V
        FHCvXyhKhfzxvi+zBEaeWslhSinGsyXSDvb3LkuaJEsmmz+MjdFnBambCzjkQ6UUscBY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m80Le-00ErwC-HV; Mon, 26 Jul 2021 15:08:46 +0200
Date:   Mon, 26 Jul 2021 15:08:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: Re: [PATCH net-next 06/18] ravb: Factorise ptp feature
Message-ID: <YP6z3i62A9YjyBvj@lunn.ch>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
 <20210722141351.13668-7-biju.das.jz@bp.renesas.com>
 <bff55135-c801-0a9e-e194-460469688afe@gmail.com>
 <OS0PR01MB5922DF642B0549BFCFCDA77C86E89@OS0PR01MB5922.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OS0PR01MB5922DF642B0549BFCFCDA77C86E89@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 09:01:29AM +0000, Biju Das wrote:
> Hi Sergei,
> 
> Thanks for the feedback.
> 
> > Subject: Re: [PATCH net-next 06/18] ravb: Factorise ptp feature
> > 
> > HEllo!
> > 
> > On 7/22/21 5:13 PM, Biju Das wrote:
> > 
> > > Gptp is active in CONFIG mode for R-Car Gen3, where as it is not
> > 
> >    It's gPTP, the manuals say. :-)
> 
> Ok.
> 
> > 
> > > active in CONFIG mode for R-Car Gen2. Add feature bits to handle both
> > > cases.
> > 
> >    I have no idea why this single diff requires 2 fetaure bits....
> 
> Basically this is a HW feature.
> 
> 1) for R-Car Gen3, gPTP is active in config mode (R-Car Gen3)
> 2) for R-Car Gen2, gPTP is not active in config mode (R-Car Gen2)
> 3) RZ/G2L does not support ptp feature.

This is useful information to put in he commit message. The commit
message should answer the question "Why is this change being made?",
since what is being changed should be obvious from the patch.

      Andrew
