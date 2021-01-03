Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4632E8D5C
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 18:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbhACRAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 12:00:44 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47586 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727281AbhACRAn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Jan 2021 12:00:43 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kw6jT-00Fo9w-F3; Sun, 03 Jan 2021 17:59:55 +0100
Date:   Sun, 3 Jan 2021 17:59:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rob Herring <robh@kernel.org>
Cc:     Robert Marko <robert.marko@sartura.hr>, agross@kernel.org,
        bjorn.andersson@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux@armlinux.org.uk, Luka Perkov <luka.perkov@sartura.hr>
Subject: Re: [PATCH 2/4] dt-bindings: net: Add bindings for Qualcomm QCA807x
Message-ID: <X/H4C1eBNHdDS4vO@lunn.ch>
References: <20201222222637.3204929-1-robert.marko@sartura.hr>
 <20201222222637.3204929-3-robert.marko@sartura.hr>
 <20201223005633.GR3107610@lunn.ch>
 <20210103164613.GA4012977@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210103164613.GA4012977@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +  qcom,tx-driver-strength:
> > > +    description: PSGMII/QSGMII TX driver strength control.
> > > +    $ref: /schemas/types.yaml#/definitions/uint32
> > > +    enum: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
> > 
> > Please use the actual values here, and have the driver convert to the
> > value poked into the register. So the property would be
> > qcom,tx-driver-strength-mv and it would have the value 220 for
> > example.
> 
> The LED binding has properties for specifying the current already. And 
> it's max current which is the h/w property where as anything less is 
> just software configuration (IOW, doesn't belong in DT).

Hi Rob

My understanding of this is it is the drive strength of the SERDES
line. Nothing to do with LEDs. The description needs improving.

      Andrew
