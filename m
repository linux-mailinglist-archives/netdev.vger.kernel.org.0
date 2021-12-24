Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B9647EA6D
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 03:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350885AbhLXCC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 21:02:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbhLXCC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 21:02:27 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9355BC061401;
        Thu, 23 Dec 2021 18:02:27 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id f9so6533061qtk.4;
        Thu, 23 Dec 2021 18:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=8v+EFvrq9T+v8VQpeRHJXJ2x1pq772O3oGSuieKYzqU=;
        b=nmsB0CFvgBwpMxzUXfY5wZPBhvDR1l4YfQS+npNosLChn5WaGBgoBD0sG5ZrWq3QM0
         2eWllSaiSK+/vhUdYISB4kx6ncY6P6LPfQ3rraLOJTR4ozJNkaVRdAJVS6tdadKKmCPK
         EplJAgj0xDxZ59XUcBMrKtA4yklNA6/hslYiyLIaLC/kFKtAE3HGTVditV8pr74QbKB4
         bKAil1OpLBnL/9n7ZmPbze2YgGO08QVxYzUxdYGW04oxwKfbeHcunFbm0KRQlXQ9L5gj
         vHPBJNlrkOwdOjeRm2M+BK5X0ecic4whmviLL7wNlHUPFtrk6Tm8zCdFgAiUoKk2T49Y
         Th8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=8v+EFvrq9T+v8VQpeRHJXJ2x1pq772O3oGSuieKYzqU=;
        b=ZqoBUvLtW6wRv26uKkhuVCCDpFKdaPN32frOklLsIisMCUc8wrvlO6zzEB5Znecd67
         WsK+BTnj3SVaEAYzWfqCxhqdSq/Z1bu74mkaGz0VNCpOrO0wqEODeUnxlNVk6ldXTKri
         6uY4n0mUMQKghN1mSmanBfnLi9ffqTm+Ijs4Esx1vz3Xj+0GWgc1la/fNZ5dV3RtvnVp
         MFud4vJwpsE9D85/Nl8KRVr47lsN8jD9sKUxqO5KaL/H9LyRJbBsOofnl0ZcmgMcX1IR
         QNzMruhb5NqbpOdcBLiYtm1yNBD/u3t/CnRs8X4LUqGEZdvuoGFRuRaQD7VhsYw9eJ6P
         +YSw==
X-Gm-Message-State: AOAM530HCJDxv42FW0hmYxziNZ3xsxSMFRJfP919z+HMnY6KscznvUpS
        u+5NrO4A0obQbBM9uxV7nB8=
X-Google-Smtp-Source: ABdhPJxMH8V8fcN88I0Q/LOISRupUL2sQM3S/8rdhesm6oPdZO6yfYN7mCRTO6MAvj14TeThZt48sA==
X-Received: by 2002:a05:622a:11d2:: with SMTP id n18mr2791940qtk.10.1640311346687;
        Thu, 23 Dec 2021 18:02:26 -0800 (PST)
Received: from localhost ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id ay42sm5547135qkb.40.2021.12.23.18.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 18:02:26 -0800 (PST)
Message-ID: <61c52a32.1c69fb81.e2913.d0d9@mx.google.com>
X-Google-Original-Message-ID: <20211224020223.GA570652@cgel.zte@gmail.com>
Date:   Fri, 24 Dec 2021 02:02:23 +0000
From:   CGEL <cgel.zte@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        prestwoj@gmail.com, xu.xin16@zte.com.cn, zxu@linkedin.com,
        praveen5582@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH net-next] ipv4: delete sysctls about routing cache
References: <20211223122010.569553-1-xu.xin16@zte.com.cn>
 <20211223084702.51d09c08@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211223084702.51d09c08@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 23, 2021 at 08:47:02AM -0800, Jakub Kicinski wrote:
> On Thu, 23 Dec 2021 12:20:10 +0000 cgel.zte@gmail.com wrote:
> > From: xu xin <xu.xin16@zte.com.cn>
> > 
> > Since routing cache in ipv4 has been deleted in 2012, the sysctls about
> > it are useless.
> 
> Search for those on GitHub. Useless or not, there is software which
> expects those files to exist and which may break if they disappear.
> That's why they were left in place.
Maybe we can note these inoperative interfaces in ip-sysctl.rst or
somewhere else, suggesting users not to use them any longer.

Wish you merry christmas in advance.
Xu Xin
