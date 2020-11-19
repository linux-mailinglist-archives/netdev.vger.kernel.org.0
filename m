Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B3E2B8AFC
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 06:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725843AbgKSF2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 00:28:22 -0500
Received: from mailout05.rmx.de ([94.199.90.90]:58544 "EHLO mailout05.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725648AbgKSF2W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 00:28:22 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout05.rmx.de (Postfix) with ESMTPS id 4Cc7W6469Vz9t9n;
        Thu, 19 Nov 2020 06:28:18 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4Cc7Vz6WlMz2xZR;
        Thu, 19 Nov 2020 06:28:11 +0100 (CET)
Received: from n95hx1g2.localnet (192.168.54.21) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 19 Nov
 2020 06:27:50 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: avoid potential use-after-free error
Date:   Thu, 19 Nov 2020 06:27:50 +0100
Message-ID: <2398833.qWU5Cqh0tX@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201118233357.ihifojr62ly4pas3@skbuf>
References: <20201118154335.1189-1-ceggers@arri.de> <20201118233357.ihifojr62ly4pas3@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.21]
X-RMX-ID: 20201119-062811-4Cc7Vz6WlMz2xZR-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday, 19 November 2020, 00:33:57 CET, Vladimir Oltean wrote:
> On Wed, Nov 18, 2020 at 04:43:35PM +0100, Christian Eggers wrote:
> > If dsa_switch_ops::port_txtstamp() returns false, clone will be freed
> > immediately. Storing the pointer in DSA_SKB_CB(skb)->clone anyway,
> > supports annoying use-after-free bugs.
> 
> Like what?
In my own code. I test for DSA_SKB_CB(skb)->clone in order to determine 
whether a skb has been selected for TX time stamping by 
ksz9477_ptp_port_txtstamp().

> 
> > Signed-off-by: Christian Eggers <ceggers@arri.de>
> > Fixes 146d442c2357 ("net: dsa: Keep a pointer to the skb clone for TX
> > timestamping")
> Not the right format for a Fixes: tag, please try to set up your
> .gitconfig to automate the creation of this tag.
I think you (or somebody else) already noted this. Sorry for postponing.

regards
Christian



