Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A8D2CC349
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 18:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388832AbgLBRRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 12:17:23 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37493 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387637AbgLBRRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 12:17:23 -0500
Received: by mail-ed1-f68.google.com with SMTP id cm17so4803333edb.4;
        Wed, 02 Dec 2020 09:17:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+UAanY5PNunboQWAira1n5v88pFyvRSB0kuWX0KJKy8=;
        b=mIrLAL5wiqgeClY6enko6Hba0NK3BA9N3li98QdBNZNxzG9f9/sIFqEersaEWGoi8Z
         hwovisYLAiFIW1ti4rsW15RS68BjfaxOt/5pz0IoWTY7zqDOz37k/CXTmVYyzmcfYex/
         UeHQi1LCm/dZIvBfFmvxT2jAUaB60TsfS2aP8HkI8ECuoLVpiJxWS0TQimKvPBUUL/A6
         LwB/+IfAycmlepObwwWTbIgZJ9ivvLZVwuhVCRF0iwZWFoHQU8cm6dJPHsYyomz/Ap2N
         rqsnqVzUEbiDJo4WgVgRhjng2oFzDK3dgPqlG7+Br+EFs9pmhIuciWA0/HpTgZaO4gFH
         Er4w==
X-Gm-Message-State: AOAM532xpmzh7hUqqQge4NY4ud6TFs0Ryfy0nXRuPH6Hji7g8G6BxSi4
        uLCYhslScr65DVbzzTTNKyXDX4+sSNA=
X-Google-Smtp-Source: ABdhPJw6F9Z2HCezk2gyTIqGZ20AJAmWFUFXLwWo7OZP94BHm5G2cz934XVMG/oAoSjGQJpBMXZ9fw==
X-Received: by 2002:aa7:dc5a:: with SMTP id g26mr948538edu.35.1606929401213;
        Wed, 02 Dec 2020 09:16:41 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id n1sm349851ejb.2.2020.12.02.09.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 09:16:40 -0800 (PST)
Date:   Wed, 2 Dec 2020 19:16:38 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH v5 net-next 1/4] dt-bindings: net: nfc: s3fwrn5: Support
 a UART interface
Message-ID: <20201202171638.GA2778@kozik-lap>
References: <1606909661-3814-1-git-send-email-bongsu.jeon@samsung.com>
 <1606909661-3814-2-git-send-email-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1606909661-3814-2-git-send-email-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 08:47:38PM +0900, Bongsu Jeon wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> Since S3FWRN82 NFC Chip, The UART interface can be used.
> S3FWRN82 supports I2C and UART interface.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> ---
>  .../bindings/net/nfc/samsung,s3fwrn5.yaml          | 31 +++++++++++++++++++---
>  1 file changed, 28 insertions(+), 3 deletions(-)
> 

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
