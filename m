Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67F54185FD3
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 21:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729181AbgCOUom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 16:44:42 -0400
Received: from correo.us.es ([193.147.175.20]:54840 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729163AbgCOUok (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Mar 2020 16:44:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8721AE8B6C
        for <netdev@vger.kernel.org>; Sun, 15 Mar 2020 21:44:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7AF99DA3A3
        for <netdev@vger.kernel.org>; Sun, 15 Mar 2020 21:44:12 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 709C3DA3A0; Sun, 15 Mar 2020 21:44:12 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 80597DA72F;
        Sun, 15 Mar 2020 21:44:09 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 15 Mar 2020 21:44:09 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5464E4251480;
        Sun, 15 Mar 2020 21:44:09 +0100 (CET)
Date:   Sun, 15 Mar 2020 21:44:35 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] netfilter: nf_flow_table: reload ipv6h in
 nf_flow_nat_ipv6
Message-ID: <20200315204435.25kji3x5me72xjgg@salvia>
References: <1584281705-26228-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584281705-26228-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 15, 2020 at 10:15:02PM +0800, Haishuang Yan wrote:
> Since nf_flow_snat_port and nf_flow_snat_ipv6 call pskb_may_pull()
> which may change skb->data, so we need to reload ipv6h at the right
> palce.

Could you collapse patch 1/4 and 2/4 ?

Same thing with patches 3/4 and 4/4 ?

Thanks.
