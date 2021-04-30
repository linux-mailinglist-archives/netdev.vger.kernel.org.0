Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8308370101
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 21:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhD3TIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 15:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbhD3TH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 15:07:59 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14988C06174A;
        Fri, 30 Apr 2021 12:07:09 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id h15so19482980wre.11;
        Fri, 30 Apr 2021 12:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to;
        bh=aveJ9Y/DaKlYULaGHHEd5Zq7IUOjFmr/T5fZyY4IRnE=;
        b=GCwEItj17qYJY04RQI3ryj2DqPd3AfUlnlJD1csKxfWxQNzI28YtdnsOvzA1q0ztPq
         byeFNEOgeXqAXWN89PiOmy1h2XnFaNpA5uLlWzGM2sfeNVvr6Ky0zNKgXBvaST9ikstG
         3nurseIGkET+d9Ex8X8u2Gc+F4j8xyQ0eNuAX8lqMhGW2HAp3UmdRr6Rk4CIi6iGXYdU
         lw/FSGKxz+z+cbMdLZjC2ff/vpNvgo3poWGqbETQ8Y6MI4Ghj5s8Mu1Iy0FtB+NMJyJZ
         psF35aHvvnFSqJLCwPLJY45h/P3Ph/Qlg41IxRyuSigC9MZnMYAkF8YBh4QmfzC42Fvk
         ikVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=aveJ9Y/DaKlYULaGHHEd5Zq7IUOjFmr/T5fZyY4IRnE=;
        b=YmrhKfJZDk4Pe0T4lC0DFpqCtPgk5kYzsrZNblJiIbb5lflCOUv9FdPLgENBC/s7Qn
         KCqfbwEeNwJIPHxv5MbXcpvTHKIZQcjBI2/Kw5PxWjjFadiO6JCmpVFSxqQfNJEkeiQv
         UgB1hNy2Pe1MdlAkbRFA1AcgborE/bK0ZRmiafwgLPp99SoONfag6KfaSqlo5MFVIbZO
         UQaOoTnNaOlJZqdq68nEFN29pxaNiK/VCAm/f97SwQh6ta+LvEsvkO5gFPNKw+SLOkZ4
         +HCuKCoZ190dpUgE7WWZvekCgZRRn5/QtazknyND5Kg57KN1YKFKPNwWl3wGs2xDFKaF
         mwyg==
X-Gm-Message-State: AOAM530mZrUupMiGZTdRYMEJZP4Tq6YdOjOkUU0tP2Aj7fMjWrTP3nY9
        eYvZwfyAW9TT0Ywq2Iw3FH6QJNHkMOnUFg==
X-Google-Smtp-Source: ABdhPJwkYSPnPbaYqjrdqtN8ivY0o3kYpZTpV6cNF3nK/qBSvUmP3LNrsaL1w+uVonRG27Q9Cokayg==
X-Received: by 2002:adf:ff89:: with SMTP id j9mr8953565wrr.416.1619809627838;
        Fri, 30 Apr 2021 12:07:07 -0700 (PDT)
Received: from pevik ([62.201.25.198])
        by smtp.gmail.com with ESMTPSA id u17sm13487650wmq.30.2021.04.30.12.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 12:07:07 -0700 (PDT)
Date:   Fri, 30 Apr 2021 21:07:05 +0200
From:   Petr Vorel <petr.vorel@gmail.com>
To:     Heiko Thiery <heiko.thiery@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2-next v2] lib/fs: fix issue when
 {name,open}_to_handle_at() is not implemented
Message-ID: <YIxVWXqBkkS6l5lB@pevik>
Reply-To: Petr Vorel <petr.vorel@gmail.com>
References: <20210430062632.21304-1-heiko.thiery@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430062632.21304-1-heiko.thiery@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> +++ b/lib/fs.c
> @@ -30,6 +30,27 @@
>  /* if not already mounted cgroup2 is mounted here for iproute2's use */
>  #define MNT_CGRP2_PATH  "/var/run/cgroup2"

> +
> +#ifndef defined HAVE_HANDLE_AT
This is also wrong, it must be:
#ifndef HAVE_HANDLE_AT

> +struct file_handle {
> +	unsigned handle_bytes;
> +	int handle_type;
> +	unsigned char f_handle[];
> +};
> +
> +int name_to_handle_at(int dirfd, const char *pathname,
> +	struct file_handle *handle, int *mount_id, int flags)
> +{
> +	return syscall(name_to_handle_at, 5, dirfd, pathname, handle,
> +	               mount_id, flags);
Also I overlooked bogus 5 parameter, why is here? Correct is:

	return syscall(__NR_name_to_handle_at, dfd, pathname, handle,
			   mount_id, flags);
> +}
> +
> +int open_by_handle_at(int mount_fd, struct file_handle *handle, int flags)
> +{
> +	return syscall(open_by_handle_at, 3, mount_fd, handle, flags);
And here 3, correct version is is:
	return syscall(__NR_open_by_handle_at, mount_fd, handle, flags);


+ adding at the top:

#ifndef HAVE_HANDLE_AT
# include <sys/syscall.h>
#endif

Kind regards,
Petr
