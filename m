Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE7036160B
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236821AbhDOXVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:21:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54486 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234716AbhDOXVT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 19:21:19 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lXBI2-00Gyf6-PS; Fri, 16 Apr 2021 01:20:50 +0200
Date:   Fri, 16 Apr 2021 01:20:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net-next 03/10] net: korina: Remove not needed cache
 flushes
Message-ID: <YHjKUulPU4pwCFxL@lunn.ch>
References: <20210414230648.76129-1-tsbogend@alpha.franken.de>
 <20210414230648.76129-4-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414230648.76129-4-tsbogend@alpha.franken.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 01:06:40AM +0200, Thomas Bogendoerfer wrote:
> Descriptors are mapped uncached so there is no need to do any cache
> handling for them.
> 
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
