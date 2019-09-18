Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8AADB6831
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 18:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730972AbfIRQcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 12:32:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53260 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726359AbfIRQcl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 12:32:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JM2h7z5mh2kb0CtWLRTSGXMX+lpVQABcP7xIjoBOrH0=; b=AJnI+Z2Evqao1gW2eq+R32q6R8
        7QL62YCkgAeqDBPgM9agnFDMd6xShli/DdqyH5WE15a3OcaxUoZJ8LYoa9yRMKxNf9nBDYzif/HYP
        wsZHXORdkDpNUeSCIVV4Q4NevRZ9esb/3LVAOOsn2tq/CHYSTdrMQTypkiRVDzuSlXWc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iAcsf-0000Pz-8g; Wed, 18 Sep 2019 18:32:37 +0200
Date:   Wed, 18 Sep 2019 18:32:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Peter Mamonov <pmamonov@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3] net/phy: fix DP83865 10 Mbps HDX loopback disable
 function
Message-ID: <20190918163236.GM9591@lunn.ch>
References: <20190918162755.24024-1-pmamonov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918162755.24024-1-pmamonov@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 07:27:55PM +0300, Peter Mamonov wrote:
> According to the DP83865 datasheet "the 10 Mbps HDX loopback can be
> disabled in the expanded memory register 0x1C0.1". The driver erroneously
> used bit 0 instead of bit 1.
> 
> Fixes: 4621bf129856 ("phy: Add file missed in previous commit.")
> Signed-off-by: Peter Mamonov <pmamonov@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

