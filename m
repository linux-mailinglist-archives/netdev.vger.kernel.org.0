Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1D26902E9
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 15:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbfHPNYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 09:24:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37502 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727218AbfHPNYi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 09:24:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=V0t3yFIwsNCVgU5rBbHlcdi/HDX0m2vdrvjJwq1wt0U=; b=GpNHp+6PpQYwov4Agh0M1Mw1j7
        ZU930WqBAIRVw1kRS0sI4Q5G9CO7rD0VYYmVsRrAD1c5qrP1zL4zQ6yFbHPgCiZ2S/JaXzwtQFJIj
        OaZpFqwI7LZzeCf61gGl6FHjwkYC3jzCat6xN6/1xJ0TI5V4GBwkkOjNAhsZ/4/QUCHQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hycDa-0000CA-Ut; Fri, 16 Aug 2019 15:24:34 +0200
Date:   Fri, 16 Aug 2019 15:24:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH v5 12/13] net: phy: adin: add ethtool get_stats support
Message-ID: <20190816132434.GB307@lunn.ch>
References: <20190816131011.23264-1-alexandru.ardelean@analog.com>
 <20190816131011.23264-13-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816131011.23264-13-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 16, 2019 at 04:10:10PM +0300, Alexandru Ardelean wrote:
> This change implements retrieving all the error counters from the PHY.
> 
> The counters require that the RxErrCnt register (0x0014) be read first,
> after which copies of the counters are latched into the registers. This
> ensures that all registers read after RxErrCnt are synchronized at the
> moment that they are read.
> 
> The counter values need to be accumulated by the driver, as each time that
> RxErrCnt is read, the values that are latched are the ones that have
> incremented from the last read.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
 
Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
