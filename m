Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388B21FF22A
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 14:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729709AbgFRMoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 08:44:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46584 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727779AbgFRMoW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 08:44:22 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jlttq-00175O-Oj; Thu, 18 Jun 2020 14:44:10 +0200
Date:   Thu, 18 Jun 2020 14:44:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lan743x: allow mac address to come from dt
Message-ID: <20200618124410.GK249144@lunn.ch>
References: <1592434750-8940-1-git-send-email-tharvey@gateworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1592434750-8940-1-git-send-email-tharvey@gateworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 03:59:10PM -0700, Tim Harvey wrote:
> If a valid mac address is present in dt, use that before using
> CSR's or a random mac address.
> 
> Signed-off-by: Tim Harvey <tharvey@gateworks.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
