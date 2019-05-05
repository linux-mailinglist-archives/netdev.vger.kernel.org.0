Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 496AC142EF
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 00:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbfEEW7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 18:59:35 -0400
Received: from mail.us.es ([193.147.175.20]:54032 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727767AbfEEW7f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 18:59:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 71D7A11ED85
        for <netdev@vger.kernel.org>; Mon,  6 May 2019 00:59:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5FBEEDA701
        for <netdev@vger.kernel.org>; Mon,  6 May 2019 00:59:33 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 47477DA70A; Mon,  6 May 2019 00:59:33 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4C5DDDA703;
        Mon,  6 May 2019 00:59:31 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 06 May 2019 00:59:31 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 219F14265A31;
        Mon,  6 May 2019 00:59:31 +0200 (CEST)
Date:   Mon, 6 May 2019 00:59:30 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz Pawelczyk <havner@gmail.com>
Subject: Re: [PATCH] extensions: libxt_owner: Add complementary groups option
Message-ID: <20190505225930.w4bcrlsgzq7cipvg@salvia>
References: <CGME20190426160306eucas1p1a0c8ec9783cc78db7381582a70d6de10@eucas1p1.samsung.com>
 <20190426160257.4139-1-l.pawelczyk@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190426160257.4139-1-l.pawelczyk@samsung.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 26, 2019 at 06:02:57PM +0200, Lukasz Pawelczyk wrote:
> The --compl-groups option causes GIDs specified with --gid-owner to be
> also checked in the complementary groups of a process.

Please, could you also update manpage?

BTW, I think you refer to _supplementary_ groups, right? Existing
documentation uses this term.
