Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6277D6337
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 15:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731631AbfJNNA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 09:00:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44674 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730087AbfJNNA2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 09:00:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XGkEijKN8/OOyckGnnk5bIOpQGRjn9DO52eDP6zmWJU=; b=tlEaobscxjg3RnSmShWjaY5E5m
        01PkwYpOpUS7j+G5/lWUEug4IOWcAX9GfwcFk9+4bCz2faJjjFZ6A0hZ5qInVBDZ+bPmudovemDty
        nKb0T3lVy9ZgjSOMJpFlFX+EFc01ier2/whiiDkGXxv573rH4USe0UTJoWcNeliMsvwU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iJzxQ-0005Ln-O4; Mon, 14 Oct 2019 15:00:16 +0200
Date:   Mon, 14 Oct 2019 15:00:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Nishad Kamdar <nishadkamdar@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>, netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: dsa: sja1105: Use the correct style for SPDX
 License Identifier
Message-ID: <20191014130016.GD19861@lunn.ch>
References: <20191012123938.GA6865@nishad>
 <CA+h21hr=Wg7ydqcTLk85rrRGhx_LCxu2Ch3dWCt1-d1XtPaAcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hr=Wg7ydqcTLk85rrRGhx_LCxu2Ch3dWCt1-d1XtPaAcA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 14, 2019 at 01:46:26PM +0300, Vladimir Oltean wrote:
> Hi Nishad,
> 
> On Sat, 12 Oct 2019 at 15:39, Nishad Kamdar <nishadkamdar@gmail.com> wrote:
> >
> > This patch corrects the SPDX License Identifier style
> > in header files related to Distributed Switch Architecture
> > drivers for NXP SJA1105 series Ethernet switch support.
> > For C header files Documentation/process/license-rules.rst
> > mandates C-like comments (opposed to C source files where
> > C++ style should be used)
> >
> > Changes made by using a script provided by Joe Perches here:
> > https://lkml.org/lkml/2019/2/7/46.
> >
> > Suggested-by: Joe Perches <joe@perches.com>
> > Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
> > ---
> 
> Your commit message has nothing to do with what you're fixing, but
> whatever. The SPDX identifiers _are_ using C-like comments.

Agreed. Please fix the commit message, and maybe make the script
generating the commit message, so future uses of it will get the
message correct.

Thanks
	Andrew
