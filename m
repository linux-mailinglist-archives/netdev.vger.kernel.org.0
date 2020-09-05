Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40ECD25E8B2
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 17:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgIEPcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 11:32:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44822 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbgIEPcm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 11:32:42 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kEaBC-00DMh7-HU; Sat, 05 Sep 2020 17:32:38 +0200
Date:   Sat, 5 Sep 2020 17:32:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Paul Barker <pbarker@konsulko.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 3/4] net: dsa: microchip: Disable RGMII in-band status on
 KSZ9893
Message-ID: <20200905153238.GE3164319@lunn.ch>
References: <20200905140325.108846-1-pbarker@konsulko.com>
 <20200905140325.108846-4-pbarker@konsulko.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200905140325.108846-4-pbarker@konsulko.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 05, 2020 at 03:03:24PM +0100, Paul Barker wrote:
> We can't assume that the link partner supports the in-band status
> reporting which is enabled by default on the KSZ9893 when using RGMII
> for the upstream port.

What do you mean by RGMII inband status reporting? SGMII/1000BaseX has
in band signalling, but RGMII?

   Andrew
