Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90001F9AC5
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 21:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfKLUcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 15:32:36 -0500
Received: from correo.us.es ([193.147.175.20]:42234 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726697AbfKLUcg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 15:32:36 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5AAD6E34C7
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 21:32:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4D5C5BAACC
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 21:32:31 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 41A57DA3A9; Tue, 12 Nov 2019 21:32:31 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3411BDA72F;
        Tue, 12 Nov 2019 21:32:29 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 12 Nov 2019 21:32:29 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 10EDD4251480;
        Tue, 12 Nov 2019 21:32:29 +0100 (CET)
Date:   Tue, 12 Nov 2019 21:32:30 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 7/7] net/mlx5: TC: Offload flow table rules
Message-ID: <20191112203230.p3lb3ivhsravctxz@salvia>
References: <20191111233430.25120-1-pablo@netfilter.org>
 <20191111233430.25120-8-pablo@netfilter.org>
 <0ba19058c0b455fe0ef9e272e981f78a977c0b82.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ba19058c0b455fe0ef9e272e981f78a977c0b82.camel@mellanox.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saeed,

On Tue, Nov 12, 2019 at 12:37:27AM +0000, Saeed Mahameed wrote:
> On Tue, 2019-11-12 at 00:34 +0100, Pablo Neira Ayuso wrote:
> > From: Paul Blakey <paulb@mellanox.com>
> > 
> > Since both tc rules and flow table rules are of the same format,
> > we can re-use tc parsing for that, and move the flow table rules
> > to their steering domain - In this case, the next chain after
> > max tc chain.
> > 
> > Issue: 1929510
> > Change-Id: I68bf14d5398b91cf26cc7c7f19dab64ba8757c01
> > Signed-off-by: Paul Blakey <paulb@mellanox.com>
> > Reviewed-by: Mark Bloch <markb@mellanox.com>
> > Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Series LGTM, 
> 
> couple of things:
>  
> 1) Paul should have removed Issue and change-Id tags
> I can do this myself when i apply those to my trees.
>
> 2) patches #1..#6 can perfectly go mlx5-next,
> already tried and i had to resolve some trivial conflicts, but all
> good.

Thanks.

> 3) this patch needs to be on top of net-next, due to dependency with 
> TC_SETUP_FT, I will resubmit it through my normal pull request
> procedure after applying all other patches in this series to mlx5-next
> shared branch. 
>
> All patches will land in net-next in couple of days, i guess there is
> no rush to have them there immediately ?

No rush on my side.

We have to wait for David to tell us if he is fine to apply this
patchset into net-next, then pull from your tree the first client for
this code in a couple of days as you suggest.
