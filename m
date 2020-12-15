Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5532DA9DD
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 10:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgLOJOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 04:14:05 -0500
Received: from mail-ej1-f65.google.com ([209.85.218.65]:47044 "EHLO
        mail-ej1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727536AbgLOJNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 04:13:54 -0500
Received: by mail-ej1-f65.google.com with SMTP id j22so8601645eja.13;
        Tue, 15 Dec 2020 01:13:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rFnb5r44Hk5DXz0JFCpBQMfmXkX1W5NDEIgxSLGBVvc=;
        b=lGD+LjX1c7z60hVeKiyYKzvSWesVWz2Vh8Bsujo7lEg7G6KZAaaks1ia2pwPsR415L
         gAq2dth4s981TfXgVVGCnuigwCmrhNB5M5LxddqZbE4BYLv+HNWIYZe7vuZWqMAEE2Zh
         TBfu79d09MZ+LyDiAhQH5b6ilwlEEw8fbV/D1q/qp+t01q3vg87urF19FLkpzcEg9X13
         Y0KI8ux4M+oc96lcrmwggo3IfUcox7bAN8Me+89E3nU0uyoIhMBPyQCb6KkjFYA0O1/l
         rtbrYVtDM5aCWovGO/wsprnr78T/IcZHtICkL9jLhCS3pIXIUZV8UdRMsr6sptzoK2Vy
         WMFQ==
X-Gm-Message-State: AOAM532ubzhLWomxQFGexlT3E3kUZMYVXdm8NnC37crZNIP3Pp8ggbXW
        xbxmctKt7I2Kv4hXI29cDz0=
X-Google-Smtp-Source: ABdhPJySndnJVgRCwyOzhjXag8LQ6zc060SR5W9nuHFoSB3ubPvN06jFqCe666TP9S/Bczfzm8o0ug==
X-Received: by 2002:a17:906:195a:: with SMTP id b26mr13930796eje.4.1608023592858;
        Tue, 15 Dec 2020 01:13:12 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id n13sm904902ejr.93.2020.12.15.01.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 01:13:11 -0800 (PST)
Date:   Tue, 15 Dec 2020 10:13:10 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH v2 net-next 2/2] nfc: s3fwrn5: Remove unused NCI prop
 commands
Message-ID: <20201215091310.GB29321@kozik-lap>
References: <20201215065401.3220-1-bongsu.jeon@samsung.com>
 <20201215065401.3220-3-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201215065401.3220-3-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 03:54:01PM +0900, Bongsu Jeon wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> Remove the unused NCI prop commands that s3fwrn5 driver doesn't use.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> ---
>  drivers/nfc/s3fwrn5/nci.c | 25 -------------------------
>  drivers/nfc/s3fwrn5/nci.h | 22 ----------------------
>  2 files changed, 47 deletions(-)
> 

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
