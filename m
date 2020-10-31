Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9E02A19A7
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 19:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbgJaSeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 14:34:02 -0400
Received: from correo.us.es ([193.147.175.20]:51154 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727967AbgJaSeC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 14:34:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4C5F46EF2D
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 19:34:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3B4D0DA78E
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 19:34:01 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3056DDA730; Sat, 31 Oct 2020 19:34:01 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 24D32DA73F;
        Sat, 31 Oct 2020 19:33:59 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 31 Oct 2020 19:33:59 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 06CAE42EF42A;
        Sat, 31 Oct 2020 19:33:58 +0100 (CET)
Date:   Sat, 31 Oct 2020 19:33:58 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net-next] net: netfilter: Add __printf() attribute
Message-ID: <20201031183358.GA13467@salvia>
References: <20201031182144.1081847-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201031182144.1081847-1-andrew@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 31, 2020 at 07:21:44PM +0100, Andrew Lunn wrote:
> nft_request_module calls vsnprintf() using parameters passed to it.
> Make the function with __printf() attribute so the compiler can check
> the format and arguments.

Applied, thanks.
