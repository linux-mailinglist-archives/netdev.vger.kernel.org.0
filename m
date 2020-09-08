Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1999260F10
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbgIHJ4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:56:24 -0400
Received: from correo.us.es ([193.147.175.20]:52732 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728798AbgIHJ4W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 05:56:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E238BF2582
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 11:56:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CB557DA796
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 11:56:18 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B78B2DA730; Tue,  8 Sep 2020 11:56:18 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E1D3DA7B6;
        Tue,  8 Sep 2020 11:56:16 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 08 Sep 2020 11:56:16 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7D0A64301DE0;
        Tue,  8 Sep 2020 11:56:16 +0200 (CEST)
Date:   Tue, 8 Sep 2020 11:56:16 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Martin Willi <martin@strongswan.org>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Romain Bellan <romain.bellan@wifirst.fr>
Subject: Re: [PATCH nf] netfilter: ctnetlink: fix mark based dump filtering
 regression
Message-ID: <20200908095616.GA3446@salvia>
References: <20200901065619.4484-1-martin@strongswan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200901065619.4484-1-martin@strongswan.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 01, 2020 at 08:56:19AM +0200, Martin Willi wrote:
> conntrack mark based dump filtering may falsely skip entries if a mask
> is given: If the mask-based check does not filter out the entry, the
> else-if check is always true and compares the mark without considering
> the mask. The if/else-if logic seems wrong.
> 
> Given that the mask during filter setup is implicitly set to 0xffffffff
> if not specified explicitly, the mark filtering flags seem to just
> complicate things. Restore the previously used approach by always
> matching against a zero mask is no filter mark is given.

Applied, thanks.
