Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0A74B515E
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 17:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729439AbfIQPYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 11:24:04 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50482 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbfIQPYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 11:24:04 -0400
Received: by mail-wm1-f68.google.com with SMTP id 5so4003682wmg.0
        for <netdev@vger.kernel.org>; Tue, 17 Sep 2019 08:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3ttIeUXbogMr7Bjx/KkQ0BSyaYtUZQVxCIPzmZCGY4M=;
        b=gDZ/8r7aD+d8/NMwdmp28r5GMw62GvFJYQnhyndweOMJJJW6FwaUIfIk/4l6MTmSRr
         fxEz7JDOjK07KxizZSk9ttgazDaCFWYWAQWvpH9HVqEYrZWmj2y+2f8MVv2CKotY3M8s
         laqP3cCBCzLPWXKrSFcsUJJGx9S60//G3whoHluXZM9YZIoYxWGsHMrrhcUu8bWgwwCy
         pwxBX3NbXtq12WbQZ+pmxXtfMVIiOpXnhK4yuiF7qz017GorEaIjRS7nFGFDz60Ak7rd
         d/2bAq40PfmPfcvSQ3UZPFxGVdCfTZ5bSJThxV63L9l/s0nWRxjrr9zZyyY3nifel8Fn
         +utA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3ttIeUXbogMr7Bjx/KkQ0BSyaYtUZQVxCIPzmZCGY4M=;
        b=gqQfxAMZr5Am1FPko7G9j7SshtfA6mGR/2zR0yhLAbZ4R4gs0TE7P47//enBp1ZFf8
         3GjnERjeQ9e8zrtLmv3w/QScACDTGnjClSeSERVeDYNk3Ifxp7MrXb0+8hQE6rYk01nL
         cawWY7qXymYGfD6XK+OW4LpySUoBZOx5S3TtLRXSwBImm5omddEUp4q97OqXRMoL+L4y
         620sHaxI70NXup8F5Waqzv9eDsQcZ1HmlcsjCBdeXoudnQ0iTx2ep5DnSUe6LSnY85o9
         5pTkAQ2L6MmMHNuw2yq6vWfmWJnJyBUQjrN/TPtaFv4cA0PbeEBuRnJtALf38QFMlNtA
         LMAA==
X-Gm-Message-State: APjAAAVJkea3xIIxtVbis2XFE6QQF2SEt4Ws/4zUp48gnvHDo80m7c2O
        QVtY5ggGXNHJIzHBYqgbw/7fvg==
X-Google-Smtp-Source: APXvYqwuO8Px2+CEMJwG0VUAAWRykFQMn4W29abvpSysz8ekDmahjReCEQ3OliKyEEO6TV1QeXgbPA==
X-Received: by 2002:a1c:c911:: with SMTP id f17mr4098651wmb.73.1568733840864;
        Tue, 17 Sep 2019 08:24:00 -0700 (PDT)
Received: from xps13.home (2a01cb088723c800c05c811fc99ddf73.ipv6.abo.wanadoo.fr. [2a01:cb08:8723:c800:c05c:811f:c99d:df73])
        by smtp.gmail.com with ESMTPSA id n1sm4295120wrg.67.2019.09.17.08.24.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 17 Sep 2019 08:24:00 -0700 (PDT)
Date:   Tue, 17 Sep 2019 17:23:57 +0200
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>, Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH iproute2 4/4] devlink: Fix devlink health set command
Message-ID: <20190917172357.5c70c3b9@xps13.home>
In-Reply-To: <1567687387-12993-5-git-send-email-tariqt@mellanox.com>
References: <1567687387-12993-1-git-send-email-tariqt@mellanox.com>
        <1567687387-12993-5-git-send-email-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  5 Sep 2019 15:43:07 +0300
Tariq Toukan <tariqt@mellanox.com> wrote:

> From: Aya Levin <ayal@mellanox.com>
> 
> Prior to this patch both the reporter's name and the grace period
> attributes shared the same bit. This caused zeroing grace period when
> setting auto recovery. Let each parameter has its own bit.
> 
> Fixes: b18d89195b16 ("devlink: Add devlink health set command")
> Signed-off-by: Aya Levin <ayal@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>

Does not apply to current iproute2.
