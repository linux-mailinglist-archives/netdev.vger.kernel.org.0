Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876F7249FBB
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 15:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgHSNZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 09:25:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33370 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728393AbgHSNQL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 09:16:11 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k8Nwm-00A5NY-NA; Wed, 19 Aug 2020 15:16:08 +0200
Date:   Wed, 19 Aug 2020 15:16:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 1/2] net: dsa: loop: Configure VLANs while
 not filtering
Message-ID: <20200819131608.GC2403519@lunn.ch>
References: <20200819043218.19285-1-f.fainelli@gmail.com>
 <20200819043218.19285-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819043218.19285-2-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 09:32:17PM -0700, Florian Fainelli wrote:
> Since this is a mock-up driver with no real data path for now, but we
> will have one at some point, enable VLANs while not filtering.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
