Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E7A28A232
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389198AbgJJWz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:55:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731830AbgJJTh1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Oct 2020 15:37:27 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74A8722475;
        Sat, 10 Oct 2020 17:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602352261;
        bh=RcrHP6M9iO2TiQX0pTpMw4VWg9yEMVSi+ILIXkBBZvY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hKqNIdhwXmIO2EMZZey3KIc+weJn3OqlPCaBFNezueQjIJUpOSRNZA3Zt/DhmvW5W
         SDP1b6ws55zHVaV0j4Zp8t40CBvNTXtbl0jo9cJ99KX4RqATTwrln90ZLAqY/h5IRg
         MgiPFnXJX+c3Cw0IK2kWwA4GDgEG8N5e+RusKPQ4=
Date:   Sat, 10 Oct 2020 10:51:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: Re: [PATCH] dpaa_eth: enable NETIF_MSG_HW by default
Message-ID: <20201010105100.1f7e71e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <AM6PR04MB39762E887745C2CAC34F9098EC0B0@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20201008120312.258644-1-vladimir.oltean@nxp.com>
        <AM6PR04MB39762E887745C2CAC34F9098EC0B0@AM6PR04MB3976.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Oct 2020 14:37:44 +0000 Madalin Bucur (OSS) wrote:
> > From: Maxim Kochetkov <fido_max@inbox.ru>
> > 
> > When packets are received on the error queue, this function under
> > net_ratelimit():
> > 
> > netif_err(priv, hw, net_dev, "Err FD status = 0x%08x\n");
> > 
> > does not get printed. Instead we only see:
> > 
> > [ 3658.845592] net_ratelimit: 244 callbacks suppressed
> > [ 3663.969535] net_ratelimit: 230 callbacks suppressed
> > [ 3669.085478] net_ratelimit: 228 callbacks suppressed
> > 
> > Enabling NETIF_MSG_HW fixes this issue, and we can see some information
> > about the frame descriptors of packets.
> > 
> > Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Reviewed-by: Madalin Bucur <madalin.bucur@oss.nxp.com>

Applied, thanks everyone!
