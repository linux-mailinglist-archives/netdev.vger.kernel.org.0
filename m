Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0377217906E
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 13:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388011AbgCDMbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 07:31:35 -0500
Received: from correo.us.es ([193.147.175.20]:54342 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387978AbgCDMbf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 07:31:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9746EE34C5
        for <netdev@vger.kernel.org>; Wed,  4 Mar 2020 13:31:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 87996DA3A0
        for <netdev@vger.kernel.org>; Wed,  4 Mar 2020 13:31:18 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7CCE3DA72F; Wed,  4 Mar 2020 13:31:18 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 97027FB378;
        Wed,  4 Mar 2020 13:31:16 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Mar 2020 13:31:16 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 706DD42EF52A;
        Wed,  4 Mar 2020 13:31:16 +0100 (CET)
Date:   Wed, 4 Mar 2020 13:31:30 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Martin Mares <mj@ucw.cz>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next,RFC 0/5] Netfilter egress hook
Message-ID: <20200304123130.yyb3miizk6yez4od@salvia>
References: <cover.1572528496.git.lukas@wunner.de>
 <20191107225149.5t4sg35b5gwuwawa@salvia>
 <20200304095032.s6ypvmo45d75wkr7@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304095032.s6ypvmo45d75wkr7@wunner.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 10:50:32AM +0100, Lukas Wunner wrote:
[...]
> So what's the consensus?  Shall I post a non-RFC version, rebased on
> current nf-next/master?

Please, move on and rebase on top of nf-next/master.

Thank you.
