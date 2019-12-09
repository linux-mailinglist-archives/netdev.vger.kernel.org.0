Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F643117329
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 18:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbfLIRvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 12:51:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42836 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbfLIRvX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 12:51:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ms/F2s3/R6/K6xLFMgTAAHNf26wBJJq851sLoWDyaHM=; b=QPhX/g5vzvc1EQQR+ElUulM8CO
        FQ5cp0+vJTpkVCwhpZxYH/fpmFvYseVfS37Ux9Yw4Ve0l/QbXlr9Nri9O6Im84c/1y21fBliMB2cC
        67MfEbqnAKFKRkazihaobdHVRE9bpS28H7xPMBIp7nYjxCTXdP/C3iLcNLm7BXAr38Go=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ieNBn-0006wI-N6; Mon, 09 Dec 2019 18:51:19 +0100
Date:   Mon, 9 Dec 2019 18:51:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Fabio Estevam <festevam@gmail.com>, netdev@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        kernel@pengutronix.de, Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v1] ARM i.MX6q: make sure PHY fixup for KSZ9031 is
 applied only on one board
Message-ID: <20191209175119.GK9099@lunn.ch>
References: <20191209084430.11107-1-o.rempel@pengutronix.de>
 <20191209171508.GD9099@lunn.ch>
 <20191209173952.qnkzfrbixjgi2jfy@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209173952.qnkzfrbixjgi2jfy@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Yes. all of them are broken.
> I just trying to not wake all wasp at one time. Most probably there are
> board working by accident. So, it will be good to have at least separate
> patches for each fixup.

I agree about a patch per fixup. Can you try to generate such patches?
See if there is enough history in git to determine which boards
actually need these fixups?

Thanks
	Andrew
