Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B04D255ED6
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 18:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbgH1Qfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 12:35:43 -0400
Received: from correo.us.es ([193.147.175.20]:45412 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726524AbgH1Qfm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 12:35:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 793A918D00D
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 18:35:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6A703DA704
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 18:35:41 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5F9F8DA791; Fri, 28 Aug 2020 18:35:41 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 54358DA78A;
        Fri, 28 Aug 2020 18:35:39 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 28 Aug 2020 18:35:39 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2958B42EF4E2;
        Fri, 28 Aug 2020 18:35:39 +0200 (CEST)
Date:   Fri, 28 Aug 2020 18:35:38 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH] net: netfilter: delete repeated words
Message-ID: <20200828163538.GA27462@salvia>
References: <20200823010727.4786-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200823010727.4786-1-rdunlap@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 22, 2020 at 06:07:27PM -0700, Randy Dunlap wrote:
> Drop duplicated words in net/netfilter/ and net/ipv4/netfilter/.

Applied, thanks.
