Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC7A020EAF6
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgF3Bd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:33:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38472 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726356AbgF3Bd5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 21:33:57 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jq59o-002vAl-5O; Tue, 30 Jun 2020 03:33:56 +0200
Date:   Tue, 30 Jun 2020 03:33:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andre.Edich@microchip.com
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        steve.glendinning@shawell.net, Parthiban.Veerasooran@microchip.com
Subject: Re: [PATCH net-next 0/8] Add PAL support to smsc95xx
Message-ID: <20200630013356.GG597495@lunn.ch>
References: <c8fafa3198fcb0ba74d2190728075f108cfc5aa1.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8fafa3198fcb0ba74d2190728075f108cfc5aa1.camel@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 07:55:24PM +0000, Andre.Edich@microchip.com wrote:
> To allow to probe external phy drivers, this patchset adds use of
> Phy Abstraction Layer to smsc95xx driver.

This is version 2 correct? Please put v2 in the Subject line.

Also, list here, what has changed since v1.

      Andrew
