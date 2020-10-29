Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3EB429EA05
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 12:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgJ2LG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 07:06:56 -0400
Received: from correo.us.es ([193.147.175.20]:54974 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727023AbgJ2LGz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 07:06:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A118E891992
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 12:06:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 92BFDDA844
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 12:06:53 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 79B3EDA840; Thu, 29 Oct 2020 12:06:53 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4F7AFDA78A;
        Thu, 29 Oct 2020 12:06:51 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 29 Oct 2020 12:06:51 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 236CC42EF4EA;
        Thu, 29 Oct 2020 12:06:51 +0100 (CET)
Date:   Thu, 29 Oct 2020 12:06:50 +0100
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
Message-ID: <20201029110650.GA10242@salvia>
References: <20201019172532.3906-1-saeed.mirzamohammadi@oracle.com>
 <20201020115047.GA15628@salvia>
 <28C74722-8F35-4397-B567-FA5BCF525891@oracle.com>
 <3BE1A64B-7104-4220-BAD1-870338A33B15@oracle.com>
 <566D38F7-7C99-40F4-A948-03F2F0439BBB@oracle.com>
 <20201027062111.GD206502@kroah.com>
 <20201027081922.GA5285@salvia>
 <20201029110241.GB3840801@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201029110241.GB3840801@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 12:02:41PM +0100, Greg KH wrote:
> On Tue, Oct 27, 2020 at 09:19:22AM +0100, Pablo Neira Ayuso wrote:
> > Hi Greg,
> > 
> > On Tue, Oct 27, 2020 at 07:21:11AM +0100, Greg KH wrote:
> > > On Sun, Oct 25, 2020 at 04:31:57PM -0700, Saeed Mirzamohammadi wrote:
> > > > Adding stable.
> > > 
> > > What did that do?
> > 
> > Saeed is requesting that stable maintainers cherry-picks this patch:
> > 
> > 31cc578ae2de ("netfilter: nftables_offload: KASAN slab-out-of-bounds
> > Read in nft_flow_rule_create")
> > 
> > into stable 5.4 and 5.8.
> 
> 5.9 is also a stable kernel :)

Oh, indeed, I forgot this one :)

> Will go queue it up everywhere...

Thanks.
