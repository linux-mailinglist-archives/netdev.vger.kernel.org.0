Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20AD1A89BD
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504079AbgDNShD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:37:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37346 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730984AbgDNShB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 14:37:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ViDMoOKYM5eKMxDsxHH7qVo/oFOUllzmSiKC3yZPO6c=; b=a4bjsZvzVTQKEboODtQWY+VzaR
        Uka9txjlohDs9CE42qN9gGt3beuSmKNSmtSo7sK+GvEmNmBdul/j9c1ITfwevq3/jPyfVKOK/ju0h
        cXqUEA7fx3zAhjjBHSzaQmtEoOu3GpTuVsEJOgDDdlfssYACYEu7t10Syh0LjvN7FKLA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jOQQW-002hvo-0W; Tue, 14 Apr 2020 20:36:52 +0200
Date:   Tue, 14 Apr 2020 20:36:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Marko <robert.marko@sartura.hr>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        robh+dt@kernel.org, Mark Rutland <mark.rutland@arm.com>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        devicetree@vger.kernel.org,
        Christian Lamparter <chunkeey@gmail.com>,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: Re: [PATCH 1/3] net: phy: mdio: add IPQ40xx MDIO driver
Message-ID: <20200414183652.GB637127@lunn.ch>
References: <20200413170107.246509-1-robert.marko@sartura.hr>
 <20200413184219.GH557892@lunn.ch>
 <CA+HBbNE_-Pjr6dZ3qjgk1MiaT3PL9eUgs=XfK-ohkWDCR9yfZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+HBbNE_-Pjr6dZ3qjgk1MiaT3PL9eUgs=XfK-ohkWDCR9yfZA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Unfortunately, I don't have access to documentation and this is all based on
> GPL code from Qualcomm's SDK.
> So I don't really know whats their purpose.

Then please try to reverse engineer it. Just looking at the code, it
seems like one register is read, and the other is write. So use that
in the name.

> No, this is also an old relic from the SDK driver.
> It works without this perfectly fine, so I will drop it from v2.

Part of cleaning up 'Vendor Crap' is throwing out all the stuff like
this. What you end up with should be something you would of been happy
to write yourself.

> > Why the name am? Generally priv is used. I could also understand bus,
> > or even data, but am?
> Like most stuff in this driver, its a leftover from the SDK driver.

I guessed as much. But this is the sort of thing you need to fix when
cleaning up 'vendor crap'.

	 Andrew
