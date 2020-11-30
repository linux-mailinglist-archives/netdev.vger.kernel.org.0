Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A9E2C8CD3
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 19:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388072AbgK3SaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 13:30:21 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33842 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388026AbgK3SaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 13:30:20 -0500
Received: by mail-wr1-f68.google.com with SMTP id k14so17533834wrn.1;
        Mon, 30 Nov 2020 10:30:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BL7GgKlxyULO787aR2VhuF5srikfeJ8kPXa9y9+CzWY=;
        b=X0AOD0U4uW7Zue0QXS+WOt6DllIhtqcJv3kIn8ECmIvm+rW95lsBEEG89APAZmiWDn
         K7Vzl3SEVimEC3rC7C8wHGEVK/lSUGy1SXqN6RaQyTyyQLLeOa2vnmPqQ1Qhi2pffcvR
         QASHdGQ7v5l6ByShPncIxQWJ6IlKu5qZsCcXxkOBp/mgLPJR9sqiIAf9ko0RsoGdxOOS
         02/lG5VUzVdUoWtPM5xWTEOmLodSmUqIG2JNjlYAEsIGelPVOtZv+pDCTuUl7Afl67Xf
         LKCUYeeapTDEfZTwq0JJHEHb0hF5SupYSTPtzHetcJdCI/WZFOQzTLHS4ySjwPRVgQ8N
         a9tQ==
X-Gm-Message-State: AOAM533zWlmzdrqbECc9MUqLnVJrGyJ9ET6m/AszVG31QtIxsdsSyA5q
        wThPYgZHTKvwK8XmdUV3Zog=
X-Google-Smtp-Source: ABdhPJy0qru9FG+0tWt9eOshF9nKj7ldKMBW7pMLd3yrYEw5pvskZP1IW/CKEzIrXt9WowIPsBTZeA==
X-Received: by 2002:a5d:5689:: with SMTP id f9mr29965801wrv.181.1606760978169;
        Mon, 30 Nov 2020 10:29:38 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id b12sm924332wmj.2.2020.11.30.10.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 10:29:37 -0800 (PST)
Date:   Mon, 30 Nov 2020 20:29:35 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bongsu jeon <bongsu.jeon2@gmail.com>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH v2 net-next 1/4] dt-bindings: net: nfc: s3fwrn5: Support
 a UART interface
Message-ID: <20201130182935.GA28735@kozik-lap>
References: <1606737627-29485-1-git-send-email-bongsu.jeon@samsung.com>
 <20201130085542.45184040@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201130085542.45184040@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 08:55:42AM -0800, Jakub Kicinski wrote:
> On Mon, 30 Nov 2020 21:00:27 +0900 Bongsu jeon wrote:
> > From: Bongsu Jeon <bongsu.jeon@samsung.com>
> > 
> > Since S3FWRN82 NFC Chip, The UART interface can be used.
> > S3FWRN82 supports I2C and UART interface.
> > 
> > Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> All patches in the series should have the same version.
> 
> If the patch was not changes in the given repost you can add:
> 
>  v3:
>   - no change
> 
> Or just not mention the version in the changelog.
> 
> It's also best to provide a cover letter describing what the series
> does as a whole for series with more than 2 patches.

Beside that I received just 1/4 of v2. LKML has one as well:
https://lore.kernel.org/lkml/1606737627-29485-1-git-send-email-bongsu.jeon@samsung.com/

Where are the others?

Best regards,
Krzysztof

