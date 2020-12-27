Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C210C2E30BA
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 11:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgL0Kxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 05:53:49 -0500
Received: from correo.us.es ([193.147.175.20]:34380 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726075AbgL0Kxt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Dec 2020 05:53:49 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3E413E34C3
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 11:52:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2F083DA78D
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 11:52:40 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 246E4DA789; Sun, 27 Dec 2020 11:52:40 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0BE2BDA72F;
        Sun, 27 Dec 2020 11:52:38 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 27 Dec 2020 11:52:38 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D8A06426CC84;
        Sun, 27 Dec 2020 11:52:37 +0100 (CET)
Date:   Sun, 27 Dec 2020 11:53:05 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        torvalds@linux-foundation.org, syzkaller-bugs@googlegroups.com,
        syzbot+e86f7c428c8c50db65b4@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: xt_RATEEST: reject non-null terminated
 string from userspace
Message-ID: <20201227105305.GA3870@salvia>
References: <000000000000fcbe0705b70e9bd9@google.com>
 <20201222222356.22645-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201222222356.22645-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 11:23:56PM +0100, Florian Westphal wrote:
> syzbot reports:
> detected buffer overflow in strlen
> [..]
> Call Trace:
>  strlen include/linux/string.h:325 [inline]
>  strlcpy include/linux/string.h:348 [inline]
>  xt_rateest_tg_checkentry+0x2a5/0x6b0 net/netfilter/xt_RATEEST.c:143
> 
> strlcpy assumes src is a c-string. Check info->name before its used.

Applied, thanks Florian.
