Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0224D3F8E77
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243364AbhHZTKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:10:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43540 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230442AbhHZTKf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 15:10:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=MVp+QqWuQEFRYD0iAeEpQZCFKNbvjGPxk+oixgJjSJA=; b=GgpJ1GK4T+uv58qhsXlC32ncAw
        9saJg1q0/Qi/LDCFHGJhBGzlMwfdVGUkul2QNXY1Dmdy2gU6R2cyyF7vbwMqBXuzDjpfzjmeuHyBq
        GaAulvGWXI45a9gSMuW3V71Id5/OgEcSPZhE/qmnP291QGq+5CyNRZMdsj0l49cE0LjA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mJKkp-003zsA-9c; Thu, 26 Aug 2021 21:09:35 +0200
Date:   Thu, 26 Aug 2021 21:09:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: Re: [PATCH net-next 04/13] ravb: Add ptp_cfg_active to struct
 ravb_hw_info
Message-ID: <YSfm7zKz5BTNUXDz@lunn.ch>
References: <20210825070154.14336-5-biju.das.jz@bp.renesas.com>
 <777c30b1-e94e-e241-b10c-ecd4d557bc06@omp.ru>
 <OS0PR01MB59220BCAE40B6C8226E4177986C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <78ff279d-03f1-6932-88d8-1eac83d087ec@omp.ru>
 <OS0PR01MB59223F0F03CC9F5957268D2086C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <9b0d5bab-e9a2-d9f6-69f7-049bfb072eba@omp.ru>
 <OS0PR01MB5922F8114A505A33F7A47EB586C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <93dab08c-4b0b-091d-bd47-6e55bce96f8a@gmail.com>
 <YSfkHtWLyVpCoG7C@lunn.ch>
 <cc3f0ae7-c1c5-12b3-46b4-0c7d1857a615@omp.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc3f0ae7-c1c5-12b3-46b4-0c7d1857a615@omp.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 26, 2021 at 10:02:07PM +0300, Sergey Shtylyov wrote:
> On 8/26/21 9:57 PM, Andrew Lunn wrote:
> 
> >>> Do you agree GAC register(gPTP active in Config) bit in AVB-DMAC mode register(CCC) present only in R-Car Gen3?
> >>
> >>    Yes.
> >>    But you feature naming is totally misguiding, nevertheless...
> > 
> > It can still be changed.
> 
>     Thank goodness, yea!

We have to live with the first version of this in the git history, but
we can add more patches fixing up whatever is broken in the unreviewed
code which got merged.

> > Just suggest a new name.
> 
>     I'd prolly go with 'gptp' for the gPTP support and 'ccc_gac' for the gPTP working also in CONFIG mode
> (CCC.GAC controls this feature).

Biju, please could you work on a couple of patches to change the names.

I also suggest you post further refactoring patches as RFC. We might
get a chance to review them then.

    Andrew
