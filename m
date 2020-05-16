Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBF51D6153
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 15:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgEPN3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 09:29:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34046 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgEPN3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 09:29:51 -0400
Received: from ip5f5af183.dynamic.kabel-deutschland.de ([95.90.241.131] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jZwsS-0004mh-36; Sat, 16 May 2020 13:29:20 +0000
Date:   Sat, 16 May 2020 15:29:18 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Nate Karstens <nate.karstens@garmin.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Laight <David.Laight@aculab.com>,
        linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-parisc@vger.kernel.org,
        sparclinux@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>,
        a.josey@opengroup.org
Subject: Re: [PATCH v2] Implement close-on-fork
Message-ID: <20200516132918.edq7p2tyh6elorjm@wittgenstein>
References: <20200515152321.9280-1-nate.karstens@garmin.com>
 <20200515155730.GF16070@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200515155730.GF16070@bombadil.infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 08:57:30AM -0700, Matthew Wilcox wrote:
> On Fri, May 15, 2020 at 10:23:17AM -0500, Nate Karstens wrote:
> > Series of 4 patches to implement close-on-fork. Tests have been
> > published to https://github.com/nkarstens/ltp/tree/close-on-fork
> > and cover close-on-fork functionality in the following syscalls:
> 
> [...]
> 
> > This functionality was approved by the Austin Common Standards
> > Revision Group for inclusion in the next revision of the POSIX
> > standard (see issue 1318 in the Austin Group Defect Tracker).
> 
> NAK to this patch series, and the entire concept.

Yeah.
But also, stuff like this should really be on linux-api.

Christian
