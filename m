Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41ABE26389E
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 23:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbgIIVnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 17:43:06 -0400
Received: from mail.nic.cz ([217.31.204.67]:36580 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbgIIVnG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 17:43:06 -0400
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id D1038140A64;
        Wed,  9 Sep 2020 23:43:02 +0200 (CEST)
Date:   Wed, 9 Sep 2020 23:43:02 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Rob Herring <robh@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?B?T25kxZllag==?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next + leds v2 1/7] dt-bindings: leds: document
 binding for HW controlled LEDs
Message-ID: <20200909234302.6294a59c@nic.cz>
In-Reply-To: <20200909213122.GA3087645@bogus>
References: <20200909162552.11032-1-marek.behun@nic.cz>
        <20200909162552.11032-2-marek.behun@nic.cz>
        <20200909182730.GK3290129@lunn.ch>
        <20200909203310.15ca4e42@dellmb.labs.office.nic.cz>
        <20200909205923.GB3056507@bogus>
        <20200909230726.233b4081@nic.cz>
        <20200909213122.GA3087645@bogus>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Sep 2020 15:31:22 -0600
Rob Herring <robh@kernel.org> wrote:

> On Wed, Sep 09, 2020 at 11:07:26PM +0200, Marek Behun wrote:
> > On Wed, 9 Sep 2020 14:59:23 -0600
> > Rob Herring <robh@kernel.org> wrote:
> >   
> > > > 
> > > > I don't know :) I copied this from other drivers, I once tried setting
> > > > up environment for doing checking of device trees with YAML schemas,
> > > > and it was a little painful :)    
> > > 
> > > pip3 install dtschema ?
> > > 
> > > Can you elaborate on the issue.
> > > 
> > > Rob
> > >   
> > 
> > I am using Gentoo and didn't want to bloat system with non-portage
> > packages, nor try to start a virtual environment. In the end I did it
> > in a chroot Ubuntu :)  
> 
> A user install doesn't work?
> 
> I don't really care for virtual env either.
> 
> > The other thing is that the make dt_binding_check executed for
> > quite a long time, and I didn't find a way to just do the binding check
> > some of the schemas.  
> 
> It's a bit faster now with what's queued for 5.10. The schema 
> validation is under 10sec now on my laptop. For the examples, any 
> new schema could apply to any example, so we have to check them all. 
> It's faster too, but still minutes to run.
> 
> > But I am not criticizing anything, I think that it is a good thing to
> > have this system.  
> 
> Good to hear. Just want to improve any pain points if possible.
> 
> Rob
> 

OK I am running it now in my chroot environment :)
