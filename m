Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3ED1ED5B3
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 20:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgFCSCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 14:02:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35286 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbgFCSCg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 14:02:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CSWKY66DWtze7X4hNKHohygR5t0l+hHbZoF4pXEq1Lw=; b=DaFszbbLzZ2HM7PRFBEFCzWsaI
        c7sYmhhPTGInhDE16ndxV3lS9cYHCJn11HVwaTX3Z3VINfC1QOZRBiLCBaoemXcfPM/eU9Lm/ANNH
        AzGOBPSmiYJOBrairjTuraOHAs20SWrmFMlVDbQG/CvelZuZpGNOJKrNEMRUFyz3NqLw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jgXig-0044gK-L2; Wed, 03 Jun 2020 20:02:30 +0200
Date:   Wed, 3 Jun 2020 20:02:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Roelof Berg <rberg@berg-solutions.de>
Cc:     David Miller <davem@davemloft.net>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lan743x: Added fixed link and RGMII support / debugging
Message-ID: <20200603180230.GA971209@lunn.ch>
References: <20200529193003.3717-1-rberg@berg-solutions.de>
 <20200601.115136.1314501977250032604.davem@davemloft.net>
 <D784BC1B-D14C-4FE4-8FD8-76BEBE60A39D@berg-solutions.de>
 <20200603155927.GC869823@lunn.ch>
 <9D950C93-921D-4D50-84C5-A566726B7AA5@berg-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9D950C93-921D-4D50-84C5-A566726B7AA5@berg-solutions.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 06:36:28PM +0200, Roelof Berg wrote:
> If I find a fix, would I need to submit a delta patch (to our last one) or a full patch ?

A delta.

  Andrew
