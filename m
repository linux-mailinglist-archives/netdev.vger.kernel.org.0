Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7142E9587
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 14:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbhADNEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 08:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbhADNEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 08:04:15 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7109CC061796;
        Mon,  4 Jan 2021 05:03:35 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id b8so14522524plx.0;
        Mon, 04 Jan 2021 05:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=862T7hic/OMu7f7cJEh2FFoF3v3gS9+yRL0pxtDB4jE=;
        b=cMEel9TKtloSoTHFocd8vnyoZ7T1Xx9Px4pFcxbVCIM2HhoA7hULRb8yJw9N7rQXnJ
         Ro/USm9rd6j0D9D9CJa4dLd4hEKn+z0ouZCrNyCjDxiIKMTUmrt0MEisxBqCoIjhkFWW
         tvxFR41Oky8F0+gkagdf2pJpifzQARDsIfIsVjKm3uGVZ2YXrIbX1T4vQ485dz99X9f3
         ZoS4ZV1tjG+mJqA1TU57VEppZnc2rJi68VW2sRoA+XADE7dddM12Jv+QFOuEFxWYttnC
         aSehdhuyVCLri8BzP3iBGQtmqtGv7KcWCk3GI5AZ8hirjJLH/cHqDCmRnDAK9okZbA7N
         nhRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=862T7hic/OMu7f7cJEh2FFoF3v3gS9+yRL0pxtDB4jE=;
        b=VJwo51+q0jjmGLJZRFEZb5kbckmVh+eYjYybsAjCFR6VgGfsyhniqXevjVdGl9+CHH
         kANulYiUZNnEVZmE8d9n7I0Qi5cIKL72n+FBDgtjaCdWTwgzVIX9l2UXuk5TVM9aC2Tm
         w8vz9CP3lrbW089eQ2M6wanvKNowkalNkx6fl3vVfZ4giQgwRwXnKsykq2LwiJQu8f29
         CDG5WXbY++kZVSjcptLMy1Xkb3L80EEkAK1v65g0uDOsTVu5d2fIbaQtCKPgTv0HKJKI
         DLYQaLNRPU8I8BXxuaIQ9L+KI1uf02y60mrDeMhBpjSWgApxa7RfoNDH7QkNmA3GO3Tt
         ja5A==
X-Gm-Message-State: AOAM532oy2cFUHpTjV+nk9nvlFaxHowotfjMW2bzvziE/Zw2qpUlwGm9
        hesNYn7RFJvnCpdjdkuXkuG2TUa4IHo=
X-Google-Smtp-Source: ABdhPJwe6TAxYKj3OChvtjsroGWbbF9IJd+DVOmcwIhnsQgjoLWhE5exnorFAbFY+MV0PVAKhNLmAQ==
X-Received: by 2002:a17:902:59dc:b029:da:84c7:f175 with SMTP id d28-20020a17090259dcb02900da84c7f175mr49386727plj.75.1609765415000;
        Mon, 04 Jan 2021 05:03:35 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id x23sm46993760pgk.14.2021.01.04.05.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 05:03:34 -0800 (PST)
Date:   Mon, 4 Jan 2021 05:03:31 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Stefan =?iso-8859-1?Q?S=F8rensen?= 
        <stefan.sorensen@spectralink.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] phy: dp83640: select CONFIG_CRC32
Message-ID: <20210104130331.GA27715@hoboy.vegasvil.org>
References: <20210103213645.1994783-1-arnd@kernel.org>
 <20210103213645.1994783-2-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210103213645.1994783-2-arnd@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 03, 2021 at 10:36:18PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Without crc32, this driver fails to link:
> 
> arm-linux-gnueabi-ld: drivers/net/phy/dp83640.o: in function `match':
> dp83640.c:(.text+0x476c): undefined reference to `crc32_le'
> 
> Fixes: 539e44d26855 ("dp83640: Include hash in timestamp/packet matching")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Richard Cochran <richardcochran@gmail.com>
