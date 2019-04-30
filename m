Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4869CF5D8
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 13:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbfD3LjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 07:39:10 -0400
Received: from mail.us.es ([193.147.175.20]:44600 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726648AbfD3LjK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 07:39:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3AE709A7B5
        for <netdev@vger.kernel.org>; Tue, 30 Apr 2019 13:39:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2CC42DA701
        for <netdev@vger.kernel.org>; Tue, 30 Apr 2019 13:39:08 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 12E72DA710; Tue, 30 Apr 2019 13:39:08 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0ACC4DA703;
        Tue, 30 Apr 2019 13:39:06 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 30 Apr 2019 13:39:06 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (129.166.216.87.static.jazztel.es [87.216.166.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C6B1D4265A5B;
        Tue, 30 Apr 2019 13:39:05 +0200 (CEST)
Date:   Tue, 30 Apr 2019 13:39:05 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Paul Gortmaker <paul.gortmaker@windriver.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH -next 0/3] netfilter: header cleanup
Message-ID: <20190430113905.bfyeijal7usqd5b6@salvia>
References: <1555360996-23684-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1555360996-23684-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 15, 2019 at 04:43:13PM -0400, Paul Gortmaker wrote:
> Having core header files in include/linux that in turn include other
> headers with a high number of includes implicitly degenerates into
> a formalism that hides what amounts to #include <linux/everything.h>
> 
> Some headers, like module.h and device.h are good examples that will
> essentially drag in almost everything.
> 
> There is nothing module specific about netfilter, but before we try
> and stop nf_tables.h from including module.h, we have to fix two
> instances of code which are implicitly relying on that module.h
> inclusion, so as to not introduce build regressions.

Series applied.
