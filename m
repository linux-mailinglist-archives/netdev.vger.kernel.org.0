Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48D9A14F230
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgAaSa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:30:27 -0500
Received: from correo.us.es ([193.147.175.20]:51824 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726264AbgAaSa0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 13:30:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F11F3FB36B
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 19:30:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E41AFDA701
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 19:30:25 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C8A25DA714; Fri, 31 Jan 2020 19:30:25 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DE2E6DA709;
        Fri, 31 Jan 2020 19:30:23 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 Jan 2020 19:30:23 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id BCC3F42EFB80;
        Fri, 31 Jan 2020 19:30:23 +0100 (CET)
Date:   Fri, 31 Jan 2020 19:30:22 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Joe Perches <joe@perches.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] netfilter: Use kvcalloc
Message-ID: <20200131183022.55dz3tm32okzva3w@salvia>
References: <5a01f309d91c35fa10b8faa60f4b84a8cb7d13b0.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a01f309d91c35fa10b8faa60f4b84a8cb7d13b0.camel@perches.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 28, 2020 at 11:07:27AM -0800, Joe Perches wrote:
> Convert the uses of kvmalloc_array with __GFP_ZERO to
> the equivalent kvcalloc.

Applied, thanks.
