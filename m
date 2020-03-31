Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B39CF199DD8
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 20:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgCaSNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 14:13:24 -0400
Received: from correo.us.es ([193.147.175.20]:58534 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbgCaSNY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Mar 2020 14:13:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9D5571C4381
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 20:13:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8EB53100A5A
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 20:13:22 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 836DF100A52; Tue, 31 Mar 2020 20:13:22 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A073A100A41;
        Tue, 31 Mar 2020 20:13:20 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 31 Mar 2020 20:13:20 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7BBC64301DE0;
        Tue, 31 Mar 2020 20:13:20 +0200 (CEST)
Date:   Tue, 31 Mar 2020 20:13:20 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Manoj Basapathi <manojbm@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: [PATCH] netfilter: IDLETIMER target v1 - match Android layout
Message-ID: <20200331181320.w5rwnpqizg555wpm@salvia>
References: <20200331163559.132240-1-zenczykowski@gmail.com>
 <20200331163904.ilucynm3brvgfezw@salvia>
 <CANP3RGf5Y=-GX=b=jWURaBdDvey0zb-_MkXj6W+TWtRvM4C3sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANP3RGf5Y=-GX=b=jWURaBdDvey0zb-_MkXj6W+TWtRvM4C3sw@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 31, 2020 at 09:41:39AM -0700, Maciej Żenczykowski wrote:
> By client code do you mean code for the iptables userspace binary?

Code that uses this, please.
