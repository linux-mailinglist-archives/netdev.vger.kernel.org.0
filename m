Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECFDD30B23D
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 22:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhBAVpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 16:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhBAVpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 16:45:33 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579F0C061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 13:45:18 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id sa23so10431146ejb.0
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 13:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=iH6RQ0vtvPtXVn8WjtPzrXTO2+gz0uYQsxqr/i362w0=;
        b=FpQZ/rQ2bonH376TP/sXc21L+fGVDNkLYMnOjylLzBhUD4nap538YiJkJrn1tuYYMl
         VpOKGQoxYAxzFFCRWI0lagDg4NI/QV7Zr9H3FV2eUrywH91Pi+/3aJiQV5PCiw58xSy5
         Wgpdyjz3PCSDeWyCFmuN27qfKh0xCKZe3Y9mWEv+Njun1MIS1hCtIrgxkA7yNl1OYKZG
         p+bR+zGKh2KQ1WGqb2c6DdMXgGzICQ23JM7hx6V8H5Tbsmgoi8zCgGKZBni2Z0EBSmGK
         mTORTV3Z++n5PThfjJbPGWxiOYqKoYW++qsbUy+Rc8pREvft3XXPfj6Vs4tEJpiXUQoM
         Yqhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=iH6RQ0vtvPtXVn8WjtPzrXTO2+gz0uYQsxqr/i362w0=;
        b=B2Q0xtSrA/6dy/SkTYMxbsKaKrKal+B7Mk854jWrNMuGVm7PyEEQ5HmoqnymdmpwIy
         VOGZK1dfL8t7xk80gGbovxFV0WHYFCoR1L/4Poh6OHE1vwXp9vs9kEYgLQaRwjESTA6p
         KzaHL7FnGyKOc7E7IJN1XK74YEYuL7skXOS3us0xsp0ld3DWy49LsEx5cmDHN7DgQ1ut
         9IqAfU8i5GSfn6YZej+B82jefKAg9xwZgxmfrzzJ+0L4Zi8al6w00+fM4FyjiQnFZUmi
         uwkhxQEgU0pVHxjTEsWafx5vQRKDJseXo1ABLXJziVNnTm3tf5rkNCKMpjwwQGHIgoB4
         VFfw==
X-Gm-Message-State: AOAM530GnloK723B/R9XIdkQpPghTjeixeg5o65rylyAbSZcf1XDmDgY
        4GMakH+eytb6zTtuUqNO+uE=
X-Google-Smtp-Source: ABdhPJyropbcbIeZoiC/xSGcvrSf3VB1TZyB2IJPTrACfrRMSTLwA66E9P7pkvYVQILcOTGARFl+GQ==
X-Received: by 2002:a17:906:e107:: with SMTP id gj7mr18904164ejb.298.1612215916941;
        Mon, 01 Feb 2021 13:45:16 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id m26sm8409611ejr.54.2021.02.01.13.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 13:45:16 -0800 (PST)
Date:   Mon, 1 Feb 2021 23:45:15 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
Subject: About PHY_INTERFACE_MODE_REVMII
Message-ID: <20210201214515.cx6ivvme2tlquge2@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

I was looking at

  commit 2cc70ba4cf5f97a7cf08063d2fae693d36b462eb
  Author: Florian Fainelli <f.fainelli@gmail.com>
  Date:   Tue May 28 04:07:21 2013 +0000

      phy: add reverse MII PHY connection type

      The PHY library currently does not know about the the reverse MII
      connection type. Add it to the list of supported PHY modes and update
      of_get_phy_mode() to support it and look for the string "rev-mii".

      Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
      Signed-off-by: David S. Miller <davem@davemloft.net>

and I couldn't figure out its intended use from the drivers that do make
use of it.

As far as I understand
https://www.eetimes.com/reverse-media-independent-interface-revmii-block-architecture/#
RevMII is a set of hardware state machines used to describe a MAC-to-MAC
connection in a richer manner than a fixed-link would. You mostly get
auto-negotiation via a minimal clause 28 state machine, which should
help avoid mismatch of link modes. You also get the illusion of a clause
22 register map that should work with the genphy driver and give you
link status based on (?!) the link partner toggling BMCR_ANRESTART, for
the most part - which would allow you to catch a change in their link
mode advertisement.

