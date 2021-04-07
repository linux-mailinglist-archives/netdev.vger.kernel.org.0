Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1931A35606C
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347597AbhDGAlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:41:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37244 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233744AbhDGAlR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:41:17 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTwFi-00FDuJ-Aq; Wed, 07 Apr 2021 02:41:02 +0200
Date:   Wed, 7 Apr 2021 02:41:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] drivers: net: dsa: qca8k: add support for
 multiple cpu port
Message-ID: <YGz/nu117LDEhsou@lunn.ch>
References: <20210406045041.16283-1-ansuelsmth@gmail.com>
 <20210406045041.16283-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406045041.16283-2-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 06:50:40AM +0200, Ansuel Smith wrote:
> qca8k 83xx switch have 2 cpu ports. Rework the driver to support
> multiple cpu port. All ports can access both cpu ports by default as
> they support the same features.

Do you have more information about how this actually works. How does
the switch decide which port to use when sending a frame towards the
CPU? Is there some sort of load balancing?

How does Linux decide which CPU port to use towards the switch?

    Andrew
