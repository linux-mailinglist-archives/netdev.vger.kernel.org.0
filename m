Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915853D2F8D
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 00:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbhGVVbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 17:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbhGVVbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 17:31:02 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D7DC061757
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 15:11:36 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d17so859230plh.10
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 15:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aMIZjsYISiszbVqhO4K3RhbKJ7SsS4bFdaK7AFj0VYc=;
        b=Tg0mtGKX5zqe89qEhdt9aswj+FEvdET9JmkvnZZPrBiSqSVSNgJ0aex4rzqyXrT0e8
         P9KPnQdDvAVH85uQkpyHuNYRW5QT6+s2hN2jIJU8EsKReMjzunblRygDA6P/f28g5rgl
         69hXeTOaLl9ayrMSzQ4aZ8nVzoyQXmT72Vqzt+5efzig0G1XYCnupWBoc50gFa+rohkf
         jB7QYPa/j6nJ2nV5Dol58PK8xPdA37bR33zf4LdJK41lN9dnMLCl1t13n7enSitaxHEH
         4oyrthvmd6jFH1vr29m6hEU7/SwFqLAnZBkIQThD8f3nzHLrjpPkF9G/HKwvOaCRBDY3
         PnCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aMIZjsYISiszbVqhO4K3RhbKJ7SsS4bFdaK7AFj0VYc=;
        b=MaYmyQqrxNjA6TCeSox0HpgQEJA0ZMl+ZEH1yZX5sHFNvVN8Jz5OExiw0qfvGIKEho
         5RP3z5fHEsy6Dyyp8/tdJU0bnS3f3hSi3lolV9nv+dB7J7L8tFliYdF8iLgawl32KWQ5
         1LbJeYqlCabavk3d6Wm/En2SvjoohdlLQTRWAr/74YSOyr4ZgQtCcJ/PIuCWfFdP/Psm
         YGTnlmeY8SiGbh9N6WGzWF8Ad8v4QqZVA9TYhmsO04wiDOtyO/UkwL6N3s4k/6sqASx9
         pjwVJ7qUB2byiubnMquH1Gr/bWtyLey1QARq26jOSIWghxAmUPzG+2F1wkCj65QV9MTv
         TjOw==
X-Gm-Message-State: AOAM5326AALJjK/Hg7SemFpyeVke4c7Rt0oAR8TteR4R/cfzi7gbplrx
        J3oxEMEKaUl30rpQElrmUNeZDA==
X-Google-Smtp-Source: ABdhPJz7kixwxzcsBzngPv2vBX8CYQK337RlCZsgHsR6bi4uGWSk6p7naWIzwdelpcngF6+IJN732Q==
X-Received: by 2002:a17:90a:f18f:: with SMTP id bv15mr10628501pjb.63.1626991896089;
        Thu, 22 Jul 2021 15:11:36 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id a35sm20839654pgm.66.2021.07.22.15.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 15:11:35 -0700 (PDT)
Date:   Thu, 22 Jul 2021 15:11:32 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Ilya Dmitrichenko <errordeveloper@gmail.com>
Cc:     netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH iproute2] ip/tunnel: always print all known attributes
Message-ID: <20210722151132.4384026a@hermes.local>
In-Reply-To: <20210716153557.10192-1-errordeveloper@gmail.com>
References: <20210716153557.10192-1-errordeveloper@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Jul 2021 16:35:57 +0100
Ilya Dmitrichenko <errordeveloper@gmail.com> wrote:

> Presently, if a Geneve or VXLAN interface was created with 'external',
> it's not possible for a user to determine e.g. the value of 'dstport'
> after creation. This change fixes that by avoiding early returns.
> 
> This change partly reverts 00ff4b8e31af ("ip/tunnel: Be consistent when
> printing tunnel collect metadata").
> 
> Signed-off-by: Ilya Dmitrichenko <errordeveloper@gmail.com>

The patch looks fine, but it doesn't patch checkpatch.
Please fix your editor settings to do whitespace properly.

~/git/iproute2 $ ~/Src/kernel/linux/scripts/checkpatch.pl ~/Downloads/iproute2-ip-tunnel-always-print-all-known-attributes.patch 
ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit 00ff4b8e31af ("ip/tunnel: Be consistent when printing tunnel collect metadata")'
#88: 
This change partly reverts 00ff4b8e31af ("ip/tunnel: Be consistent when

ERROR: code indent should use tabs where possible
#129: FILE: ip/iplink_geneve.c:259:
+        }$

WARNING: please, no spaces at the start of a line
#129: FILE: ip/iplink_geneve.c:259:
+        }$

ERROR: code indent should use tabs where possible
#161: FILE: ip/iplink_vxlan.c:426:
+        }$

WARNING: please, no spaces at the start of a line
#161: FILE: ip/iplink_vxlan.c:426:
+        }$

total: 3 errors, 2 warnings, 80 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
