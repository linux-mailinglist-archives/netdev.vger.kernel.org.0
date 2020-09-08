Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C633B2607DF
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 02:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgIHA5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 20:57:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48848 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727993AbgIHA5L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 20:57:11 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kFRwb-00DiAu-W4; Tue, 08 Sep 2020 02:57:09 +0200
Date:   Tue, 8 Sep 2020 02:57:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: don't print non-fatal MTU error if
 not supported
Message-ID: <20200908005709.GB3267902@lunn.ch>
References: <20200907232556.1671828-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907232556.1671828-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 02:25:56AM +0300, Vladimir Oltean wrote:
> Commit 72579e14a1d3 ("net: dsa: don't fail to probe if we couldn't set
> the MTU") changed, for some reason, the "err && err != -EOPNOTSUPP"
> check into a simple "err". This causes the MTU warning to be printed
> even for drivers that don't have the MTU operations implemented.
> Fix that.

Hi Vladimir

In some ways, this has been good. A lot more DSA drivers now have MTU
support and jumbo packet support.

> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
