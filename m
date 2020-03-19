Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 042E618C101
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 21:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbgCSUFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 16:05:18 -0400
Received: from correo.us.es ([193.147.175.20]:51940 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbgCSUFR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 16:05:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4DB4511EB8C
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 21:04:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3CF47FC5ED
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 21:04:45 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3261DFC5E5; Thu, 19 Mar 2020 21:04:45 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 56643DA72F;
        Thu, 19 Mar 2020 21:04:43 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 19 Mar 2020 21:04:43 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3478A42EFB80;
        Thu, 19 Mar 2020 21:04:43 +0100 (CET)
Date:   Thu, 19 Mar 2020 21:05:13 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] netfilter: nf_flow_table: reload ip{v6}h in
 nf_flow_tuple_ip{v6}
Message-ID: <20200319200513.5az6whhu4gdyqpll@salvia>
References: <1584410573-6812-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
 <1584410573-6812-2-git-send-email-yanhaishuang@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584410573-6812-2-git-send-email-yanhaishuang@cmss.chinamobile.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 10:02:53AM +0800, Haishuang Yan wrote:
> Since pskb_may_pull may change skb->data, so we need to reload ip{v6}h at
> the right place.

Also applied, thanks.
