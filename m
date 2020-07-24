Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9446822C461
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 13:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgGXL3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 07:29:01 -0400
Received: from correo.us.es ([193.147.175.20]:44590 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726182AbgGXL3A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 07:29:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6245C18CDCA
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 13:28:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 50B64DA8E8
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 13:28:59 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 45461DA856; Fri, 24 Jul 2020 13:28:59 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D1F8EDA73F;
        Fri, 24 Jul 2020 13:28:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 24 Jul 2020 13:28:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6A39242EFB83;
        Fri, 24 Jul 2020 13:28:56 +0200 (CEST)
Date:   Fri, 24 Jul 2020 13:28:56 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH for v5.9] netfilter: Replace HTTP links with HTTPS ones
Message-ID: <20200724112856.GA26061@salvia>
References: <20200719115202.58449-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200719115202.58449-1-grandmaster@al2klimov.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 19, 2020 at 01:52:02PM +0200, Alexander A. Klimov wrote:
> Rationale:
> Reduces attack surface on kernel devs opening the links for MITM
> as HTTPS traffic is much harder to manipulate.

LGTM.

Can you squash this patch into this?

netfilter: xtables: Replace HTTP links with HTTPS ones

Probably better if this can be done for the entire netfilter tree in
one single patch.

Thanks.
