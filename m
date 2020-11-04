Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DED02A64FA
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729944AbgKDNWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:22:07 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34650 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726691AbgKDNWG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 08:22:06 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kaIjg-005Cw7-8H; Wed, 04 Nov 2020 14:22:00 +0100
Date:   Wed, 4 Nov 2020 14:22:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Dustin McIntire <dustin@sensoria.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 02/12] net: ethernet: smsc: smc911x: Mark 'status' as
 __maybe_unused
Message-ID: <20201104132200.GW933237@lunn.ch>
References: <20201104090610.1446616-1-lee.jones@linaro.org>
 <20201104090610.1446616-3-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104090610.1446616-3-lee.jones@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 09:06:00AM +0000, Lee Jones wrote:
> 'status' is used to interact with a hardware register.  It might not
> be safe to remove it entirely.  Mark it as __maybe_unused instead.

Hi Lee

https://www.mail-archive.com/netdev@vger.kernel.org/msg365875.html

I'm working on driver/net/ethernet and net to make it w=1 clean.  I
suggest you hang out on the netdev mailing list so you don't waste
your time reproducing what i am doing.

     Andrew
