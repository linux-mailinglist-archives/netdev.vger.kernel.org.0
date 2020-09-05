Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7802E25E8B5
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 17:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgIEPed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 11:34:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44834 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbgIEPea (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 11:34:30 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kEaCu-00DMhy-Nc; Sat, 05 Sep 2020 17:34:24 +0200
Date:   Sat, 5 Sep 2020 17:34:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Paul Barker <pbarker@konsulko.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] ksz9477 dsa switch driver improvements
Message-ID: <20200905153424.GF3164319@lunn.ch>
References: <20200905140325.108846-1-pbarker@konsulko.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200905140325.108846-1-pbarker@konsulko.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 05, 2020 at 03:03:21PM +0100, Paul Barker wrote:
> These changes were made while debugging the ksz9477 driver for use on a
> custom board which uses the ksz9893 switch supported by this driver. The
> patches have been runtime tested on top of Linux 5.8.4, I couldn't
> runtime test them on top of 5.9-rc3 due to unrelated issues. They have
> been build tested on top of 5.9-rc3.

Hi Paul

Please rebase onto net-next. Take a look at:

https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html

	Andrew
