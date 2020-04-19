Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185F11AFA56
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 15:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgDSNAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 09:00:45 -0400
Received: from correo.us.es ([193.147.175.20]:42912 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725910AbgDSNAp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 09:00:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B1E3E1E2C63
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 15:00:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A3EA2FF6F5
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 15:00:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 858F7FC553; Sun, 19 Apr 2020 15:00:44 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6A432DA788;
        Sun, 19 Apr 2020 15:00:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 19 Apr 2020 15:00:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 358BF41E4801;
        Sun, 19 Apr 2020 15:00:42 +0200 (CEST)
Date:   Sun, 19 Apr 2020 15:00:41 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Hillf Danton <hdanton@sina.com>
Cc:     Florian Westphal <fw@strlen.de>,
        syzbot <syzbot+33e06702fd6cffc24c40@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, davem@davemloft.net, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Stefano Brivio <sbrivio@redhat.com>
Subject: Re: WARNING in nf_nat_unregister_fn
Message-ID: <20200419130041.jsb5a3dvchedbnin@salvia>
References: <000000000000490f1005a375ed34@google.com>
 <20200417094250.21872-1-hdanton@sina.com>
 <20200418082832.8904-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200418082832.8904-1-hdanton@sina.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 18, 2020 at 04:28:32PM +0800, Hillf Danton wrote:
> Subject: [PATCH] netfilter: nat: fix error handling upon registering inet hook
> From: Hillf Danton <hdanton@sina.com>
> 
> A case of warning was reported by syzbot,

Applied, thank you.
