Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20D31FD4EF
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 20:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgFQSyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 14:54:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44750 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726971AbgFQSyB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 14:54:01 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jldCA-0010sc-A4; Wed, 17 Jun 2020 20:53:58 +0200
Date:   Wed, 17 Jun 2020 20:53:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dejin Zheng <zhengdejin5@gmail.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kevin Groeneveld <kgroeneveld@gmail.com>
Subject: Re: [PATCH net v2] net: phy: smsc: fix printing too many logs
Message-ID: <20200617185358.GC240559@lunn.ch>
References: <20200617183400.19386-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617183400.19386-1-zhengdejin5@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> v1 -> v2:
> 	- add more commit message spell out why has this commit
> 	  and how to modify it.

Just to re-iterate what i said for v1, this does not explain why -110
is not an error and so should not cause a message to be printed.

   Andrew
