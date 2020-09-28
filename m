Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D7627B6B3
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 22:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgI1UwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 16:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgI1UwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 16:52:12 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BB1C061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 13:52:12 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id b17so1396389pji.1
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 13:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N/6tMjAU83pBPZsZpiMZQiEvPJJe3wBR1akf3N9FiNg=;
        b=h+hJMn31EVS18Wt/1JvPwFYM9jzEaJ4UyXTa9myGSBg5iBYu7kMO4nyXV/Af6kSnup
         m07MNUrMWFFbAzKuSL5oUOYzzEwZ9G9tdOEFNbpZ2hfS2llQkYsxXkcPlkRuTGF7iT8V
         aSZhVhMUqgA4HpsbjPPu3zDBzhD6Db761dAbw3lEnD2wI7+rPa6WPZTj6QfcTwcjiHZc
         n04+qipeNg1oHk0V0RBhOg7cwzpdVVVr64u2y3X9CI0Tokkv0IdidCWYsmtWMSGzPNiN
         i6lpKXDaKplNRwSIP/HzGp1h0viK0EQ1LRURfM4WL2yJjQ50tVr/I2mgzHlxHBmkflJc
         rrUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N/6tMjAU83pBPZsZpiMZQiEvPJJe3wBR1akf3N9FiNg=;
        b=CFJ3zkoUKxQehlt/cR0unrXBu6+TkS8tP4bm3LGcDqhXYGSqL4238wUZB7RCU2Luvr
         ntiSZDhVdf3aj86/dmQk/c5gLpbyH0IiabVP9+Qo7BgVnMsFZaflXToW7bXZ0rvUjg8w
         O+b/pJ6m7roVuDbVl8t6X39YstA4kEQktWLPD/uSqqoQpZQ4gYxLbfoRuQPoYxuIoCyM
         9X+wjqM6XHpYuUUAbthjvEgXIQssRSXFtue4m7qOGaQfqMLBNlAMhKBJnDcArvXlUMeN
         lzwkjzWebacMsFIU6VmVK7VAFplT5Mm7yIHUZenRWZUrouH0rEcw0TZFzB5aW7ri/gUy
         /V6A==
X-Gm-Message-State: AOAM532xa9bJjm7pFjrUzazmi+gXHxm3GzRGt4x3seZRoh3WTk8prMEL
        H/JUv9WOShZzG6+MZfkr4sng2lJVruD0Mw==
X-Google-Smtp-Source: ABdhPJxfjuNUVNYzfeMMnrYhazPRBbAi6tzZ4ko+9S+XxhcYXkZyAvl68dq/WAWZclCFs2KLAF5ASg==
X-Received: by 2002:a17:90a:13c7:: with SMTP id s7mr939141pjf.124.1601326331917;
        Mon, 28 Sep 2020 13:52:11 -0700 (PDT)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id e16sm2196243pgv.81.2020.09.28.13.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 13:52:11 -0700 (PDT)
Date:   Mon, 28 Sep 2020 13:52:04 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netdev@vger.kernel.org
Subject: Re: [iproute PATCH] build: avoid make jobserver warnings
Message-ID: <20200928135204.3285b619@hermes.local>
In-Reply-To: <20200928190801.561-1-jengelh@inai.de>
References: <20200928083931.75629c32@hermes.local>
        <20200928190801.561-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Sep 2020 21:08:01 +0200
Jan Engelhardt <jengelh@inai.de> wrote:

> I observe:
>=20
> 	=C2=BB make -j8 CCOPTS=3D-ggdb3
> 	lib
> 	make[1]: warning: -j8 forced in submake: resetting jobserver mode.
> 	make[1]: Nothing to be done for 'all'.
> 	ip
> 	make[1]: warning: -j8 forced in submake: resetting jobserver mode.
> 	    CC       ipntable.o
>=20
> MFLAGS is a historic variable of some kind; removing it fixes the
> jobserver issue.
>=20
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>

Applied.
