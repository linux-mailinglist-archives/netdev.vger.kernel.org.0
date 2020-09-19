Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9CC527115C
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 01:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgISXYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 19:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbgISXYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 19:24:20 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFFE7C0613CE;
        Sat, 19 Sep 2020 16:24:19 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJmDD-0020kM-6N; Sat, 19 Sep 2020 23:24:11 +0000
Date:   Sun, 20 Sep 2020 00:24:11 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
Message-ID: <20200919232411.GK3421308@ZenIV.linux.org.uk>
References: <20200919224122.GJ3421308@ZenIV.linux.org.uk>
 <36CF3DE7-7B4B-41FD-9818-FDF8A5B440FB@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <36CF3DE7-7B4B-41FD-9818-FDF8A5B440FB@amacapital.net>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 03:53:40PM -0700, Andy Lutomirski wrote:

> > It would not be a win - most of the syscalls don't give a damn
> > about 32bit vs. 64bit...
> 
> Any reasonable implementation would optimize it out for syscalls that don’t care.  Or it could be explicit:
> 
> DEFINE_MULTIARCH_SYSCALL(...)

1) what would that look like?
2) have you counted the syscalls that do and do not need that?
3) how many of those realistically *can* be unified with their
compat counterparts?  [hint: ioctl(2) cannot]
