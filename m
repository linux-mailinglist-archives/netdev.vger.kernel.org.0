Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F72D19EDEC
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 22:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbgDEU1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 16:27:21 -0400
Received: from correo.us.es ([193.147.175.20]:42496 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727612AbgDEU1V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Apr 2020 16:27:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DDE436D4EF
        for <netdev@vger.kernel.org>; Sun,  5 Apr 2020 22:27:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D03F8100A53
        for <netdev@vger.kernel.org>; Sun,  5 Apr 2020 22:27:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C5241100A48; Sun,  5 Apr 2020 22:27:19 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 83BF0100A4B;
        Sun,  5 Apr 2020 22:27:17 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 05 Apr 2020 22:27:17 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6314F426CCB9;
        Sun,  5 Apr 2020 22:27:17 +0200 (CEST)
Date:   Sun, 5 Apr 2020 22:27:17 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Manoj Basapathi <manojbm@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] netfilter: IDLETIMER target v1 - match Android layout
Message-ID: <20200405202717.3ikqp7osddi5zkzu@salvia>
References: <20200331163559.132240-1-zenczykowski@gmail.com>
 <20200405200522.5pcxitjcnxss4e7r@salvia>
 <CANP3RGczLdp831hQvxAPp_RPdf=A75zKoEEkFE+QGcw0sPy62w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANP3RGczLdp831hQvxAPp_RPdf=A75zKoEEkFE+QGcw0sPy62w@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 05, 2020 at 01:14:39PM -0700, Maciej Żenczykowski wrote:
> > Hi Maciej,
> >
> > I'm attaching a new version, including EOPNOTSUPP if the send_nl_msg
> > field is set, it's the most basic handling I can think of until this
> > option becomes useful.
> >
> > Would you commit to send a patch for this new merge window to make it
> > useful?
> 
> Yes, I can do that.

Thank you.

Patch is applied to nf.git
