Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C541129A665
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 09:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894568AbgJ0ITc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 04:19:32 -0400
Received: from correo.us.es ([193.147.175.20]:52726 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2894553AbgJ0IT3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 04:19:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 45B2E303D05
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 09:19:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 372D8DA72F
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 09:19:26 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 36437DA78D; Tue, 27 Oct 2020 09:19:26 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7850ADA72F;
        Tue, 27 Oct 2020 09:19:23 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 27 Oct 2020 09:19:23 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4D30542EF42B;
        Tue, 27 Oct 2020 09:19:23 +0100 (CET)
Date:   Tue, 27 Oct 2020 09:19:22 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH linux-5.9 1/1] net: netfilter: fix KASAN:
 slab-out-of-bounds Read in nft_flow_rule_create
Message-ID: <20201027081922.GA5285@salvia>
References: <20201019172532.3906-1-saeed.mirzamohammadi@oracle.com>
 <20201020115047.GA15628@salvia>
 <28C74722-8F35-4397-B567-FA5BCF525891@oracle.com>
 <3BE1A64B-7104-4220-BAD1-870338A33B15@oracle.com>
 <566D38F7-7C99-40F4-A948-03F2F0439BBB@oracle.com>
 <20201027062111.GD206502@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201027062111.GD206502@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

On Tue, Oct 27, 2020 at 07:21:11AM +0100, Greg KH wrote:
> On Sun, Oct 25, 2020 at 04:31:57PM -0700, Saeed Mirzamohammadi wrote:
> > Adding stable.
> 
> What did that do?

Saeed is requesting that stable maintainers cherry-picks this patch:

31cc578ae2de ("netfilter: nftables_offload: KASAN slab-out-of-bounds
Read in nft_flow_rule_create")

into stable 5.4 and 5.8.

Thanks.
