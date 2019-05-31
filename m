Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F4124311A4
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 17:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfEaPyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 11:54:10 -0400
Received: from mail.us.es ([193.147.175.20]:37614 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbfEaPyK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 11:54:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2FA5281A10
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 17:54:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1CE8FDA706
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 17:54:08 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 049A8DA70C; Fri, 31 May 2019 17:54:08 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 054EADA703;
        Fri, 31 May 2019 17:54:06 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 May 2019 17:54:06 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D2DE34265A5B;
        Fri, 31 May 2019 17:54:05 +0200 (CEST)
Date:   Fri, 31 May 2019 17:54:05 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz Pawelczyk <havner@gmail.com>
Subject: Re: [PATCH v3] netfilter: xt_owner: Add supplementary groups option
Message-ID: <20190531155405.npz2fhey7vj56zjx@salvia>
References: <CGME20190510114627eucas1p25476833d2d375b113353741c18aecd92@eucas1p2.samsung.com>
 <20190510114622.831-1-l.pawelczyk@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190510114622.831-1-l.pawelczyk@samsung.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 10, 2019 at 01:46:22PM +0200, Lukasz Pawelczyk wrote:
> The XT_OWNER_SUPPL_GROUPS flag causes GIDs specified with XT_OWNER_GID
> to be also checked in the supplementary groups of a process.
> 
> f_cred->group_info cannot be modified during its lifetime and f_cred
> holds a reference to it so it's safe to use.

Applied, thanks.
