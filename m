Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79BCF1B429
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 12:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbfEMKk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 06:40:59 -0400
Received: from mail.us.es ([193.147.175.20]:41432 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727272AbfEMKk5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 06:40:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E2939E5A44
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 12:40:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C2CC2DA78D
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 12:40:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BF1F1DA78C; Mon, 13 May 2019 12:40:54 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7D7EDDA701;
        Mon, 13 May 2019 12:40:45 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 13 May 2019 12:40:35 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 228C8406740D;
        Mon, 13 May 2019 12:40:32 +0200 (CEST)
Date:   Mon, 13 May 2019 12:40:31 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jagdish Motwani <Jagdish.Motwani@Sophos.com>
Cc:     Jagdish Motwani <j.k.motwani@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] netfilter: nf_queue:fix reinject verdict handling
Message-ID: <20190513104031.np2ollc6njuof2s2@salvia>
References: <20190508183114.7507-1-j.k.motwani@gmail.com>
 <20190513092211.isxyzpytenvocbx2@salvia>
 <CWXP265MB1464BCF96C61A8FD47619AE59E0F0@CWXP265MB1464.GBRP265.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CWXP265MB1464BCF96C61A8FD47619AE59E0F0@CWXP265MB1464.GBRP265.PROD.OUTLOOK.COM>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 13, 2019 at 10:36:51AM +0000, Jagdish Motwani wrote:
> Hi Pablo,
> 
> The case I am referring to is : If there are more than 1  hooks
> returning NF_QUEUE verdict.  When the first queue reinjects the
> packet, 'nf_reinject' starts traversing hooks with hook_index (i).
> However if it again receives a NF_QUEUE verdict (by some other
> netfilter hook), it queue with the wrong hook_index.  So, when the
> second queue reinjects the packet, it re-executes some hooks in
> between the first 2 hooks.

Please, include this description in the patch. And thanks for
explaining.

> Thanks, I will mark :  Fixes: 960632ece694 ("netfilter: convert hook list to an array") and update the description also.

Thanks, will wait for v2.
