Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E973714198F
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 21:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbgARUTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 15:19:40 -0500
Received: from correo.us.es ([193.147.175.20]:50018 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727029AbgARUTk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jan 2020 15:19:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5EA3C3066A7
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 21:19:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5042BDA718
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 21:19:37 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 44E9EDA713; Sat, 18 Jan 2020 21:19:37 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0C56DA703;
        Sat, 18 Jan 2020 21:19:34 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 18 Jan 2020 21:19:34 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A9E9F41E4800;
        Sat, 18 Jan 2020 21:19:34 +0100 (CET)
Date:   Sat, 18 Jan 2020 21:19:33 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        syzbot+cf23983d697c26c34f60@syzkaller.appspotmail.com,
        Florian Westphal <fw@strlen.de>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: Re: [Patch nf] netfilter: nft_osf: NFTA_OSF_DREG must not be null
Message-ID: <20200118201933.wm3b25hhqe7fpqg7@salvia>
References: <20200118194015.14988-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200118194015.14988-1-xiyou.wangcong@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks. This is a dup though:

https://patchwork.ozlabs.org/patch/1225125/

Thanks in any case.
