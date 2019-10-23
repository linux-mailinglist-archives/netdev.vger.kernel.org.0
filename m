Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98DB2E0F3F
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 02:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732078AbfJWAf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 20:35:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58718 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727140AbfJWAf4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 20:35:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6Z1DBBH/xUKUXF6UckwoFUZ5ZnN9nnX2q+E7Z7EAe2Q=; b=y9NLf0atN/EmyK6I1GyF2uyzPc
        Wef1EEQatx+CogP0iIpR5QX2/xoGcAmg+ahCmFHstkzlyen5Yw0d8g5664osChhKqFiChQ1FxotsZ
        8VTDFSCkt1zIan4zR5AzDg3UQjMMe9Kmwk9uQr3EA/rF3vm0xr/w0hhDljIR8XVCrprE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iN4cp-0004IX-0w; Wed, 23 Oct 2019 02:35:43 +0200
Date:   Wed, 23 Oct 2019 02:35:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Chris Snook <chris.snook@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        James Hogan <jhogan@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v4 2/5] dt-bindings: net: dsa: qca,ar9331 switch
 documentation
Message-ID: <20191023003543.GE5707@lunn.ch>
References: <20191022055743.6832-1-o.rempel@pengutronix.de>
 <20191022055743.6832-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022055743.6832-3-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 07:57:40AM +0200, Oleksij Rempel wrote:
> Atheros AR9331 has built-in 5 port switch. The switch can be configured
> to use all 5 or 4 ports. One of built-in PHYs can be used by first built-in
> ethernet controller or to be used directly by the switch over second ethernet
> controller.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Hi Oleksij

What we never really discussed is how this MUXing of the PHY works.

What i'm worried about is that when we do understand how it works, we
cannot properly support it using this binding.

Please could you try to find information about this.

Thanks
	Andrew
