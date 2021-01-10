Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799BB2F0603
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 09:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbhAJIja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 03:39:30 -0500
Received: from correo.us.es ([193.147.175.20]:38736 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbhAJIja (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Jan 2021 03:39:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0B3DDDA723
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 09:38:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F1EC3DA792
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 09:38:06 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E764FDA78D; Sun, 10 Jan 2021 09:38:06 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A38F6DA730;
        Sun, 10 Jan 2021 09:38:04 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 10 Jan 2021 09:38:04 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 74006426CC84;
        Sun, 10 Jan 2021 09:38:04 +0100 (CET)
Date:   Sun, 10 Jan 2021 09:38:46 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     20210104110723.43564-1-yiche@redhat.com
Cc:     Chen Yi <yiche@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Leo <liuhangbin@gmail.com>
Subject: Re: [PATCH] selftests: netfilter: Pass family parameter "-f" to
 conntrack tool
Message-ID: <20210110083846.GA28611@salvia>
References: <20210105153120.42710-1-yiche@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210105153120.42710-1-yiche@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 11:31:20PM +0800, Chen Yi wrote:
> Fix nft_conntrack_helper.sh false fail report:
> 
> 1) Conntrack tool need "-f ipv6" parameter to show out ipv6 traffic items.
> 
> 2) Sleep 1 second after background nc send packet, to make sure check
> is after this statement executed.
> 
> False report:
> FAIL: ns1-lkjUemYw did not show attached helper ip set via ruleset
> PASS: ns1-lkjUemYw connection on port 2121 has ftp helper attached
> ...
> 
> After fix:
> PASS: ns1-2hUniwU2 connection on port 2121 has ftp helper attached
> PASS: ns2-2hUniwU2 connection on port 2121 has ftp helper attached
> ...

Applied.
