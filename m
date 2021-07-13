Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27AE3C756D
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 19:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhGMRCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 13:02:46 -0400
Received: from angie.orcam.me.uk ([78.133.224.34]:60606 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhGMRCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 13:02:46 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id C7CC792009C; Tue, 13 Jul 2021 18:59:54 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id BFC4D92009B;
        Tue, 13 Jul 2021 18:59:54 +0200 (CEST)
Date:   Tue, 13 Jul 2021 18:59:54 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Pavel Skripkin <paskripkin@gmail.com>
cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fddi: fix UAF in fza_probe
In-Reply-To: <20210713105853.8979-1-paskripkin@gmail.com>
Message-ID: <alpine.DEB.2.21.2107131853530.9461@angie.orcam.me.uk>
References: <20210713105853.8979-1-paskripkin@gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Jul 2021, Pavel Skripkin wrote:

> fp is netdev private data and it cannot be
> used after free_netdev() call. Using fp after free_netdev()
> can cause UAF bug. Fix it by moving free_netdev() after error message.

 Can you justify the lines for a better layout?  The paragraph looks odd 
to me in its current form.

> Fixes: 61414f5ec983 ("FDDI: defza: Add support for DEC FDDIcontroller 700
> TURBOchannel adapter")
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>

 Otherwise LGTM.  And a good catch, thank you!

Reviewed-by: Maciej W. Rozycki <macro@orcam.me.uk>

  Maciej
