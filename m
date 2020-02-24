Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14A0A169BD8
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 02:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbgBXBiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 20:38:20 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58594 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727158AbgBXBiU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Feb 2020 20:38:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QYeLQ8lLCklto74fF9o5XDB0S9cMvar92hb6s1ZGt88=; b=JQoNGsbgSwlp2Kg5S6PYJljgyr
        ScXnkYNpSWTv6q4NSc/2RzCbxfuUGXcUkBaRMlOOxcbk2QetANfwxIMr6aCe99b5HBstkzhZCmr4C
        vDQWg8LLgoTy+oJmiuRoRtd+SqdAE1xn8p+LC+VygorIsC2fd4i0jwJx0lj0MCwwVUOQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j62hC-0005Bp-55; Mon, 24 Feb 2020 02:38:06 +0100
Date:   Mon, 24 Feb 2020 02:38:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: mdio: add ipq8064 mdio driver
Message-ID: <20200224013806.GA19628@lunn.ch>
References: <20200220151301.10564-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220151301.10564-1-ansuelsmth@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 04:12:55PM +0100, Ansuel Smith wrote:
> Currently ipq806x soc use generi bitbang driver to
> comunicate with the gmac ethernet interface.
> Add a dedicated driver created by chunkeey to fix this.
> 
> Christian Lamparter <chunkeey@gmail.com>
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

It would be good to Cc: Christian Lamparter so he is aware of
this. Also, it would be nice to have a Signed-off-by: from Christian.

      Andrew
