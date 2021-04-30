Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9DC36FBDA
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 16:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbhD3OCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 10:02:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47884 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229688AbhD3OCq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 10:02:46 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lcTiG-001ovK-CN; Fri, 30 Apr 2021 16:01:48 +0200
Date:   Fri, 30 Apr 2021 16:01:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     =?utf-8?B?5pu554Wc?= <cao88yu@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net] dsa: mv88e6xxx: 6161: Use chip wide MAX MTU
Message-ID: <YIwNzKZbiuLZRnoR@lunn.ch>
References: <20210426233441.302414-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210426233441.302414-1-andrew@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 27, 2021 at 01:34:41AM +0200, Andrew Lunn wrote:
> The datasheets suggests the 6161 uses a per port setting for jumbo
> frames. Testing has however shown this is not correct, it uses the old
> style chip wide MTU control. Change the ops in the 6161 structure to
> reflect this.
> 
> Fixes: 1baf0fac10fb ("net: dsa: mv88e6xxx: Use chip-wide max frame size for MTU")
> Reported by: 曹煜 <cao88yu@gmail.com>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

self NACK.

We dug deeper and found a different real problem. Patches to follow.

   Andrew
