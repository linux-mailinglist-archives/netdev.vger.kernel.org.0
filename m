Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A745313DCBF
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgAPN7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 08:59:36 -0500
Received: from correo.us.es ([193.147.175.20]:60960 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726474AbgAPN7g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 08:59:36 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E45852A2BC0
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 14:59:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D6EE1DA714
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 14:59:34 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CB89FDA723; Thu, 16 Jan 2020 14:59:34 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C8B9EDA707;
        Thu, 16 Jan 2020 14:59:32 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 16 Jan 2020 14:59:32 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A603342EF9E1;
        Thu, 16 Jan 2020 14:59:32 +0100 (CET)
Date:   Thu, 16 Jan 2020 14:59:32 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot <syzbot+f9d4095107fc8749c69c@syzkaller.appspotmail.com>
Subject: Re: [PATCH] netfilter: nf_tables: fix memory leak in
 nf_tables_parse_netdev_hooks()
Message-ID: <20200116135932.64pqshxvvvpoqawo@salvia>
References: <000000000000ffbba3059c3b5352@google.com>
 <20200116100931.ot2ef4jvsw4ldye2@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116100931.ot2ef4jvsw4ldye2@kili.mountain>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 01:09:31PM +0300, Dan Carpenter wrote:
> Syzbot detected a leak in nf_tables_parse_netdev_hooks().  If the hook
> already exists, then the error handling doesn't free the newest "hook".

Applied, thanks.
