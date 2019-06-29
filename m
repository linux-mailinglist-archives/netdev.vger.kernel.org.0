Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E331A5ADAF
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 01:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbfF2XLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 19:11:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43348 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726942AbfF2XLV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jun 2019 19:11:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=L6GfLA/rkyEsf3aUbhTEHivTi5OAhnQC3dk1Hx4xbVw=; b=ALvI80KRnPMFjo4dEgP1+pzFC+
        PKTS4XwlFe1pBidVY2SSJ0sWrbnJRMqUBpuRzM5Nv8YWMpOpNi/hmTeomFRCBAUE8+adIONfTc2Ww
        Jqu1UvNCuXjtb2R0csJuaWxG5CWQHvXtZKHIUl1xIaVIcLcSye4l34xOZx51hD0flcYg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hhMV5-0007EK-ES; Sun, 30 Jun 2019 01:11:19 +0200
Date:   Sun, 30 Jun 2019 01:11:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     vtolkm@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: loss of connectivity after enabling vlan_filtering
Message-ID: <20190629231119.GC26554@lunn.ch>
References: <e5252bf0-f9c1-3e40-aebd-8c091dbb3e64@gmail.com>
 <20190629224927.GA26554@lunn.ch>
 <6226b473-b232-e1d3-40e9-18d118dd82c4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6226b473-b232-e1d3-40e9-18d118dd82c4@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 30, 2019 at 01:04:50AM +0200, vtolkm@googlemail.com wrote:
> 
> On 30/06/2019 00:49, Andrew Lunn wrote:
> > On Sun, Jun 30, 2019 at 12:01:38AM +0200, vtolkm@googlemail.com wrote:
> >> * DSA MV88E6060
> >> * iproute2 v.5.0.0-2.0
> >> * OpenWRT 19.07 with kernel 4.14.131 armv7l
> > The mv88e6060 driver is very simple. It has no support for VLANs. It
> > does not even have support for offloading bridging between ports to
> > the switch.
> >
> > The data sheet for this device is open. So if you want to hack on the
> > driver, you could do.
> >
> > 	Andrew
> 
> Are you sure? That is a bit confusing after reading
> https://lore.kernel.org/patchwork/patch/575746/

Quoting that patch:

	This commit implements the switchdev operations to add, delete
	and dump VLANs for the Marvell 88E6352 and compatible switch
	chips.

Vivien added support for the 6352. That uses the mv88e6xxx driver, not
the mv88e6060. And by compatible switches, he meant those in the 6352
family, so 6172 6176 6240 6352 and probably the 6171 6175 6350 6351.

	Andrew
