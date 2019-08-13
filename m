Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10A498B4AD
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 11:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbfHMJzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 05:55:35 -0400
Received: from correo.us.es ([193.147.175.20]:34454 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728322AbfHMJzf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 05:55:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DA4EBFC5E0
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 11:55:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CAEC8DA7B9
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 11:55:32 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C08EEDA730; Tue, 13 Aug 2019 11:55:32 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C1C29D190F;
        Tue, 13 Aug 2019 11:55:30 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Aug 2019 11:55:30 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.218.116])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 95C3D4265A2F;
        Tue, 13 Aug 2019 11:55:30 +0200 (CEST)
Date:   Tue, 13 Aug 2019 11:55:29 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Net Dev <netdev@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH net-next v1 0/8] netfilter: header compilation fixes
Message-ID: <20190813095529.aisgjjwl6rzt5xeh@salvia>
References: <20190722201615.GE23346@azazel.net>
 <20190807141705.4864-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807141705.4864-1-jeremy@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 07, 2019 at 03:16:57PM +0100, Jeremy Sowden wrote:
> A number of netfilter header files are on the header-test blacklist
> becuse they cannot be compiled stand-alone.   There are two main reasons
> for this: missing inclusions of other headers, and missing conditionals
> checking for CONFIG_* symbols.
> 
> The first six of these patches rectify these omissions, the seventh
> removes some unnecessary "#ifdef __KERNEL__" checks, and the last
> removes all the NF headers from the blacklist.
> 
> I've cc'ed Masahiro Yamada because the last patch removes 74 lines from
> include/Kbuild and may conflict with his kbuild tree.

Series applied, one comment below.

> Jeremy Sowden (8):
>   netfilter: inlined four headers files into another one.
>   netfilter: added missing includes to a number of header-files.
>   netfilter: added missing IS_ENABLED(CONFIG_BRIDGE_NETFILTER) checks to
>     header-file.
>   netfilter: added missing IS_ENABLED(CONFIG_NF_TABLES) check to
>     header-file.
>   netfilter: added missing IS_ENABLED(CONFIG_NF_CONNTRACK) checks to
>     some header-files.
>   netfilter: added missing IS_ENABLED(CONFIG_NETFILTER) checks to some
>     header-files.
>   netfilter: removed "#ifdef __KERNEL__" guards from some headers.
>   kbuild: removed all netfilter headers from header-test blacklist.

Would you mind if - before pushing this out - I do this string
replacement for the patch subject?

s/added/add
s/removed/remove
s/inlined/inline

I was told present tense is preferred for description. Otherwise, I'll
leave them as is.

Thanks.
