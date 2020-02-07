Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8375155A2A
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 15:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgBGO47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 09:56:59 -0500
Received: from correo.us.es ([193.147.175.20]:51658 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726901AbgBGO47 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Feb 2020 09:56:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 10244C1063
        for <netdev@vger.kernel.org>; Fri,  7 Feb 2020 15:56:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 02858DA712
        for <netdev@vger.kernel.org>; Fri,  7 Feb 2020 15:56:59 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EC013DA703; Fri,  7 Feb 2020 15:56:58 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2C7B5DA707;
        Fri,  7 Feb 2020 15:56:57 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 07 Feb 2020 15:56:57 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [84.78.24.221])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D888142EFB80;
        Fri,  7 Feb 2020 15:56:56 +0100 (CET)
Date:   Fri, 7 Feb 2020 15:56:53 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org,
        syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [Patch nf v2 3/3] xt_hashlimit: limit the max size of hashtable
Message-ID: <20200207145653.x2sb3kds6butpf6j@salvia>
References: <20200203043053.19192-1-xiyou.wangcong@gmail.com>
 <20200203043053.19192-4-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203043053.19192-4-xiyou.wangcong@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 02, 2020 at 08:30:53PM -0800, Cong Wang wrote:
> The user-specified hashtable size is unbound, this could
> easily lead to an OOM or a hung task as we hold the global
> mutex while allocating and initializing the new hashtable.
> 
> Add a max value to cap both cfg->size and cfg->max, as
> suggested by Florian.

Also applied, thanks.
