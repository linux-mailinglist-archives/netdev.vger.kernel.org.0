Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C99324715
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 23:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235686AbhBXWop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 17:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbhBXWom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 17:44:42 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9541C061574;
        Wed, 24 Feb 2021 14:44:01 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id p1so33810edy.2;
        Wed, 24 Feb 2021 14:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=99V2B0lnlTGfCOt0X39MWt84YcT3N4F3t+5LYtHZ6Iw=;
        b=p73RPwZFjFXxYHKyRyrcKs0GB/hGBGHBVL0/qLOu/GuPnm3gWqcZ1cCQLMgVfRcENg
         XFity6oJZgxZ8KpDzdFLmqTRb+gfb4oC4Oz9s9pL+d4xquct3IeRkZYdTug5K67ryvfP
         DQ5TcvAbS4Hz/yPoplIrhdziBemOkBqZhEcXggk6A9Ic2AEp6fUMvakb8c0tMC8C+IVW
         AkfPUP2895v0F6cg/0JqwTMPsqbVGPczwN/137oDbKP/kurnE5XDVAIj61dmb6xO5Ura
         3Ht3xecyi1dqmrmzhuYw6MS5EfWklYJrevHC/bFJbMZ0rgg6kqPkza2YBT5D5YWspaBh
         YqLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=99V2B0lnlTGfCOt0X39MWt84YcT3N4F3t+5LYtHZ6Iw=;
        b=e6PCG3jFvBeKpUbtw27ZEPIEz/caOI2uR6AwDHNNXSzPOsw0N3VtHsoCAmnrM66vU5
         KbFtSu6RQman4AS1fUCCVxR/2Zrj0cMVTQtegMQ/zq/RkcEZ6vJ00BWiCxqoLL/gpyJd
         WwIRMwWgMpq6znPnMYrvPpFJlgtnOTsyDKRpTL8u3f33aJth3K3GhsX5VPsqWArGsh2R
         SjBOwRY2ibQT/yQ+BUr1fX4bybcpfSlQSpvtliXDaZPSgoFaJCBdpFR/PssrButvBTat
         uVSL/+7xa4J2iUVLxn+6zHrsKjK261EYJm4gIU+KbISywqDro4C5Mx+sgPfoZOHJ5iq+
         OYGQ==
X-Gm-Message-State: AOAM531H2h2/4js0hFSdF1PGcN9EdmOF0TMX5AEPwwJd6FD3ltnqsAS0
        khtbyguhULkqeaFx0Hk6CAgMebYxaWk=
X-Google-Smtp-Source: ABdhPJwJU5EMZypPEqCk9rg3mlZaM0FS5VotXftAQn6Pmqmf9MgXhD16wMOjK4wB9r2MazBdyg7z2g==
X-Received: by 2002:a50:ed11:: with SMTP id j17mr70812eds.324.1614206640326;
        Wed, 24 Feb 2021 14:44:00 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id qx17sm2038811ejb.85.2021.02.24.14.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 14:43:59 -0800 (PST)
Date:   Thu, 25 Feb 2021 00:43:58 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: sja1105: Remove unneeded cast in
 sja1105_crc32()
Message-ID: <20210224224358.pysql5pu23zt7mtb@skbuf>
References: <20210223112003.2223332-1-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223112003.2223332-1-geert+renesas@glider.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 12:20:03PM +0100, Geert Uytterhoeven wrote:
> sja1105_unpack() takes a "const void *buf" as its first parameter, so
> there is no need to cast away the "const" of the "buf" variable before
> calling it.
> 
> Drop the cast, as it prevents the compiler performing some checks.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

By the way, your email went straight to my spam box, I just found the
patch by mistake on patchwork.

    Why is this message in spam?
    It is in violation of Google's recommended email sender guidelines.

> Compile-tested only.
> 
> BTW, sja1105_packing() and packing() are really bad APIs, as the input
> pointer parameters cannot be const due to the direction depending on
> "op".  This means the compiler cannot do const checks.  Worse, callers
> are required to cast away constness to prevent the compiler from
> issueing warnings.  Please don't do this!
> ---

What const checks can the compiler not do?
Also, if you know of an existing kernel API which can replace packing(),
I'm all ears.
