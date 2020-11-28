Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432FE2C704C
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 19:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732720AbgK1Rzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 12:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgK1FWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 00:22:10 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C69C0613D1
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 21:22:07 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id e23so1000122pgk.12
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 21:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0xb3TURKT8c7EWC09LqbBAbcuKonEnu9PoM6dSdstbg=;
        b=Pl+pAI+x2nIH82TRI6EjqYGk5u9OMB6hiev7DZN/jaVQ5l2e8qX57VaMlDBPiwG+FK
         aqn1e2kCHdemnyMhiQjjLCWxNOKkt8va53aZpoWPMaN0nWvsMJyGwzBHrZsuUXTxpNMh
         DFOEK6nsRdR+JMR/BUCP/flJod2HnYQipsoVf7lNJi3RpXVKGdrKz6RVJVIaNTlrDEJo
         y5HgN6j7sGhZiGqHjtG3R3GdfhSvAFBt/jy+7CKF2iq81pyXeOr0R8bWfTXOgs9mAfGC
         +4jk6E2wzNo0ctiBZM9MPm4AjtgkDaTXvcfVHw30Ed/3OcB/yIT8fL4jxJBg+GW3NF7J
         Xrvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0xb3TURKT8c7EWC09LqbBAbcuKonEnu9PoM6dSdstbg=;
        b=X6Kp0687lbxWCuoJZSdVbiN1YxoRrrcwNjrB98F80PL+KsLzMZpKFN7/QBeGoy+t0p
         47NKeKQJsnxzA8WXr6K9mxnl2l5vCJm84cT0Vpy5+Dp4FipB+hv3N8/NQuVjkhU2WB6r
         I7DMEbYmOu0hPomaZ4Z0iD+HzmMyRQUy5z1+SoAbKW9t7oY29167fXMKTQ9GDGYrMNhg
         03XfOhC+OG45FAWPj9dVzYGB/0kWY+S/RZkZ5z+bIN0mT6/cKw2MjYsBf9cYYIpUudd/
         b0Ukiue6mVTx0gtUvTBg75gJKC6ZFfw/dZCtSF1BFLqeuF9/kGVr7w2QIYv9UID/vvnt
         SgqQ==
X-Gm-Message-State: AOAM5315pJzZTpkL8Jo8Jt/l8btO/nPFx6zThBUhFyvubgA3n8a+ghqs
        MEuXi0MPX+GjIgVwU8l4ru3uiA==
X-Google-Smtp-Source: ABdhPJzx9Oh+yPePjDYGnpx+pqj1KQ9j31z7BxgUzCfLyt3Yy9TZSpvcZAtaRKe+rJWZod/2HHo0YA==
X-Received: by 2002:aa7:90d2:0:b029:198:39d8:e5b0 with SMTP id k18-20020aa790d20000b029019839d8e5b0mr10241901pfk.1.1606540927464;
        Fri, 27 Nov 2020 21:22:07 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 10sm2062806pjt.35.2020.11.27.21.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 21:22:06 -0800 (PST)
Date:   Fri, 27 Nov 2020 21:21:51 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Luca Boccassi <bluca@debian.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC iproute2] tc/mqprio: json-ify output
Message-ID: <20201127212151.4984075c@hermes.local>
In-Reply-To: <20201127152625.61874-1-bluca@debian.org>
References: <20201127152625.61874-1-bluca@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020 15:26:25 +0000
Luca Boccassi <bluca@debian.org> wrote:

> As reported by a Debian user, mqprio output in json mode is
> invalid:
> 
> {
>      "kind": "mqprio",
>      "handle": "8021:",
>      "dev": "enp1s0f0",
>      "root": true,
>      "options": { tc 2 map 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0
>           queues:(0:3) (4:7)
>           mode:channel
>           shaper:dcb}
> }
> 
> json-ify it, while trying to maintain the same formatting
> for standard output.
> 
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=972784
> 
> Signed-off-by: Luca Boccassi <bluca@debian.org>

Did you try feeding that into the python parser?
What is before/after?

