Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E946C28EF5A
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 11:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730701AbgJOJ0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 05:26:50 -0400
Received: from correo.us.es ([193.147.175.20]:40850 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727753AbgJOJ0u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 05:26:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8949BC0B3E
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 11:26:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7BB53DA7B9
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 11:26:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7115CDA78C; Thu, 15 Oct 2020 11:26:46 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 574A2DA78C;
        Thu, 15 Oct 2020 11:26:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 15 Oct 2020 11:26:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 26D5F42EF42C;
        Thu, 15 Oct 2020 11:26:44 +0200 (CEST)
Date:   Thu, 15 Oct 2020 11:26:43 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Florian Westphal <fw@strlen.de>, fabf@skynet.be,
        Shuah Khan <shuah@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: Re: selftests: netfilter: nft_nat.sh: /dev/stdin:2:9-15: Error:
 syntax error, unexpected counter
Message-ID: <20201015092643.GB3468@salvia>
References: <CA+G9fYv=zPRGCKyhi9DeUsvyb6ZLVVXdV3hW+15XnQN2R3ircQ@mail.gmail.com>
 <20201014193034.GA14337@salvia>
 <CA+G9fYsnPH4nQWoY0bpdw+DS5sqO4xcxDXuu-tfEHxXEGrMyUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+G9fYsnPH4nQWoY0bpdw+DS5sqO4xcxDXuu-tfEHxXEGrMyUA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 08:31:52AM +0530, Naresh Kamboju wrote:
> On Thu, 15 Oct 2020 at 01:00, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > On Wed, Oct 14, 2020 at 05:19:33PM +0530, Naresh Kamboju wrote:
> > > While running kselftest netfilter test on x86_64 devices linux next
> > > tag 20201013 kernel
> > > these errors are noticed. This not specific to kernel version we have
> > > noticed these errors
> > > earlier also.
> > >
> > > Am I missing configs ?
> >
> > What nftables version are you using?
> 
> nft --version
> nftables v0.7 (Scrooge McDuck)

That's very very old.

Latest is 0.9.6, please run latest in your CI testbed.
