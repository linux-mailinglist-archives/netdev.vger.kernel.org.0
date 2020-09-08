Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE48261053
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 12:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729705AbgIHK4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 06:56:24 -0400
Received: from correo.us.es ([193.147.175.20]:40940 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729394AbgIHK4T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 06:56:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6D1CD1C438A
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 12:56:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 60298DA84A
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 12:56:18 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4AFA2DA856; Tue,  8 Sep 2020 12:56:18 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 14E1CDA704;
        Tue,  8 Sep 2020 12:56:16 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 08 Sep 2020 12:56:16 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CB1814301DE1;
        Tue,  8 Sep 2020 12:56:15 +0200 (CEST)
Date:   Tue, 8 Sep 2020 12:56:15 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     kadlec@netfilter.org, fw@strlen.de, roopa@nvidia.com,
        nikolay@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: ebt_stp: Remove unused macro
 BPDU_TYPE_TCN
Message-ID: <20200908105615.GA17880@salvia>
References: <20200904125653.15170-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200904125653.15170-1-wanghai38@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 04, 2020 at 08:56:53PM +0800, Wang Hai wrote:
> BPDU_TYPE_TCN is never used after it was introduced.
> So better to remove it.

Applied, thanks.
