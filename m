Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF1E2EC5A
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 23:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729532AbfD2V5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 17:57:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49149 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729517AbfD2V5N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 17:57:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QTSRmRd8rjnTbUIBtFMoJtgxJfJ188lpDp0wbdS6ne4=; b=ue5Q9aED/zS7Iipaj8AmJavQmp
        XUB8kGRsA8t00hhys3EDQVhXudN92cWFCGk8BDA7lOkbv7nCduHmdVmqEn+Ltiypp230zxEtuwylU
        akBS0KneBUL5a0ZLwzsRA1WtNkIKGdgadb+6Loj3wTi+J7cYuD9OzbtisKY0EaACNprA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hLEGs-00073T-MZ; Mon, 29 Apr 2019 23:57:10 +0200
Date:   Mon, 29 Apr 2019 23:57:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 10/13] net: dsa: Skip calling
 .port_vlan_filtering on no change
Message-ID: <20190429215710.GI12333@lunn.ch>
References: <20190428184554.9968-1-olteanv@gmail.com>
 <20190428184554.9968-11-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190428184554.9968-11-olteanv@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 28, 2019 at 09:45:51PM +0300, Vladimir Oltean wrote:
> Even if VLAN filtering is global, DSA will call this callback once per
> each port. Drivers should not have to compare the global state with the
> requested change. So let DSA do it.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
