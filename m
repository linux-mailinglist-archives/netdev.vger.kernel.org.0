Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD08C13DCB7
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgAPN7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 08:59:03 -0500
Received: from correo.us.es ([193.147.175.20]:60734 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726343AbgAPN7D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 08:59:03 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 749692A2BB3
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 14:59:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 661C0DA71F
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 14:59:01 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 657D2DA702; Thu, 16 Jan 2020 14:59:01 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 73FB4DA711;
        Thu, 16 Jan 2020 14:58:59 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 16 Jan 2020 14:58:59 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 548FB42EF9E2;
        Thu, 16 Jan 2020 14:58:59 +0100 (CET)
Date:   Thu, 16 Jan 2020 14:58:58 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        netdev@vger.kernel.org,
        syzbot+0e63ae76d117ae1c3a01@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nf_tables: remove WARN and add NLA_STRING
 upper limits
Message-ID: <20200116135858.jluljsh3bvp7klm3@salvia>
References: <000000000000b9fc96059c36db9e@google.com>
 <20200116080650.4798-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116080650.4798-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 09:06:50AM +0100, Florian Westphal wrote:
> This WARN can trigger because some of the names fed to the module
> autoload function can be of arbitrary length.
> 
> Remove the WARN and add limits for all NLA_STRING attributes.

Applied, thanks.
