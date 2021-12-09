Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096A646DF54
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 01:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241424AbhLIARF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 19:17:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49082 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241413AbhLIARE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 19:17:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F11AB82305
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 00:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC4DC00446;
        Thu,  9 Dec 2021 00:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639008809;
        bh=06ld+wHpRBnA634rNj2BeLx7I+Fp1By5bDy/6Hi3r0E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oTXJXiq+j8/97LJXNvshwMpssY+0UNCkBW1ISCnTnVFB5o4J5x5x5E9z4A0FbgWpo
         P7ZvJW8wQD5Ukd8yRQwEBM5qxh8wqZsP1olRLaFaqO3+KkKjtQfuHP+v6kPAbJOpuk
         CypnRtx9vuit8U7rkIqUlXXBYylznhe2kY1tTBv2CwIH/VQb1MLYksB1GxLKtI+G9p
         tT36mNFArypL5HdLZrLgk7aQrQ7/DtY6BOEA4lA8Yo66rrcdXuTNLaecapOIttBbhX
         fpxY68pSUNKul5FJxamoo6EIj2fkDk6Whbt9hXxzbG59vBk9iQ7uJIIWnSXBT9XJgV
         Di9SLvTODgAWg==
Date:   Wed, 8 Dec 2021 16:13:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Martin Kaistra <martin.kaistra@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH net-next 05/11] net: dsa: sja1105: remove hwts_tx_en
 from tagger data
Message-ID: <20211208161328.466a3cba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211208200504.3136642-6-vladimir.oltean@nxp.com>
References: <20211208200504.3136642-1-vladimir.oltean@nxp.com>
        <20211208200504.3136642-6-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  8 Dec 2021 22:04:58 +0200 Vladimir Oltean wrote:
> This tagger property is in fact not used at all by the tagger, only by
> the switch driver. Therefore it makes sense to be moved to
> sja1105_private.

This one transiently breaks build.
