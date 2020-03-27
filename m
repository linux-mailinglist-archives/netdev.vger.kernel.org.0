Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3D51195AF8
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 17:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgC0QXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 12:23:00 -0400
Received: from correo.us.es ([193.147.175.20]:36880 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727495AbgC0QXA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 12:23:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0FEEDE8629
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 17:22:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 02C14DA390
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 17:22:58 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EBF75DA72F; Fri, 27 Mar 2020 17:22:57 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3991FDA840;
        Fri, 27 Mar 2020 17:22:56 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 27 Mar 2020 17:22:56 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1820942EE38F;
        Fri, 27 Mar 2020 17:22:56 +0100 (CET)
Date:   Fri, 27 Mar 2020 17:22:55 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Oz Shlomo <ozsh@mellanox.com>, Majd Dibbiny <majd@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/3] netfilter: flowtable: Support offload of
 tuples in parallel
Message-ID: <20200327162255.a5esovzczin6jr7p@salvia>
References: <1585300351-15741-1-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585300351-15741-1-git-send-email-paulb@mellanox.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 12:12:28PM +0300, Paul Blakey wrote:
> The following patchset opens support for offloading tuples in parallel.
> 
> Patches for netfilter replace the flow table block lock with rw sem,
> and use a work entry per offload command, so they can be run in
> parallel under rw sem read lock.

I'll apply 1/3 and 2/3 to nf-next.

@Saeed: please handle patch 3/3 through the MLX5 driver tree.

Thanks.
