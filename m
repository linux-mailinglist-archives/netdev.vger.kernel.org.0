Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1187F4EBD2
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 17:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbfFUPUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 11:20:46 -0400
Received: from mail.us.es ([193.147.175.20]:46944 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbfFUPUp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 11:20:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5FF44EDB05
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 17:20:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 50EA5DA70F
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 17:20:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 465E9DA707; Fri, 21 Jun 2019 17:20:43 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9BA14DA706;
        Fri, 21 Jun 2019 17:20:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 21 Jun 2019 17:20:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 754194265A2F;
        Fri, 21 Jun 2019 17:20:40 +0200 (CEST)
Date:   Fri, 21 Jun 2019 17:20:40 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Yuehaibing <yuehaibing@huawei.com>
Cc:     kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        rdunlap@infradead.org, linux-kernel@vger.kernel.org,
        coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: ipv6: Fix build error without
 CONFIG_IPV6
Message-ID: <20190621152040.jxct6a5smwo3wi6q@salvia>
References: <20190612084715.21656-1-yuehaibing@huawei.com>
 <d2eba9e4-34be-f9bb-f0fd-024fe81d2b02@huawei.com>
 <20190620155016.6kk7xi4wldm5ijyh@salvia>
 <cceb80d8-8997-5831-cb39-14801c1cfe39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cceb80d8-8997-5831-cb39-14801c1cfe39@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Actually, I'm going to take this one:

https://patchwork.ozlabs.org/patch/1117011/

which looks more complete.

Thanks a lot for reporting in any case.
