Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 439E614F22B
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgAaS3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:29:24 -0500
Received: from correo.us.es ([193.147.175.20]:51468 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgAaS3W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 13:29:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DEA16FB372
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 19:29:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D10F5DA713
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 19:29:21 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B2D96DA705; Fri, 31 Jan 2020 19:29:21 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C0C6DDA705;
        Fri, 31 Jan 2020 19:29:19 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 Jan 2020 19:29:19 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A4DAF42EFB80;
        Fri, 31 Jan 2020 19:29:19 +0100 (CET)
Date:   Fri, 31 Jan 2020 19:29:18 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_flowtable: fix documentation
Message-ID: <20200131182918.zfndm623af6bhxog@salvia>
References: <20200130191019.19440-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130191019.19440-1-mcroce@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 30, 2020 at 08:10:19PM +0100, Matteo Croce wrote:
> In the flowtable documentation there is a missing semicolon, the command
> as is would give this error:
> 
>     nftables.conf:5:27-33: Error: syntax error, unexpected devices, expecting newline or semicolon
>                     hook ingress priority 0 devices = { br0, pppoe-data };
>                                             ^^^^^^^
>     nftables.conf:4:12-13: Error: invalid hook (null)
>             flowtable ft {
>                       ^^

Applied, thanks.
