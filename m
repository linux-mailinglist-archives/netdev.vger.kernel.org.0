Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4002820EAB3
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgF3BIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:08:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38392 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728060AbgF3BIV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 21:08:21 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jq4l1-002ux8-MR; Tue, 30 Jun 2020 03:08:19 +0200
Date:   Tue, 30 Jun 2020 03:08:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andre.Edich@microchip.com
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        steve.glendinning@shawell.net, Parthiban.Veerasooran@microchip.com
Subject: Re: [PATCH net-next 1/8] smsc95xx: check return value of
 smsc95xx_reset
Message-ID: <20200630010819.GD597495@lunn.ch>
References: <07d84bc9ea8a7282b790795ca3ebfc0c7d63447d.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07d84bc9ea8a7282b790795ca3ebfc0c7d63447d.camel@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 01:10:47PM +0000, Andre.Edich@microchip.com wrote:
> The return value of the function smsc95xx_reset() must be checked
> to avoid returning false success from the function smsc95xx_bind().

Hi Andre

This and the next patch look like fixes. They should be for the net
tree, and have a Fixes: tag added.

      Andrew
