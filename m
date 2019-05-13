Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25CCF1B2C5
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 11:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbfEMJWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 05:22:19 -0400
Received: from mail.us.es ([193.147.175.20]:35444 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728051AbfEMJWS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 05:22:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6FCA61C438B
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 11:22:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F79CDA705
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 11:22:16 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 53BC1DA715; Mon, 13 May 2019 11:22:16 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0D337DA709;
        Mon, 13 May 2019 11:22:12 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 13 May 2019 11:22:12 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D5D144265A32;
        Mon, 13 May 2019 11:22:11 +0200 (CEST)
Date:   Mon, 13 May 2019 11:22:11 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jagdish Motwani <j.k.motwani@gmail.com>
Cc:     netdev@vger.kernel.org,
        Jagdish Motwani <jagdish.motwani@sophos.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_queue:fix reinject verdict handling
Message-ID: <20190513092211.isxyzpytenvocbx2@salvia>
References: <20190508183114.7507-1-j.k.motwani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508183114.7507-1-j.k.motwani@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jagdish,

On Thu, May 09, 2019 at 12:01:14AM +0530, Jagdish Motwani wrote:
> From: Jagdish Motwani <jagdish.motwani@sophos.com>
> 
> In case of more than 1 nf_queues, hooks between them are being executed
> more than once.

This refers to NF_REPEAT, correct?

I think this broke with 960632ece6949. If so, it would be good to add
the following tag to this patch then. It's useful for robots
collecting fixes for -stable kernels.

Fixes: 960632ece694 ("netfilter: convert hook list to an array")

> Signed-off-by: Jagdish Motwani <jagdish.motwani@sophos.com>

Thanks.
