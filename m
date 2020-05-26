Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9030A1BCFFB
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 00:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgD1WaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 18:30:11 -0400
Received: from correo.us.es ([193.147.175.20]:60544 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbgD1WaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 18:30:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F045E11EB3C
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 00:30:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E1F9CBAAAF
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 00:30:08 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D7499BAC2F; Wed, 29 Apr 2020 00:30:08 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EE64CBAAAF;
        Wed, 29 Apr 2020 00:30:06 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 Apr 2020 00:30:06 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D134142EF4E1;
        Wed, 29 Apr 2020 00:30:06 +0200 (CEST)
Date:   Wed, 29 Apr 2020 00:30:06 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] iptables: flush stdout after every verbose log.
Message-ID: <20200428223006.GA30304@salvia>
References: <20200421081542.108296-1-zenczykowski@gmail.com>
 <20200428000525.GD24002@salvia>
 <CAHo-OoxP6ZrvbXFH_tC9_wdVDg7y=8bzVY9oKZTieZL_mqS1NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHo-OoxP6ZrvbXFH_tC9_wdVDg7y=8bzVY9oKZTieZL_mqS1NQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 05:14:24PM -0700, Maciej Żenczykowski wrote:
> > Could you check if this slows down iptables-restore?
> 
> per the iptables-restore man page
>        -v, --verbose
>               Print additional debug info during ruleset processing.
> 
> Well, if you run it with verbose mode enabled you probably don't care
> about performance all that much...

Thanks for explaining.

How long has this been broken? I mean, netd has been there for quite a
while interacting with iptables. However, the existing behaviour was
not a problem? Or a recent bug?
