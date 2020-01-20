Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEB7143020
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 17:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbgATQmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 11:42:22 -0500
Received: from correo.us.es ([193.147.175.20]:53146 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728712AbgATQmW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jan 2020 11:42:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7B6B515AEB0
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 17:42:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6E2AADA71F
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 17:42:20 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6383BDA714; Mon, 20 Jan 2020 17:42:20 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5A600DA711;
        Mon, 20 Jan 2020 17:42:18 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 20 Jan 2020 17:42:18 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 310B341E4801;
        Mon, 20 Jan 2020 17:42:18 +0100 (CET)
Date:   Mon, 20 Jan 2020 17:42:17 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Kadlecsik =?iso-8859-1?Q?J=F3zsef?= <kadlec@blackhole.kfki.hu>
Cc:     syzbot <syzbot+fabca5cbf5e54f3fe2de@syzkaller.appspotmail.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH 1/1] netfilter: ipset: use bitmap infrastructure
 completely
Message-ID: <20200120164217.udzs5jxb35phd4ks@salvia>
References: <alpine.DEB.2.20.2001192203200.18095@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.20.2001192203200.18095@blackhole.kfki.hu>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 19, 2020 at 10:06:49PM +0100, Kadlecsik József wrote:
> The bitmap allocation did not use full unsigned long sizes
> when calculating the required size and that was triggered by KASAN
> as slab-out-of-bounds read in several places. The patch fixes all
> of them.

Applied, thanks Jozsef.
