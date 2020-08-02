Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0A3235732
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 15:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbgHBNtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 09:49:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38874 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728043AbgHBNtj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Aug 2020 09:49:39 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k2EMq-007vXU-RY; Sun, 02 Aug 2020 15:49:36 +0200
Date:   Sun, 2 Aug 2020 15:49:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Armin Wolf <W_Armin@gmx.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2 v2 net-next] 8390: Miscellaneous cleanups
Message-ID: <20200802134936.GC1862409@lunn.ch>
References: <20200801205242.GA9549@mx-linux-amd>
 <20200801213204.0a52a865@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200802131452.GA2321@mx-linux-amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200802131452.GA2321@mx-linux-amd>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Did you apply patch 2/2 of the patchset?
> Because version-printing (and the need for a version string) was removed
> from lib8390.c in patch 2/2 to allow the replacement of said
> version-string with MODULE_* macros in 8390.c, and failing to do so whould result
> in the exact same error.

Hi Armin

We require that there be no break in buildability. The kernel must
always build. Otherwise git bisect becomes much more difficult to use.

   Andrew
