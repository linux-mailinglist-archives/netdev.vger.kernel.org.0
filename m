Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A70D34FB5
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 20:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbfFDSPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 14:15:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55874 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbfFDSPh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 14:15:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sgH5Y5zz0cDqAoPiD35f5G5smL2HNGy5LnHl3LCfjrE=; b=pHIZz0vYjIPSl4G9DDAX0kw9w0
        GweQcbjHPCv69ArX30958gmqBJG8SBLY1rn0Bi7GraPZGEIT7lnson+QRYpu5MSnueGVejFP3u0Uh
        igo5Pevig5rVoKo6cf94VcyrvNp/5yQa6tzeypxcr7bTG6LTYkgPr2FNi3few9Kqfpak=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hYDy8-00078C-7C; Tue, 04 Jun 2019 20:15:32 +0200
Date:   Tue, 4 Jun 2019 20:15:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 02/17] net: dsa: Add teardown callback for
 drivers
Message-ID: <20190604181532.GG16951@lunn.ch>
References: <20190604170756.14338-1-olteanv@gmail.com>
 <20190604170756.14338-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604170756.14338-3-olteanv@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 04, 2019 at 08:07:41PM +0300, Vladimir Oltean wrote:
> This is helpful for e.g. draining per-driver (not per-port) tagger
> queues.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
