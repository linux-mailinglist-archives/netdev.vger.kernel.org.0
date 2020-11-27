Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9B32C6383
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 12:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgK0K6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 05:58:13 -0500
Received: from correo.us.es ([193.147.175.20]:41636 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726417AbgK0K6N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 05:58:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D3DEEA8201
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 11:58:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C4AF3DA844
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 11:58:10 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C4070DA840; Fri, 27 Nov 2020 11:58:10 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 693B3DA704;
        Fri, 27 Nov 2020 11:58:08 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 27 Nov 2020 11:58:08 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4995342EF42A;
        Fri, 27 Nov 2020 11:58:08 +0100 (CET)
Date:   Fri, 27 Nov 2020 11:58:08 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org, wenxu@ucloud.cn, paulb@nvidia.com,
        ozsh@nvidia.com, ahleihel@nvidia.com
Subject: Re: [PATCH net-next] net/sched: act_ct: enable stats for HW
 offloaded entries
Message-ID: <20201127105808.GA8330@salvia>
References: <481a65741261fd81b0a0813e698af163477467ec.1606415787.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <481a65741261fd81b0a0813e698af163477467ec.1606415787.git.marcelo.leitner@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 26, 2020 at 03:40:49PM -0300, Marcelo Ricardo Leitner wrote:
> By setting NF_FLOWTABLE_COUNTER. Otherwise, the updates added by
> commit ef803b3cf96a ("netfilter: flowtable: add counter support in HW
> offload") are not effective when using act_ct.
> 
> While at it, now that we have the flag set, protect the call to
> nf_ct_acct_update() by commit beb97d3a3192 ("net/sched: act_ct: update
> nf_conn_acct for act_ct SW offload in flowtable") with the check on
> NF_FLOWTABLE_COUNTER, as also done on other places.
> 
> Note that this shouldn't impact performance as these stats are only
> enabled when net.netfilter.nf_conntrack_acct is enabled.
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
