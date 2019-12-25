Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE0812A91B
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 21:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfLYUqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 15:46:36 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40016 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbfLYUqg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Dec 2019 15:46:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4ZzRvdaBtnhB0AU4QWJ+geeibBRbqhrl+tCTqbC8vaU=; b=kJNBQkw6ivE+im5O6ztGzUBsBB
        /VDcORIn2KtBPoC1qux3QHcFdbVeM7C/afZgC706hL7dTqOg/10MzhBC190VmOmTGIQKazpowtIS+
        g1T8aZw5zcErTraxRUshRczhczu4yYfBn1tKHVA9qNuh+LUEZiX1KSAVuhHHWJno3KDQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ikDY7-0008Nv-7l; Wed, 25 Dec 2019 21:46:31 +0100
Date:   Wed, 25 Dec 2019 21:46:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH v2] mv88e6xxx: Add serdes Rx statistics
Message-ID: <20191225204631.GB31948@lunn.ch>
References: <20191225052238.23334-1-nikita.yoush@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191225052238.23334-1-nikita.yoush@cogentembedded.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 25, 2019 at 08:22:38AM +0300, Nikita Yushchenko wrote:
> If packet checker is enabled in the serdes, then Rx counter registers
> start working, and no side effects have been detected.
> 
> This patch enables packet checker automatically when powering serdes on,
> and exposes Rx counter registers via ethtool statistics interface.
> 
> Code partially basded by older attempt by Andrew Lunn.
> 
> Signed-off-by: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
> ---
> Changes from v1:
> - added missing break statement (thanks kbuild test robot <lkp@intel.com>)

Opps. Sorry i missed that.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
