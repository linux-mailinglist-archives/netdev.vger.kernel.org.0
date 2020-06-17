Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F44C1FD231
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 18:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgFQQ3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 12:29:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727053AbgFQQ3g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 12:29:36 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EE12208D5;
        Wed, 17 Jun 2020 16:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592411376;
        bh=8NMooyy9zmgCoRz9Bfe1m3a59TQs9KsGHEYsdfsawh8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MH6ZKdWSSSG59udAA/XdSSPJAxxGN811FLnDmTYPldlXucVraXf7S6zsF6t22ymKI
         +Fw7kOjrx0cqwSv1hvOP2AOo3bWkoQpA1SiHmmHaMUogb3qxSm0ZL4iMnsv0O2qsOH
         ceFiN7rHSJCTklc0YjRe+/vEdrg01lsNmGSVRepg=
Date:   Wed, 17 Jun 2020 09:29:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <linux@armlinux.org.uk>, <antoine.tenart@bootlin.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: macb: undo operations in case of failure
Message-ID: <20200617092935.4e3616c1@kicinski-fedora-PC1C0HJN>
In-Reply-To: <1592400235-11833-1-git-send-email-claudiu.beznea@microchip.com>
References: <1592400235-11833-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Jun 2020 16:23:55 +0300 Claudiu Beznea wrote:
> Undo previously done operation in case macb_phylink_connect()
> fails. Since macb_reset_hw() is the 1st undo operation the
> napi_exit label was renamed to reset_hw.
> 
> Fixes: b2b041417299 ("net: macb: convert to phylink")
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>

Fixes tag: Fixes: b2b041417299 ("net: macb: convert to phylink")
Has these problem(s):
	- Target SHA1 does not exist
