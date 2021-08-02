Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC483DD74E
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 15:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbhHBNjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 09:39:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57220 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233719AbhHBNjk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 09:39:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5lw41H6w70pZFPZYn804ztO37u1ine6njh7Mo1mlvr8=; b=Ik5YqngM3Pu8FIsibgGI90LXCE
        /MbmLCGpkr20VvijZkNxPwyjDhC82eFgOjL0CuRmQQEbKBSaMfKmEtEJ52MTI2YiRMe/O1M1BA4Qz
        rtNMwAGJTST96S/bLC7mu0acx88lcVBdMFAiArFPcR5+11vN2tc1dRMVMW7AmAgp6cRQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mAYA9-00FpNJ-7T; Mon, 02 Aug 2021 15:39:25 +0200
Date:   Mon, 2 Aug 2021 15:39:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     luoj@codeaurora.org
Cc:     Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Gross, Andy" <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Robert Marko <robert.marko@sartura.hr>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        devicetree@vger.kernel.org, Sricharan <sricharan@codeaurora.org>
Subject: Re: [PATCH 3/3] dt-bindings: net: rename Qualcomm IPQ MDIO bindings
Message-ID: <YQf1jdsUc8S7tTBy@lunn.ch>
References: <20210729125358.5227-1-luoj@codeaurora.org>
 <20210729125358.5227-3-luoj@codeaurora.org>
 <CAL_Jsq+=Vyy7_EQ_A7JW4ZfqpPU=6eCyUYMnPORChGvefw-yTA@mail.gmail.com>
 <7873e70dcf4fe749521bd9c985571742@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7873e70dcf4fe749521bd9c985571742@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > since the phylib code can't satisfy resetting PHY in IPQ chipset, phylib
> > resets phy by
> > configuring GPIO output value to 1, then to 0. however the PHY reset in
> > IPQ chipset need
> > to configuring GPIO output value to 0, then to 1 for the PHY reset, so i
> > put the phy-reset-gpios here.

Look at the active low DT property of a GPIO.

     Andrew
