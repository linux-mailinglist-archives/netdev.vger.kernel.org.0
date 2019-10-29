Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA4DE7E3D
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 02:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730011AbfJ2Bzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 21:55:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39460 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728432AbfJ2Bzk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 21:55:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sjXFPKiWrLyR6LHPsDmQMC4ULkd5iUf14tApuhtKjWI=; b=IAt6IlL7bCnqA3YBZLRZvaQQW1
        jX/49ygOkpMCKL4CYlyAL3+myL5k2dBmepZJ0srWGH5EaG4V+v2aQZiL37wdBxOGAB/1NrXKXRzoO
        8KHPgiKv82Qihw59TQeEUycm98Z8T7P+p1pD4waTBYzgN5hk8ESJhSML+9djW52PtPGA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iPGjR-0001Hv-VC; Tue, 29 Oct 2019 02:55:37 +0100
Date:   Tue, 29 Oct 2019 02:55:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        laurentiu.tudor@nxp.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next v3 4/5] dpaa2-eth: add MAC/PHY support through
 phylink
Message-ID: <20191029015537.GI15259@lunn.ch>
References: <1571998630-17108-1-git-send-email-ioana.ciornei@nxp.com>
 <1571998630-17108-5-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571998630-17108-5-git-send-email-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 01:17:09PM +0300, Ioana Ciornei wrote:
> The dpaa2-eth driver now has support for connecting to its associated
> PHY device found through standard OF bindings.
> 
> This happens when the DPNI object (that the driver probes on) gets
> connected to a DPMAC. When that happens, the device tree is looked up by
> the DPMAC ID, and the associated PHY bindings are found.
> 
> The old logic of handling the net device's link state by hand still
> needs to be kept, as the DPNI can be connected to other devices on the
> bus than a DPMAC: other DPNI, DPSW ports, etc. This logic is only
> engaged when there is no DPMAC (and therefore no phylink instance)
> attached.
> 
> The MC firmware support multiple type of DPMAC links: TYPE_FIXED,
> TYPE_PHY. The TYPE_FIXED mode does not require any DPMAC management from
> Linux side, and as such, the driver will not handle such a DPMAC.
> 
> Although PHYLINK typically handles SFP cages and in-band AN modes, for
> the moment the driver only supports the RGMII interfaces found on the
> LX2160A. Support for other modes will come later.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
