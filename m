Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899AF1D5548
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 17:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgEOP5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 11:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726283AbgEOP5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 11:57:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC002C061A0C;
        Fri, 15 May 2020 08:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vg97Zc+yBbH72pdkZwDBNGODCPrdrEdYXXBAaIV2Oiw=; b=bzUzwrUjBws0tIpnnw6gyN9V0/
        DEHrV9rVluyQUK+FkkQ1eobbrpCgDX5J1ZpBZlnmP/MjvMAlP952p1uy/0WAvi0Md/Hfiw3Ls4zih
        WXY29L9IuNuFXLm1+of43Qf/L+4asIjGHEWNGUXw9ez8PnkiC7FOy9huhUcn0GCg/yrl0gOON5YFU
        QqMg4LZ1RUNsWnTsSrkQgsKr5vKbLOqDS8YkkJ0O1BTSqd8RB5uK8jM7DtbTSsrmlMVLr8EGdpbRc
        Z6H+F7nNTNM/Ng9QVTpmfc+4lxFZxc4lLU2pDnH5voOjqtDjqjozbkFFhHNjAJ2s0ocUy7a2ljjOj
        g+gi0BIw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jZciI-0006zr-4p; Fri, 15 May 2020 15:57:30 +0000
Date:   Fri, 15 May 2020 08:57:30 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Nate Karstens <nate.karstens@garmin.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
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
Message-ID: <20200515155730.GF16070@bombadil.infradead.org>
References: <20200515152321.9280-1-nate.karstens@garmin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515152321.9280-1-nate.karstens@garmin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 10:23:17AM -0500, Nate Karstens wrote:
> Series of 4 patches to implement close-on-fork. Tests have been
> published to https://github.com/nkarstens/ltp/tree/close-on-fork
> and cover close-on-fork functionality in the following syscalls:

[...]

> This functionality was approved by the Austin Common Standards
> Revision Group for inclusion in the next revision of the POSIX
> standard (see issue 1318 in the Austin Group Defect Tracker).

NAK to this patch series, and the entire concept.

Is there a way to persuade POSIX that they made a bad decision by
standardising this mess?
