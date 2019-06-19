Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73FB84B67B
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 12:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbfFSKv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 06:51:28 -0400
Received: from mail.us.es ([193.147.175.20]:40974 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726958AbfFSKv2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 06:51:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D696C67B98
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 12:51:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C71DDDA78E
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 12:51:25 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C47EFDA78D; Wed, 19 Jun 2019 12:51:25 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5515BDA718;
        Wed, 19 Jun 2019 12:51:23 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 19 Jun 2019 12:51:23 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1D9474265A32;
        Wed, 19 Jun 2019 12:51:23 +0200 (CEST)
Date:   Wed, 19 Jun 2019 12:51:22 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Colin King <colin.king@canonical.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][V2][next] netfilter: synproxy: ensure zero is returned
 on non-error return path
Message-ID: <20190619105122.envwm53ew7isp4m2@salvia>
References: <20190618142244.16463-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618142244.16463-1-colin.king@canonical.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 03:22:44PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently functions nf_synproxy_{ipc4|ipv6}_init return an uninitialized
> garbage value in variable ret on a successful return.  Fix this by
> returning zero on success.

Applied, thanks Colin.
