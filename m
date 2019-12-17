Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D71341238BC
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbfLQVgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:36:14 -0500
Received: from correo.us.es ([193.147.175.20]:33340 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727529AbfLQVgO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 16:36:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E289FE8646
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 22:36:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D66F5DA70B
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 22:36:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CBE57DA70F; Tue, 17 Dec 2019 22:36:09 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C6794DA70F;
        Tue, 17 Dec 2019 22:36:07 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 17 Dec 2019 22:36:07 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A958B4265A5A;
        Tue, 17 Dec 2019 22:36:07 +0100 (CET)
Date:   Tue, 17 Dec 2019 22:36:08 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCHv2 nf-next 0/5] netfilter: nft_tunnel: a bunch of fixes
 and improvements
Message-ID: <20191217213608.m4hhc4yvmj3hcpen@salvia>
References: <cover.1576226965.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1576226965.git.lucien.xin@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 04:53:04PM +0800, Xin Long wrote:
> This patchset adds some fixes and improvements for nft_tunnel.
> 
> Note the patch for adding support for geneve opts in nft_tunnel
> will be posted in another patch after this one.

Series applied, thanks.
