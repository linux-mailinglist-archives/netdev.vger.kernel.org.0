Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5185692552
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 15:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbfHSNk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 09:40:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41614 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727301AbfHSNk7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 09:40:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pqjjjZpjmu45M0iQkwOGv6GKxw6LMNBhET0LTmd8Uvo=; b=Jm+sCHpiPmIFwu54dbNZSUVIhl
        5oCZLxs0rVB1WwVpzaud6QnvspREvebzO3FTo5TXqN5rIIWedOOxEJ8BeF4pVxdr+T/hWeHA0XTJV
        qwK07b/DjF9m7aUxAlok35O2Sgax4EvJdcP+vStZkiQcuz0nlVLgyyKRXSYDR/Lj+9zg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hzhu5-0006Bt-0q; Mon, 19 Aug 2019 15:40:57 +0200
Date:   Mon, 19 Aug 2019 15:40:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, marek.behun@nic.cz, davem@davemloft.net,
        f.fainelli@gmail.com
Subject: Re: [PATCH net-next 4/6] net: dsa: mv88e6xxx: do not change STP
 state on port disabling
Message-ID: <20190819134057.GF8981@lunn.ch>
References: <20190818173548.19631-1-vivien.didelot@gmail.com>
 <20190818173548.19631-5-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190818173548.19631-5-vivien.didelot@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 18, 2019 at 01:35:46PM -0400, Vivien Didelot wrote:
> When disabling a port, that is not for the driver to decide what to
> do with the STP state. This is already handled by the DSA layer.

Hi Vivien

Putting the port into STP disabled state is how you actually disable
it, for the mv88e6xxx. So this is not really about STP, it is about
powering off the port. Maybe a comment is needed, rather than removing
the code?

    Thanks
	Andrew
