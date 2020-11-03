Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74622A4F1F
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 19:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729306AbgKCSmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 13:42:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:49646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgKCSmN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 13:42:13 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30EA7223C6;
        Tue,  3 Nov 2020 18:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604428933;
        bh=d5gRTQP0dGkK59avyt40Hks9mGeJh+ZVf02YieS2DOM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZJHA7DdYENeqkpxzuSab8PYMzJeNTYDzczlTsoqlAI1kEPtc2EoKKPWRtx5ylEEwq
         nDuJ0c3eyeZt9DWbpaPR1l/3s1mx2IjDPeFnzsTBAaCdOEhK1UX6rJ9etARf5fU+It
         ytXNTGKfoAnRKb1h3+5nwa04r9oUPwEfiodBrj/Y=
Date:   Tue, 3 Nov 2020 10:42:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Camelia Alexandra Groza <camelia.groza@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net v3 0/2] dpaa_eth: buffer layout fixes
Message-ID: <20201103104212.3be43311@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <VI1PR04MB58073450C08552820A7755AAF2110@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <cover.1604339942.git.camelia.groza@nxp.com>
        <VI1PR04MB58073450C08552820A7755AAF2110@VI1PR04MB5807.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Nov 2020 16:37:26 +0000 Camelia Alexandra Groza wrote:
> > Subject: [PATCH net v3 0/2] dpaa_eth: buffer layout fixes
> > 
> > The patches are related to the software workaround for the A050385
> > erratum.
> > The first patch ensures optimal buffer usage for non-erratum scenarios. The
> > second patch fixes a currently inconsequential discrepancy between the
> > FMan and Ethernet drivers.

Hm, looks like the bot didn't reply, these are applied to net, as you
probably noticed.
 
> Jakub, when are you planning the next merger of net into net-next? I
> have a patch set for net-next depending on this one.

Thursday afternoon PST, or Friday. Depends on when Linus pulls from net.
