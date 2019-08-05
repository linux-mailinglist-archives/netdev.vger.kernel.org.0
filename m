Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8F08121E
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 08:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbfHEGPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 02:15:18 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:41678 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbfHEGPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 02:15:17 -0400
Received: by mail-yb1-f195.google.com with SMTP id x188so6683204yba.8;
        Sun, 04 Aug 2019 23:15:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d2DU9kBb4leQ/jOn2DVY+dV3e2iyLt3yKa1OyuxJhhA=;
        b=niX/7BE0qnoG0ZC0Uk3XxzdIW0aioGSBYPc+lg9U/X/SSOAB33ZNx7XlS1YGMFzHH9
         URtQRuorc/d4vnDD+n9f2HRDuOPR8VpbOUgWUsUJRSqFkIv1nY5K/PJ6FWYGpAuPMoOH
         frjg1PzM2144xST0SsVQ62fZBgGs052KUDdvcDfXdbSQwV/zTXpSxMc00s/Hp5lpnVA/
         PGwBk66bbPNKmL/mYgDLgFimTRJIxufQb/xCohkuYBWaRsdpFha/jeb8GguuABQ1O3Zy
         TXVQDmBtRvWMkOhr9k7Odl7ojZgbjC72oq0mSl+oMLlwlUKlXpI3a6fC0BzC8M8culPH
         TYng==
X-Gm-Message-State: APjAAAUAZ8Sw67g/gGP4uSre4N8v6Osuoxo3fHdtZ3VT+BDMg7lI4Bu0
        MJNhHuLNMcsS6FX5L9RqJ4G7gnWTZ2zI+9T9H0Q=
X-Google-Smtp-Source: APXvYqxIHFOCA1aPmW3BGgaIKCs7UKtDpmPvJAnMddZGIS9z2sgUDL6Nk7QxPFU7DVCcM3g9BQaZl43vOUxJJYUfDp8=
X-Received: by 2002:a25:5f4b:: with SMTP id h11mr5510243ybm.420.1564985716710;
 Sun, 04 Aug 2019 23:15:16 -0700 (PDT)
MIME-Version: 1.0
References: <1564566033-676-1-git-send-email-harini.katakam@xilinx.com>
 <1564566033-676-2-git-send-email-harini.katakam@xilinx.com> <20190804145633.GB6800@lunn.ch>
In-Reply-To: <20190804145633.GB6800@lunn.ch>
From:   Harini Katakam <harinik@xilinx.com>
Date:   Mon, 5 Aug 2019 11:45:05 +0530
Message-ID: <CAFcVECL6cvCjeo+fn1NDyMDZyZXDrWyhD9djvcVXiLVLiLgGeA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] dt-bindings: net: macb: Add new property for PS
 SGMII only
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Harini Katakam <harini.katakam@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        David Miller <davem@davemloft.net>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Sun, Aug 4, 2019 at 8:26 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Wed, Jul 31, 2019 at 03:10:32PM +0530, Harini Katakam wrote:
> > Add a new property to indicate when PS SGMII is used with NO
> > external PHY on board.
>
> Hi Harini
>
> What exactly is you use case? Are you connecting to a Ethernet switch?
> To an SFP cage with a copper module?

Yes, an SFP cage is the common HW target for this patch. Essentially, there
is no external PHY driver that the macb can "connect" to; if there was an
external PHY on board, its link status would also indicate when the GEM(PCS)
to external PHY link was down. But in the absence of an external PHY on
HW, PCS link status needs to be monitored and reported to users.

Regards,
Harini
