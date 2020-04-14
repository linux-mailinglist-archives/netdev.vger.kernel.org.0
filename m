Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD731A7F5C
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 16:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389205AbgDNOQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 10:16:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36542 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733197AbgDNOQQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 10:16:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=B9TC/7zlNWGNsADMoz8DkUehEwOaUcqyzM1pp+Q+cTc=; b=mXHuxR24gvgZWVMzJwkMvds8lL
        UZGWdiT0ZLCoGNpqicWNQiqY3zrc588spcnRVj55NsSgPACZthinEzY2pw6uvpn+CNn3yyRZ/IAKu
        Zve8lXDxcfOk9XpngLj86PQCeJVhszujWb0Yg49snFYTDywqVu0/+EScuuzbL7G2O2FM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jOMMF-002fCz-Ng; Tue, 14 Apr 2020 16:16:11 +0200
Date:   Tue, 14 Apr 2020 16:16:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        open list <linux-kernel@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org
Subject: Re: [PATCH net 4/4] net: dsa: b53: Rework ARL bin logic
Message-ID: <20200414141611.GM436020@lunn.ch>
References: <20200414041630.5740-1-f.fainelli@gmail.com>
 <20200414041630.5740-5-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414041630.5740-5-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 09:16:30PM -0700, Florian Fainelli wrote:
> When asking the ARL to read a MAC address, we will get a number of bins
> returned in a single read. Out of those bins, there can essentially be 3
> states:
> 
> - all bins are full, we have no space left, and we can either replace an
>   existing address or return that full condition
> 
> - the MAC address was found, then we need to return its bin index and
>   modify that one, and only that one
> 
> - the MAC address was not found and we have a least one bin free, we use
>   that bin index location then
> 
> The code would unfortunately fail on all counts.
> 
> Fixes: 1da6df85c6fb ("net: dsa: b53: Implement ARL add/del/dump operations")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
