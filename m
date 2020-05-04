Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800DE1C3B3A
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 15:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgEDN2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 09:28:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40020 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727104AbgEDN2H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 09:28:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pw9R2dXBAzVfSFeO5KLWScuxBDYmfHCqEXY/AXjW7KI=; b=Xq0QnQER+SBbsOxb/Kg2dDarwb
        +hlmiH+MruR2HOmbQ2Jd6zf3ag465y81lhM+c1bbtboh6zBQo1iDgRB00O6KUDkh6Vz563Yejy/o8
        Xx6Je72pObD3FVb/9BggFuZ+m0k1SoBRG8aZaHG54OuhvvS6aNgGlG19eD0ec9wcWkQg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jVb8a-000npc-2q; Mon, 04 May 2020 15:28:00 +0200
Date:   Mon, 4 May 2020 15:28:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: dsa: Do not make user port errors fatal
Message-ID: <20200504132800.GA190789@lunn.ch>
References: <20200504035057.20275-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504035057.20275-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 03, 2020 at 08:50:57PM -0700, Florian Fainelli wrote:
> Prior to 1d27732f411d ("net: dsa: setup and teardown ports"), we would
> not treat failures to set-up an user port as fatal, but after this
> commit we would, which is a regression for some systems where interfaces
> may be declared in the Device Tree, but the underlying hardware may not
> be present (pluggable daughter cards for instance).
> 
> Fixes: 1d27732f411d ("net: dsa: setup and teardown ports")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
