Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C97917A67F
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 14:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgCENh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 08:37:27 -0500
Received: from correo.us.es ([193.147.175.20]:38388 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbgCENh1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 08:37:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D3BE820A536
        for <netdev@vger.kernel.org>; Thu,  5 Mar 2020 14:37:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C761DDA3A9
        for <netdev@vger.kernel.org>; Thu,  5 Mar 2020 14:37:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BB337DA3C2; Thu,  5 Mar 2020 14:37:09 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CA117DA38D;
        Thu,  5 Mar 2020 14:37:07 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 05 Mar 2020 14:37:07 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id AB31C42EF4E0;
        Thu,  5 Mar 2020 14:37:07 +0100 (CET)
Date:   Thu, 5 Mar 2020 14:37:22 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        netdev@vger.kernel.org,
        syzbot+a2ff6fa45162a5ed4dd3@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nf_tables: free flowtable hooks on hook
 register error
Message-ID: <20200305133722.ddjx7nefs6wbzhej@salvia>
References: <20200302205850.29365-1-fw@strlen.de>
 <20200305120931.poeox6r3rapcbujb@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305120931.poeox6r3rapcbujb@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 05, 2020 at 01:10:12PM +0100, Pablo Neira Ayuso wrote:
> On Mon, Mar 02, 2020 at 09:58:50PM +0100, Florian Westphal wrote:
> > If hook registration fails, the hooks allocated via nft_netdev_hook_alloc
> > need to be freed.
> > 
> > We can't change the goto label to 'goto 5' -- while it does fix the memleak
> > it does cause a warning splat from the netfilter core (the hooks were not
> > registered).
> 
> It seems test/shell crashes after this, looking. It works after
> reverting.

Actually, no problem problem is not related to this patch. Sorry for
the noise.
