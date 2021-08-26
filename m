Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9DB3F8E51
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 20:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243469AbhHZS6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 14:58:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43506 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243330AbhHZS6k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 14:58:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GuIdOX4qztvHnZjlBA6soFbZ7BBKvSgHp2woZuWMXIU=; b=hs7KJmCaKsVbwjtvlHkJgQZZ3Q
        kBTUPNumJQcvjLR8UHs4/BA2b7OjfVgf8LcIEG3KRtjlNZotrTgixkDOXeXoqY7geuWX3ct+huIFm
        x1O2B40HsmXJp2ieWUKnUbPUXoY0rn7w1rUywS2h80t8cuvuC2WlzpR9bkjrB7ZE3GZA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mJKZC-003zmS-Ew; Thu, 26 Aug 2021 20:57:34 +0200
Date:   Thu, 26 Aug 2021 20:57:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
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
Message-ID: <YSfkHtWLyVpCoG7C@lunn.ch>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
 <20210825070154.14336-5-biju.das.jz@bp.renesas.com>
 <777c30b1-e94e-e241-b10c-ecd4d557bc06@omp.ru>
 <OS0PR01MB59220BCAE40B6C8226E4177986C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <78ff279d-03f1-6932-88d8-1eac83d087ec@omp.ru>
 <OS0PR01MB59223F0F03CC9F5957268D2086C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <9b0d5bab-e9a2-d9f6-69f7-049bfb072eba@omp.ru>
 <OS0PR01MB5922F8114A505A33F7A47EB586C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <93dab08c-4b0b-091d-bd47-6e55bce96f8a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93dab08c-4b0b-091d-bd47-6e55bce96f8a@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Do you agree GAC register(gPTP active in Config) bit in AVB-DMAC mode register(CCC) present only in R-Car Gen3?
> 
>    Yes.
>    But you feature naming is totally misguiding, nevertheless...

It can still be changed. Just suggest a new name.

   Andrew
