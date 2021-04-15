Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409B036160E
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237180AbhDOXVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:21:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54494 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237134AbhDOXVv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 19:21:51 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lXBIZ-00GyfZ-A5; Fri, 16 Apr 2021 01:21:23 +0200
Date:   Fri, 16 Apr 2021 01:21:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net-next 04/10] net: korina: Remove nested helpers
Message-ID: <YHjKc3jiTxMUXupo@lunn.ch>
References: <20210414230648.76129-1-tsbogend@alpha.franken.de>
 <20210414230648.76129-5-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414230648.76129-5-tsbogend@alpha.franken.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 01:06:41AM +0200, Thomas Bogendoerfer wrote:
> Remove helpers, which are only used in one call site.
> 
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
