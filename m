Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873C02C59E3
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 18:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404201AbgKZRCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 12:02:00 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35908 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404106AbgKZRB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 12:01:59 -0500
Received: by mail-wm1-f66.google.com with SMTP id f190so58696wme.1;
        Thu, 26 Nov 2020 09:01:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p5u+I4L/R8k3QmFwoa0PXudnHrBlJR7xKWZWA7BHe8c=;
        b=a/Ujn0j89eikLzvp+2xAGyFPbkxvMewWljiTrzZhieRx8djYJc4RXki9rWa8o6xnTQ
         U86JAPwvxYb/3mFpmQ3bOCalqhOPuwjNl/juYEPqF/jDySXOiaDIn0eDTANkJKbA32ex
         TruFbOlppltb4tS+ED/TBPfDD/8l6QmIon4NL/PbUu7ToS1409XWedjZ1WNua77Y2qXd
         zWQ/Vn8lIUULssMRxJs28EDbkU01FrzDM3arlR1YCTsZAADtmpguq1J6iHjCo+2fQ7OM
         qMUWfBdfXZaM1lQuL98QQDud7crf46wKxLD+xH13fBERyP2u96IdOlzzN+w1k83mfpB1
         jerg==
X-Gm-Message-State: AOAM531dxjPeBHbiLhXioSiXVNFHClhZorxVWmj1NjFrqFvxJ0dWzCE8
        pF0eskjsNiaJPeVOtA5Z+14=
X-Google-Smtp-Source: ABdhPJwbdTks1pmZqfOgVKSU3Q5zZro4Vc28AJU/X6Lp45Jeke+KxaoNeLXXts9EwBk6A9SARRQdeQ==
X-Received: by 2002:a1c:2384:: with SMTP id j126mr4454862wmj.116.1606410117778;
        Thu, 26 Nov 2020 09:01:57 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id 189sm9786068wmb.18.2020.11.26.09.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 09:01:56 -0800 (PST)
Date:   Thu, 26 Nov 2020 18:01:54 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     bongsu.jeon2@gmail.com
Cc:     k.opasiak@samsung.com, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] nfc: s3fwrn5: use signed integer for
 parsing GPIO numbers
Message-ID: <20201126170154.GA4978@kozik-lap>
References: <1606404819-30647-1-git-send-email-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1606404819-30647-1-git-send-email-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 27, 2020 at 12:33:37AM +0900, bongsu.jeon2@gmail.com wrote:
> From: Krzysztof Kozlowski <krzk@kernel.org>
> 
> GPIOs - as returned by of_get_named_gpio() and used by the gpiolib - are
> signed integers, where negative number indicates error.  The return
> value of of_get_named_gpio() should not be assigned to an unsigned int
> because in case of !CONFIG_GPIOLIB such number would be a valid GPIO.
> 
> Fixes: c04c674fadeb ("nfc: s3fwrn5: Add driver for Samsung S3FWRN5 NFC Chip")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

Why do you send my patch?

Best regards,
Krzysztof
