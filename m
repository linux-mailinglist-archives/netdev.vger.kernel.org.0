Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96381195C85
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 18:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbgC0RWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 13:22:38 -0400
Received: from correo.us.es ([193.147.175.20]:37334 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727716AbgC0RWi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 13:22:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 50A8F8E594
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 18:22:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 407FFDA3AC
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 18:22:36 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 35D3BDA3A1; Fri, 27 Mar 2020 18:22:36 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 553DCDA3A3;
        Fri, 27 Mar 2020 18:22:34 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 27 Mar 2020 18:22:34 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2BADE42EE395;
        Fri, 27 Mar 2020 18:22:34 +0100 (CET)
Date:   Fri, 27 Mar 2020 18:22:33 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jules Irenge <jbi.octave@gmail.com>
Cc:     boqun.feng@gmail.com, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>
Subject: Re: [PATCH 5/8] netfilter: conntrack: Add missing annotations for
 nf_conntrack_all_lock() and nf_conntrack_all_unlock()
Message-ID: <20200327172233.4koyonq3iqp6pmy4@salvia>
References: <0/8>
 <20200311010908.42366-1-jbi.octave@gmail.com>
 <20200311010908.42366-6-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311010908.42366-6-jbi.octave@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 01:09:05AM +0000, Jules Irenge wrote:
> Sparse reports warnings at nf_conntrack_all_lock()
> 	and nf_conntrack_all_unlock()
> 
> warning: context imbalance in nf_conntrack_all_lock()
> 	- wrong count at exit
> warning: context imbalance in nf_conntrack_all_unlock()
> 	- unexpected unlock
> 
> Add the missing __acquires(&nf_conntrack_locks_all_lock)
> Add missing __releases(&nf_conntrack_locks_all_lock)

Also applied, thanks.
