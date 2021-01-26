Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977B23055F0
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 09:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S316912AbhAZXMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405825AbhAZU4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 15:56:01 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E23C06174A;
        Tue, 26 Jan 2021 12:55:20 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l4VMh-00C2sE-Kg; Tue, 26 Jan 2021 21:55:07 +0100
Message-ID: <596880294af8224f2f28311c39491bdfa3b39f2e.camel@sipsolutions.net>
Subject: Re: [PATCH net] iwlwifi: provide gso_type to GSO packets
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Ben Greear <greearb@candelatech.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        linux-wireless@vger.kernel.org
Date:   Tue, 26 Jan 2021 21:55:06 +0100
In-Reply-To: <20210126123207.5c79f4c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210125150949.619309-1-eric.dumazet@gmail.com>
         <20210126123207.5c79f4c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-01-26 at 12:32 -0800, Jakub Kicinski wrote:
> On Mon, 25 Jan 2021 07:09:49 -0800 Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> > 
> > net/core/tso.c got recent support for USO, and this broke iwlfifi
> > because the driver implemented a limited form of GSO.
> > 
> > Providing ->gso_type allows for skb_is_gso_tcp() to provide
> > a correct result.
> > 
> > Fixes: 3d5b459ba0e3 ("net: tso: add UDP segmentation support")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Reported-by: Ben Greear <greearb@candelatech.com>
> > Bisected-by: Ben Greear <greearb@candelatech.com>
> > Tested-by: Ben Greear <greearb@candelatech.com>
> > Cc: Luca Coelho <luciano.coelho@intel.com>
> > Cc: linux-wireless@vger.kernel.org
> > Cc: Johannes Berg <johannes@sipsolutions.net>
> 
> Johannes, Eric tagged this for net, are you okay with me taking it?
> No strong preference here.

I guess that really would normally go through Luca's and Kalle's trees,
but yes, please just take it, it's been long and it won't conflict with
anything.

johannes

