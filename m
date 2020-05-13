Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3AE71D19E6
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 17:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730426AbgEMPuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 11:50:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58248 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728490AbgEMPuA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 11:50:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CAERETo3HmCt4cbe7skcUAdSIJs8TS922Vv3SvzLnWo=; b=QgBfCmP3WmKmpu6AFL6yVYiciq
        tlhwOShfjy+y8zbLvLsZLYnwvCB1KcWONL3FUxrPaFR3vIeC+gQ4pi0I4Mc6H6AJlZlllJnesOh5J
        ae7LL5bwGY6eLSJVHQrzBaHrWegML8A7ADQWcrJRRxhLwEF82ck04tel3r4y0b1IkzAk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jYtdp-002B9b-U1; Wed, 13 May 2020 17:49:53 +0200
Date:   Wed, 13 May 2020 17:49:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] net: phy: at803x: add cable test support
Message-ID: <20200513154953.GI499265@lunn.ch>
References: <20200513120648.14415-1-o.rempel@pengutronix.de>
 <0c80397b-58b8-0807-0b98-695db8068e25@gmail.com>
 <20200513154544.gwcccvbicpvrj6vm@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513154544.gwcccvbicpvrj6vm@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Uff.. i missed this. Then I'll need only to add some changes on top of
> his patch.

I've been chatting with mwalle on IRC today. There should be a repost
of the patches soon.

   Andrew
