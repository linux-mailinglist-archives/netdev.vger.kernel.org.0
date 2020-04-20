Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39BAB1B0564
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 11:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgDTJQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 05:16:52 -0400
Received: from mx1.tq-group.com ([62.157.118.193]:28970 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725865AbgDTJQv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 05:16:51 -0400
IronPort-SDR: 2ys5ASrXSbcmVL+4NIw63pOAsLRT+HX/T8VTq5XCDymrms7XkAaUO3Ms8NQ8AWUHf33n9UUGKk
 wY9hC3uxchSHHARCVSIC+ed5O33c4Y/BTY0SYzC8e4L0Ev/VkMB3wJc3LoKtni2FiiRG5fcnri
 KKUGcenNyVMfMFZh5VhGhLzv+RAWODG5Uzbz/vt5BG2MYZrqijiYQrb4AK77lsQeatkuwTHKWC
 UMFTj2bbWfcEu26J00XaxPJ+dUImnEQZQ/kAF/vRfhNt+me/IiDGbeFrR/kA22WfeLf0hQ2Vnf
 KFA=
X-IronPort-AV: E=Sophos;i="5.72,406,1580770800"; 
   d="scan'208";a="11886200"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 20 Apr 2020 11:16:49 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Mon, 20 Apr 2020 11:16:49 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Mon, 20 Apr 2020 11:16:49 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1587374209; x=1618910209;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oSH4PE9XUEzsC5hY5Yl58pEZ9iVdMK0ATZmTRJuWy9I=;
  b=ac5gOFDjEWBUoWCuv/9qNa1bTBJ7OVUyXwt1PIkSXdWosuj2Wy9TeU9a
   uH+fFlRfHgExn+PB19kwgBWaoiQFfZDBALxSIKdPZzUadPc4Tltz/Tz7e
   mQfIZhP2/4/QrcnHHtaiuWj/sZ9JWbRxc0DgNbEN9dRlQxGNfoOWFtn/j
   Giw1Y1PGWVmx5Db6NkaT2Bzy7sDYHDdgi+kbTvI4EI+WLFO86OcQAp3Nc
   Ud6m8HtPJaL2jFmq3C7uzlasY3EI4ZxZw7SyDhzSmONfrodw7cDwNA7Tt
   W9Uk/ViJJy8gDY2NGawMuM7jX81YbdsxGG0rWPfhgviW6LPtCPUJkne5W
   A==;
IronPort-SDR: VAaUGW9OFiUDqtCiMG47M9f1Qvx33mJ6omOs+p+lue1C9j1oOUAQymQCiVF9QsgAdt763n54Ym
 ItjjHfJjY+venTKKHG/OoF39QYFCvVa75vEjUrafECUIqod95BbByM24NDkMmkMeHw/A7vkk50
 +BxOfbRFatY6ZlMVZk7bi0ksJM3md3uPcM3laONwbLTorrH9FzfYo6XFKymsT7wQ1f/tyD9LSn
 nQ6Be86QaCKWLNPnJb7HocyM42ia2w5vhYkq6HzlMLwpnPIyCNVrdc1Fb9M/1kxa8PZ3dXw4kJ
 Lfo=
X-IronPort-AV: E=Sophos;i="5.72,406,1580770800"; 
   d="scan'208";a="11886199"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 20 Apr 2020 11:16:49 +0200
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.117.49.26])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id 3A902280065;
        Mon, 20 Apr 2020 11:16:49 +0200 (CEST)
Message-ID: <f7b9de1b0caa4b27ccfe23c969ff586ec7ecefea.camel@ew.tq-group.com>
Subject: Re: [PATCH net-next 1/4] net: dsa: allow switch drivers to override
 default slave PHY addresses
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Date:   Mon, 20 Apr 2020 11:16:46 +0200
In-Reply-To: <a796bf7cfb1f72a888522050320624546950c281.camel@ew.tq-group.com>
References: <20200330135345.4361-1-matthias.schiffer@ew.tq-group.com>
         <6a306ad4-c029-03a3-7a1c-0fdadc13d386@gmail.com>
         <a796bf7cfb1f72a888522050320624546950c281.camel@ew.tq-group.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-03-31 at 11:09 +0200, Matthias Schiffer wrote:
> On Mon, 2020-03-30 at 20:04 -0700, Florian Fainelli wrote:
> > 
> > On 3/30/2020 6:53 AM, Matthias Schiffer wrote:
> > > Avoid having to define a PHY for every physical port when PHY
> > > addresses
> > > are fixed, but port index != PHY address.
> > > 
> > > Signed-off-by: Matthias Schiffer <
> > > matthias.schiffer@ew.tq-group.com
> > > > 
> > 
> > You could do this much more elegantly by doing this with Device
> > Tree
> > and
> > specifying the built-in PHYs to be hanging off the switch's
> > internal
> > MDIO bus and specifying the port to PHY address mapping, you would
> > only
> > patch #4 then.
> 
> This does work indeed, but it seems we have different ideas on
> elegance.
> 
> I'm not happy about the fact that an implementor needs to study the
> switch manual in great detail to find out about things like the PHY
> address offsets when the driver could just to the right thing by
> default. Requiring this only for some switch configurations, while
> others work fine with the defaults, doesn't make this any less
> confusing (I'd even argue that it would be better if there weren't
> any
> default PHY and IRQ mappings for the switch ports, but I also
> understand that this can't easily be removed at this point...)
> 
> In particular when PHY IRQ support is desired (not implemented on the
> PHY driver side for this switch yet; not sure if my current project
> will require it), indices are easy to get wrong - which might not be
> noticed as long as there is no PHY driver with IRQ support for the
> port
> PHYs, potentially breaking existing Device Trees with future kernel
> updates. For this reason, I think at least patch #2 should be
> considered even if #1 and #3 are rejected.
> 
> Kind regards,
> Matthias

net-next is open again, and I'd like to come to a conclusion regarding
this patch series before I resend it (or parts of it).

It is my impression that a detailed configuration in the Device Tree is
most useful when the driver that it configures is very generic, so
different values are useful in practice.

The mv88e6xxx driver is not generic in this sense: It already lists
every single piece of supported hardware, often using completely
different code for different chips - which is already not configurable
in the Device Tree (and being able to wouldn't make much sense IMO).

Having the additional pieces of sane defaults in the driver that are
introduced by the patches 1..3 of this series avoids mistakes in the DT
configuration, for settings that never need to be modified for a given
switch model supported by mv88e6xxx.

Kind regards,
Matthias

