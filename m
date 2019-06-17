Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEBF484D1
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 16:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbfFQOCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 10:02:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33134 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725983AbfFQOCz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 10:02:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NLmK9rOO5VvLR7mLxvavfAoFSN3ceVBckcTU41bgZsw=; b=hMmhLsBoXeMpfMl3U4IHIwRdsj
        PLbBdSI7lLwFY5f0CpH3RRL3hYYfE2Rj1DM65UJ8ZFAE9L096phJ6YbPsSmwo1V3cg8y7CiFGqx4Q
        ObFfvXCtO0a14PpRW0dS137hADwrk2g35cUwGgNhOvU+tG3GiL4jbgK0jDk0fVsqrzbA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hcsDH-0007gw-Tq; Mon, 17 Jun 2019 16:02:23 +0200
Date:   Mon, 17 Jun 2019 16:02:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, john@phrozen.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: mediatek: Add MT7621 TRGMII mode
 support
Message-ID: <20190617140223.GC25211@lunn.ch>
References: <20190616182010.18778-1-opensource@vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190616182010.18778-1-opensource@vdorst.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 16, 2019 at 08:20:08PM +0200, René van Dorst wrote:
> Like many other mediatek SOCs, the MT7621 SOC and the internal MT7530 switch both
> supports TRGMII mode. MT7621 TRGMII speed is 1200MBit.

Hi René

Is TRGMII used only between the SoC and the Switch? Or does external
ports of the switch also support 1200Mbit/s? If external ports support
this, what does ethtool show for Speed?

      Thanks
	Andrew
