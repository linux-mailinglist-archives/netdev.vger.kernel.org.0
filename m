Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15B2255EDB
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 18:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbgH1QhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 12:37:04 -0400
Received: from correo.us.es ([193.147.175.20]:45642 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726524AbgH1QhD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 12:37:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3FAB918D002
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 18:37:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2B286DA78E
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 18:37:02 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1FF81DA72F; Fri, 28 Aug 2020 18:37:02 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 11F21DA73D;
        Fri, 28 Aug 2020 18:37:00 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 28 Aug 2020 18:37:00 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D5D8242EF4E3;
        Fri, 28 Aug 2020 18:36:59 +0200 (CEST)
Date:   Fri, 28 Aug 2020 18:36:59 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fabian Frederick <fabf@skynet.be>
Cc:     kadlec@netfilter.org, fw@strlen.de, sbrivio@redhat.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V2 1/5 nf] selftests: netfilter: fix header example
Message-ID: <20200828163659.GA28045@salvia>
References: <20200823181537.13254-1-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200823181537.13254-1-fabf@skynet.be>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 23, 2020 at 08:15:37PM +0200, Fabian Frederick wrote:
> nft_flowtable.sh is made for bash not sh.
> Also give values which not return "RTNETLINK answers: Invalid
> argument"

Series from 1 to 5 is applied.
