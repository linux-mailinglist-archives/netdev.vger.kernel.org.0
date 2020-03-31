Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB30819A276
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 01:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731407AbgCaX2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 19:28:30 -0400
Received: from correo.us.es ([193.147.175.20]:36962 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731331AbgCaX23 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Mar 2020 19:28:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AE84811EB88
        for <netdev@vger.kernel.org>; Wed,  1 Apr 2020 01:28:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E98C100A44
        for <netdev@vger.kernel.org>; Wed,  1 Apr 2020 01:28:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 91867DA736; Wed,  1 Apr 2020 01:28:27 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 567A5100A44;
        Wed,  1 Apr 2020 01:28:25 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 01 Apr 2020 01:28:25 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3775E4301DE1;
        Wed,  1 Apr 2020 01:28:25 +0200 (CEST)
Date:   Wed, 1 Apr 2020 01:28:24 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Jan Engelhardt <jengelh@inai.de>, Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Manoj Basapathi <manojbm@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: [PATCH] netfilter: IDLETIMER target v1 - match Android layout
Message-ID: <20200331232824.ici562aee6zr3w23@salvia>
References: <20200331163559.132240-1-zenczykowski@gmail.com>
 <nycvar.YFH.7.76.2003312012340.6572@n3.vanv.qr>
 <20200331181641.anvsbczqh6ymyrrl@salvia>
 <CAHo-Ooy-5CxfWhHuhWHO5M_wm8mO_ZMZT81qNSSNTyN5OAoJww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHo-Ooy-5CxfWhHuhWHO5M_wm8mO_ZMZT81qNSSNTyN5OAoJww@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 31, 2020 at 02:21:00PM -0700, Maciej Żenczykowski wrote:
> Right, this is not in 5.6 as it's only in net-next atm as it was only
> merged very recently.
> I mentioned this in the commit message.
> 
> I'm not sure what you mean by code that uses this.
> You can checkout aosp source and look there...
> There's the kernel code (that's effectively already linked from the
> commit message), and the iptables userspace changes (
> https://android.googlesource.com/platform/external/iptables/+/refs/heads/master/extensions/libxt_IDLETIMER.c#39

OK, so this is field ised set in userspace.

> ), and the netd C++/Java layer that uses iptables -j IDLETIMER
> --send_nl_msg 1 (
> https://android.googlesource.com/platform/system/netd/+/refs/heads/master/server/IdletimerController.cpp#151
> ) and the resulting notifications parsing (can't easily find it atm).
> 
> If you mean by code that uses this patch... that's impossible as this
> patch doesn't implement a usable feature.
> It just moves the offset.
> 
> Could you clarify what you're asking for?

Maybe I'm misunderstanding. How is this field used in aosp?

I mean, if --send_nl_msg 1 is passed, how does the existing behaviour
changes?
