Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00B317AA7E
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 16:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729693AbfG3ODa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 10:03:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47844 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729121AbfG3ODa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 10:03:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+412fmGoKfxTtG6dc5ZZWvHXd5U9JsLF+FkdYZQ+yew=; b=5GYaY7vr7stDsxMpDy8/FHmIyu
        42XAZvGYc2GjtByVgvqKSWiq8DcK6aZ63aUKCPi2pMgMMMw1vfHfyt94Lyu20qYblVeEOTbQ2E7RO
        GBDKzCi7nQoto8y5yeYYRAogfg7WV2CbO1/H4FDPikdFck6lUWlLbGSOtSv5LURt4t8w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hsSit-00084n-E0; Tue, 30 Jul 2019 16:03:27 +0200
Date:   Tue, 30 Jul 2019 16:03:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hubert Feurstein <h.feurstein@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH 0/4] net: dsa: mv88e6xxx: add support for MV88E6220
Message-ID: <20190730140327.GL28552@lunn.ch>
References: <20190730100429.32479-1-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730100429.32479-1-h.feurstein@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 12:04:25PM +0200, Hubert Feurstein wrote:
> This patch series adds support for the MV88E6220 chip to the mv88e6xxx driver.
> The MV88E6220 is almost the same as MV88E6250 except that the ports 2-4 are
> not routed to pins.
> 
> Furthermore, PTP support is added to the MV88E6250 family.

Hi Hubert

In general, these are a nice series of patches.

FYI: Please indicate in the subject link which tree the patches are
for. These are all for net-next, so the subject would be

[PATCH net-next] net: dsa: mv88e6xxx: .....

Thanks
	Andrew
