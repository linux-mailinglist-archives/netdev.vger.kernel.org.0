Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFC0A5D7C
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 23:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727748AbfIBVUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 17:20:14 -0400
Received: from correo.us.es ([193.147.175.20]:48906 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727318AbfIBVUN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 17:20:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 14913172C8B
        for <netdev@vger.kernel.org>; Mon,  2 Sep 2019 23:20:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 06FDEDA72F
        for <netdev@vger.kernel.org>; Mon,  2 Sep 2019 23:20:10 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E522FB8011; Mon,  2 Sep 2019 23:20:09 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D7A50D2B1F;
        Mon,  2 Sep 2019 23:20:07 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 02 Sep 2019 23:20:07 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A7AB742EF4E0;
        Mon,  2 Sep 2019 23:20:07 +0200 (CEST)
Date:   Mon, 2 Sep 2019 23:20:08 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Leonardo Bras <leonardo@linux.ibm.com>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v5 1/1] net: br_netfiler_hooks: Drops IPv6 packets if
 IPv6 module is not loaded
Message-ID: <20190902212008.gy4ejl4bj5fhdqfm@salvia>
References: <20190831044032.31931-1-leonardo@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190831044032.31931-1-leonardo@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 31, 2019 at 01:40:33AM -0300, Leonardo Bras wrote:
> A kernel panic can happen if a host has disabled IPv6 on boot and have to
> process guest packets (coming from a bridge) using it's ip6tables.
> 
> IPv6 packets need to be dropped if the IPv6 module is not loaded, and the
> host ip6tables will be used.

Applied, thanks.
