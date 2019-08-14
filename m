Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0184D8DFFF
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 23:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbfHNVhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 17:37:46 -0400
Received: from correo.us.es ([193.147.175.20]:46818 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728320AbfHNVhp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 17:37:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 48A72C414A
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 23:37:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 39E556DC67
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 23:37:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 249CC8E69F; Wed, 14 Aug 2019 23:37:43 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 06DF4DA704;
        Wed, 14 Aug 2019 23:37:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 14 Aug 2019 23:37:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CE5724265A2F;
        Wed, 14 Aug 2019 23:37:40 +0200 (CEST)
Date:   Wed, 14 Aug 2019 23:37:41 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] netfilter: nft_bitwise: Adjust parentheses to fix memcmp
 size argument
Message-ID: <20190814213741.ptoel7373xqwzlj5@salvia>
References: <20190814165809.46421-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814165809.46421-1-natechancellor@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 09:58:09AM -0700, Nathan Chancellor wrote:
> clang warns:
> 
> net/netfilter/nft_bitwise.c:138:50: error: size argument in 'memcmp'
> call is a comparison [-Werror,-Wmemsize-comparison]
>         if (memcmp(&priv->xor, &zero, sizeof(priv->xor) ||
>                                       ~~~~~~~~~~~~~~~~~~^~

Applied, thanks.
