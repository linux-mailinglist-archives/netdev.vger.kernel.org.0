Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F841A7F30
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 16:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388982AbgDNOHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 10:07:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36520 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388950AbgDNOHd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 10:07:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Apg7KSuzSoY9RJMbqt/rU+GxBZW+ZwBg4apqMt7/XV8=; b=wtnfpDpqG2O9AWbgb7SMqSg4br
        OXH3oXlLC0KnNsXtHWIjXODdRbV37oC5lrubW1D5KrNmFP42+0ATjqeio+0i6vMpt+zmIC2eTiaJT
        Vwwsj1jEI/ma0qYQxWnxEKXlliGPsiaVlrlDQPKWXYEo9uC6PoVjBaoBWGHLaHic94xw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jOMDq-002f8R-6R; Tue, 14 Apr 2020 16:07:30 +0200
Date:   Tue, 14 Apr 2020 16:07:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        open list <linux-kernel@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org
Subject: Re: [PATCH net 3/4] net: dsa: b53: Fix ARL register definitions
Message-ID: <20200414140730.GL436020@lunn.ch>
References: <20200414041630.5740-1-f.fainelli@gmail.com>
 <20200414041630.5740-4-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414041630.5740-4-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 09:16:29PM -0700, Florian Fainelli wrote:
> The ARL {MAC,VID} tuple and the forward entry were off by 0x10 bytes,
> which means that when we read/wrote from/to ARL bin index 0, we were
> actually accessing the ARLA_RWCTRL register.
> 
> Fixes: 1da6df85c6fb ("net: dsa: b53: Implement ARL add/del/dump operations")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
