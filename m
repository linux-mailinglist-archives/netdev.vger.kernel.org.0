Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5E7260F8A
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 12:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729054AbgIHKW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 06:22:28 -0400
Received: from correo.us.es ([193.147.175.20]:45692 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbgIHKW2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 06:22:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A901C11EB83
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 12:22:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A8F2DA78C
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 12:22:26 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8FF74DA72F; Tue,  8 Sep 2020 12:22:26 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7EEA5DA78B;
        Tue,  8 Sep 2020 12:22:24 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 08 Sep 2020 12:22:24 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5FA314301DE3;
        Tue,  8 Sep 2020 12:22:24 +0200 (CEST)
Date:   Tue, 8 Sep 2020 12:22:24 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-net] netfilter: conntrack: nf_conncount_init is
 failing with IPv6 disabled
Message-ID: <20200908102224.GA4395@salvia>
References: <159897212470.60236.5737844268627410321.stgit@ebuild>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <159897212470.60236.5737844268627410321.stgit@ebuild>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 01, 2020 at 04:56:02PM +0200, Eelco Chaudron wrote:
> The openvswitch module fails initialization when used in a kernel
> without IPv6 enabled. nf_conncount_init() fails because the ct code
> unconditionally tries to initialize the netns IPv6 related bit,
> regardless of the build option. The change below ignores the IPv6
> part if not enabled.
> 
> Note that the corresponding _put() function already has this IPv6
> configuration check.

Applied to nf.git

Please, Cc: netfilter-devel@vger.kernel.org next time.

Thanks.
