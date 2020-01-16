Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 413D213DCD3
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 15:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgAPOAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 09:00:24 -0500
Received: from correo.us.es ([193.147.175.20]:33034 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbgAPOAY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 09:00:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 94C432A2BB9
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 15:00:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 86D69DA781
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 15:00:22 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7A243DA711; Thu, 16 Jan 2020 15:00:22 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 81E07DA707;
        Thu, 16 Jan 2020 15:00:20 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 16 Jan 2020 15:00:20 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5BBB242EF9E1;
        Thu, 16 Jan 2020 15:00:20 +0100 (CET)
Date:   Thu, 16 Jan 2020 15:00:19 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot+76d0b80493ac881ff77b@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nft_tunnel: fix null-attribute check
Message-ID: <20200116140019.zlfrzfotfz2e2rbc@salvia>
References: <000000000000b62bda059c36db7c@google.com>
 <20200116074411.19511-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116074411.19511-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 08:44:11AM +0100, Florian Westphal wrote:
> else we get null deref when one of the attributes is missing, both
> must be non-null.

Also applied, thanks.
