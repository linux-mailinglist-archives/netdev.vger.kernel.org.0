Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1DC3B74D8
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 17:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbhF2PLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 11:11:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33518 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232521AbhF2PLR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 11:11:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=aHUv1uxIIkg9h4CX5a7k0FeDVb1WtxaAGtg5UiSFyPQ=; b=OP
        5oFxYODNaG6FZxmqhuVXo2CKyMODk3UOygjlQ6v+EeU0kBescPNnAeC29Hhp2zBDxs2XLlhDvvMFX
        T31qCJza+LjVOJwAxzLMI7y3lfr4iCmAECcJN+ESD/QUSCywf5S60YsyqvYM/VA3NOhIopGLq859C
        TEubvns1SNAo3U0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lyFM0-00BYTY-J9; Tue, 29 Jun 2021 17:08:48 +0200
Date:   Tue, 29 Jun 2021 17:08:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Kurt Cancemi <kurt@x64architecture.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/1] net: phy: marvell: Fixed handing of delays with
 plain RGMII interface
Message-ID: <YNs3gI9A6e4QkTrj@lunn.ch>
References: <20210628192826.1855132-1-kurt@x64architecture.com>
 <20210628192826.1855132-2-kurt@x64architecture.com>
 <20210629004958.40f3b98c@thinkpad>
 <CADujJWWoWRyW3S+f3F_Zhq9H90QZ1W4eu=5dyad3DeMLHFp2TA@mail.gmail.com>
 <20210629022335.1d27efc9@thinkpad>
 <CADujJWXFFBUy9H3-w32uCYs_cJM5dBrWFzRg3x-Dq9+kki436g@mail.gmail.com>
 <20210629125234.7fcfc6bb@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210629125234.7fcfc6bb@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 12:52:34PM +0200, Marek Behún wrote:
> On Mon, 28 Jun 2021 21:12:41 -0400
> Kurt Cancemi <kurt@x64architecture.com> wrote:
> 
> > I am using drivers/net/ethernet/freescale/dpaa. This is a T2080 soc.
> > 
> > The following is where I added a dev_info statement for "phy_if", it
> > correctly returned -> PHY_INTERFACE_MODE_RGMII_ID.
> > https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/freescale/fman/mac.c#L774
> 
> It seem that dpaa / fman drivers do the same thing for both
> "rgmii" and "rgmii-id". There should be code that enables the delays
> for the "rgmii-id" variant...

Generally, the MAC does nothing, and asks the PHY to do the delay. So
in the MAC driver there should be nothing, apart from pass phy-mode to
the PHY.

    Andrew
