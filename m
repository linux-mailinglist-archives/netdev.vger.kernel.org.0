Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD01214236
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 02:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgGDAHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 20:07:11 -0400
Received: from correo.us.es ([193.147.175.20]:56238 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726779AbgGDAHK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 20:07:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 189B5ED5CB
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 02:07:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 000DFDA78A
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 02:07:08 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E1A19DA796; Sat,  4 Jul 2020 02:07:08 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B3186DA73F;
        Sat,  4 Jul 2020 02:07:06 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 04 Jul 2020 02:07:06 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8143C4265A32;
        Sat,  4 Jul 2020 02:07:06 +0200 (CEST)
Date:   Sat, 4 Jul 2020 02:07:06 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Gaurav Singh <gaurav1086@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>,
        "open list:NETWORKING [IPv4/IPv6]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [net/ipv6] Remove redundant null check in ah_mt6
Message-ID: <20200704000706.GA32604@salvia>
References: <20200625023626.32557-1-gaurav1086@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625023626.32557-1-gaurav1086@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Gaurav,

On Wed, Jun 24, 2020 at 10:36:25PM -0400, Gaurav Singh wrote:
> ah cannot be NULL since its already checked above after
> assignment and is being dereferenced before in pr().
> Remove the redundant null check.

Could you collapse all your patches into one?

They look like the same logic change (patch description is the same in
the four patches in the series).

Please, prepend netfilter: to your patch subject, I suggest the
following subject for the collapsed patch.

        netfilter: ip6tables: Remove redundant null checks

Thanks.
