Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE9B71892D1
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 01:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgCRAVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 20:21:44 -0400
Received: from correo.us.es ([193.147.175.20]:41744 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726680AbgCRAVo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 20:21:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 62AE01C4390
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:21:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5520DDA3B1
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:21:13 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 49568DA3AA; Wed, 18 Mar 2020 01:21:13 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 837BFDA736;
        Wed, 18 Mar 2020 01:21:11 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 01:21:11 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 56079426CCBA;
        Wed, 18 Mar 2020 01:21:11 +0100 (CET)
Date:   Wed, 18 Mar 2020 01:21:39 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Martin Mares <mj@ucw.cz>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Thomas Graf <tgraf@suug.ch>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH nf-next 0/3] Netfilter egress hook
Message-ID: <20200318002139.zcweejpc2z6lgpag@salvia>
References: <cover.1583927267.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1583927267.git.lukas@wunner.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 12:59:00PM +0100, Lukas Wunner wrote:
> Introduce a netfilter egress hook to complement the existing ingress hook.
> 
> User space support for nft will be submitted separately in a minute.
> 
> I'm re-submitting this as non-RFC per Pablo's request.  Compared to the
> RFC, I've changed the order in patch [3/3] to perform netfilter first,
> then tc (instead of the other way round).  The rationale is provided in
> the commit message.  I've also extended the commit message with performance
> measurements.
> 
> To reproduce the performance measurements in patch [3/3], you'll need
> net-next commit 1e09e5818b3a ("pktgen: Allow on loopback device").

Series applied to nf-next, thank you.
