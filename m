Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 587BEB8E08
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 11:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408585AbfITJtc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 20 Sep 2019 05:49:32 -0400
Received: from correo.us.es ([193.147.175.20]:45938 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405771AbfITJtc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 05:49:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A1A38C32A9
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 11:49:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 90764FF2EB
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 11:49:28 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7E300B8019; Fri, 20 Sep 2019 11:49:28 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 64A86B7FF2;
        Fri, 20 Sep 2019 11:49:26 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 20 Sep 2019 11:49:26 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [5.182.56.138])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0E27A41E4800;
        Fri, 20 Sep 2019 11:49:25 +0200 (CEST)
Date:   Fri, 20 Sep 2019 11:49:25 +0200
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
Message-ID: <20190920094925.aw7actk4tdnk3rke@salvia>
References: <20190916000517.45028-1-kilobyte@angband.pl>
 <20190916130811.GA29776@azazel.net>
 <20190917050946.kmzajvqh3kjr4ch5@salvia>
 <20190917145907.GA2241@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20190917145907.GA2241@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 17, 2019 at 03:59:08PM +0100, Jeremy Sowden wrote:
[...]
> The commit in net-next that fixes it is:
> 
>   47e640af2e49 ("netfilter: add missing IS_ENABLED(CONFIG_NF_TABLES) check to header-file.")
> 
> I applied it to the mainline and compile-tested it to verify that it
> does indeed fix the build failure.
> 
> From my reading of stable-kernel-rules.rst and netdev-FAQ.rst, it
> appears that the fix should come from the mainline, so I will wait for
> it to get there.

Thanks, just send this to stable@vger.kernel.org and Cc
netfilter-devel@vger.kernel.org and me when requesting this.
