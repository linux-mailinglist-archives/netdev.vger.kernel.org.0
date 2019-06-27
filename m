Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40FBB58111
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 13:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbfF0LCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 07:02:22 -0400
Received: from mail.us.es ([193.147.175.20]:60818 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726370AbfF0LCW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 07:02:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 21A48B6C7C
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 13:02:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 12FC99D56B
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 13:02:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 039D7A0AAC; Thu, 27 Jun 2019 13:02:18 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A7527FB37C;
        Thu, 27 Jun 2019 13:02:16 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 27 Jun 2019 13:02:16 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7C4F94265A31;
        Thu, 27 Jun 2019 13:02:16 +0200 (CEST)
Date:   Thu, 27 Jun 2019 13:02:16 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com
Subject: Re: [PATCH net-next v2] net: ethtool: Allow parsing ETHER_FLOW types
 when using flow_rule
Message-ID: <20190627110216.fney5pj2low7vwdw@salvia>
References: <20190627085226.7658-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627085226.7658-1-maxime.chevallier@bootlin.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 10:52:26AM +0200, Maxime Chevallier wrote:
> When parsing an ethtool_rx_flow_spec, users can specify an ethernet flow
> which could contain matches based on the ethernet header, such as the
> MAC address, the VLAN tag or the ethertype.
> 
> ETHER_FLOW uses the src and dst ethernet addresses, along with the
> ethertype as keys. Matches based on the vlan tag are also possible, but
> they are specified using the special FLOW_EXT flag.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>

Acked-by: Pablo Neira Ayuso <pablo@gnumonks.org>

Thanks Maxime.
