Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4649A34DE7
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 18:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbfFDQph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 12:45:37 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44992 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727470AbfFDQph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 12:45:37 -0400
Received: by mail-pg1-f194.google.com with SMTP id n2so10675228pgp.11
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 09:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CUZhA4yAj4TLDGFIadVZVNw3lmcRT2Ciiub/8XGf6UQ=;
        b=oIzffG4FRd2E07zWXuVyehtbhbDoB+7QzEff15NUP0zIvpyFr106L4qTXAn0uL0T2E
         jh2zQV63XBObSxnKZepl7hQvImSODjYFI35PKBS/rU+y4v7Bx9MO53vzkapoxZUGn565
         e0hsde1IV23UQesw+imkPCQ7Mbl2lFDDJPF3UzuxQ0i6lmghRvt+K+PwoAmLtQFkOWx7
         OwjgFblVnc2KvYilLHRFbI4Haw0F/mRtEs8DtVjFLMGB/6TNu/38z/ymMxmjtOjliBx2
         xMgh09f5JYafjOg9UAK55gxvmFVGeBBqfwIMVXvG64xp20KCgeFh860UxvfhEKX4PbFM
         /qwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CUZhA4yAj4TLDGFIadVZVNw3lmcRT2Ciiub/8XGf6UQ=;
        b=Y3ZPrTqOMXiqeBK8tCuXC6+0WiWEz/G/NUkv2TF7EajQ5EgGRo3b0tc4/P3CLNiPqa
         shWlVhvnlKD9c+/Bb6m0KLVf72QUnBtKOGixiHPk7nj3r0gNQgu0XCH4us6FxgRMQPCc
         bEDbZI0Gn9nxVUuNyD8iAglHmcSLRv/Q2qA3NM0KDSVDgTxVkhCvBFafxWH6we0w4RnY
         wNls/G0pRPsF0cwwfJJ68BSOzz6OhWSLy3t7pPWrPZAlqNBGd1pi2UISCXky0dyXnCYJ
         twjQT2KsMJrsPdbHVvz3tmh7ukbA+5vYiaMUKR8jmgVY7QpewNy7QrZskcT/c+BBMjDN
         guKQ==
X-Gm-Message-State: APjAAAV8kJIlDCVZnlJAV6f4wmo1j6mIQDjz8lLarOxn8KQeLGZOUpXu
        dDHrpoxFCR2IN6WCtM5CZGy2JqfGUXY=
X-Google-Smtp-Source: APXvYqxZ9hg5sC91spAS51wbjVoJV586gJ+rXDLcsNkMKxyOzNoaqci5fccP7jvIryKI2slv6XqLQQ==
X-Received: by 2002:a17:90a:628a:: with SMTP id d10mr9758899pjj.7.1559666736350;
        Tue, 04 Jun 2019 09:45:36 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id l20sm18457567pff.102.2019.06.04.09.45.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 09:45:36 -0700 (PDT)
Date:   Tue, 4 Jun 2019 09:45:34 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [PATCH] devlink: fix libc and kernel headers collision
Message-ID: <20190604094534.6974f899@hermes.lan>
In-Reply-To: <602128d22db86bd67e11dec8fe40a73832c222c9.1559230347.git.baruch@tkos.co.il>
References: <602128d22db86bd67e11dec8fe40a73832c222c9.1559230347.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 May 2019 18:32:27 +0300
Baruch Siach <baruch@tkos.co.il> wrote:

> Since commit 2f1242efe9d ("devlink: Add devlink health show command") we
> use the sys/sysinfo.h header for the sysinfo(2) system call. But since
> iproute2 carries a local version of the kernel struct sysinfo, this
> causes a collision with libc that do not rely on kernel defined sysinfo
> like musl libc:
> 
> In file included from devlink.c:25:0:
> .../sysroot/usr/include/sys/sysinfo.h:10:8: error: redefinition of 'struct sysinfo'
>  struct sysinfo {
>         ^~~~~~~
> In file included from ../include/uapi/linux/kernel.h:5:0,
>                  from ../include/uapi/linux/netlink.h:5,
>                  from ../include/uapi/linux/genetlink.h:6,
>                  from devlink.c:21:
> ../include/uapi/linux/sysinfo.h:8:8: note: originally defined here
>  struct sysinfo {
> 		^~~~~~~
> 
> Rely on the kernel header alone to avoid kernel and userspace headers
> collision of definitions.
> 
> Cc: Aya Levin <ayal@mellanox.com>
> Cc: Moshe Shemesh <moshe@mellanox.com>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Ok, applied. Note that musl libc is not officially supported or tested
as part of iproute2. I will take patches to fix build and bugs, but you
are on your own if you must use it.

