Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E881D2DB132
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 17:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730722AbgLOQU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 11:20:58 -0500
Received: from correo.us.es ([193.147.175.20]:43658 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730618AbgLOQUi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 11:20:38 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D878310329A
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 17:19:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CACB8DA84A
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 17:19:37 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C1475DA840; Tue, 15 Dec 2020 17:19:37 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 93206DA78F;
        Tue, 15 Dec 2020 17:19:35 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 15 Dec 2020 17:19:35 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6A32142EFB80;
        Tue, 15 Dec 2020 17:19:35 +0100 (CET)
Date:   Tue, 15 Dec 2020 17:19:50 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Colin King <colin.king@canonical.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] netfilter: nftables: fix incorrect increment of
 loop counter
Message-ID: <20201215161950.GA10902@salvia>
References: <20201214234015.85072-1-colin.king@canonical.com>
 <20201215143830.GA10086@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201215143830.GA10086@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 03:38:30PM +0100, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Mon, Dec 14, 2020 at 11:40:15PM +0000, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > The intention of the err_expr cleanup path is to iterate over the
> > allocated expr_array objects and free them, starting from i - 1 and
> > working down to the start of the array. Currently the loop counter
> > is being incremented instead of decremented and also the index i is
> > being used instead of k, repeatedly destroying the same expr_array
> > element.  Fix this by decrementing k and using k as the index into
> > expr_array.
> > 
> > Addresses-Coverity: ("Infinite loop")
> > Fixes: 8cfd9b0f8515 ("netfilter: nftables: generalize set expressions support")
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> @Jakub: Would you please take this one into net-next? Thanks!

You marked as "Awaiting Upstream", I'll take care of it.

Thanks.
