Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04A9038ADD
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 15:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728782AbfFGNIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 09:08:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35820 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727566AbfFGNIT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 09:08:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=AU9CcQAqmC/YppEjljtNOsJ27fN6/IKTULF1R4894yw=; b=Buu3R7rRDIiFEPIECppM9KaKBX
        eRs94YSGG7yORtRRLOC3o3MatZzxnrZZvZYgWtqloIeom1bMzKaYV2/hTI/ZYPP42ltkJMEKpTiJb
        SIAhE+8Ch9jRVyFN1pk8iKy8K2tNDQyMTX1XIwGhDVmgXotnoTe7hgT2ghXpp6AZiDpM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hZEbM-0007JX-Is; Fri, 07 Jun 2019 15:08:12 +0200
Date:   Fri, 7 Jun 2019 15:08:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Jiri Kosina <trivial@kernel.org>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH trivial] Documentation: net: dsa: Grammar s/the its/its/
Message-ID: <20190607130812.GA27291@lunn.ch>
References: <20190607110842.12876-1-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607110842.12876-1-geert+renesas@glider.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 07, 2019 at 01:08:42PM +0200, Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
