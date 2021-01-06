Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED042EC642
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 23:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbhAFWdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 17:33:55 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53926 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbhAFWdy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 17:33:54 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kxHMZ-00GXBo-BU; Wed, 06 Jan 2021 23:33:07 +0100
Date:   Wed, 6 Jan 2021 23:33:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH next] net: dsa: print error on invalid port index
Message-ID: <X/Y6o5SJBAeyBPHx@lunn.ch>
References: <20210106090915.21439-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210106090915.21439-1-zajec5@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 06, 2021 at 10:09:15AM +0100, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Looking for an -EINVAL all over the dsa code could take hours for
> inexperienced DSA users.

Following this argument, you should add dev_err() by every -EINVAL.

> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
