Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36363F09ED
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 19:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhHRRKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 13:10:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56922 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229889AbhHRRKB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 13:10:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FMajQxh4j0Trlt2HiUYVBxTD0sfB9uOoOL1XmXuHepM=; b=lx/TkBMVLBWZl1LqdvbxZPFiUo
        BIs2zRLqmluT4x8IsGq8GbZJUNmITq1nw0z2WX/qcqX/VOsGD+Ewz72XQAqW5AEevTcelKthXzsvu
        O6LibKBLTHFZ4GbKtqMlGozntYsYEP9JHM9VYknUITY5Q9XojspLaBv86vMeGG7F6EQA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mGP3x-000oy0-Uf; Wed, 18 Aug 2021 19:09:13 +0200
Date:   Wed, 18 Aug 2021 19:09:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jie Luo <luoj@codeaurora.org>
Cc:     Michael Walle <michael@walle.cc>, davem@davemloft.net,
        hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH] net: phy: add qca8081 ethernet phy driver
Message-ID: <YR0+uXdKoXrFEhpZ@lunn.ch>
References: <6856a839-0fa0-1240-47cd-ae8536294bcd@codeaurora.org>
 <20210818074102.78006-1-michael@walle.cc>
 <9aa1543b-e1b8-fba2-1b93-c954dd2e3e50@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9aa1543b-e1b8-fba2-1b93-c954dd2e3e50@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 09:34:40PM +0800, Jie Luo wrote:
> 
> On 8/18/2021 3:41 PM, Michael Walle wrote:
> > > qca8081 supports IEEE1588 feature, the IEEE1588 code may be submitted in
> > > the near future,
> > > 
> > > so it may be a good idea to keep it out from at803x code.
> > The AR8031 also supports PTP. Unfortunately, there is no public datasheet
> > for the QCA8081, so I can't have a look if both are similar.
> > 
> > See also,
> > https://lore.kernel.org/netdev/20200228180226.22986-1-michael@walle.cc/
> > 
> > -michael
> 
> Hi Michael,
> 
> Thanks for this comment. it is true that AR8031 supports basic PTP features.
> 
> please refer to the following link for the outline features of qca801.
> 
> https://www.qualcomm.com/products/qca8081

Is the PTP hardware in the qca8081 the same as the ar8031? When you
add PTP support, will it be for both PHYs?

What about the cable diagnostics? The at803x already has this
implemented. Will the same work for the qca8081?

    Andrew
