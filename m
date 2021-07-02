Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535C23B9BFB
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 07:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhGBFXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 01:23:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229676AbhGBFXp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 01:23:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B255161413;
        Fri,  2 Jul 2021 05:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625203274;
        bh=MZB0X1r1XyALXMFLtBsI7mSBtgi4CfjWNQcn0tJA3VM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jj4KBAIL1Oi54PBja2kOXAwb9j5cV5Q+vaL5nsuuH1CtgW9MXRjy3tKvUtCJRv2UE
         WkB0KDodwld81PdrJbPY048JvOX0WdDBzXoSx1x6uoxKky//c99H6CvwTAC8NzvLUR
         8E6LVY38bquTdh+zwDvJEu53hGRq4jBWrEmGcOZE=
Date:   Fri, 2 Jul 2021 07:21:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     tj@kernel.org, shuah@kernel.org, akpm@linux-foundation.org,
        rafael@kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, andriin@fb.com, daniel@iogearbox.net,
        atenart@kernel.org, alobakin@pm.me, weiwan@google.com,
        ap420073@gmail.com, jeyu@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, minchan@kernel.org,
        axboe@kernel.dk, mbenes@suse.com, jpoimboe@redhat.com,
        tglx@linutronix.de, keescook@chromium.org, jikos@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] selftests: add tests_sysfs module
Message-ID: <YN6iSKCetBrk2y8V@kroah.com>
References: <20210702050543.2693141-1-mcgrof@kernel.org>
 <20210702050543.2693141-2-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702050543.2693141-2-mcgrof@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 01, 2021 at 10:05:40PM -0700, Luis Chamberlain wrote:
> @@ -0,0 +1,953 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * sysfs test driver
> + *
> + * Copyright (C) 2021 Luis Chamberlain <mcgrof@kernel.org>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2 of the License, or at your option any
> + * later version; or, when distributed separately from the Linux kernel or
> + * when incorporated into other software packages, subject to the following
> + * license:

This boilerplate should not be here, only the spdx line is needed.

> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of copyleft-next (version 0.3.1 or later) as published
> + * at http://copyleft-next.org/.

Please no, this is a totally different license :(

