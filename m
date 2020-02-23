Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1A6169A4D
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 22:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgBWVkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 16:40:22 -0500
Received: from correo.us.es ([193.147.175.20]:51446 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727100AbgBWVkW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Feb 2020 16:40:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8E846EBAC5
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 22:40:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 827DEDA38D
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 22:40:15 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7837BDA3C2; Sun, 23 Feb 2020 22:40:15 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A89DDDA7B2;
        Sun, 23 Feb 2020 22:40:13 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 23 Feb 2020 22:40:13 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 81E5A42EF4E1;
        Sun, 23 Feb 2020 22:40:13 +0100 (CET)
Date:   Sun, 23 Feb 2020 22:40:18 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCHv2 nf-next] netfilter: nft_tunnel: add support for geneve
 opts
Message-ID: <20200223214018.g5jbv4p4o74k6rru@salvia>
References: <0711b62fce237dfde2d02e92d4d273c9578818ef.1581313282.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0711b62fce237dfde2d02e92d4d273c9578818ef.1581313282.git.lucien.xin@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 10, 2020 at 01:41:22PM +0800, Xin Long wrote:
> Like vxlan and erspan opts, geneve opts should also be supported in
> nft_tunnel.

Applied, thanks.
