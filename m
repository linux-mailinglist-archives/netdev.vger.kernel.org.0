Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0592E3E368A
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 19:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbhHGRoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 13:44:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38342 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhHGRoX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Aug 2021 13:44:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BRK5L6T4KuYFCyZr+/n2UE9YDeqkKvXCisEuYuPGvUs=; b=InQaQiNJv8HWTKxhzlTwvkfd1B
        McuJ/iSsPysKDwhbDgPHVxutMzrMVvKfX0anqHSGTLgg6mtCcPt7Vb34TfMHpGeH1tU9sVC208CkA
        g7reFzTvn6uLAUU7OWFEUMvCcwInwyELk8Z3/KmtHoiLVqXFDDz6b7GR9PDs2IVhmKy0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mCQMf-00GVj9-0S; Sat, 07 Aug 2021 19:44:05 +0200
Date:   Sat, 7 Aug 2021 19:44:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dario Alcocer <dalcocer@helixd.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Marvell switch port shows LOWERLAYERDOWN, ping fails
Message-ID: <YQ7GZINFFwgnVALz@lunn.ch>
References: <YPxPF2TFSDX8QNEv@lunn.ch>
 <f8ee6413-9cf5-ce07-42f3-6cc670c12824@helixd.com>
 <bcd589bd-eeb4-478c-127b-13f613fdfebc@helixd.com>
 <527bcc43-d99c-f86e-29b0-2b4773226e38@helixd.com>
 <fb7ced72-384c-9908-0a35-5f425ec52748@helixd.com>
 <YQGgvj2e7dqrHDCc@lunn.ch>
 <59790fef-bf4a-17e5-4927-5f8d8a1645f7@helixd.com>
 <YQGu2r02XdMR5Ajp@lunn.ch>
 <11b81662-e9ce-591c-122a-af280f1e1f59@helixd.com>
 <fea36eed-eaff-4381-b2fd-628b60237aab@helixd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fea36eed-eaff-4381-b2fd-628b60237aab@helixd.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 05, 2021 at 02:44:32PM -0700, Dario Alcocer wrote:
> On 7/28/21 12:37 PM, Dario Alcocer wrote:
> > On 7/28/21 12:24 PM, Andrew Lunn wrote:
> > > Take a look at:
> > > 
> > > https://github.com/lunn/mv88e6xxx_dump/blob/master/mv88e6xxx_dump.c
> > > 
> > 
> > Many thanks for the link; I will build and install it on the target.
> > Hope it will work with the older kernel (5.4.114) we're using.
> 
> I've got a dumb question: is mv88e6xxx_dump intended to be built on the
> target, or do I use a cross compiler?

I've always built it on the target. In order to make kernel
development work easy, i generally use Debian on everything. Sometimes
with a USB stick, or a big MMC card, sometimes NFS root. Once the
kernel works, then i will move to the production environment, which
generally makes a poor development environment, so should be avoided
as much as possible.

It should be possible to cross compile it, since it uses autotools.

   Andrew
