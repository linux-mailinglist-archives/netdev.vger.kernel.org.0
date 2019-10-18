Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E64EEDC7C7
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 16:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439547AbfJROwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 10:52:34 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:58651 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394114AbfJROwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 10:52:34 -0400
Received: from localhost (aclermont-ferrand-651-1-259-53.w86-207.abo.wanadoo.fr [86.207.98.53])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 3F327200008;
        Fri, 18 Oct 2019 14:52:32 +0000 (UTC)
Date:   Fri, 18 Oct 2019 16:52:30 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        netdev@vger.kernel.org, thomas.petazzoni@bootlin.com
Subject: Re: [PATCH net-next] net: macb: convert to phylink
Message-ID: <20191018145230.GJ3125@piout.net>
References: <20191018143924.7375-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191018143924.7375-1-antoine.tenart@bootlin.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/10/2019 16:39:24+0200, Antoine Ténart wrote:
> This patch converts the MACB Ethernet driver to the Phylink framework.
> The MAC configuration is moved to the Phylink ops and Phylink helpers
> are now used in the ethtools functions.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
Tested-by: Alexandre Belloni <alexandre.belloni@bootlin.com>


-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
