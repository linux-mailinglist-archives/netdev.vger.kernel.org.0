Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A12DA07DA
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 18:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfH1QvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 12:51:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38206 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726504AbfH1QvE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 12:51:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ixODsFMELCng7h9EhHNQpojxF2BquZ4q7tzkcCgRsv0=; b=h6SqiHtGvVmZmvVGFX+0uPeAYi
        D4TEtVtJFrNQ6daTRyLHdY7BfmWuNkMgnrqOEz4yKiiMI/XS3l4rmZCNSdnq0UTieQAXJcgZIFdqj
        wVfSjGPUe9sKgQuV8DBWpDujXwQ5iGKjm2WGUUjkcKjW0pQPrpFkvqT0L3vD/6WoxmrA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i319w-0004Md-Bd; Wed, 28 Aug 2019 18:51:00 +0200
Date:   Wed, 28 Aug 2019 18:51:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>,
        f.fainelli@gmail.com
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: keep CMODE writable code
 private
Message-ID: <20190828165100.GD13074@lunn.ch>
References: <20190828162659.10306-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828162659.10306-1-vivien.didelot@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 28, 2019 at 12:26:59PM -0400, Vivien Didelot wrote:
> This is a follow-up patch for commit 7a3007d22e8d ("net: dsa:
> mv88e6xxx: fully support SERDES on Topaz family").
> 
> Since .port_set_cmode is only called from mv88e6xxx_port_setup_mac and
> mv88e6xxx_phylink_mac_config, it is fine to keep this "make writable"
> code private to the mv88e6341_port_set_cmode implementation, instead
> of adding yet another operation to the switch info structure.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