The thing is, RevMII as I understand it is simply the state machines for
autoneg and the virtual MDIO interface. RevMII is not a data link
protocol, is it? So why does PHY_INTERFACE_MODE_REVMII exist? Having
RevMII for the MDIO link management doesn't mean you don't have MII, or
RMII, or RGMII, or whatever, for the actual data link.

Another thing is, I think there's one fundamental thing that RevMII
can't abstract away behind that genphy-compatible clause 22 register
map. That is whether you're on the 'PHY' side of the RevMII block or on
the 'MAC' side of it. I think mostly small embedded devices would
implement a RevMII block in order to disguise themselves as real PHYs to
whatever the real SoC that connects to them is. But the underlying data
link is fundamentally asymmetrical any way you look at it. For example,
in the legacy MII protocol, both TX_CLK and RX_CLK are driven by the PHY
at 25 MHz. This means that two devices that use MII as a data link must
be aware of their role as a MAC or as a PHY. Same thing with RMII, where
the 50 MHz clock signals are either driven by the MAC or by an external
oscillator (but not by the PHY).

The point is that if the system implementing the RevMII block (not the
one connected over real MDIO to it) is running Linux, this creates an
apparent paradox. The MAC driver will think it's connected to a PHY, but
nonetheless, the MAC must operate in the role of a PHY. This is the
description of a PHY-to-PHY setup, something which doesn't make sense.
I.e. the MAC driver supports RMII. If it's attached to an RMII PHY it
should operate as a MAC, drive the 50 MHz clock. Except when that RMII
PHY is actually a virtual RevMII PHY and we're on the local side of it,
then everything is in reverse and we should actually not drive the 50
MHz clock because we're the PHY. But if we're on the remote side of the
RevMII PHY, things are again normal and we should do whatever a RMII MAC
does, not what a RMII PHY does.

Consider the picture below.

 +--------------------------+                    +--------------------------+
 |Linux    +----+------+----+           MDIO/MDC |-----------+      Linux   |
 |box A    |Side|RevMII|Side|<-------------------|    MDIO   |      box B   |
 |      +--| A  |block | B  |<-------------------|controller |              |
 |      |  +----+------+----+                    |-----------+              |
 |      |                   |                    |        |                 |
 |   internal               |                    |     phy-handle           |
 |    MDIO                  |Actual data link    |                          |
 |      |            +------|<-------------------|------+                   |
 |  phy-handle       | MAC  |<-------------------| MAC  |                   |
 |                   |as PHY|------------------->|as MAC|                   |
 |                   +------|------------------->|------+                   |
 |                          |MII/RMII/RGMII/SGMII|                          |
 +--------------------------+                    +--------------------------+

The RevMII block implemented by the hardware on Linux box A has two
virtual register maps compatible with a clause 22 gigabit PHY, called
side A and side B. Presumably same PHY ID is presented to both sides, so
both box A and box B load the same PHY driver (let that be genphy).
But the actual data link is RMII, which is asymmetric in roles (all MII
protocols are asymmetric in roles to some degree, even RGMII which does
support in-band signaling driven by the PHY, even SGMII where the same
thing is true). So somebody must tell Linux box A to configure the MAC
as a PHY, and Linux box B to configure the MAC as a MAC. Who tells them
that? I thought PHY_INTERFACE_MODE_REVMII was supposed to help, but I
just don't see how - the information about the underlying data link type
is just lost.

Is it the case that the hardware on Linux box A is just supposed to hide
that it's really using RGMII/RMII/MII with a PHY role as the actual data
link, and just give that a pretty name "RevMII" aka "none of your business"?
But again I don't believe that to be true, somebody still has to care at
some point about protocol specific things, like RGMII delays, or
clocking setup at 25 or 50 or 125 MHz depending on whether MII or RMII
or RGMII is used, whether to generate inband signaling and wait for ACK,
etc etc.
