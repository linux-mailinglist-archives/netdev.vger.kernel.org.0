Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A69513837B
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 06:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbfFGE2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 00:28:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47514 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbfFGE2Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 00:28:16 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ECD05883BA;
        Fri,  7 Jun 2019 04:28:15 +0000 (UTC)
Received: from oldenburg2.str.redhat.com (ovpn-116-59.ams2.redhat.com [10.36.116.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7AE6280DB3;
        Fri,  7 Jun 2019 04:28:11 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     Joseph Myers <joseph@codesourcery.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, <linux-api@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <netdev@vger.kernel.org>,
        Laura Abbott <labbott@redhat.com>,
        Paul Burton <pburton@wavecomp.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org
Subject: Re: [PATCH] uapi: avoid namespace conflict in linux/posix_types.h
References: <20190319165123.3967889-1-arnd@arndb.de>
        <alpine.DEB.2.21.1905072249570.19308@digraph.polyomino.org.uk>
Date:   Fri, 07 Jun 2019 06:28:09 +0200
In-Reply-To: <alpine.DEB.2.21.1905072249570.19308@digraph.polyomino.org.uk>
        (Joseph Myers's message of "Tue, 7 May 2019 22:50:49 +0000")
Message-ID: <87tvd2j9ye.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Fri, 07 Jun 2019 04:28:16 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Joseph Myers:

> What happened with this patch (posted 19 March)?  I found today that we 
> can't use Linux 5.1 headers in glibc testing because the namespace issues 
> are still present in the headers as of the release.

This regression fix still hasn't been merged into Linus' tree.  What is
going on here?

This might seem rather minor, but the namespace testing is actually
relevant in practice.  It prevents accidental clashes with C/C++
identifiers in user code.

If this fairly central UAPI header is not made namespace-clean again,
then we need to duplicate information from more UAPI headers in glibc,
and I don't think that's something we'd want to do.

Thanks,
Florian
