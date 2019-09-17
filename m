Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02B0EB46BD
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 07:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfIQFKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 01:10:09 -0400
Received: from correo.us.es ([193.147.175.20]:56128 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390984AbfIQFKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 01:10:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8BFB5DA4DF
        for <netdev@vger.kernel.org>; Tue, 17 Sep 2019 07:10:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7FD56B7FFB
        for <netdev@vger.kernel.org>; Tue, 17 Sep 2019 07:10:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7195FD2B1F; Tue, 17 Sep 2019 07:10:05 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5D539FF6FA;
        Tue, 17 Sep 2019 07:10:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 17 Sep 2019 07:10:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [46.31.102.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DD8D14265A5A;
        Tue, 17 Sep 2019 07:10:02 +0200 (CEST)
Date:   Tue, 17 Sep 2019 07:09:46 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Adam Borowski <kilobyte@angband.pl>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: bridge: drop a broken include
Message-ID: <20190917050946.kmzajvqh3kjr4ch5@salvia>
References: <20190916000517.45028-1-kilobyte@angband.pl>
 <20190916130811.GA29776@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916130811.GA29776@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jeremy,

On Mon, Sep 16, 2019 at 02:08:12PM +0100, Jeremy Sowden wrote:
> On 2019-09-16, at 02:05:16 +0200, Adam Borowski wrote:
> > This caused a build failure if CONFIG_NF_CONNTRACK_BRIDGE is set but
> > CONFIG_NF_TABLES=n -- and appears to be unused anyway.
[...]
> There are already changes in the net-next tree that will fix it.

If the fix needs to go to -stable 5.3 kernel release, then you have to
point to the particular commit ID of this patch to fix this one.
net-next contains 5.4-rc material. I'd appreciate also if you can help
identify the patch with a Fixes: tag.

Thanks.
