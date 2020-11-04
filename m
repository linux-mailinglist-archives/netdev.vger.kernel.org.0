Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334242A69B8
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 17:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731239AbgKDQ1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 11:27:46 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35548 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730966AbgKDQ1p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 11:27:45 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kaLdG-005F6t-Hc; Wed, 04 Nov 2020 17:27:34 +0100
Date:   Wed, 4 Nov 2020 17:27:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Roelof Berg <rberg@berg-solutions.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] lan743x: correctly handle chips with internal PHY
Message-ID: <20201104162734.GA1249360@lunn.ch>
References: <20201104160847.30049-1-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104160847.30049-1-TheSven73@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Note that as a side-effect, the devicetree phy mode now no longer
> has a default, and always needs to be specified explicitly (via
> 'phy-connection-type').

That sounds like it could break systems. Why do you do this?

     Andrew
