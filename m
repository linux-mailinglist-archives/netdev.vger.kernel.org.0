Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B67E4A9D18
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 10:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732166AbfIEIen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 04:34:43 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:59222 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730753AbfIEIen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 04:34:43 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 27A6425B753;
        Thu,  5 Sep 2019 18:34:41 +1000 (AEST)
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id 24951940AC6; Thu,  5 Sep 2019 10:34:39 +0200 (CEST)
Date:   Thu, 5 Sep 2019 10:34:39 +0200
From:   Simon Horman <horms@verge.net.au>
To:     David Miller <davem@davemloft.net>
Cc:     sergei.shtylyov@cogentembedded.com, magnus.damm@gmail.com,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        kazuya.mizuguchi.ks@renesas.com
Subject: Re: [net-next 1/3] ravb: correct typo in FBP field of SFO register
Message-ID: <20190905083437.ey3exkaj3dpkhs5w@verge.net.au>
References: <20190902080603.5636-1-horms+renesas@verge.net.au>
 <20190902080603.5636-2-horms+renesas@verge.net.au>
 <20190902.113355.2056970452068168668.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190902.113355.2056970452068168668.davem@davemloft.net>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 02, 2019 at 11:33:55AM -0700, David Miller wrote:
> From: Simon Horman <horms+renesas@verge.net.au>
> Date: Mon,  2 Sep 2019 10:06:01 +0200
> 
> > -	SFO_FPB		= 0x0000003F,
> > +	SFO_FBP		= 0x0000003F,
> >  };
> > 
> >  /* RTC */
> > ---
> >  drivers/net/ethernet/renesas/ravb.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> 
> Simon please clean this up, I don't know what happened here :-)

Yeah, sorry about that. I don't know how it happened either.
