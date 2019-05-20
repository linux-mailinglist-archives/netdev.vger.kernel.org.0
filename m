Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7484C22990
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 02:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729807AbfETAeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 20:34:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39485 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727682AbfETAeH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 May 2019 20:34:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QJ1zlmiUwkwG5fWJeQtvywIkCnEFUS1im+V7yvPnneo=; b=w07pfqMWRp5S6YyWg40sQaWds5
        MpevLIUi3S0QIbW3VGyK0XeAGb9+EOFTwh+yaX+wP7NNdsuYR1KUhHodyKxyljCiNdk4Ob1Fi13Cx
        04ti23myNThFJ1fYuKtr1YT9xXjAQEnhxbZ1efA1lhwzeyGDImLf+wvZ05j2B9V2aXGs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hSWFa-00019D-85; Mon, 20 May 2019 02:33:58 +0200
Date:   Mon, 20 May 2019 02:33:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        Chuanhong Guo <gch981213@gmail.com>,
        info@freifunk-bad-gandersheim.net
Subject: Re: [PATCH v4 3/3] net: ethernet: add ag71xx driver
Message-ID: <20190520003358.GB1695@lunn.ch>
References: <20190519080304.5811-1-o.rempel@pengutronix.de>
 <20190519080304.5811-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190519080304.5811-4-o.rempel@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +config AG71XX
> +	tristate "Atheros AR7XXX/AR9XXX built-in ethernet mac support"
> +	depends on ATH79
> +	select PHYLIB
> +	select MDIO_BITBANG

I don't see any need for MDIO_BITBANG.

  Andrew
