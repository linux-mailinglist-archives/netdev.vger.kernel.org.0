Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C7C2D1E62
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 00:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgLGXcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 18:32:07 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43150 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbgLGXcG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 18:32:06 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kmPyO-00AiL5-JO; Tue, 08 Dec 2020 00:31:16 +0100
Date:   Tue, 8 Dec 2020 00:31:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v1 2/2] net: dsa: microchip: improve port count
 comments
Message-ID: <20201207233116.GB2475764@lunn.ch>
References: <20201205152814.7867-1-TheSven73@gmail.com>
 <20201205152814.7867-2-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201205152814.7867-2-TheSven73@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 05, 2020 at 10:28:14AM -0500, Sven Van Asbroeck wrote:
> From: Sven Van Asbroeck <thesven73@gmail.com>
> 
> Port counts in microchip dsa drivers can be quite confusing:
> on the ksz8795, ksz_chip_data->port_cnt excludes the cpu port,
> yet on the ksz9477, it includes the cpu port.
> 
> Add comments to document this situation explicitly.

Rather than document it, we should make it uniform. Unless there is a
valid reason to require them to mean different things.

      Andrew
