Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7378443E20
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389129AbfFMPrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:47:39 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:39764 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731751AbfFMJ0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 05:26:42 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id A335925B7FA;
        Thu, 13 Jun 2019 19:26:39 +1000 (AEST)
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id 91846940483; Thu, 13 Jun 2019 11:26:37 +0200 (CEST)
Date:   Thu, 13 Jun 2019 11:26:37 +0200
From:   Simon Horman <horms@verge.net.au>
To:     David Miller <davem@davemloft.net>
Cc:     fabrizio.castro@bp.renesas.com, wg@grandegger.com,
        mkl@pengutronix.de, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        geert+renesas@glider.be, Chris.Paterson2@renesas.com,
        biju.das@bp.renesas.com, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH repost 0/5] Repost CAN and CANFD dt-bindings
Message-ID: <20190613092635.ztm4k34o5jrxmadd@verge.net.au>
References: <1557429622-31676-1-git-send-email-fabrizio.castro@bp.renesas.com>
 <TY1PR01MB1770D2AAF2ED748575CA4CBFC0100@TY1PR01MB1770.jpnprd01.prod.outlook.com>
 <20190612122020.sgp5q427ilh6bbbg@verge.net.au>
 <20190612.094908.1957141510166169801.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612.094908.1957141510166169801.davem@davemloft.net>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 09:49:08AM -0700, David Miller wrote:
> From: Simon Horman <horms@verge.net.au>
> Date: Wed, 12 Jun 2019 14:20:20 +0200
> 
> > are you comfortable with me taking these patches
> > through the renesas tree? Or perhaps should they be reposted
> > to you for inclusion in net-next?
> > 
> > They have been stuck for a long time now.
> 
> They can go through the renesas tree, no problem.
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Thanks Dave,

I have applied these to the renesas tree for inclusion in v5.3.
