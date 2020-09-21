Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4872729B1
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 17:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgIUPPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 11:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbgIUPPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 11:15:03 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B431C061755;
        Mon, 21 Sep 2020 08:15:03 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKNWq-003C4C-8W; Mon, 21 Sep 2020 15:14:56 +0000
Date:   Mon, 21 Sep 2020 16:14:56 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        David Laight <David.Laight@aculab.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 05/11] iov_iter: merge the compat case into
 rw_copy_check_uvector
Message-ID: <20200921151456.GV3421308@ZenIV.linux.org.uk>
References: <20200921143434.707844-1-hch@lst.de>
 <20200921143434.707844-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921143434.707844-6-hch@lst.de>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 04:34:28PM +0200, Christoph Hellwig wrote:
> +static int compat_copy_iovecs_from_user(struct iovec *iov,
> +		const struct iovec __user *uvector, unsigned long nr_segs)
> +{
> +	const struct compat_iovec __user *uiov =
> +		(const struct compat_iovec __user *)uvector;
> +	unsigned long i;
	         ^^^^
Huh?
