Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93B627CE92
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729688AbgI2NJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:09:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728407AbgI2NI5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 09:08:57 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E461A207F7;
        Tue, 29 Sep 2020 13:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601384936;
        bh=Su0UiZc0qmLvVTnSUix5XFVQIT/6cyR/d0HnpU80kbk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yWKlRDduCWOBjEwP1oqDN6/BEc6zqVqWR36zVBC381AAUxXaP5olPCU6UY2oyG2MO
         xIR/z647ta86JQnvIc8k52cBv6FZ5Fvx9SgUSJZ5Uoi1LpYm/T4ZfmgftSeteGR4bY
         W5iAenCJkDGdEiI1A5iq0P/jqnXqr0nkYYOPL7W0=
Date:   Tue, 29 Sep 2020 08:14:37 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     ioana.ciornei@nxp.com, ruxandra.radulescu@nxp.com, kuba@kernel.org,
        andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] dpaa2-mac: Fix potential null pointer dereference
Message-ID: <20200929131437.GB28922@embeddedor>
References: <20200925170323.GA20546@embeddedor>
 <20200925.171554.1696394343282908508.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925.171554.1696394343282908508.davem@davemloft.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 05:15:54PM -0700, David Miller wrote:
> From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Date: Fri, 25 Sep 2020 12:03:23 -0500
> 
> > There is a null-check for _pcs_, but it is being dereferenced
> > prior to this null-check. So, if _pcs_ can actually be null,
> > then there is a potential null pointer dereference that should
> > be fixed by null-checking _pcs_ before being dereferenced.
> > 
> > Addresses-Coverity-ID: 1497159 ("Dereference before null check")
> > Fixes: 94ae899b2096 ("dpaa2-mac: add PCS support through the Lynx module")
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> Applied, thanks.

Thanks, Dave.
--
Gustavo
