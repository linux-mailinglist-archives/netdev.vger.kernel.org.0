Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 005361238FF
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbfLQV65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:58:57 -0500
Received: from correo.us.es ([193.147.175.20]:41918 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbfLQV65 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 16:58:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6A6C79ED4E
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 22:58:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5E118DA710
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 22:58:54 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 53784DA703; Tue, 17 Dec 2019 22:58:54 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 59BABDA703;
        Tue, 17 Dec 2019 22:58:52 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 17 Dec 2019 22:58:52 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3C3FD4265A5A;
        Tue, 17 Dec 2019 22:58:52 +0100 (CET)
Date:   Tue, 17 Dec 2019 22:58:52 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next] netfilter: Clean up unnecessary #ifdef
Message-ID: <20191217215852.miwzcem5ebfi2d2g@salvia>
References: <4362209712369ea47ac39b06a9fc93fc4ce3a25c.1574247376.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4362209712369ea47ac39b06a9fc93fc4ce3a25c.1574247376.git.lukas@wunner.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 12:33:59PM +0100, Lukas Wunner wrote:
> If CONFIG_NETFILTER_INGRESS is not enabled, nf_ingress() becomes a no-op
> because it solely contains an if-clause calling nf_hook_ingress_active(),
> for which an empty inline stub exists in <linux/netfilter_ingress.h>.
> 
> All the symbols used in the if-clause's body are still available even if
> CONFIG_NETFILTER_INGRESS is not enabled.
> 
> The additional "#ifdef CONFIG_NETFILTER_INGRESS" in nf_ingress() is thus
> unnecessary, so drop it.

Applied, thanks.
